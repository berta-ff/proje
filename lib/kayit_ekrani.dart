import 'package:flutter/material.dart';

// DÜZELTİLMİŞ YOLLAR
import 'models/user.dart';
import 'services/local_auth_service.dart';

// main.dart'tan alınan sabitler
const Color hintColor = Colors.grey;
const Color accentColor = Colors.lightBlue;


class KayitEkrani extends StatefulWidget {
  const KayitEkrani({super.key});

  @override
  State<KayitEkrani> createState() => _KayitEkraniState();
}

class _KayitEkraniState extends State<KayitEkrani> {
  // 1. YENİ CONTROLLER'LAR EKLENDİ
  final TextEditingController _isimSoyisimController = TextEditingController();
  final TextEditingController _kullaniciAdiController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _telefonController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();

  final LocalAuthService _authService = LocalAuthService();

  @override
  void dispose() {
    // Tüm controller'ları dispose et
    _isimSoyisimController.dispose();
    _kullaniciAdiController.dispose();
    _emailController.dispose();
    _telefonController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
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

  void _handleRegistration() async {
    final String isimSoyisim = _isimSoyisimController.text.trim();
    final String kullaniciAdi = _kullaniciAdiController.text.trim();
    final String email = _emailController.text.trim();
    final String telefon = _telefonController.text.trim();
    final String password = _passwordController.text;
    final String confirmPassword = _confirmPasswordController.text;

    // Basit doğrulama kontrolleri
    if (isimSoyisim.isEmpty || kullaniciAdi.isEmpty || email.isEmpty || telefon.isEmpty || password.isEmpty || confirmPassword.isEmpty) {
      _gosterSnackBar('Hata: Tüm alanlar doldurulmalıdır.', isError: true);
      return;
    }

    if (!email.contains('@')) {
      _gosterSnackBar('Hata: Lütfen geçerli bir e-posta adresi girin.', isError: true);
      return;
    }

    if (password.length < 6) {
      _gosterSnackBar('Hata: Şifre en az 6 karakter olmalıdır.', isError: true);
      return;
    }

    if (password != confirmPassword) {
      _gosterSnackBar('Hata: Şifreler uyuşmuyor.', isError: true);
      return;
    }

    // Yeni kullanıcı nesnesi oluştur
    final newUser = User(
      isimSoyisim: isimSoyisim,
      kullaniciAdi: kullaniciAdi,
      email: email,
      telefon: telefon,
      sifre: password,
      favoritePlaceIds: [], // Yeni kullanıcı için boş favori listesi
    );

    // Servis ile kaydı dene
    final bool success = await _authService.registerUser(newUser);

    if (!mounted) return; // widget hala ağaçta mı kontrol et

    if (success) {
      _gosterSnackBar('Kayıt başarılı! Lütfen giriş yapın.', isError: false);
      // Kayıt başarılıysa giriş ekranına geri dön
      Navigator.pop(context);
    } else {
      _gosterSnackBar('Hata: Bu e-posta adresi zaten kayıtlı.', isError: true);
    }
  }


  @override
  Widget build(BuildContext context) {
    // Unused local variable uyarısı giderildi.
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
                  hintText: 'adınızı ve soyadınızı girin',
                  prefixIcon: Icon(Icons.badge),
                ),
              ),
              const SizedBox(height: 20),

              // Kullanıcı Adı
              TextField(
                controller: _kullaniciAdiController,
                decoration: const InputDecoration(
                  labelText: 'Kullanıcı Adı',
                  hintText: 'sadece harf ve rakam',
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
              // **********************************

              // Şifre
              TextField(
                controller: _passwordController,
                obscureText: true,
                decoration: const InputDecoration(
                  labelText: 'Şifre',
                  hintText: 'en az 6 karakterli şifre girin',
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
                  hintText: 'şifrenizi tekrar girin',
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
                child: Text('Zaten hesabın var mı? Giriş Yap', style: TextStyle(color: hintColor)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}