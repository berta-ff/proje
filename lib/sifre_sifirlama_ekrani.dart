import 'package:flutter/material.dart';
// 🔥 YENİ EKLE: Firebase Auth paketini prefix ile import et
import 'package:firebase_auth/firebase_auth.dart' as fba;


// main.dart'tan alınan sabitler (Bunların başka bir yerden geldiği varsayılıyor)
const Color accentColor = Colors.lightBlue; // Veya uygulamanızdaki gerçek değeri

class SifreSifirlamaEkrani extends StatefulWidget {
  const SifreSifirlamaEkrani({super.key});

  @override
  State<SifreSifirlamaEkrani> createState() => _SifreSifirlamaEkraniState();
}

class _SifreSifirlamaEkraniState extends State<SifreSifirlamaEkrani> {
  final TextEditingController _emailController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  void _gosterSnackBar(String mesaj, {required bool isError}) {
    final accentColor = Theme.of(context).colorScheme.secondary;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(mesaj),
        duration: const Duration(seconds: 2),
        backgroundColor: isError ? Colors.red.shade700 : accentColor,
      ),
    );
  }

  // ŞİFRE SIFIRLAMA İŞLEMİNİ YÖNETEN METOT (FIREBASE İLE GÜNCELLENDİ)
  void _sifreSifirla() async {
    final String email = _emailController.text.trim();

    if (email.isEmpty || !email.contains('@')) {
      _gosterSnackBar('Hata: Lütfen geçerli bir e-posta adresi girin.', isError: true);
      return;
    }

    // Loading göstergesini başlat
    showDialog(
      context: context,
      builder: (context) => const Center(child: CircularProgressIndicator()),
      barrierDismissible: false,
    );

    try {
      // 🔥 Firebase Şifre Sıfırlama E-postası Gönderme İşlemi 🔥
      await fba.FirebaseAuth.instance.sendPasswordResetEmail(email: email);

      // Başarı durumunda
      if (!mounted) return;
      Navigator.pop(context); // Loading ekranını kapat

      _gosterSnackBar(
        'Şifre sıfırlama bağlantısı $email adresine gönderildi. Lütfen gelen kutunuzu kontrol edin.',
        isError: false,
      );

      // Başarılı işlem sonrası Giriş Ekranına geri dön
      // 1.5 saniye bekleme yerine hemen geri dönülüyor.
      Navigator.pop(context);

    } on fba.FirebaseAuthException catch (e) {
      // Hata durumunda
      if (!mounted) return;
      Navigator.pop(context); // Loading ekranını kapat

      String hataMesaji = 'Şifre sıfırlama bağlantısı gönderilemedi.';

      if (e.code == 'user-not-found') {
        hataMesaji = 'Bu e-posta adresine ait kullanıcı bulunamadı.';
      } else if (e.code == 'invalid-email') {
        hataMesaji = 'Geçersiz e-posta adresi formatı.';
      } else {
        hataMesaji = 'Bilinmeyen Hata: ${e.message}';
      }

      _gosterSnackBar(hataMesaji, isError: true);
    } catch (e) {
      if (!mounted) return;
      Navigator.pop(context);
      _gosterSnackBar('Beklenmedik bir hata oluştu: $e', isError: true);
    }
  }


  @override
  Widget build(BuildContext context) {
    // Tema renklerini al
    final bodyTextColor = Theme.of(context).textTheme.bodyMedium?.color;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Şifre Sıfırlama'),
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(30.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Icon(
                Icons.lock_open,
                size: 100,
                color: accentColor,
              ),
              const SizedBox(height: 10),
              Text(
                'Şifre Sıfırlama',
                style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: bodyTextColor,
                ),
              ),
              const SizedBox(height: 10),
              const Text(
                'Şifrenizi sıfırlamak için e-posta adresinizi girin.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16),
              ),

              const SizedBox(height: 40),

              // E-posta Giriş Alanı
              TextField(
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: const InputDecoration(
                  labelText: 'E-posta Adresi',
                  hintText: 'e-posta adresinizi girin',
                  prefixIcon: Icon(Icons.email),
                ),
              ),

              const SizedBox(height: 30),

              // Şifre Sıfırlama Butonu
              ElevatedButton(
                onPressed: _sifreSifirla,
                child: const Text('Sıfırlama Bağlantısı Gönder'),
              ),

              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}