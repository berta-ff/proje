// lib/screens/giris_ekrani.dart (VEYA lib/giris_ekrani.dart - Dosya yolun hangisiyse)

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart' as fba;
import 'package:cloud_firestore/cloud_firestore.dart'; // Firestore eklendi

// DİKKAT: UserNotifier ve Model importlarını kendi dosya yoluna göre ayarla
// Eğer providers klasöründeyse:
import 'providers/user_provider.dart';
// Eğer modeller models klasöründeyse:
import 'models/user.dart';

// Ana dizindeki dosyalar (Eğer oradaysa)
import 'kayit_ekrani.dart';

class GirisEkrani extends StatefulWidget {
  const GirisEkrani({super.key});

  @override
  State<GirisEkrani> createState() => _GirisEkraniState();
}

class _GirisEkraniState extends State<GirisEkrani> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  // 🔥 TEK DEĞİŞİKLİK BURASI: Loading'i kontrol eden değişken
  bool _isLoading = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _gosterSnackBar(String mesaj, {required bool isError}) {
    if (!mounted) return;
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
    Navigator.pushNamed(context, '/sifre_sifirlama');
  }

  void _kaydol() {
    Navigator.pushNamed(context, '/kayit');
  }

  // --- GİRİŞ MANTIĞI (GÜNCELLENDİ) ---
  void _handleLogin() async {
    final String email = _emailController.text.trim();
    final String password = _passwordController.text;

    if (email.isEmpty || password.isEmpty) {
      _gosterSnackBar('Lütfen e-posta ve şifrenizi girin.', isError: true);
      return;
    }

    // 1. Loading'i Başlat (Ekrana showDialog yerine değişken ile müdahale ediyoruz)
    setState(() {
      _isLoading = true;
    });

    try {
      // 2. Firebase Auth Girişi
      fba.UserCredential userCredential = await fba.FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      // 3. Firestore'dan Veri Çekme
      String uid = userCredential.user!.uid;
      DocumentSnapshot userDoc = await FirebaseFirestore.instance.collection('users').doc(uid).get();

      User loggedInUser;

      if (userDoc.exists) {
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
        // Kullanıcı verisi yoksa oluştur (Yedek Plan)
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

      if (!mounted) return;

      // 4. Provider Güncelle ve Yönlendir
      Provider.of<UserNotifier>(context, listen: false).login(loggedInUser);

      _gosterSnackBar('Giriş Başarılı!', isError: false);

      // Ana Ekrana Git
      Navigator.pushNamedAndRemoveUntil(context, '/', (route) => false);

    } on fba.FirebaseAuthException catch (e) {
      if (!mounted) return;
      String hataMesaji = 'Giriş başarısız oldu.';
      if (e.code == 'user-not-found' || e.code == 'wrong-password' || e.code == 'invalid-credential') {
        hataMesaji = 'Girdiğiniz e-posta veya şifre hatalı.';
      } else if (e.code == 'invalid-email') {
        hataMesaji = 'Geçersiz e-posta adresi formatı.';
      } else {
        hataMesaji = 'Hata: ${e.message}';
      }
      _gosterSnackBar(hataMesaji, isError: true);

      // Hata olduğunda loading'i kapat
      setState(() => _isLoading = false);

    } catch (e) {
      if (!mounted) return;
      _gosterSnackBar('Beklenmedik bir hata oluştu: $e', isError: true);
      setState(() => _isLoading = false);
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
      // Stack yapısını koruduk, sadece en sona Loading katmanı ekledik
      body: Stack(
        children: [
          // 1. KATMAN: ARKA PLAN RESMİ (Senin Orijinal Kodun)
          Positioned.fill(
            child: Opacity(
              opacity: 0.9,
              child: Image.asset('assets/images/arkaplann.jpg', fit: BoxFit.cover,
                errorBuilder: (c, o, s) => Container(color: Colors.grey[200]),
              ),
            ),
          ),

          // 2. KATMAN: İÇERİK (Senin Orijinal Kodun)
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

                  // Buton (Loading varsa devre dışı kalır)
                  ElevatedButton(
                    onPressed: _isLoading ? null : _handleLogin,
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

          // 3. KATMAN: YENİ LOADING PERDESİ (Tasarımı bozmaz, sadece üstüne gelir)
          if (_isLoading)
            Container(
              color: Colors.black.withOpacity(0.5),
              child: const Center(
                child: CircularProgressIndicator(color: Colors.white),
              ),
            ),
        ],
      ),
    );
  }
}