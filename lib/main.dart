import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';

// Yapılandırma Dosyası
import 'firebase_options.dart';

// Provider'lar (Durum Yönetimi)
import 'providers/theme_provider.dart';
import 'providers/user_provider.dart';

// Kök Dizindeki Ekranlar (Klasör yapısında kökte bıraktıklarımız)
import 'giris_ekrani.dart';
import 'kayit_ekrani.dart';

// Screens Klasöründeki Ekranlar
import 'screens/auth_check_screen.dart';
import 'screens/main_app_wrapper.dart';
import 'screens/settings_screen.dart';
import 'screens/detail_screen.dart';
import 'screens/event_detail_screen.dart';
import 'screens/profile_screens.dart'; // Profil, Düzenleme ve Şifre ekranları
import 'screens/sifre_sifirlama_ekrani.dart'; // Screens klasörüne taşıdığımız şifre ekranı

void main() async {
  // 1. Flutter Motorunu Hazırla
  WidgetsFlutterBinding.ensureInitialized();

  // 2. Firebase'i Başlat
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // 3. Uygulamayı Başlat
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // MultiProvider ile User ve Theme durumlarını tüm ağaca yayıyoruz
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ThemeNotifier()),
        ChangeNotifierProvider(create: (_) => UserNotifier()),
      ],
      child: Consumer<ThemeNotifier>(
        builder: (context, themeNotifier, child) {
          return MaterialApp(
            title: 'Nerede Ne Var?',
            debugShowCheckedModeBanner: false, // Debug bandını kaldırır

            // Tema Ayarları (Theme Provider'dan gelir)
            theme: buildCustomTheme(brightness: Brightness.light),
            darkTheme: buildCustomTheme(brightness: Brightness.dark),
            themeMode: themeNotifier.themeMode,

            // 🚀 ROTA YÖNETİMİ (Tüm ekranlar burada tanımlı)
            initialRoute: '/auth_check',
            routes: {
              // Uygulama açılışında giriş kontrolü
              '/auth_check': (context) => const AuthCheckScreen(),

              // Kimlik Doğrulama Ekranları
              '/login': (context) => const GirisEkrani(),
              '/kayit': (context) => const KayitEkrani(),
              '/sifre_sifirlama': (context) => const SifreSifirlamaEkrani(),

              // Ana Uygulama (Alt Menü ve Drawer içeren yapı)
              '/': (context) => const MainAppWrapper(),

              // Ayarlar ve Profil Ekranları
              '/settings': (context) => const SettingsScreen(),
              '/profile': (context) => const ProfileInfoScreen(showAppBar: true),
              '/edit_profile': (context) => const EditProfileScreen(),
              '/change_password': (context) => const ChangePasswordScreen(),

              // Etkinlik Detay Ekranı (Argüman alır)
              '/event_detail': (context) => EventDetailScreen(
                event: ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>,
              ),

              // Mekan Detay Ekranı (Veri güvenliği ve Argüman işleme)
              '/detail': (context) {
                final item = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;

                // Gelen veriyi güvenli bir Map kopyasına dönüştürme
                final Map<String, dynamic> safeItem = Map.from(item);

                // Menü listesi için güvenli tip dönüşümü
                if (safeItem['menu'] is List && safeItem['menu'] != null) {
                  safeItem['menu'] = (safeItem['menu'] as List).cast<Map<String, dynamic>>();
                }

                // Yorum listesi için güvenli tip dönüşümü
                if (safeItem['comments'] is List && safeItem['comments'] != null) {
                  safeItem['comments'] = (safeItem['comments'] as List).cast<Map<String, dynamic>>();
                }

                return DetailScreen(item: safeItem);
              },
            },
          );
        },
      ),
    );
  }
}