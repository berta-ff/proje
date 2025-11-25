import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// Provider ve Modeller (Üst klasörlerde)
import '../providers/user_provider.dart';
import '../models/user.dart';

// Ekranlar (Aynı klasörde)
import 'faq_screen.dart';
import 'suggest_place_screen.dart';
import 'home_content.dart';
import 'search_content.dart';
import 'favorites_content.dart';
import 'profile_screens.dart';


class MainAppWrapper extends StatefulWidget {
  const MainAppWrapper({super.key});

  @override
  State<MainAppWrapper> createState() => _MainAppWrapperState();
}

class _MainAppWrapperState extends State<MainAppWrapper> {
  int _currentIndex = 0;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  late final List<Widget> _screens;

  @override
  void initState() {
    super.initState();
    _screens = [
      HomeContent(scaffoldKey: _scaffoldKey),
      const SearchContent(),
      const FavoritesContent(),
      const ProfileInfoScreen(showAppBar: false),
    ];
  }

  // Drawer (Yan Menü)
  Widget _buildAppDrawer(BuildContext context) {
    final accentColor = Theme.of(context).colorScheme.secondary;
    final User? currentUser = Provider.of<UserNotifier>(context).currentUser;
    final String drawerName = currentUser?.isimSoyisim ?? "Misafir Kullanıcı";
    final String drawerEmail = currentUser?.email ?? "Giriş Yapılmadı";

    return Drawer(
      child: Column(
        children: [
          UserAccountsDrawerHeader(
            accountName: Text(drawerName, style: const TextStyle(fontWeight: FontWeight.bold)),
            accountEmail: Text(drawerEmail),
            currentAccountPicture: const CircleAvatar(child: Icon(Icons.person)),
            decoration: BoxDecoration(color: accentColor),
          ),
          ListTile(
            leading: const Icon(Icons.help_outline),
            title: const Text('Sık Sorulan Sorular'),
            onTap: () {
              Navigator.pop(context);
              // Artık FaqScreen import edilebilir
              Navigator.of(context).push(MaterialPageRoute(builder: (context) => FaqScreen()));
            },
          ),

          ListTile(
            leading: const Icon(Icons.add_location),
            title: const Text('Yer Öner'),
            onTap: () {
              Navigator.of(context).pop();
              // Artık SuggestPlaceScreen import edilebilir
              Navigator.of(context).push(MaterialPageRoute(builder: (context) => const SuggestPlaceScreen()));
            },
          ),
          const Divider(),
          const Spacer(),
          ListTile(
            leading: const Icon(Icons.settings),
            title: const Text('Ayarlar'),
            onTap: () {
              Navigator.pop(context);
              Navigator.pushNamed(context, '/settings');
            },
          ),
          ListTile(
            leading: const Icon(Icons.logout),
            title: const Text('Çıkış Yap'),
            onTap: () {
              Provider.of<UserNotifier>(context, listen: false).logout();
              Navigator.pushNamedAndRemoveUntil(context, '/login', (Route<dynamic> route) => false);
            },
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final primaryColor = Theme.of(context).scaffoldBackgroundColor;
    final selectedColor = Theme.of(context).colorScheme.secondary;
    final unselectedColor = isDarkMode ? Colors.grey.shade400 : Colors.grey.shade600;

    return Scaffold(
      key: _scaffoldKey,
      drawer: _buildAppDrawer(context),
      body: IndexedStack(index: _currentIndex, children: _screens),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.15), spreadRadius: 0, blurRadius: 10)],
        ),
        child: BottomNavigationBar(
          currentIndex: _currentIndex,
          backgroundColor: primaryColor,
          elevation: 0,
          unselectedItemColor: unselectedColor,
          selectedItemColor: selectedColor,
          type: BottomNavigationBarType.fixed,
          onTap: (index) => setState(() => _currentIndex = index),
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.home, size: 26), label: 'Ana Sayfa'),
            BottomNavigationBarItem(icon: Icon(Icons.search, size: 26), label: 'Ara'),
            BottomNavigationBarItem(icon: Icon(Icons.favorite_border, size: 26), label: 'Favoriler'),
            BottomNavigationBarItem(icon: Icon(Icons.account_circle, size: 26), label: 'Hesap'),
          ],
        ),
      ),
    );
  }
}