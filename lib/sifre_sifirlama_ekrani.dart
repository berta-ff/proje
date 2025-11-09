import 'package:flutter/material.dart';

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

  void _sifreSifirla() {
    final String email = _emailController.text;

    if (!email.contains('@')) {
      _gosterSnackBar('Hata: Lütfen geçerli bir e-posta adresi girin.', isError: true);
      return;
    }

    debugPrint('Şifre Sıfırlama Denemesi: E-posta: $email');
    _gosterSnackBar('Şifre sıfırlama bağlantısı e-posta adresinize gönderildi!', isError: false);

    // 1.5 saniye sonra geri dön
    Future.delayed(const Duration(milliseconds: 1500), () {
      if (!mounted) return;
      Navigator.pop(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    final accentColor = Theme.of(context).colorScheme.secondary;
    final bodyTextColor = Theme.of(context).textTheme.bodyMedium?.color;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Şifremi Unuttum'),
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(32.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
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