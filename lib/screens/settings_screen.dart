import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/theme_provider.dart';
import '../providers/user_provider.dart';
// 🔥 Firebase için gerekli import'lar
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';


class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});
  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool isPrivacyEnabled = true;

  // 1. HESAP SİLME İŞLEMİ (Firestore ve Auth Silme)
  Future<void> _deleteAccount({required String password}) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    // Yükleniyor ekranını göster
    showDialog(context: context, barrierDismissible: false, builder: (context) => const Center(child: CircularProgressIndicator()));

    try {
      // 1. YENİDEN KİMLİK DOĞRULAMA (RE-AUTHENTICATION)
      final AuthCredential credential = EmailAuthProvider.credential(
        email: user.email!,
        password: password,
      );
      await user.reauthenticateWithCredential(credential);

      // 2. FİRESTORE VERİSİNİ SİLME
      await FirebaseFirestore.instance.collection('users').doc(user.uid).delete();

      // 3. AUTH HESABINI SİLME
      await user.delete();

      // İşlem başarılı: Çıkış yap ve giriş ekranına yönlendir
      if (!mounted) return;
      Provider.of<UserNotifier>(context, listen: false).logout();
      Navigator.popUntil(context, (route) => route.isFirst); // Tüm yükleme ekranlarını kapat
      Navigator.pushReplacementNamed(context, '/login'); // Login ekranına git

    } on FirebaseAuthException catch (e) {
      // Hata durumunda yükleniyor ekranını kapat
      if (mounted) Navigator.pop(context);

      String errorMessage;
      if (e.code == 'wrong-password') {
        // 🔥 PROFESYONEL VE TÜRKÇE HATA MESAJI (1. Örnek)
        errorMessage = 'Güvenliğiniz için lütfen kayıtlı şifrenizi doğru bir şekilde girerek işlemi tekrar deneyiniz.';
      } else if (e.code == 'requires-recent-login') {
        // 🔥 PROFESYONEL VE TÜRKÇE HATA MESAJI (2. Örnek)
        errorMessage = 'Güvenlik protokolleri gereği, hassas işlemler için oturumunuzun güncel olması gerekmektedir. Lütfen çıkış yaparak oturumu yenileyiniz.';
      } else {
        // 🔥 BEKLENMEYEN TÜM İNGİLİZCE HATALAR İÇİN GENEL MESAJ
        errorMessage = 'Güvenliğiniz için lütfen kayıtlı şifrenizi doğru bir şekilde girerek işlemi tekrar deneyiniz';
      }

      // Hata mesajını göster
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(errorMessage)));
      }

    } catch (e) {
      if (mounted) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Beklenmedik bir hata oluştu. İnternet bağlantınızı kontrol ediniz.')));
      }
    }
  }


  // 2. ŞİFRE GİRİŞ DİALOGU
  void _showPasswordConfirmationDialog(BuildContext context) {
    final passwordController = TextEditingController();
    final confirmPasswordController = TextEditingController();
    final formKey = GlobalKey<FormState>();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Şifrenizi Doğrulayın'),
          content: SingleChildScrollView(
            child: Form(
              key: formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text('Hesabınızın güvenliği için lütfen şifrenizi giriniz.'),
                  const SizedBox(height: 15),
                  TextFormField(
                    controller: passwordController,
                    obscureText: true,
                    decoration: const InputDecoration(labelText: 'Şifre'),
                    validator: (value) {
                      if (value == null || value.isEmpty) return 'Şifre boş bırakılamaz.';
                      return null;
                    },
                  ),
                  TextFormField(
                    controller: confirmPasswordController,
                    obscureText: true,
                    decoration: const InputDecoration(labelText: 'Şifre Tekrar'),
                    validator: (value) {
                      if (value != passwordController.text) return 'Şifreler uyuşmuyor.';
                      return null;
                    },
                  ),
                ],
              ),
            ),
          ),
          actions: [
            TextButton(
              child: const Text('İptal'),
              onPressed: () => Navigator.pop(context),
            ),
            TextButton(
              child: const Text('Hesabı Sil', style: TextStyle(color: Colors.red)),
              onPressed: () {
                if (formKey.currentState!.validate()) {
                  Navigator.pop(context); // Dialogu kapat
                  _deleteAccount(password: passwordController.text); // Silme işlemini başlat
                }
              },
            ),
          ],
        );
      },
    );
  }

  // 3. İLK ONAY DİALOGU
  void _showInitialConfirmationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Hesabınızı Silmek Üzeresiniz'),
          content: const Text(
              'Hesabınızı sildiğinizde tüm verileriniz kalıcı olarak silinecektir. Bu işlem geri alınamaz. Emin misiniz?'),
          actions: [
            TextButton(
              child: const Text('İptal'),
              onPressed: () => Navigator.pop(context),
            ),
            TextButton(
              child: const Text('Evet, Sil', style: TextStyle(color: Colors.red)),
              onPressed: () {
                Navigator.pop(context); // İlk dialogu kapat
                _showPasswordConfirmationDialog(context); // Şifre doğrulama dialogunu aç
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final themeNotifier = Provider.of<ThemeNotifier>(context);
    bool isDarkMode = themeNotifier.themeMode == ThemeMode.dark;

    return Scaffold(
      appBar: AppBar(title: const Text('Ayarlar'), backgroundColor: Colors.deepPurple),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          SwitchListTile(
            title: const Text('Karanlık Mod'),
            value: isDarkMode,
            onChanged: (value) => themeNotifier.setThemeMode(value ? ThemeMode.dark : ThemeMode.light),
            secondary: Icon(Icons.brightness_2, color: isDarkMode ? Colors.yellow : Colors.blueGrey),
          ),
          const Divider(),
          SwitchListTile(
            title: const Text('Gizlilik Ayarları'),
            value: isPrivacyEnabled,
            onChanged: (value) => setState(() => isPrivacyEnabled = value),
            secondary: const Icon(Icons.lock),
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.security, color: Colors.red),
            title: const Text('Hesabı Sil', style: TextStyle(color: Colors.red)),
            onTap: () {
              // Silme akışını başlatan fonksiyonu çağırıyoruz
              _showInitialConfirmationDialog(context);
            },
          ),
          const Divider(),
          // Çıkış Yap butonu isteğiniz üzerine bu listeden kaldırılmıştır.
        ],
      ),
    );
  }
}