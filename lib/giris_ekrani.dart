import 'package:flutter/material.dart';

// Gerekli import'lar
import 'models/user.dart';
import 'services/local_auth_service.dart';
import 'package:provider/provider.dart';
import 'main.dart'; // UserNotifier sınıfını buradan alacak
import 'package:firebase_auth/firebase_auth.dart' as fba; // Firebase Auth

// main.dart'tan alınan sabitler
const Color hintColor = Colors.grey;
const Color accentColor = Colors.lightBlue;


class GirisEkrani extends StatefulWidget {
  const GirisEkrani({super.key});

  @override
  State<GirisEkrani> createState() => _GirisEkraniState();
}

class _GirisEkraniState extends State<GirisEkrani> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  // LocalAuthService nesnesi artık _handleLogin'de kullanılmadığı için burada kalması sorun yaratmaz.

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
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

  void _sifremiUnuttum() {
    // Şifre sıfırlama ekranı rotası
    Navigator.pushNamed(context, '/sifre_sifirlama');
  }

  void _kaydol() {
    // Kaydol ekranı rotası
    Navigator.pushNamed(context, '/kayit');
  }

  // GİRİŞ İŞLEMİNİ YÖNETEN METOT (DÜZELTİLDİ: Yönlendirme Eklendi)
  void _handleLogin() async {
    final String email = _emailController.text.trim();
    final String password = _passwordController.text;

    if (email.isEmpty || password.isEmpty) {
      _gosterSnackBar('Lütfen e-posta ve şifrenizi girin.', isError: true);
      return;
    }

    // Loading göstergesini başlat
    showDialog(
      context: context,
      builder: (context) => const Center(child: CircularProgressIndicator()),
      barrierDismissible: false,
    );

    try {
      // 🔥 Firebase'e GİRİŞ İŞLEMİ 🔥
      await fba.FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Başarı durumunda
      if (!mounted) return;
      Navigator.pop(context); // Loading ekranını kapat

      _gosterSnackBar('Giriş Başarılı! Yönlendiriliyorsunuz.', isError: false);

      // 🔥 KESİN ÇÖZÜM: BAŞARILI GİRİŞTE ANA EKRANA ZORLA YÖNLENDİRME 🔥
      // Bu komut, ikinci girişteki takılma sorununu çözecektir.
      Navigator.pushNamedAndRemoveUntil(context, '/', (route) => false);

    } on fba.FirebaseAuthException catch (e) {
      // Hata durumunda
      if (!mounted) return;
      Navigator.pop(context); // Loading ekranını kapat
      String hataMesaji = 'Giriş başarısız oldu.';

      if (e.code == 'user-not-found' || e.code == 'wrong-password') {
        hataMesaji = 'Girdiğiniz e-posta veya şifre hatalı.';
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

  // Misafir olarak giriş yapma metodu
  void _guestLogin() {
    // UserNotifier'ın guestLogin metodunu çağır (Bu hala yerel auth mantığıdır)
    Provider.of<UserNotifier>(context, listen: false).guestLogin();

    // Ana ekrana yönlendir
    // Burada da pushNamedAndRemoveUntil kullanmak daha iyidir.
    Navigator.pushNamedAndRemoveUntil(context, '/', (route) => false);
  }


  @override
  Widget build(BuildContext context) {
    // Tema renklerini al
    final bodyTextColor = Theme.of(context).textTheme.bodyMedium?.color;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Giriş Ekranı'),
      ),
      body: Stack(
        children: [
          // ARKA PLAN FOTOĞRAFI - TÜM EKRANI KAPLAYACAK
          Positioned.fill(
            child: Opacity(
              opacity: 0.9, // Arka plan şeffaflığı (0.1-1.0 arası ayarlayabilirsiniz)
              child: Image.asset(
                'assets/images/arkaplann.jpg',
                fit: BoxFit.cover,
              ),
            ),
          ),

          // ÖN PLANDAKI İÇERİK
          Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(30.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  // SADECE LOGOS.PNG FOTOĞRAFI
                  ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: Image.asset(
                      'assets/images/logos.png', // logos.png dosyanız
                      width: 150,
                      height: 150,
                      fit: BoxFit.contain,
                      errorBuilder: (context, error, stackTrace) {
                        return Icon(
                          Icons.image_not_supported,
                          size: 100,
                          color: Colors.grey,
                        );
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

                  const SizedBox(height: 20),

                  // Şifre Giriş Alanı
                  TextField(
                    controller: _passwordController,
                    obscureText: true,
                    decoration: const InputDecoration(
                      labelText: 'Şifre',
                      hintText: 'şifrenizi girin',
                      prefixIcon: Icon(Icons.lock),
                    ),
                  ),

                  // Şifremi Unuttum Bağlantısı
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      onPressed: _sifremiUnuttum,
                      child: Stack(
                        children: [
                          Text(
                            'Şifremi Unuttum?',
                            style: TextStyle(
                              fontSize: 14,
                              foreground: Paint()
                                ..style = PaintingStyle.stroke
                                ..strokeWidth = 1
                                ..color = Colors.black,
                              shadows: const [
                                Shadow(
                                  color: Colors.black54,
                                  offset: Offset(0, 2),
                                  blurRadius: 4,
                                ),
                              ],
                            ),
                          ),
                          const Text(
                            'Şifremi Unuttum?',
                            style: TextStyle(
                                fontSize: 14,
                                color: Colors.white
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 10),

                  // Giriş Butonu (İnce, uzun ikonlu)
                  ElevatedButton(
                    onPressed: _handleLogin,
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Icon(Icons.login, size: 28),
                        SizedBox(width: 10),
                        Text('Giriş Yap'),
                      ],
                    ),
                  ),

                  const SizedBox(height: 20),

                  // Kaydol Bağlantısı
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Hesabın yok mu?',
                        style: TextStyle(color: hintColor),
                      ),
                      TextButton(
                        onPressed: _kaydol,
                        child: Stack(
                          children: [
                            Text(
                              'Kaydol',
                              style: TextStyle(
                                fontSize: 14,
                                foreground: Paint()
                                  ..style = PaintingStyle.stroke
                                  ..strokeWidth = 1
                                  ..color = Colors.black,
                                shadows: const [
                                  Shadow(
                                    color: Colors.black54,
                                    offset: Offset(0, 2),
                                    blurRadius: 4,
                                  ),
                                ],
                              ),
                            ),
                            const Text(
                              'Kaydol',
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),

                  // YENİ: Misafir olarak Giriş Butonu
                  TextButton(
                    onPressed: _guestLogin,
                    child: Stack(
                      children: [
                        // Kenar (Stroke)
                        Text(
                          'Misafir olarak devam et',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                            foreground: Paint()
                              ..style = PaintingStyle.stroke
                              ..strokeWidth = 1
                              ..color = Colors.black,
                            shadows: const [
                              Shadow(
                                color: Colors.black,
                                offset: Offset(0, 2),
                                blurRadius: 4,
                              ),
                            ],
                          ),
                        ),
                        // Ana Metin
                        Text(
                          'Misafir olarak devam et',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
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