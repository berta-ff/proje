// lib/kayit_ekrani.dart

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as fba;
import 'dart:ui'; // Buzlu cam efekti için gerekli

class KayitEkrani extends StatefulWidget {
  const KayitEkrani({super.key});

  @override
  State<KayitEkrani> createState() => _KayitEkraniState();
}

class _KayitEkraniState extends State<KayitEkrani> {
  // Form Anahtarı (Validasyon için gerekli)
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _isimController = TextEditingController();
  final TextEditingController _kullaniciAdiController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _telefonController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmController = TextEditingController();

  bool _isLoading = false;
  bool _isPasswordVisible = false; // Şifre göster/gizle için

  @override
  void dispose() {
    _isimController.dispose();
    _kullaniciAdiController.dispose();
    _emailController.dispose();
    _telefonController.dispose();
    _passwordController.dispose();
    _confirmController.dispose();
    super.dispose();
  }

  void _handleRegistration() async {
    // 1. Form Validasyonu: Boş alan var mı kontrol et
    if (!_formKey.currentState!.validate()) {
      return; // Eğer hata varsa işlemi durdur
    }

    setState(() => _isLoading = true);

    try {
      // 2. Firebase Auth Kaydı
      fba.UserCredential cred = await fba.FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text,
      );

      // 3. Firestore Kaydı
      await FirebaseFirestore.instance.collection('users').doc(cred.user!.uid).set({
        'isimSoyisim': _isimController.text.trim(),
        'kullaniciAdi': _kullaniciAdiController.text.trim(),
        'email': _emailController.text.trim(),
        'telefon': _telefonController.text.trim(),
        'favoritePlaceIds': [],
        'createdAt': FieldValue.serverTimestamp(),
      });

      if (!mounted) return;

      // Başarılı Mesajı
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('🎉 Kayıt Başarılı! Giriş yapılıyor...'),
          backgroundColor: Colors.green,
        ),
      );

      // Geri dön (AuthCheckScreen otomatik yakalayacak)
      Navigator.pop(context);

    } on fba.FirebaseAuthException catch (e) {
      String message = 'Bir hata oluştu.';
      if (e.code == 'email-already-in-use') message = 'Bu e-posta zaten kullanımda.';
      if (e.code == 'weak-password') message = 'Şifre çok zayıf.';
      if (e.code == 'invalid-email') message = 'Geçersiz e-posta formatı.';

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(message), backgroundColor: Colors.redAccent),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Hata: $e'), backgroundColor: Colors.redAccent),
      );
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Klavye açılınca tasarımın bozulmaması için
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Stack(
        children: [
          // 1. KATMAN: Arka Plan Resmi
          Positioned.fill(
            child: Image.asset(
              'assets/images/arkaplann.jpg',
              fit: BoxFit.cover,
              errorBuilder: (c, o, s) => Container(color: const Color(0xFF1A1A2E)),
            ),
          ),

          // 2. KATMAN: Karartma (Overlay)
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.black.withOpacity(0.4),
                    Colors.black.withOpacity(0.8),
                  ],
                ),
              ),
            ),
          ),

          // 3. KATMAN: Form İçeriği
          Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 40),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10), // Buzlu cam efekti
                  child: Container(
                    padding: const EdgeInsets.all(30),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.1), // Şeffaf beyaz
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: Colors.white.withOpacity(0.2)),
                    ),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          const Text(
                            "Aramıza Katıl",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                              letterSpacing: 1.2,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            "Nerde Ne Var dünyasını keşfetmek için hesap oluşturun.",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.white.withOpacity(0.7),
                            ),
                          ),
                          const SizedBox(height: 30),

                          // İsim Soyisim
                          _buildModernTextField(
                            controller: _isimController,
                            label: "İsim Soyisim",
                            icon: Icons.person_outline,
                          ),
                          const SizedBox(height: 15),

                          // Kullanıcı Adı
                          _buildModernTextField(
                            controller: _kullaniciAdiController,
                            label: "Kullanıcı Adı",
                            icon: Icons.alternate_email,
                          ),
                          const SizedBox(height: 15),

                          // E-posta
                          _buildModernTextField(
                            controller: _emailController,
                            label: "E-posta Adresi",
                            icon: Icons.email_outlined,
                            inputType: TextInputType.emailAddress,
                          ),
                          const SizedBox(height: 15),

                          // Telefon
                          _buildModernTextField(
                            controller: _telefonController,
                            label: "Telefon Numarası",
                            icon: Icons.phone_iphone,
                            inputType: TextInputType.phone,
                          ),
                          const SizedBox(height: 15),

                          // Şifre
                          _buildModernTextField(
                            controller: _passwordController,
                            label: "Şifre",
                            icon: Icons.lock_outline,
                            isPassword: true,
                          ),
                          const SizedBox(height: 15),

                          // Şifre Tekrar
                          _buildModernTextField(
                            controller: _confirmController,
                            label: "Şifre Tekrar",
                            icon: Icons.lock_reset,
                            isPassword: true,
                            validator: (val) {
                              if (val != _passwordController.text) return "Şifreler uyuşmuyor";
                              return null;
                            },
                          ),
                          const SizedBox(height: 35),

                          // KAYIT BUTONU
                          _isLoading
                              ? const Center(child: CircularProgressIndicator(color: Colors.white))
                              : Container(
                            decoration: BoxDecoration(
                              gradient: const LinearGradient(
                                colors: [Color(0xFF4facfe), Color(0xFF00f2fe)],
                                begin: Alignment.centerLeft,
                                end: Alignment.centerRight,
                              ),
                              borderRadius: BorderRadius.circular(12),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.blue.withOpacity(0.3),
                                  blurRadius: 10,
                                  offset: const Offset(0, 5),
                                ),
                              ],
                            ),
                            child: ElevatedButton(
                              onPressed: _handleRegistration,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.transparent,
                                shadowColor: Colors.transparent,
                                padding: const EdgeInsets.symmetric(vertical: 16),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              child: const Text(
                                "Hesap Oluştur",
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),

                          const SizedBox(height: 20),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text("Zaten hesabın var mı? ", style: TextStyle(color: Colors.white.withOpacity(0.7))),
                              GestureDetector(
                                onTap: () => Navigator.pop(context),
                                child: const Text(
                                  "Giriş Yap",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    decoration: TextDecoration.underline,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // --- MODERN INPUT WIDGET ---
  Widget _buildModernTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    TextInputType inputType = TextInputType.text,
    bool isPassword = false,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      obscureText: isPassword && !_isPasswordVisible,
      keyboardType: inputType,
      style: const TextStyle(color: Colors.white),
      validator: validator ?? (value) {
        if (value == null || value.isEmpty) {
          return '$label boş bırakılamaz';
        }
        if (label == "Şifre" && value.length < 6) {
          return 'Şifre en az 6 karakter olmalı';
        }
        return null;
      },
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(color: Colors.white.withOpacity(0.7)),
        prefixIcon: Icon(icon, color: Colors.white.withOpacity(0.7)),
        suffixIcon: isPassword
            ? IconButton(
          icon: Icon(
            _isPasswordVisible ? Icons.visibility : Icons.visibility_off,
            color: Colors.white.withOpacity(0.7),
          ),
          onPressed: () {
            setState(() {
              _isPasswordVisible = !_isPasswordVisible;
            });
          },
        )
            : null,
        filled: true,
        fillColor: Colors.white.withOpacity(0.1),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.white.withOpacity(0.1)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.lightBlueAccent, width: 1.5),
        ),
        errorStyle: const TextStyle(color: Color(0xFFFF6B6B), fontWeight: FontWeight.bold),
      ),
    );
  }
}