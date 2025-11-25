// lib/screens/auth_check_screen.dart
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart' as fba;
import 'package:provider/provider.dart';
import '../giris_ekrani.dart';
import 'main_app_wrapper.dart';
import '../providers/user_provider.dart';

class AuthCheckScreen extends StatefulWidget {
  const AuthCheckScreen({super.key});

  @override
  State<AuthCheckScreen> createState() => _AuthCheckScreenState();
}

class _AuthCheckScreenState extends State<AuthCheckScreen> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<fba.User?>(
      stream: fba.FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        // 1. Bağlantı bekleniyor
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(body: Center(child: CircularProgressIndicator()));
        }

        // 2. Kullanıcı Giriş Yapmış
        if (snapshot.hasData && snapshot.data != null) {
          final firebaseUser = snapshot.data!;

          return Consumer<UserNotifier>(
            builder: (context, userNotifier, child) {
              // Eğer Provider'da veri yoksa, arka planda çek
              if (userNotifier.currentUser == null) {
                // Future.microtask ile build işlemi çakışmasını önlüyoruz
                Future.microtask(() => userNotifier.fetchUser(firebaseUser.uid));

                // Veri gelene kadar loading göster
                return const Scaffold(
                  body: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CircularProgressIndicator(),
                        SizedBox(height: 10),
                        Text("Profil Yükleniyor...")
                      ],
                    ),
                  ),
                );
              }

              // Veri varsa Ana Sayfaya git
              return const MainAppWrapper();
            },
          );
        }

        // 3. Giriş Yapılmamış
        return const GirisEkrani();
      },
    );
  }
}