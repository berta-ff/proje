import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart' as fba;

// 🔥 ÖNEMLİ: UserNotifier artık providers klasöründe
import 'providers/user_provider.dart';

// Ekranlar
import 'kayit_ekrani.dart'; // Bu dosya lib/ klasöründe olduğu için doğrudan çağrılır
import 'screens/sifre_sifirlama_ekrani.dart'; // Bu dosya lib/screens/ klasöründe OLMALIDIR

class GirisEkrani extends StatefulWidget {
  const GirisEkrani({super.key});

  @override
  State<GirisEkrani> createState() => _GirisEkraniState();
}

class _GirisEkraniState extends State<GirisEkrani> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _gosterSnackBar(String mesaj, {required bool isError}) {
    final themeColor = Theme.of(context).colorScheme.secondary;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(mesaj),
        duration: const Duration(seconds: 2),
        backgroundColor: isError ? Colors.red.shade700 : themeColor,
      ),
    );
  }

  void _sifremiUnuttum() {
    // Şifre sıfırlama ekranına yönlendirme
    Navigator.pushNamed(context, '/sifre_sifirlama');
  }

  void _kaydol() {
    Navigator.pushNamed(context, '/kayit');
  }

  void _handleLogin() async {
    final String email = _emailController.text.trim();
    final String password = _passwordController.text;

    if (email.isEmpty || password.isEmpty) {
      _gosterSnackBar('Lütfen e-posta ve şifrenizi girin.', isError: true);
      return;
    }

    showDialog(
      context: context,
      builder: (context) => const Center(child: CircularProgressIndicator()),
      barrierDismissible: false,
    );

    try {
      await fba.FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (!mounted) return;
      Navigator.pop(context); // Loading kapat

      _gosterSnackBar('Giriş Başarılı! Yönlendiriliyorsunuz.', isError: false);

      // Main.dart'taki StreamBuilder zaten yönlendirmeyi yapacak.

    } on fba.FirebaseAuthException catch (e) {
      if (!mounted) return;
      Navigator.pop(context);
      String hataMesaji = 'Giriş başarısız oldu.';

      if (e.code == 'user-not-found' || e.code == 'wrong-password' || e.code == 'invalid-credential') {
        hataMesaji = 'Girdiğiniz e-posta veya şifre hatalı.';
      } else if (e.code == 'invalid-email') {
        hataMesaji = 'Geçersiz e-posta adresi formatı.';
      } else {
        hataMesaji = 'Hata: ${e.message}';
      }

      _gosterSnackBar(hataMesaji, isError: true);
    } catch (e) {
      if (!mounted) return;
      Navigator.pop(context);
      _gosterSnackBar('Beklenmedik bir hata oluştu: $e', isError: true);
    }
  }

  // Misafir Girişi
  void _guestLogin() {
    // UserNotifier provider üzerinden çağrılıyor
    Provider.of<UserNotifier>(context, listen: false).guestLogin();
    Navigator.pushNamedAndRemoveUntil(context, '/', (route) => false);
  }

  @override
  Widget build(BuildContext context) {
    final bodyTextColor = Theme.of(context).textTheme.bodyMedium?.color;

    return Scaffold(
      appBar: AppBar(title: const Text('Giriş Ekranı')),
      body: Stack(
        children: [
          Positioned.fill(
            child: Opacity(
              opacity: 0.9,
              child: Image.asset('assets/images/arkaplann.jpg', fit: BoxFit.cover,
                errorBuilder: (c, o, s) => Container(color: Colors.grey[200]),
              ),
            ),
          ),
          Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(30.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: Image.asset(
                      'assets/images/logos.png',
                      width: 150, height: 150, fit: BoxFit.contain,
                      errorBuilder: (context, error, stackTrace) {
                        return const Icon(Icons.image_not_supported, size: 100, color: Colors.grey);
                      },
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'Nerde Ne Var?',
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: bodyTextColor,
                    ),
                  ),
                  const SizedBox(height: 40),
                  TextField(
                    controller: _emailController,
                    keyboardType: TextInputType.emailAddress,
                    decoration: const InputDecoration(
                      labelText: 'E-posta Adresi',
                      prefixIcon: Icon(Icons.email),
                      filled: true,
                      fillColor: Colors.white70,
                    ),
                  ),
                  const SizedBox(height: 20),
                  TextField(
                    controller: _passwordController,
                    obscureText: true,
                    decoration: const InputDecoration(
                      labelText: 'Şifre',
                      prefixIcon: Icon(Icons.lock),
                      filled: true,
                      fillColor: Colors.white70,
                    ),
                  ),
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      onPressed: _sifremiUnuttum,
                      child: const Text('Şifremi Unuttum?', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, shadows: [Shadow(blurRadius: 2, color: Colors.black)])),
                    ),
                  ),
                  const SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: _handleLogin,
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [Icon(Icons.login), SizedBox(width: 10), Text('Giriş Yap')],
                    ),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text('Hesabın yok mu?', style: TextStyle(color: Colors.white, shadows: [Shadow(blurRadius: 2, color: Colors.black)])),
                      TextButton(
                        onPressed: _kaydol,
                        child: const Text('Kaydol', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, decoration: TextDecoration.underline, shadows: [Shadow(blurRadius: 2, color: Colors.black)])),
                      ),
                    ],
                  ),
                  TextButton(
                    onPressed: _guestLogin,
                    child: const Text('Misafir olarak devam et', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, shadows: [Shadow(blurRadius: 2, color: Colors.black)])),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}