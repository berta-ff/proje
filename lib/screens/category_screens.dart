import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../constants.dart';
import '../models/data_model.dart';
import '../providers/user_provider.dart';



// --- İKON SEÇİCİ YARDIMCI FONKSİYON ---
// String isme bakıp uygun ikonu verir. Veri dosyasını kirletmeden ikon ekleriz.
IconData _getCategoryIcon(String name) {
  switch (name) {
  // Yeme & İçme
    case 'Cafe': return Icons.coffee; // veya Icons.local_cafe
    case 'Tatlı & Pastane': return Icons.cake;
    case 'Fast Food': return Icons.fastfood;
    case 'Türk Mutfağı': return Icons.soup_kitchen; // veya Icons.dining
    case 'Dünya Mutfağı': return Icons.public;

  // Dünya
    case 'Çin Mutfağı': return Icons.rice_bowl;
    case 'Japon Mutfağı': return Icons.bento; // veya Icons.set_meal
    case 'İtalyan Mutfağı': return Icons.local_pizza;
    case 'Meksika Mutfağı': return Icons.local_fire_department; // Acı :)

  // Sanat & Kültür
    case 'Müze': return Icons.museum;
    case 'Tiyatro': return Icons.theater_comedy;
    case 'Sanat Galerisi': return Icons.palette; // veya Icons.brush

  // Alışveriş
    case 'Alışveriş Merkezi': return Icons.apartment; // Büyük bina ikonu
    case 'Çarşı & Pazar & Cadde': return Icons.storefront; // Dükkan/Tezgah ikonu
    default: return Icons.category; // Bilinmeyenler için
  }
}

// --- ORTAK KART TASARIMI ---
Widget _buildSubCategoryCard(BuildContext context, String title, VoidCallback onTap) {
  final accentColor = Theme.of(context).colorScheme.secondary;
  final icon = _getCategoryIcon(title); // İkonu otomatik bul

  return Card(
    margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8.0),
    elevation: 3,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    child: InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 16.0),
        child: Row(
          children: [
            // İKON KUTUSU
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: accentColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(icon, size: 30, color: accentColor),
            ),
            const SizedBox(width: 15),
            // KATEGORİ İSMİ
            Expanded(
              child: Text(
                title,
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
            // OK İŞARETİ
            Icon(Icons.chevron_right, color: Colors.grey.shade600, size: 28),
          ],
        ),
      ),
    ),
  );
}

// 1. FoodSubCategoryScreen
class FoodSubCategoryScreen extends StatelessWidget {
  const FoodSubCategoryScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Yeme & İçme'), backgroundColor: Colors.redAccent),
      body: ListView.builder(
        padding: const EdgeInsets.only(top: 10),
        itemCount: foodSubCategories.length,
        itemBuilder: (context, index) {
          final subCategory = foodSubCategories[index];

          return _buildSubCategoryCard(
              context,
              subCategory,
                  () {
                if (subCategory == 'Dünya Mutfağı') {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => const InternationalCuisineScreen()));
                } else {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => CategoryListScreen(selectedCategory: '🍴 Yeme & İçme Yerleri', initialSubCategory: subCategory)));
                }
              }
          );
        },
      ),
    );
  }
}

// 2. InternationalCuisineScreen
class InternationalCuisineScreen extends StatelessWidget {
  const InternationalCuisineScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Dünya Mutfağı'), backgroundColor: Colors.blueGrey),
      body: ListView.builder(
        padding: const EdgeInsets.only(top: 10),
        itemCount: internationalCuisines.length,
        itemBuilder: (context, index) {
          final cuisine = internationalCuisines[index];

          return _buildSubCategoryCard(
            context,
            cuisine,
                () => Navigator.push(context, MaterialPageRoute(builder: (context) => CategoryListScreen(selectedCategory: '🍴 Yeme & İçme Yerleri', initialSubCategory: 'Dünya Mutfağı', initialSubSubCategory: cuisine))),
          );
        },
      ),
    );
  }
}

// 3. ArtCultureSubCategoryScreen
class ArtCultureSubCategoryScreen extends StatelessWidget {
  const ArtCultureSubCategoryScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Sanat & Kültür'), backgroundColor: Colors.cyan.shade600),
      body: ListView.builder(
        padding: const EdgeInsets.only(top: 10),
        itemCount: artCultureSubCategories.length,
        itemBuilder: (context, index) {
          final subCategory = artCultureSubCategories[index];

          return _buildSubCategoryCard(
            context,
            subCategory,
                () => Navigator.push(context, MaterialPageRoute(builder: (context) => CategoryListScreen(selectedCategory: '🎭 Sanat & Kültür Yerleri', initialSubCategory: subCategory))),
          );
        },
      ),
    );
  }
}

// 4. CategoryListScreen (RADYO BUTONLU FİLTRE ÖZELLİĞİ KORUNDU)
class CategoryListScreen extends StatefulWidget {
  final String selectedCategory;
  final String initialSubCategory;
  final String initialSubSubCategory;

  const CategoryListScreen({super.key, required this.selectedCategory, this.initialSubCategory = 'Hepsi', this.initialSubSubCategory = 'Hepsi'});
  @override
  State<CategoryListScreen> createState() => _CategoryListScreenState();
}

class _CategoryListScreenState extends State<CategoryListScreen> {
  SortingType _currentSorting = SortingType.none;
  double _minRatingFilter = 0.0;

  // Filtre Paneli (Radyo Butonlu Versiyon)
  void _showFilterModal() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (context) {
        double tempRating = _minRatingFilter;
        SortingType tempSorting = _currentSorting;

        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setModalState) {
            return Padding(
              padding: const EdgeInsets.all(20.0),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Filtrele ve Sırala', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                        TextButton(
                          onPressed: () {
                            setModalState(() {
                              tempRating = 0.0;
                              tempSorting = SortingType.none;
                            });
                          },
                          child: const Text("Temizle", style: TextStyle(color: Colors.red)),
                        )
                      ],
                    ),
                    const Divider(),
                    const Text('Sıralama', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.grey)),
                    RadioListTile<SortingType>(
                      title: const Text('Puan: Yüksekten Düşüğe'),
                      value: SortingType.ratingHighToLow,
                      groupValue: tempSorting,
                      activeColor: Theme.of(context).primaryColor,
                      contentPadding: EdgeInsets.zero,
                      onChanged: (val) => setModalState(() => tempSorting = val!),
                    ),
                    RadioListTile<SortingType>(
                      title: const Text('Puan: Düşükten Yükseğe'),
                      value: SortingType.ratingLowToHigh,
                      groupValue: tempSorting,
                      activeColor: Theme.of(context).primaryColor,
                      contentPadding: EdgeInsets.zero,
                      onChanged: (val) => setModalState(() => tempSorting = val!),
                    ),
                    RadioListTile<SortingType>(
                      title: const Text('Favori: Çoktan Aza'),
                      value: SortingType.favoritesHighToLow,
                      groupValue: tempSorting,
                      activeColor: Theme.of(context).primaryColor,
                      contentPadding: EdgeInsets.zero,
                      onChanged: (val) => setModalState(() => tempSorting = val!),
                    ),
                    RadioListTile<SortingType>(
                      title: const Text('Favori: Azdan Çoğa'),
                      value: SortingType.favoritesLowToHigh,
                      groupValue: tempSorting,
                      activeColor: Theme.of(context).primaryColor,
                      contentPadding: EdgeInsets.zero,
                      onChanged: (val) => setModalState(() => tempSorting = val!),
                    ),
                    // YENİ FAVORİ SIRALAMA SEÇENEKLERİ SONU

                    const SizedBox(height: 15),
                    const SizedBox(height: 15),
                    const Text('Puan Aralığı', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.grey)),
                    const SizedBox(height: 5),
                    Column(
                      children: List.generate(5, (index) {
                        int starValue = index + 1;
                        String label = starValue == 5 ? "5 Yıldız ⭐" : "$starValue Yıldız Üstü ⭐";
                        return RadioListTile<double>(
                          title: Text(label, style: const TextStyle(fontWeight: FontWeight.w500)),
                          value: starValue.toDouble(),
                          groupValue: tempRating,
                          activeColor: Theme.of(context).primaryColor,
                          contentPadding: EdgeInsets.zero,
                          controlAffinity: ListTileControlAffinity.leading,
                          onChanged: (val) => setModalState(() => tempRating = val!),
                        );
                      }),
                    ),
                    const SizedBox(height: 25),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(backgroundColor: Theme.of(context).primaryColor, padding: const EdgeInsets.symmetric(vertical: 15), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
                        onPressed: () {
                          setState(() {
                            _currentSorting = tempSorting;
                            _minRatingFilter = tempRating;
                          });
                          Navigator.pop(context);
                        },
                        child: const Text('FİLTREYİ UYGULA', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
                      ),
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final userNotifier = Provider.of<UserNotifier>(context);
    final favoritePlaceIds = userNotifier.favoriteIds;
    final places = DataModel.filterAndSortItems(
        widget.selectedCategory,
        _minRatingFilter,
        5.0,
        _currentSorting,
        widget.initialSubCategory,
        widget.initialSubSubCategory,
        favoritePlaceIds);


    return Scaffold(
      appBar: AppBar(
        title: Text(widget.selectedCategory),
        backgroundColor: Theme.of(context).primaryColor,
        actions: [
          Stack(
            alignment: Alignment.topRight,
            children: [
              IconButton(icon: const Icon(Icons.filter_list, size: 30, color: Colors.white), onPressed: _showFilterModal),
              if (_minRatingFilter > 0 || _currentSorting != SortingType.none)
                Positioned(right: 8, top: 8, child: Container(padding: const EdgeInsets.all(4), decoration: const BoxDecoration(color: Colors.amber, shape: BoxShape.circle))),
            ],
          ),
        ],
      ),
      body: places.isEmpty
          ? Center(child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [const Icon(Icons.search_off, size: 60, color: Colors.grey), const SizedBox(height: 10), Text('Kriterlere uygun yer bulunamadı.', style: TextStyle(fontSize: 16, color: Colors.grey.shade600)), if(_minRatingFilter > 0) TextButton(onPressed: () => setState(() => _minRatingFilter = 0.0), child: const Text("Filtreleri Temizle"))]))
          : ListView.builder(
        padding: const EdgeInsets.all(10),
        itemCount: places.length,
        itemBuilder: (context, index) {
          final item = places[index];
          final isFavorite = userNotifier.currentUser?.favoritePlaceIds.contains(item['id']) ?? false;
          return Card(
            elevation: 2,
            margin: const EdgeInsets.symmetric(vertical: 6),
            child: ListTile(
              contentPadding: const EdgeInsets.all(10),
              title: Text(item['name']!, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
              subtitle: Row(children: [const Icon(Icons.star, color: Colors.amber, size: 18), const SizedBox(width: 4), Text('${item['rating']}', style: const TextStyle(fontWeight: FontWeight.bold)), const SizedBox(width: 10), if(item['sub_category'] != null) Text('•  ${item['sub_category']}', style: const TextStyle(color: Colors.grey))]),
              trailing: IconButton(icon: Icon(isFavorite ? Icons.favorite : Icons.favorite_border, color: isFavorite ? Colors.red : null), onPressed: () => userNotifier.toggleFavorite(item['id'] as int)),
              onTap: () => Navigator.pushNamed(context, '/detail', arguments: item),
            ),
          );
        },
      ),
    );
  }
}
// 5. ShoppingSubCategoryScreen (YENİ ARA EKRAN)
class ShoppingSubCategoryScreen extends StatelessWidget {
  const ShoppingSubCategoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // AppBar rengini morumsu bir renk yaptım, istersen değiştirebilirsin
      appBar: AppBar(title: const Text('Alışveriş Seçenekleri'), backgroundColor: Colors.deepPurple),
      body: ListView.builder(
        padding: const EdgeInsets.only(top: 10),
        itemCount: shoppingSubCategories.length,
        itemBuilder: (context, index) {
          final subCategory = shoppingSubCategories[index];

          // Ortak kart tasarımını kullanıyoruz (Resimdeki gibi görünmesi için)
          return _buildSubCategoryCard(
              context,
              subCategory,
                  () {
                // Tıklayınca o alt kategoriye ait listeyi aç
                Navigator.push(context, MaterialPageRoute(builder: (context) => CategoryListScreen(
                    selectedCategory: '🛍️ Alışveriş',
                    initialSubCategory: subCategory
                )));
              }
          );
        },
      ),
    );
  }
}