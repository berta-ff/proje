// kayit_ekrani.dart
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart'; // Firestore için gerekli
import 'package:provider/provider.dart'; // Provider erişimi için gerekli
import 'package:firebase_auth/firebase_auth.dart' as fba; // Firebase Auth

import 'main.dart'; // UserNotifier sınıfına erişim için
import 'models/user.dart'; // User modelimiz

// main.dart'tan alınan sabitler
const Color hintColor = Colors.grey;
const Color accentColor = Colors.lightBlue;

class KayitEkrani extends StatefulWidget {
  const KayitEkrani({super.key});

  @override
  State<KayitEkrani> createState() => _KayitEkraniState();
}

class _KayitEkraniState extends State<KayitEkrani> {
  // Controller'lar
  final TextEditingController _isimSoyisimController = TextEditingController();
  final TextEditingController _kullaniciAdiController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _telefonController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();

  @override
  void dispose() {
    // Tüm controller'ları bellekten temizle
    _isimSoyisimController.dispose();
    _kullaniciAdiController.dispose();
    _emailController.dispose();
    _telefonController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _gosterSnackBar(String mesaj, {required bool isError}) {
    // Eğer context yoksa veya widget ağacından çıktıysa hata vermemesi için kontrol
    if (!mounted) return;

    final snackBarColor = isError ? Colors.red.shade700 : Theme.of(context).colorScheme.secondary;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(mesaj),
        duration: const Duration(seconds: 2),
        backgroundColor: snackBarColor,
      ),
    );
  }

  void _handleRegistration() async {
    final String email = _emailController.text.trim();
    final String password = _passwordController.text;
    final String confirmPassword = _confirmPasswordController.text;

    // Validasyonlar
    if (_isimSoyisimController.text.isEmpty ||
        _kullaniciAdiController.text.isEmpty ||
        email.isEmpty ||
        _telefonController.text.isEmpty ||
        password.isEmpty ||
        confirmPassword.isEmpty) {
      _gosterSnackBar('Lütfen tüm alanları doldurun.', isError: true);
      return;
    }

    if (password != confirmPassword) {
      _gosterSnackBar('Şifreler uyuşmuyor.', isError: true);
      return;
    }

    // Loading göstergesini başlat
    showDialog(
      context: context,
      builder: (context) => const Center(child: CircularProgressIndicator()),
      barrierDismissible: false,
    );

    try {
      // 1. Firebase Auth ile Kullanıcı Oluştur (E-posta ve Şifre)
      fba.UserCredential userCredential = await fba.FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Oluşan kullanıcının benzersiz ID'sini (UID) al
      String uid = userCredential.user!.uid;

      // 2. User Nesnesini Oluştur (Model)
      // Şifreyi güvenlik nedeniyle veritabanına kaydetmiyoruz (boş bırakıyoruz)
      User newUser = User(
        isimSoyisim: _isimSoyisimController.text,
        kullaniciAdi: _kullaniciAdiController.text,
        email: email,
        telefon: _telefonController.text,
        sifre: "",
        favoritePlaceIds: [], // Yeni kullanıcının favorileri boştur
      );

      // 3. Firestore Veritabanına Kullanıcı Detaylarını Kaydet
      await FirebaseFirestore.instance.collection('users').doc(uid).set({
        'isimSoyisim': newUser.isimSoyisim,
        'kullaniciAdi': newUser.kullaniciAdi,
        'email': newUser.email,
        'telefon': newUser.telefon,
        'favoritePlaceIds': [], // Boş liste olarak başlat
        'createdAt': FieldValue.serverTimestamp(), // Kayıt tarihi (isteğe bağlı)
      });

      // 4. Provider'ı Güncelle (ÖNEMLİ ADIM)
      // Bu adım sayesinde kayıt olur olmaz uygulama giriş yapıldığını anlar ve verileri gösterir.
      if (!mounted) return;
      Provider.of<UserNotifier>(context, listen: false).login(newUser);

      // Loading ekranını kapat
      Navigator.pop(context);

      _gosterSnackBar('Kayıt Başarılı! Otomatik olarak giriş yapıldı.', isError: false);

      // Not: main.dart içindeki StreamBuilder (AuthCheckScreen) zaten
      // authState changes'i dinlediği için otomatik yönlendirme yapabilir,
      // ancak Provider'ı güncellediğimiz için ekran bilgileri dolu gelecektir.

    } on fba.FirebaseAuthException catch (e) {
      // Hata durumunda loading'i kapat
      if (mounted) Navigator.pop(context);

      String hataMesaji = 'Kayıt başarısız oldu.';

      if (e.code == 'weak-password') {
        hataMesaji = 'Şifre çok zayıf. Lütfen daha güçlü bir şifre kullanın.';
      } else if (e.code == 'email-already-in-use') {
        hataMesaji = 'Bu e-posta adresi zaten kullanımda.';
      } else if (e.code == 'invalid-email') {
        hataMesaji = 'Geçersiz e-posta adresi formatı.';
      } else {
        hataMesaji = 'Hata: ${e.message}';
      }

      _gosterSnackBar(hataMesaji, isError: true);
    } catch (e) {
      if (mounted) Navigator.pop(context);
      _gosterSnackBar('Beklenmedik bir hata oluştu: $e', isError: true);
    }
  }

  @override
  Widget build(BuildContext context) {
    final bodyTextColor = Theme.of(context).textTheme.bodyMedium?.color;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Kayıt Ekranı'),
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(30.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              // Başlık
              Text(
                'Yeni Hesap Oluştur',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: bodyTextColor,
                ),
              ),
              const SizedBox(height: 30),

              // İsim Soyisim
              TextField(
                controller: _isimSoyisimController,
                keyboardType: TextInputType.name,
                decoration: const InputDecoration(
                  labelText: 'İsim Soyisim',
                  hintText: 'Adınızı ve soyadınızı girin',
                  prefixIcon: Icon(Icons.badge),
                ),
              ),
              const SizedBox(height: 20),

              // Kullanıcı Adı
              TextField(
                controller: _kullaniciAdiController,
                decoration: const InputDecoration(
                  labelText: 'Kullanıcı Adı',
                  hintText: 'Sadece harf ve rakam',
                  prefixIcon: Icon(Icons.person),
                ),
              ),
              const SizedBox(height: 20),

              // E-posta
              TextField(
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: const InputDecoration(
                  labelText: 'E-posta Adresi',
                  hintText: 'örnek@mail.com',
                  prefixIcon: Icon(Icons.email),
                ),
              ),
              const SizedBox(height: 20),

              // Telefon
              TextField(
                controller: _telefonController,
                keyboardType: TextInputType.phone,
                decoration: const InputDecoration(
                  labelText: 'Telefon Numarası',
                  hintText: '5xx xxx xx xx',
                  prefixIcon: Icon(Icons.phone),
                ),
              ),
              const SizedBox(height: 20),

              // Şifre
              TextField(
                controller: _passwordController,
                obscureText: true,
                decoration: const InputDecoration(
                  labelText: 'Şifre',
                  hintText: 'En az 6 karakter',
                  prefixIcon: Icon(Icons.lock),
                ),
              ),

              const SizedBox(height: 20),

              // Şifre Tekrarı
              TextField(
                controller: _confirmPasswordController,
                obscureText: true,
                decoration: const InputDecoration(
                  labelText: 'Şifre Tekrarı',
                  hintText: 'Şifrenizi tekrar girin',
                  prefixIcon: Icon(Icons.lock_reset),
                ),
              ),

              const SizedBox(height: 30),

              ElevatedButton(
                onPressed: _handleRegistration,
                child: const Text('Hemen Kaydol'),
              ),

              const SizedBox(height: 20),

              TextButton(
                onPressed: () {
                  Navigator.pop(context); // Giriş ekranına geri dön
                },
                child: const Text(
                  'Zaten hesabın var mı? Giriş Yap',
                  style: TextStyle(color: hintColor),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}