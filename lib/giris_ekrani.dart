// giris_ekrani.dart
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart' as fba;

import 'models/user.dart';
import 'main.dart'; // UserNotifier için

// main.dart'tan alınan sabitler
const Color hintColor = Colors.grey;

class GirisEkrani extends StatefulWidget {
  const GirisEkrani({super.key});

  @override
  State<GirisEkrani> createState() => _GirisEkraniState();
}

class _GirisEkraniState extends State<GirisEkrani> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  // 🔥 YENİ: Loading durumunu kontrol eden değişken
  bool _isLoading = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _gosterSnackBar(String mesaj, {required bool isError}) {
    if (!mounted) return;
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

    // 1. Loading'i Başlat (Dialog açmıyoruz, değişkeni değiştiriyoruz)
    setState(() {
      _isLoading = true;
    });

    try {
      // 2. Firebase Auth Girişi
      fba.UserCredential userCredential = await fba.FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      String uid = userCredential.user!.uid;

      // 3. Firestore'dan veriyi çek
      DocumentSnapshot userDoc = await FirebaseFirestore.instance.collection('users').doc(uid).get();

      User loggedInUser;

      if (userDoc.exists) {
        // A. Kullanıcı verisi VAR
        Map<String, dynamic> userData = userDoc.data() as Map<String, dynamic>;

        List<dynamic> favListDyn = userData['favoritePlaceIds'] ?? [];
        List<int> favList = favListDyn.map((e) => int.parse(e.toString())).toList();

        loggedInUser = User(
          isimSoyisim: userData['isimSoyisim'] ?? '',
          kullaniciAdi: userData['kullaniciAdi'] ?? '',
          email: userData['email'] ?? email,
          telefon: userData['telefon'] ?? '',
          sifre: "",
          favoritePlaceIds: favList,
        );
      } else {
        // B. Kullanıcı verisi YOK -> Oluştur
        loggedInUser = User(
          isimSoyisim: "Kullanıcı",
          kullaniciAdi: email.split('@')[0],
          email: email,
          telefon: "",
          sifre: "",
          favoritePlaceIds: [],
        );

        await FirebaseFirestore.instance.collection('users').doc(uid).set({
          'isimSoyisim': loggedInUser.isimSoyisim,
          'kullaniciAdi': loggedInUser.kullaniciAdi,
          'email': loggedInUser.email,
          'telefon': loggedInUser.telefon,
          'favoritePlaceIds': [],
        });
      }

      // 4. Provider'ı güncelle ve Yönlendir
      // Not: AuthCheckScreen zaten otomatik yönlendirecek ama biz garanti olsun diye Provider'ı güncelliyoruz.
      if (mounted) {
        Provider.of<UserNotifier>(context, listen: false).login(loggedInUser);

        // Başarılı olduğunda loading'i kapatmaya gerek yok, çünkü sayfa değişecek.
        // Ama yine de temiz kod için:
        setState(() {
          _isLoading = false;
        });

        _gosterSnackBar('Giriş Başarılı!', isError: false);
        // Ana Ekrana Git
        Navigator.pushNamedAndRemoveUntil(context, '/', (route) => false);
      }

    } on fba.FirebaseAuthException catch (e) {
      // Hata durumunda Loading'i durdur
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }

      String hataMesaji = 'Giriş başarısız.';
      if (e.code == 'user-not-found' || e.code == 'wrong-password') {
        hataMesaji = 'E-posta veya şifre hatalı.';
      } else if (e.code == 'invalid-email') {
        hataMesaji = 'Geçersiz e-posta formatı.';
      } else {
        hataMesaji = 'Hata: ${e.message}';
      }
      _gosterSnackBar(hataMesaji, isError: true);

    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
      _gosterSnackBar('Beklenmedik bir hata: $e', isError: true);
      debugPrint("Giriş Hatası: $e");
    }
  }

  void _guestLogin() {
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
          // 1. ARKA PLAN
          Positioned.fill(
            child: Opacity(
              opacity: 0.9,
              child: Image.asset('assets/images/arkaplann.jpg', fit: BoxFit.cover),
            ),
          ),

          // 2. İÇERİK
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
                      width: 150,
                      height: 150,
                      fit: BoxFit.contain,
                      errorBuilder: (context, error, stackTrace) =>
                      const Icon(Icons.image_not_supported, size: 100, color: Colors.grey),
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
                      hintText: 'e-posta adresinizi girin',
                      prefixIcon: Icon(Icons.email),
                    ),
                  ),
                  const SizedBox(height: 20),
                  TextField(
                    controller: _passwordController,
                    obscureText: true,
                    decoration: const InputDecoration(
                      labelText: 'Şifre',
                      hintText: 'şifrenizi girin',
                      prefixIcon: Icon(Icons.lock),
                    ),
                  ),
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
                                Shadow(color: Colors.black54, offset: Offset(0, 2), blurRadius: 4),
                              ],
                            ),
                          ),
                          const Text('Şifremi Unuttum?', style: TextStyle(fontSize: 14, color: Colors.white)),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: _isLoading ? null : _handleLogin, // Loading varsa butona basılamaz
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
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('Hesabın yok mu?', style: TextStyle(color: hintColor)),
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
                                  Shadow(color: Colors.black54, offset: Offset(0, 2), blurRadius: 4),
                                ],
                              ),
                            ),
                            const Text('Kaydol', style: TextStyle(fontSize: 14, color: Colors.white)),
                          ],
                        ),
                      ),
                    ],
                  ),
                  TextButton(
                    onPressed: _guestLogin,
                    child: Stack(
                      children: [
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
                              Shadow(color: Colors.black, offset: Offset(0, 2), blurRadius: 4),
                            ],
                          ),
                        ),
                        const Text(
                          'Misafir olarak devam et',
                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Colors.white),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          // 3. 🔥 YENİ LOADING OVERLAY (En üst katman)
          if (_isLoading)
            Container(
              color: Colors.black.withOpacity(0.5), // Arka planı hafif karart
              child: const Center(
                child: CircularProgressIndicator(color: Colors.white),
              ),
            ),
        ],
      ),
    );
  }
}