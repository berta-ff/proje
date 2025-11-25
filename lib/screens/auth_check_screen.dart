import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart' as fba;
import '../giris_ekrani.dart'; // Ana dizindeki dosya
import 'main_app_wrapper.dart'; // Aynı klasördeki dosya

class AuthCheckScreen extends StatelessWidget {
  const AuthCheckScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<fba.User?>(
      stream: fba.FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }
        if (snapshot.hasData && snapshot.data != null) {
          return const MainAppWrapper();
        }
        return const GirisEkrani();
      },
    );
  }
}