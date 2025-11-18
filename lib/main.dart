import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:async'; // Timer için eklendi

// DÜZELTİLMİŞ/EKSİK IMPORT'LAR
import 'models/user.dart';
import 'giris_ekrani.dart';
import 'kayit_ekrani.dart';
import 'services/local_auth_service.dart';

// 🔥 Sadece tek bir kez ve prefix ile import edin
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:firebase_auth/firebase_auth.dart' as fba;
import 'package:flutter/widgets.dart'; // WidgetsFlutterBinding için
import 'sifre_sifirlama_ekrani.dart';

// Açık Mavi/Beyaz Tema Renkleri (BU KODLAR IMPORT'LARDAN SONRA GELMELİ)
const Color accentColor = Colors.lightBlue;
const Color inputFillColor = Color(0xFFEFEFEF);
const Color hintColor = Colors.grey;

// Global Kategoriler Haritası
final Map<String, IconData> categories = {
  '🍽️ Yemek Yerleri': Icons.restaurant,
  '🗺️ Gezilecek Yerler': Icons.map,
  '🛍️ Alışveriş': Icons.shopping_bag,
  '🎉 Eğlence Yerleri': Icons.celebration,
};

// --- Sıralama Türü Enum'u ---
enum SortingType { none, ratingHighToLow, ratingLowToHigh }

// --- Yorum Filtreleme Türü Enum'u ---
enum CommentFilterType {
  all,
  min4Stars,
  exact5Stars,
  exact1Star,
}

// ************************************************
// KULLANICI YÖNETİMİ MODEL VE STATE SINIFLARI
// ************************************************

// 3. Kullanıcı Oturum Yönetimi (Provider)
class UserNotifier extends ChangeNotifier {
  User? _currentUser;

  User? get currentUser => _currentUser;

  // Giriş yapıldığında çağrılır
  void login(User user) {
    _currentUser = user;
    notifyListeners();
  }

  // Çıkış yapıldığında çağrılır
  void logout() {
    _currentUser = null;
    notifyListeners();
  }

  // YENİ: Misafir olarak devam et metodu
  void guestLogin() {
    _currentUser = null; // Misafir, yani giriş yapılmamış durum.
    notifyListeners();
  }

  // Kullanıcı bilgilerini günceller (Sadece oturumu günceller)
  void updateUser(User oldUser, {
    required String isimSoyisim,
    required String kullaniciAdi,
    required String email,
    required String telefon,
  }) {
    // Yeni User nesnesini yeni bilgilerle oluştur
    final newUser = User(
      isimSoyisim: isimSoyisim,
      kullaniciAdi: kullaniciAdi,
      email: email,
      telefon: telefon,
      sifre: oldUser.sifre, // Şifreyi koru
      favoritePlaceIds: oldUser.favoritePlaceIds, // Favorileri koru
    );

    _currentUser = newUser;
    notifyListeners();
  }

  // Şifreyi değiştirir (Sadece oturumu günceller)
  String? changePassword(User oldUser, String oldSifre, String newSifre) {
    // 1. Mevcut şifre kontrolü
    if (oldUser.sifre != oldSifre) {
      return 'Hata: Mevcut şifreniz yanlış.';
    }

    // 2. Yeni User nesnesini yeni şifre ile oluştur
    final newUser = User(
      isimSoyisim: oldUser.isimSoyisim,
      kullaniciAdi: oldUser.kullaniciAdi,
      email: oldUser.email,
      telefon: oldUser.telefon,
      sifre: newSifre, // Yeni şifre
      favoritePlaceIds: oldUser.favoritePlaceIds, // Favorileri koru
    );

    // 3. Geçerli oturumu yeni kullanıcı ile güncelle
    _currentUser = newUser;
    notifyListeners();
    return null; // Başarı durumunda null döner
  }

  // YENİ: Favori Ekleme/Kaldırma
  Future<void> toggleFavorite(int placeId) async {
    if (_currentUser == null) {
      // Misafir kullanıcı için bir şey yapma
      return;
    }

    List<int> currentFavorites = List.from(_currentUser!.favoritePlaceIds);
    bool isFavorite = currentFavorites.contains(placeId);

    if (isFavorite) {
      currentFavorites.remove(placeId);
    } else {
      currentFavorites.add(placeId);
    }

    // Kalıcı depolamayı güncelle
    final LocalAuthService authService = LocalAuthService();
    final bool success = await authService.updateUserFavorites(_currentUser!, currentFavorites);

    if (success) {
      // Eğer kalıcı depolama başarılıysa, UserNotifier'ı güncelle
      final updatedUser = User(
        isimSoyisim: _currentUser!.isimSoyisim,
        kullaniciAdi: _currentUser!.kullaniciAdi,
        email: _currentUser!.email,
        telefon: _currentUser!.telefon,
        sifre: _currentUser!.sifre,
        favoritePlaceIds: currentFavorites,
      );

      _currentUser = updatedUser;
      notifyListeners();
    }
  }
}


// ************************************************
// TEMA YÖNETİMİ VE TEMEL UYGULAMA YAPISI
// ************************************************

// Tema Yönetimi için ChangeNotifier
class ThemeNotifier extends ChangeNotifier {
  ThemeMode _themeMode = ThemeMode.light;

  ThemeMode get themeMode => _themeMode;

  void setThemeMode(ThemeMode mode) {
    _themeMode = mode;
    notifyListeners();
  }
}

// Özel Tema Fonksiyonu
ThemeData _buildCustomTheme({required Brightness brightness}) {
  final isLight = brightness == Brightness.light;
  final primaryBackgroundColor = isLight ? Colors.white : const Color(0xFF282C34);
  final primaryTextColor = isLight ? Colors.black87 : Colors.white;

  // Deprecated `withOpacity` uyarısını gidermek için `withAlpha` kullanıldı.
  final semiOpaqueColor = primaryTextColor.withAlpha((255 * 0.8).round());

  return ThemeData(
    primaryColor: accentColor,
    hintColor: accentColor,
    brightness: brightness,
    scaffoldBackgroundColor: primaryBackgroundColor,
    appBarTheme: AppBarTheme(
      backgroundColor: accentColor,
      foregroundColor: Colors.white,
      elevation: 0,
      centerTitle: true,
      titleTextStyle: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
    ),
    textTheme: TextTheme(
      bodyMedium: TextStyle(color: primaryTextColor),
      titleMedium: TextStyle(color: semiOpaqueColor),
      headlineMedium: TextStyle(color: primaryTextColor),
      headlineLarge: TextStyle(color: primaryTextColor),
    ).apply(
      bodyColor: primaryTextColor,
      displayColor: primaryTextColor,
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: isLight ? inputFillColor : const Color(0xFF3B4048),
      hintStyle: TextStyle(color: hintColor),
      labelStyle: TextStyle(color: hintColor),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide.none,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(color: accentColor, width: 2),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide.none,
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: accentColor,
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        padding: const EdgeInsets.symmetric(vertical: 12),
        textStyle: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        minimumSize: const Size(double.infinity, 0),
      ),
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: accentColor,
        textStyle: const TextStyle(fontWeight: FontWeight.w600),
      ),
    ),
    colorScheme: ColorScheme.fromSwatch(primarySwatch: Colors.lightBlue).copyWith(secondary: accentColor, brightness: brightness),
  );
}


void main() async { // async eklendi
  // 1. Flutter'ın widget bağlarını hazırlar (Firebase init için zorunlu)
  WidgetsFlutterBinding.ensureInitialized();

  // 2. Firebase'i başlatır
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ThemeNotifier()),
        ChangeNotifierProvider(create: (_) => UserNotifier()),
      ],
      child: Consumer<ThemeNotifier>(
        builder: (context, themeNotifier, child) {
          return MaterialApp(
            title: 'Nerede Ne Var?',
            theme: _buildCustomTheme(brightness: Brightness.light),
            darkTheme: _buildCustomTheme(brightness: Brightness.dark),
            themeMode: themeNotifier.themeMode,

            // Uygulama Giriş Noktası
            initialRoute: '/auth_check',
            routes: {
              '/auth_check': (context) => const AuthCheckScreen(),
              // Giriş ekranını harici dosyadan alıyoruz
              '/login': (context) => const GirisEkrani(),
              '/kayit': (context) => const KayitEkrani(),
              '/': (context) => const MainAppWrapper(),
              '/settings': (context) => const SettingsScreen(),
              '/sifre_sifirlama': (context) => const SifreSifirlamaEkrani(),
              '/profile': (context) => const ProfileInfoScreen(showAppBar: true),
              '/edit_profile': (context) => const EditProfileScreen(),
              '/change_password': (context) => const ChangePasswordScreen(),
              '/detail': (context) => DetailScreen(
                item: ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>,
              ),
            },
          );
        },
      ),
    );
  }
}


// ************************************************
// ANA SARAMALAYICI VE BOTTOM NAVIGATION BAR
// ************************************************

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

  // Drawer İçeriği
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
            title: const Text('Sık Sorulan Sorulanlar'),
            onTap: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Sık Sorulanlar Sayfasına Yönlendiriliyor...')));
            },
          ),
          ListTile(
            leading: const Icon(Icons.support_agent),
            title: const Text('Destek Hattı'),
            onTap: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Destek Hattı Çağrısı Başlatılıyor...')));
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
              // Çıkış yapıldığında UserNotifier'ı güncelle
              Provider.of<UserNotifier>(context, listen: false).logout();
              Navigator.pushNamedAndRemoveUntil(
                  context,
                  '/login',
                      (Route<dynamic> route) => false
              );
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

      body: IndexedStack(
        index: _currentIndex,
        children: _screens,
      ),

      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.15),
              spreadRadius: 0,
              blurRadius: 10,
            ),
          ],
        ),
        child: BottomNavigationBar(
          currentIndex: _currentIndex,
          backgroundColor: primaryColor,
          elevation: 0,
          unselectedItemColor: unselectedColor,
          selectedItemColor: selectedColor,
          type: BottomNavigationBarType.fixed,
          selectedFontSize: 12,
          unselectedFontSize: 10,
          selectedLabelStyle: const TextStyle(fontWeight: FontWeight.bold),

          onTap: (index) {
            setState(() {
              _currentIndex = index;
            });
          },
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

// ************************************************
// ÖRNEK VERİLERİ VE TÜM ALT SINIFLAR
// ************************************************

class DataModel {
  static final List<Map<String, dynamic>> items = [
    {
      'id': 1,
      'name': 'Gastro Lounge',
      'category': '🍽️ Yemek Yerleri',
      'description': 'Modern mutfak ve rahat atmosfer. Şehirdeki en popüler mekanlardan biri.',
      'rating': 4.5,
      'location': 'Şehir Merkezi',
      'menu': [
        {'name': 'Izgara Somon', 'price': 85},
        {'name': 'Vegan Burger', 'price': 70},
        {'name': 'Makarna Çeşitleri', 'price': 60}
      ],
      'comments': [
        {'user': 'Ali Y.', 'text': 'Somon harikaydı, servis hızlıydı.', 'rating': 5.0},
        {'user': 'Buse K.', 'text': 'Biraz pahalı ama yemekler lezzetli.', 'rating': 4.0},
        {'user': 'Canan D.', 'text': 'Ortam çok güzel.', 'rating': 5.0},
      ],
      'details': ['Hızlı Servis', 'Geniş Otopark', 'Açık Alan'],
    },
    {
      'id': 2,
      'name': 'Tarihi Çarşı',
      'category': '🛍️ Alışveriş',
      'description': 'Yerel el sanatları, antika ve hediyelik eşyaların bulunduğu eski çarşı.',
      'rating': 4.8,
      'location': 'Eski Şehir',
      'menu': [],
      'comments': [
        {'user': 'Furkan G.', 'text': 'Aradığım antika parçayı buldum!', 'rating': 5.0},
      ],
      'details': ['Halka Açık', 'Otobüs Erişimi'],
    },
    {
      'id': 3,
      'name': 'Yeşil Göl',
      'category': '🗺️ Gezilecek Yerler',
      'description': 'Huzurlu doğa manzarası, piknik alanları ve uzun yürüyüş parkurları.',
      'rating': 5.0,
      'location': 'Dağ Eteği',
      'menu': [],
      'comments': [
        {'user': 'Cemil A.', 'text': 'Görülmeye değer, tertemiz hava!', 'rating': 5.0},
        {'user': 'Deniz B.', 'text': 'Çok kalabalıktı, hafta içi gitmek daha iyi.', 'rating': 4.0},
        {'user': 'Eda T.', 'text': 'Mükemmel bir gün geçirdim.', 'rating': 5.0},
      ],
      'details': ['Giriş Saati: 09:00 - 18:00', 'Giriş Ücreti: 10₺'],
    },
    {
      'id': 4,
      'name': 'Adrenalin Park',
      'category': '🎉 Eğlence Yerleri',
      'description': 'Tırmanma duvarı, zip-line ve macera parkurları.',
      'rating': 4.2,
      'location': 'Orman Kenarı',
      'menu': [],
      'comments': [
        {'user': 'Hakan Ş.', 'text': 'Çok eğlenceliydi!', 'rating': 5.0},
      ],
      'details': ['Haftasonu Kalabalık', 'Yaş Sınırı: 10+'],
    },
    {
      'id': 5,
      'name': 'Deniz Restaurant',
      'category': '🍽️ Yemek Yerleri',
      'description': 'Taze deniz ürünleri ve deniz manzarası.',
      'rating': 3.5,
      'location': 'Sahil Yolu',
      'menu': [
        {'name': 'Balık Çeşitleri', 'price': 120},
        {'name': 'Karides Güveç', 'price': 150}
      ],
      'comments': [
        {'user': 'Furkan G.', 'text': 'Manzara harika, servis yavaştı.', 'rating': 3.0},
        {'user': 'Selin Y.', 'text': 'Pahalı ve lezzetsiz.', 'rating': 1.0},
      ],
      'details': ['Canlı Müzik', 'Deniz Manzaralı'],
    },
  ];

  static List<Map<String, dynamic>> filterAndSortItems(String category, double minRating, double maxRating, SortingType sortingType) {
    List<Map<String, dynamic>> filteredList = items
        .where((item) => item['category'] == category)
        .where((item) => (item['rating'] as double) >= minRating && (item['rating'] as double) <= maxRating)
        .toList();

    if (sortingType == SortingType.ratingHighToLow) {
      filteredList.sort((a, b) => (b['rating'] as double).compareTo(a['rating'] as double));
    } else if (sortingType == SortingType.ratingLowToHigh) {
      filteredList.sort((a, b) => (a['rating'] as double).compareTo(b['rating'] as double));
    }
    return filteredList;
  }
}

// 1. Ana Sayfa İçeriği (Kategori Grid Görünümü)
class HomeContent extends StatelessWidget {
  final GlobalKey<ScaffoldState> scaffoldKey;
  const HomeContent({super.key, required this.scaffoldKey});

  @override
  Widget build(BuildContext context) {
    final accentColor = Theme.of(context).colorScheme.secondary;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Ana Sayfa'),
        backgroundColor: accentColor,
        leading: IconButton(
          icon: const Icon(Icons.menu, size: 30, color: Colors.white),
          onPressed: () {
            scaffoldKey.currentState?.openDrawer();
          },
        ),
        // Dead code uyarısını gidermek için actions düzenlendi
        actions: [
          IconButton(
            icon: const Icon(Icons.settings, size: 30, color: Colors.white),
            onPressed: () {
              Navigator.pushNamed(context, '/settings');
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // REKLAM BOŞLUĞU
            Container(
              height: 60,
              color: Colors.grey.shade200,
              margin: const EdgeInsets.only(bottom: 15),
              child: Center(
                child: Text('REKLAM ALANI', style: TextStyle(color: Colors.grey.shade700)),
              ),
            ),

            const Padding(
              padding: EdgeInsets.only(bottom: 12.0, top: 8.0),
              child: Text('Kategoriler', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
            ),
            Expanded(
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  crossAxisSpacing: 10.0,
                  mainAxisSpacing: 10.0,
                  childAspectRatio: 1.0,
                ),
                itemCount: categories.length,
                itemBuilder: (context, index) {
                  final entry = categories.entries.elementAt(index);
                  // CategoryListScreen'e gönderilen başlık, data modelindeki ile aynı olmalı.
                  return _buildCategoryGridItem(context, entry.key, entry.value);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoryGridItem(BuildContext context, String title, IconData icon) {
    final accentColor = Theme.of(context).colorScheme.secondary;

    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: InkWell(
        onTap: () {
          // Bu kısımdaki title (örneğin: '🍽️ Yemek Yerleri') direkt olarak filtreleniyor.
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => CategoryListScreen(selectedCategory: title),
            ),
          );
        },
        borderRadius: BorderRadius.circular(10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 30, color: accentColor),
            const SizedBox(height: 5),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4.0),
              child: Text(
                // Bu kısım sadece gösterim için (\n ile satır atlatıldı).
                title.replaceAll(' ', '\n'),
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// 2. Ara İçeriği
class SearchContent extends StatefulWidget {
  const SearchContent({super.key});
  @override
  State<SearchContent> createState() => _SearchContentState();
}

class _SearchContentState extends State<SearchContent> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged() {
    setState(() {
      _searchQuery = _searchController.text;
    });
  }

  List<Map<String, dynamic>> get _filteredPlaceList {
    if (_searchQuery.isEmpty) {
      return DataModel.items; // Arama yoksa tüm öğeleri göster
    }

    final query = _searchQuery.toLowerCase();
    return DataModel.items.where((place) {
      final name = place['name']?.toLowerCase() ?? '';
      final description = place['description']?.toLowerCase() ?? '';
      final category = place['category']?.toLowerCase() ?? '';

      // İsimde, açıklamada veya kategoride arama yap
      return name.contains(query) || description.contains(query) || category.contains(query);
    }).toList();
  }

  Widget _buildRatingStars(double rating) {
    int fullStars = rating.floor();
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(5, (index) {
        if (index < fullStars) {
          return const Icon(Icons.star, color: Colors.amber, size: 16);
        } else {
          return const Icon(Icons.star_border, color: Colors.grey, size: 16);
        }
      }),
    );
  }

  @override
  Widget build(BuildContext context) {
    final accentColor = Theme.of(context).colorScheme.secondary;
    final UserNotifier userNotifier = Provider.of<UserNotifier>(context);
    final List<int> favoriteIds = userNotifier.currentUser?.favoritePlaceIds ?? [];
    final List<Map<String, dynamic>> results = _filteredPlaceList;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Ara'),
        backgroundColor: accentColor,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                labelText: 'Mekan, kategori veya açıklama ara',
                hintText: 'Örn: Kebapçı, Tarihi Yer...',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: _searchQuery.isNotEmpty
                    ? IconButton(
                  icon: const Icon(Icons.clear),
                  onPressed: () {
                    _searchController.clear();
                  },
                )
                    : null,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
              ),
            ),
          ),
          Expanded(
            child: results.isEmpty && _searchQuery.isNotEmpty
                ? const Center(child: Text('Aradığınız kriterlere uygun sonuç bulunamadı.'))
                : ListView.builder(
              itemCount: results.length,
              itemBuilder: (context, index) {
                final item = results[index];
                final isFavorite = favoriteIds.contains(item['id']);
                final IconData? categoryIcon = categories[item['category']];

                return Card(
                  margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  elevation: 4,
                  child: ListTile(
                    leading: categoryIcon != null
                        ? Icon(categoryIcon, color: accentColor)
                        : const Icon(Icons.place, color: Colors.grey),
                    title: Text(item['name']!),
                    subtitle: Row(
                      children: [
                        _buildRatingStars(item['rating'] as double),
                        Text(' Puan: ${(item['rating'] as double).toStringAsFixed(1)} - ${item['category']}'),
                      ],
                    ),
                    trailing: IconButton(
                      icon: Icon(
                        isFavorite ? Icons.favorite : Icons.favorite_border,
                        color: isFavorite ? Colors.red : Colors.grey,
                      ),
                      // Favori butonu basıldığında UserNotifier'daki metodu çağır
                      onPressed: () => userNotifier.toggleFavorite(item['id'] as int),
                    ),
                    onTap: () {
                      Navigator.pushNamed(context, '/detail', arguments: item);
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}


// 3. Favoriler İçeriği
class FavoritesContent extends StatelessWidget {
  const FavoritesContent({super.key});

  @override
  Widget build(BuildContext context) {
    final accentColor = Theme.of(context).colorScheme.secondary;
    final UserNotifier userNotifier = Provider.of<UserNotifier>(context);
    final User? currentUser = userNotifier.currentUser;
    final bool isLoggedIn = currentUser != null;

    return Scaffold(
      appBar: AppBar(title: const Text('Favoriler'), backgroundColor: Colors.pink),
      body: !isLoggedIn // Misafir Kontrolü
          ? Center(
        child: Padding(
          padding: const EdgeInsets.all(30.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.lock_outline, size: 80, color: Colors.grey.shade400),
              const SizedBox(height: 20),
              const Text(
                'Favori listesini görebilmek için giriş yapmalısınız.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);
                },
                child: const Text('Giriş Yap / Kaydol'),
              ),
            ],
          ),
        ),
      )
          : _buildFavoriteList(context, userNotifier, accentColor),
    );
  }

  Widget _buildRatingStars(double rating) {
    int fullStars = rating.floor();
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(5, (index) {
        if (index < fullStars) {
          return const Icon(Icons.star, color: Colors.amber, size: 16);
        } else {
          return const Icon(Icons.star_border, color: Colors.grey, size: 16);
        }
      }),
    );
  }

  Widget _buildFavoriteList(BuildContext context, UserNotifier userNotifier, Color accentColor) {
    final List<int> favoriteIds = userNotifier.currentUser!.favoritePlaceIds;

    // Favori ID'lerine göre yerleri filtrele
    final List<Map<String, dynamic>> favoritePlaces = DataModel.items
        .where((item) => favoriteIds.contains(item['id']))
        .toList();

    if (favoritePlaces.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.favorite_border, size: 80, color: Colors.pink.shade300),
            const SizedBox(height: 20),
            const Text(
              'Henüz favorilere eklediğiniz bir yer yok.',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            const Text('Favorilere eklemek için Ana Sayfa veya Ara sekmesini kullanın.'),
          ],
        ),
      );
    }

    return ListView.builder(
      itemCount: favoritePlaces.length,
      itemBuilder: (context, index) {
        final item = favoritePlaces[index];
        final IconData? categoryIcon = categories[item['category']];
        // Favoriler listesindeki her öğe zaten favori olduğu için isFavorite her zaman true'dur.
        const bool isFavorite = true;

        return Card(
          margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
          elevation: 4,
          child: ListTile(
            leading: categoryIcon != null
                ? Icon(categoryIcon, color: accentColor)
                : const Icon(Icons.place, color: Colors.grey),
            title: Text(item['name']!),
            subtitle: Row(
              children: [
                _buildRatingStars(item['rating'] as double),
                Text(' Puan: ${(item['rating'] as double).toStringAsFixed(1)} - ${item['category']}'),
              ],
            ),
            trailing: IconButton(
              icon: Icon(
                isFavorite ? Icons.favorite : Icons.favorite_border,
                color: isFavorite ? Colors.red : Colors.grey,
              ),
              onPressed: () => userNotifier.toggleFavorite(item['id'] as int),
            ),
            onTap: () {
              Navigator.pushNamed(context, '/detail', arguments: item);
            },
          ),
        );
      },
    );
  }
}

// --- Profil Bilgileri Sayfası (Hesap Sekmesi İçeriği) ---
class ProfileInfoScreen extends StatelessWidget {
  final bool showAppBar;
  const ProfileInfoScreen({super.key, this.showAppBar = false});

  @override
  Widget build(BuildContext context) {
    final profileColor = Colors.deepPurple;
    final primaryTextColor = Theme.of(context).textTheme.bodyMedium?.color;

    // Kullanıcı bilgilerini UserNotifier'dan al
    final User? currentUser = Provider.of<UserNotifier>(context).currentUser;

    // Kullanıcıya göre dinamik değerler
    final userName = currentUser?.kullaniciAdi ?? 'Misafir';
    final userEmail = currentUser?.email ?? 'Giriş Yapılmadı';
    final userPhone = currentUser?.telefon ?? 'Bilinmiyor';
    final userIsimSoyisim = currentUser?.isimSoyisim ?? 'Giriş Yapılmadı';
    final bool isLoggedIn = currentUser != null;


    return Scaffold(
      appBar: showAppBar
          ? AppBar(title: const Text('Hesap Bilgileri'), backgroundColor: profileColor)
          : null,
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(30.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              CircleAvatar(radius: 60, child: Icon(Icons.person, size: 80, color: isLoggedIn ? Colors.white : Colors.grey)),
              const SizedBox(height: 30),

              // Profil Detayları
              _buildProfileDetail(Icons.badge, 'Ad Soyad', userIsimSoyisim, primaryTextColor),
              _buildProfileDetail(Icons.person, 'Kullanıcı Adı', userName, primaryTextColor),
              _buildProfileDetail(Icons.email, 'E-posta', userEmail, primaryTextColor),
              _buildProfileDetail(Icons.phone, 'Telefon', userPhone, primaryTextColor),
              _buildProfileDetail(Icons.lock, 'Şifre', '******', primaryTextColor),

              const SizedBox(height: 20),

              if (isLoggedIn)
                ElevatedButton(
                  onPressed: () {
                    // Bilgileri Düzenle ekranına yönlendir
                    Navigator.pushNamed(context, '/edit_profile');
                  },
                  child: const Text('Bilgileri Düzenle'),
                )
              else
                ElevatedButton(
                  onPressed: () {
                    // Giriş yapma ekranına yönlendir
                    Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);
                  },
                  child: const Text('Giriş Yap'),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProfileDetail(IconData icon, String label, String value, Color? primaryTextColor) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, color: Colors.grey),
              const SizedBox(width: 8),
              Text('$label:', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: primaryTextColor)),
            ],
          ),
          const SizedBox(height: 4),
          Text(value, style: const TextStyle(fontSize: 16, color: Colors.blue), textAlign: TextAlign.center),
        ],
      ),
    );
  }
}

// --- Kategori Listeleme Sayfası ---
class CategoryListScreen extends StatefulWidget {
  final String selectedCategory;
  const CategoryListScreen({super.key, required this.selectedCategory});

  @override
  State<CategoryListScreen> createState() => _CategoryListScreenState();
}

class _CategoryListScreenState extends State<CategoryListScreen> {
  // Filtreleme ve Sıralama State'leri
  double _minRating = 1.0;
  double _maxRating = 5.0;
  SortingType _currentSort = SortingType.none;

  // Rating yıldızlarını oluşturan yardımcı metot
  Widget _buildRatingStars(double rating) {
    int fullStars = rating.floor();
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(5, (index) {
        if (index < fullStars) {
          return const Icon(Icons.star, color: Colors.amber, size: 16);
        } else {
          return const Icon(Icons.star_border, color: Colors.grey, size: 16);
        }
      }),
    );
  }


  // Ana içerik (Listeyi oluşturan metot)
  Widget _buildMainContent(BuildContext context) {
    final accentColor = Theme.of(context).colorScheme.secondary;

    // Filtreleri uygulayarak listeyi al
    final List<Map<String, dynamic>> places = DataModel.filterAndSortItems(
      widget.selectedCategory,
      _minRating,
      _maxRating,
      _currentSort,
    );

    // Favori ID'lerini UserNotifier'dan al
    final List<int> favoritePlaceIds = Provider.of<UserNotifier>(context).currentUser?.favoritePlaceIds ?? [];
    final UserNotifier userNotifier = Provider.of<UserNotifier>(context, listen: false);

    // Listeyi oluştur
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Toplam ${places.length} Yer Bulundu', style: const TextStyle(fontWeight: FontWeight.bold)),
              Row(
                children: [
                  TextButton.icon(
                    onPressed: _showFilterDialog,
                    icon: const Icon(Icons.filter_list),
                    label: const Text('Filtrele'),
                  ),
                ],
              ),
            ],
          ),
        ),
        Expanded(
          child: places.isEmpty
              ? Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'Aradığınız kriterlere uygun yer bulunamadı.',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 18),
                ),
                const SizedBox(height: 20),
                TextButton(
                  onPressed: () {
                    setState(() {
                      _minRating = 1;
                      _maxRating = 5;
                      _currentSort = SortingType.none;
                    });
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Filtreler sıfırlandı!')));
                  },
                  child: const Text('Filtreleri Sıfırla'),
                ),
              ],
            ),
          )
              : ListView.builder(
            itemCount: places.length,
            itemBuilder: (context, index) {
              final item = places[index];
              final isFavorite = favoritePlaceIds.contains(item['id']);
              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                elevation: 4,
                child: ListTile(
                  // Icon bilgisini kategoriler haritasından alıyoruz
                  leading: Icon(categories[widget.selectedCategory], color: accentColor),
                  title: Text(item['name']!),
                  subtitle: Row(
                    children: [
                      _buildRatingStars(item['rating'] as double),
                      Text(' Puan: ${(item['rating'] as double).toStringAsFixed(1)}'),
                    ],
                  ),
                  trailing: IconButton(
                    icon: Icon(
                      isFavorite ? Icons.favorite : Icons.favorite_border,
                      color: isFavorite ? Colors.red : Colors.grey,
                    ),
                    onPressed: () => userNotifier.toggleFavorite(item['id'] as int),
                  ),
                  onTap: () {
                    Navigator.pushNamed(context, '/detail', arguments: item);
                  },
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  // Filtre iletişim kutusunu gösteren metot
  void _showFilterDialog() {
    SortingType tempSort = _currentSort;
    RangeValues tempRatingRange = RangeValues(_minRating, _maxRating);

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setStateSB) {
            return AlertDialog(
              title: const Text('Filtreler ve Sıralama'),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    const Text('Sıralama', style: TextStyle(fontWeight: FontWeight.bold)),
                    DropdownButton<SortingType>(
                      value: tempSort,
                      isExpanded: true,
                      items: const [
                        DropdownMenuItem(value: SortingType.none, child: Text("Varsayılan (Filtreler)")),
                        DropdownMenuItem(value: SortingType.ratingHighToLow, child: Text("Puan: En Yüksekten En Düşüğe (⭐)")),
                        DropdownMenuItem(value: SortingType.ratingLowToHigh, child: Text("Puan: En Düşükten En Yüksekğe (⭐)")),
                      ],
                      onChanged: (SortingType? newValue) {
                        setStateSB(() {
                          tempSort = newValue!;
                        });
                      },
                    ),
                    const Divider(height: 30),
                    const Text('Memnuniyet Aralığı (Yıldız)', style: TextStyle(fontWeight: FontWeight.bold)),
                    const SizedBox(height: 10),
                    RangeSlider(
                      values: tempRatingRange,
                      min: 1,
                      max: 5,
                      divisions: 4,
                      labels: RangeLabels(tempRatingRange.start.round().toString(), tempRatingRange.end.round().toString()),
                      onChanged: (RangeValues newValues) {
                        setStateSB(() {
                          tempRatingRange = newValues;
                        });
                      },
                    ),
                    Text('Seçilen Yıldız Aralığı: ${tempRatingRange.start.round()} - ${tempRatingRange.end.round()}'),
                  ],
                ),
              ),
              actions: <Widget>[
                TextButton(child: const Text('Kapat'), onPressed: () { Navigator.of(context).pop(); }),
                ElevatedButton(
                  child: const Text('Uygula'),
                  onPressed: () {
                    setState(() {
                      _minRating = tempRatingRange.start;
                      _maxRating = tempRatingRange.end;
                      _currentSort = tempSort;
                    });
                    Navigator.of(context).pop();
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Filtreler ve Sıralama uygulandı!')));
                  },
                ),
              ],
            );
          },
        );
      },
    );
  }


  @override
  Widget build(BuildContext context) {
    final accentColor = Theme.of(context).colorScheme.secondary;
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.selectedCategory),
        backgroundColor: accentColor,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings, size: 30, color: Colors.white),
            onPressed: () {
              Navigator.pushNamed(context, '/settings');
            },
          ),
        ],
      ),
      body: _buildMainContent(context),
    );
  }
}

// --- Detay ve Yorum Ekranı ---
class DetailScreen extends StatefulWidget {
  final Map<String, dynamic> item;
  const DetailScreen({super.key, required this.item});

  @override
  State<DetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  Set<int> _selectedRatings = {1, 2, 3, 4, 5};
  final TextEditingController _commentController = TextEditingController();
  double _newRating = 5.0; // Yeni yorum için başlangıç puanı
  bool _isCommentAreaVisible = false;

  List<Map<String, dynamic>> get _allComments => widget.item['comments'] as List<Map<String, dynamic>>? ?? [];

  List<Map<String, dynamic>> get _filteredComments {
    if (_selectedRatings.isEmpty) return [];

    return _allComments.where((comment) {
      final rating = (comment['rating'] as num).round();
      return _selectedRatings.contains(rating);
    }).toList();
  }

  void _addComment() {
    final User? currentUser = Provider.of<UserNotifier>(context, listen: false).currentUser;

    if (currentUser == null) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Yorum yapabilmek için giriş yapmalısınız.')));
      return;
    }

    if (_commentController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Lütfen bir yorum yazın.')));
      return;
    }

    final newComment = {
      'user': currentUser.kullaniciAdi, // Kullanıcı adını kullan
      'text': _commentController.text.trim(),
      'rating': _newRating,
    };

    // DataModel'deki listeyi doğrudan değiştirmemiz gerektiği için,
    // gerçek uygulamada bu bir servis katmanı aracılığıyla yapılmalıdır.
    // Şimdilik, sadece widget'ın state'ini ve DataModel'i güncelleyelim.
    setState(() {
      widget.item['comments'] = [..._allComments, newComment];
      _commentController.clear();
      _isCommentAreaVisible = false;
      _newRating = 5.0; // Puanı sıfırla
    });

    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Yorumunuz eklendi!')));
  }

  // --- Yardımcı Metotlar ---

  Widget _buildRatingStars(double rating) {
    int fullStars = rating.floor();
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(5, (index) {
        if (index < fullStars) {
          return const Icon(Icons.star, color: Colors.amber, size: 16);
        } else {
          return const Icon(Icons.star_border, color: Colors.grey, size: 16);
        }
      }),
    );
  }

  Widget _buildMenuSection(List<Map<String, dynamic>>? menu) {
    if (menu == null || menu.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Popüler Menüler', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
        const SizedBox(height: 10),
        ...menu.map((m) => Padding(
          padding: const EdgeInsets.symmetric(vertical: 4.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(m['name']!),
              Text('${m['price']} ₺', style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.green)),
            ],
          ),
        )),
      ],
    );
  }

  Widget _buildDetailsSection(List<String>? details) {
    if (details == null || details.isEmpty) return const SizedBox.shrink();
    final accentColor = Theme.of(context).colorScheme.secondary;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Detaylar', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
        const SizedBox(height: 10),
        ...details.map((d) => Padding(
          padding: const EdgeInsets.symmetric(vertical: 4.0),
          child: Row(
            children: [
              Icon(Icons.info_outline, size: 20, color: accentColor),
              const SizedBox(width: 8),
              Flexible(child: Text(d)),
            ],
          ),
        )),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final isFoodCategory = widget.item['category'] == '🍽️ Yemek Yerleri';
    final accentColor = Theme.of(context).colorScheme.secondary;
    final primaryTextColor = Theme.of(context).textTheme.bodyMedium?.color ?? Colors.black;

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.item['name']!),
        backgroundColor: accentColor,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 200,
              decoration: BoxDecoration(
                color: Theme.of(context).brightness == Brightness.light ? Colors.grey[300] : Colors.grey[700],
                borderRadius: BorderRadius.circular(8),
              ),
              child: Center(child: Text(isFoodCategory ? 'Yemek Fotoğrafı' : 'Gezi Fotoğrafı', style: const TextStyle(fontSize: 20))),
            ),
            const SizedBox(height: 16),
            Text(widget.item['name']!, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Text(widget.item['description']!, style: const TextStyle(fontSize: 16)),
            const Divider(height: 30),

            if (isFoodCategory) ...[
              _buildMenuSection(widget.item['menu'] as List<Map<String, dynamic>>?),
            ] else ...[
              _buildDetailsSection(widget.item['details'] as List<String>?),
            ],

            const Divider(height: 30),

            // --- Yorumlar Bölümü ---
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Yorumlar (${_filteredComments.length})', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: primaryTextColor)),
                TextButton.icon(
                  onPressed: () {
                    setState(() {
                      _isCommentAreaVisible = !_isCommentAreaVisible;
                    });
                  },
                  icon: Icon(_isCommentAreaVisible ? Icons.close : Icons.edit, color: accentColor),
                  label: Text(_isCommentAreaVisible ? 'Yorumu Kapat' : 'Yorum Yap', style: TextStyle(color: accentColor)),
                ),
              ],
            ),
            const SizedBox(height: 10),

            // Yorum Yapma Alanı
            if (_isCommentAreaVisible)
              Padding(
                padding: const EdgeInsets.only(bottom: 16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text('Puanın: ', style: TextStyle(fontSize: 16)),
                        Slider(
                          value: _newRating,
                          min: 1,
                          max: 5,
                          divisions: 4,
                          label: _newRating.toStringAsFixed(1),
                          onChanged: (double value) {
                            setState(() {
                              _newRating = value;
                            });
                          },
                          activeColor: Colors.amber,
                          inactiveColor: Colors.grey,
                        ),
                        Text(_newRating.toStringAsFixed(1), style: const TextStyle(fontWeight: FontWeight.bold)),
                      ],
                    ),
                    TextField(
                      controller: _commentController,
                      maxLines: 3,
                      decoration: InputDecoration(
                        labelText: 'Yorumunuz',
                        hintText: 'Deneyiminizi paylaşın...',
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                      ),
                    ),
                    const SizedBox(height: 10),
                    ElevatedButton(
                      onPressed: _addComment,
                      child: const Text('Yorumu Gönder'),
                    ),
                  ],
                ),
              ),

            // Yorum Filtreleme Butonları
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  _buildFilterChip('Tümü', {1, 2, 3, 4, 5}),
                  _buildFilterChip('5 Yıldız', {5}),
                  _buildFilterChip('4+ Yıldız', {4, 5}),
                  _buildFilterChip('1 Yıldız', {1}),
                ],
              ),
            ),
            const SizedBox(height: 10),

            // Yorum Listesi
            if (_filteredComments.isEmpty)
              const Center(child: Padding(
                padding: EdgeInsets.all(20.0),
                child: Text('Bu filtreye uygun yorum bulunamadı.'),
              ))
            else
              ..._filteredComments.map((comment) => Card(
                margin: const EdgeInsets.symmetric(vertical: 4),
                child: ListTile(
                  leading: const CircleAvatar(child: Icon(Icons.person)),
                  title: Text(comment['user']!),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildRatingStars(comment['rating'] as double),
                      Text(comment['text']!),
                    ],
                  ),
                ),
              )),
          ],
        ),
      ),
    );
  }

  Widget _buildFilterChip(String label, Set<int> ratings) {
    final bool isSelected = _selectedRatings.containsAll(ratings) && ratings.containsAll(_selectedRatings);

    return Padding(
      padding: const EdgeInsets.only(right: 8.0),
      child: FilterChip(
        label: Text(label),
        selected: isSelected,
        onSelected: (bool selected) {
          setState(() {
            _selectedRatings = ratings;
          });
        },
      ),
    );
  }
}

// --- Kullanıcı Bilgilerini Düzenleme Sayfası ---
class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});
  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  // YENİ: Form Key
  final _formKey = GlobalKey<FormState>();

  // YENİ: Controller'lar ve LocalAuthService
  late TextEditingController isimSoyisimController;
  late TextEditingController kullaniciAdiController;
  late TextEditingController emailController;
  late TextEditingController telefonController;
  final LocalAuthService _authService = LocalAuthService();
  bool _isLoading = false;
  late User _oldUser;

  @override
  void initState() {
    super.initState();
    _oldUser = Provider.of<UserNotifier>(context, listen: false).currentUser!;
    isimSoyisimController = TextEditingController(text: _oldUser.isimSoyisim);
    kullaniciAdiController = TextEditingController(text: _oldUser.kullaniciAdi);
    emailController = TextEditingController(text: _oldUser.email);
    telefonController = TextEditingController(text: _oldUser.telefon);
  }

  @override
  void dispose() {
    isimSoyisimController.dispose();
    kullaniciAdiController.dispose();
    emailController.dispose();
    telefonController.dispose();
    super.dispose();
  }

  // Bilgileri kaydetme metodu (güncellendi)
  void _saveProfile() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      // 1. Yeni User nesnesini oluştur
      final updatedUser = User(
        email: emailController.text,
        sifre: _oldUser.sifre,
        isimSoyisim: isimSoyisimController.text,
        kullaniciAdi: kullaniciAdiController.text,
        telefon: telefonController.text,
        favoritePlaceIds: _oldUser.favoritePlaceIds, // Favorileri koru
      );

      // 2. LocalAuthService ile kalıcı veriyi güncelle
      // ERROR FIX: Hatalı parametreler kaldırıldı, LocalAuthService'in yeni imzasını kullanır
      final bool updateSuccess = await _authService.updateUser(
        oldUser: _oldUser,
        newUser: updatedUser,
      );

      if (!mounted) return;

      if (updateSuccess) {
        // 3. UserNotifier'ı güncelle
        Provider.of<UserNotifier>(context, listen: false).updateUser(
          _oldUser,
          isimSoyisim: isimSoyisimController.text,
          kullaniciAdi: kullaniciAdiController.text,
          email: emailController.text,
          telefon: telefonController.text,
        );

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Bilgiler başarıyla güncellendi!')),
        );
        Navigator.pop(context); // Profil ekranına geri dön
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Hata: Kullanıcı adı veya E-posta zaten kullanılıyor.')),
        );
      }

      setState(() {
        _isLoading = false;
      });
    }
  }

  // Şifre Değiştirme sayfasına yönlendirme
  void _changePassword() {
    Navigator.pushNamed(context, '/change_password');
  }

  @override
  Widget build(BuildContext context) {
    final accentColor = Theme.of(context).colorScheme.secondary;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Bilgileri Düzenle'),
        backgroundColor: Colors.deepPurple, // Profil rengi
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(30.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                const Text(
                  'Hesap Bilgilerini Güncelle',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 30),

                // İsim Soyisim Alanı
                TextFormField(
                  controller: isimSoyisimController,
                  keyboardType: TextInputType.name,
                  decoration: const InputDecoration(labelText: 'İsim Soyisim', prefixIcon: Icon(Icons.badge)),
                  validator: (value) {
                    if (value == null || value.isEmpty || value.split(' ').length < 2) {
                      return 'Lütfen adınızı ve soyadınızı girin.';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),

                // Kullanıcı Adı Alanı
                TextFormField(
                  controller: kullaniciAdiController,
                  decoration: const InputDecoration(labelText: 'Kullanıcı Adı', prefixIcon: Icon(Icons.person)),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Lütfen bir kullanıcı adı girin.';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),

                // E-posta Alanı
                TextFormField(
                  controller: emailController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: const InputDecoration(labelText: 'E-posta', prefixIcon: Icon(Icons.email)),
                  validator: (value) {
                    if (value == null || !value.contains('@')) {
                      return 'Lütfen geçerli bir e-posta girin.';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),

                // Telefon Alanı
                TextFormField(
                  controller: telefonController,
                  keyboardType: TextInputType.phone,
                  decoration: const InputDecoration(labelText: 'Telefon', prefixIcon: Icon(Icons.phone)),
                  validator: (value) {
                    if (value == null || value.isEmpty || value.length < 10) {
                      return 'Lütfen geçerli bir telefon numarası girin.';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 30),

                // Şifre Değiştirme Butonu
                TextButton(
                  onPressed: _changePassword,
                  child: const Text('Şifreyi Değiştir'),
                ),

                const SizedBox(height: 20),

                // Kaydet Butonu
                _isLoading
                    ? Center(child: CircularProgressIndicator(color: accentColor))
                    : ElevatedButton(
                  onPressed: _saveProfile,
                  child: const Text('BİLGİLERİ KAYDET'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// --- Şifre Değiştirme Sayfası ---
class ChangePasswordScreen extends StatefulWidget {
  const ChangePasswordScreen({super.key});
  @override
  State<ChangePasswordScreen> createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController currentPasswordController = TextEditingController();
  final TextEditingController newPasswordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();
  final LocalAuthService _authService = LocalAuthService();
  bool _isLoading = false;

  @override
  void dispose() {
    currentPasswordController.dispose();
    newPasswordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  void _saveNewPassword() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      final User? oldUser = Provider.of<UserNotifier>(context, listen: false).currentUser;
      if (oldUser == null) {
        setState(() {
          _isLoading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Hata: Oturum bulunamadı.')));
        return;
      }

      // 1. Mevcut şifre kontrolü (LocalAuthService'te de kontrol ediliyor, ama burada UI geri bildirimi için ön kontrol)
      if (oldUser.sifre != currentPasswordController.text) {
        setState(() {
          _isLoading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Hata: Mevcut şifreniz yanlış.')));
        return;
      }

      // 2. LocalAuthService'i kullanarak kalıcı veriyi güncelle
      final bool updateSuccess = await _authService.updateUserPassword(oldUser, newPasswordController.text);

      if (!mounted) return; // Asenkron işlem sonrası BuildContext kontrolü

      setState(() {
        _isLoading = false;
      });

      if (updateSuccess) {
        // 3. Veri kalıcı olarak güncellendikten sonra UserNotifier'ı güncelle
        // UserNotifier içindeki changePassword metodu, şifrenin doğru olduğunu varsayar
        Provider.of<UserNotifier>(context, listen: false).changePassword(
          oldUser,
          currentPasswordController.text,
          newPasswordController.text,
        );

        // Başarılı
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Şifreniz başarıyla güncellendi!')));
        Navigator.pop(context); // Önceki ekrana geri dön (EditProfileScreen)
      } else {
        // Hata (Genellikle kullanıcı bulunamadı)
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Hata: Şifre güncelleme işlemi başarısız oldu.')));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final accentColor = Theme.of(context).colorScheme.secondary;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Şifre Değiştir'),
        backgroundColor: Colors.deepPurple,
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(30.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                const Text(
                  'Yeni Şifrenizi Belirleyin',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 30),

                // Mevcut Şifre Alanı
                TextFormField(
                  controller: currentPasswordController,
                  obscureText: true,
                  decoration: const InputDecoration(labelText: 'Mevcut Şifre', prefixIcon: Icon(Icons.lock)),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Lütfen mevcut şifrenizi girin.';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),

                // Yeni Şifre Alanı
                TextFormField(
                  controller: newPasswordController,
                  obscureText: true,
                  decoration: const InputDecoration(labelText: 'Yeni Şifre', prefixIcon: Icon(Icons.lock_open)),
                  validator: (value) {
                    if (value == null || value.length < 6) {
                      return 'Şifre en az 6 karakter olmalıdır.';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),

                // Yeni Şifre Tekrar Alanı
                TextFormField(
                  controller: confirmPasswordController,
                  obscureText: true,
                  decoration: const InputDecoration(labelText: 'Yeni Şifre Tekrar', prefixIcon: Icon(Icons.lock_reset)),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Lütfen yeni şifreyi tekrar girin.';
                    }
                    if (value != newPasswordController.text) {
                      return 'Şifreler uyuşmuyor.';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 30),

                // Kaydet Butonu
                _isLoading
                    ? Center(child: CircularProgressIndicator(color: accentColor))
                    : ElevatedButton(
                  onPressed: _saveNewPassword,
                  child: const Text('ŞİFREYİ GÜNCELLE'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// --- Ayarlar Sayfası ---
class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});
  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class AuthCheckScreen extends StatelessWidget {
  const AuthCheckScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // ⚠️ StreamBuilder, Firebase'in oturum durumunu sürekli dinler.
    return StreamBuilder<fba.User?>(
      // fba.User: Firebase'in User sınıfı.
      stream: fba.FirebaseAuth.instance.authStateChanges(),
      // fba.FirebaseAuth: Firebase'in Auth sınıfı.

      builder: (context, snapshot) {
        // 1. Bağlantı bekleme durumunda (Yükleniyor ekranı)
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        // 2. Kullanıcı giriş yapmış mı kontrolü.
        if (snapshot.hasData && snapshot.data != null) {
          // Kullanıcı giriş yapmış. Ana ekranı göster.
          return const MainAppWrapper();
        }

        // 3. Kullanıcı giriş yapmamış. Giriş ekranını göster.
        return const GirisEkrani();
      },
    );
  }
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool isPrivacyEnabled = true;

  @override
  Widget build(BuildContext context) {
    final themeNotifier = Provider.of<ThemeNotifier>(context);
    bool isDarkMode = themeNotifier.themeMode == ThemeMode.dark;
    final settingsColor = Colors.deepPurple;
    // Unused local variable uyarısı giderildi.

    return Scaffold(
      appBar: AppBar(
        title: const Text('Ayarlar'),
        backgroundColor: settingsColor,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: <Widget>[
          SwitchListTile(
            title: const Text('Karanlık Mod (Dark Mode)'),
            subtitle: const Text('Uygulama temasını koyu renge çevir.'),
            value: isDarkMode,
            onChanged: (bool value) {
              themeNotifier.setThemeMode(value ? ThemeMode.dark : ThemeMode.light);
            },
            secondary: Icon(Icons.brightness_2, color: isDarkMode ? Colors.yellow : Colors.blueGrey),
          ),
          const Divider(),
          SwitchListTile(
            title: const Text('Gizlilik Ayarları'),
            subtitle: const Text('Hesap bilgilerimin gizli kalmasını sağla.'),
            value: isPrivacyEnabled,
            onChanged: (bool value) {
              setState(() {
                isPrivacyEnabled = value;
              });
            },
            secondary: const Icon(Icons.lock),
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.notifications),
            title: const Text('Bildirim Ayarları'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Bildirim ayarları sayfasına gidiliyor.')));
            },
          ),
          const Divider(),
          ListTile(
            leading: Icon(Icons.security, color: Colors.red),
            title: const Text('Hesabı Sil', style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold)),
            trailing: const Icon(Icons.warning, color: Colors.red),
            onTap: () {
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text('Hesabı Sil'),
                  content: const Text('Hesabınızı silmek istediğinizden emin misiniz? Bu işlem geri alınamaz!'),
                  actions: [
                    TextButton(onPressed: () => Navigator.pop(context), child: const Text('İptal')),
                    TextButton(
                      onPressed: () {
                        // Gerçek silme işlemi (LocalAuthService ile) buraya gelecek
                        Provider.of<UserNotifier>(context, listen: false).logout();
                        Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);
                      },
                      child: Text('Sil', style: TextStyle(color: Colors.red)),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}