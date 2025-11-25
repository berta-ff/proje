import 'package:flutter/material.dart';
import '../constants.dart';
import '../models/data_model.dart';
import 'category_screens.dart';

class HomeContent extends StatelessWidget {
  final GlobalKey<ScaffoldState> scaffoldKey;
  const HomeContent({super.key, required this.scaffoldKey});

  Widget _buildEventCard(BuildContext context, Map<String, dynamic> event, int index) {
    // 🔥 GÜNCELLEME: Eğer etkinlikte özel renk varsa onu kullan, yoksa rastgele bir renk üret.
    // Colors.primaries listesinden index'e göre renk seçerek "sözde rastgele" ama sabit bir düzen sağlıyoruz.
    final Color eventColor = event['color'] as Color? ?? Colors.primaries[index % Colors.primaries.length];

    return InkWell(
      onTap: () => Navigator.pushNamed(context, '/event_detail', arguments: event),
      borderRadius: BorderRadius.circular(10),
      child: Container(
        width: 280,
        margin: const EdgeInsets.only(right: 15),
        decoration: BoxDecoration(
          color: eventColor,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 5, offset: const Offset(0, 3))],
        ),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // İsimlerin yanına numara ekledim ki 15 tane olduğu belli olsun
              Text("${event['name']} #${index + 1}", style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold), maxLines: 2, overflow: TextOverflow.ellipsis),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(children: [const Icon(Icons.calendar_today, size: 14, color: Colors.white70), const SizedBox(width: 5), Text('${event['date']} | ${event['time']}', style: const TextStyle(color: Colors.white70))]),
                  const SizedBox(height: 4),
                  Row(children: [const Icon(Icons.location_on, size: 14, color: Colors.white70), const SizedBox(width: 5), Text(event['location']!, style: const TextStyle(color: Colors.white70))]),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCategoryListItem(BuildContext context, String title, IconData icon) {
    final accentColor = Theme.of(context).colorScheme.secondary;
    void handleTap() {
      if (title == '🍴 Yeme & İçme Yerleri') {
        Navigator.push(context, MaterialPageRoute(builder: (context) => const FoodSubCategoryScreen()));
      } else if (title == '🎭 Sanat & Kültür Yerleri') {
        Navigator.push(context, MaterialPageRoute(builder: (context) => const ArtCultureSubCategoryScreen()));

      } else if (title == '🛍️ Alışveriş') {
        Navigator.push(context, MaterialPageRoute(builder: (context) => const ShoppingSubCategoryScreen()));

      } else {
        Navigator.push(context, MaterialPageRoute(builder: (context) => CategoryListScreen(selectedCategory: title)));
      }
    }

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 0, vertical: 10.0), // Kartlar arası dış boşluk
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: InkWell(
        onTap: handleTap,
        borderRadius: BorderRadius.circular(10),
        child: Padding(


          padding: const EdgeInsets.symmetric(vertical: 80.0, horizontal: 10.0),
          child: Row(
            children: [
              Icon(icon, size: 25, color: accentColor),
              const SizedBox(width: 15),
              // Yazı boyutu orijinal (17-18 civarı ideal)
              Expanded(child: Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold))),
              Icon(Icons.chevron_right, color: Colors.grey.shade600, size: 28),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final accentColor = Theme.of(context).colorScheme.secondary;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ana Sayfa'),
        backgroundColor: accentColor,
        leading: IconButton(icon: const Icon(Icons.menu, size: 30, color: Colors.white), onPressed: () => scaffoldKey.currentState?.openDrawer()),
        actions: [IconButton(icon: const Icon(Icons.settings, size: 30, color: Colors.white), onPressed: () => Navigator.pushNamed(context, '/settings'))],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // --- GÜNCELLENEN KISIM BAŞLANGICI ---
            if (DataModel.events.isNotEmpty) ...[
              const Padding(padding: EdgeInsets.only(bottom: 12.0, top: 8.0, left: 4.0), child: Text('🔥 Yaklaşan Etkinlikler', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold))),
              SizedBox(
                  height: 100,
                  child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      // BURASI DEĞİŞTİ: Sabit 15 sayı veriyoruz
                      itemCount: 15,
                      itemBuilder: (context, index) {
                        // Veri listesi 15'ten az olsa bile başa dönerek veriyi tekrar kullanır (Döngüsel Veri)
                        final event = DataModel.events[index % DataModel.events.length];
                        return _buildEventCard(context, event, index);
                      }
                  )
              ),
              const Divider(height: 25),
            ],
            // --- GÜNCELLENEN KISIM SONU ---

            const Padding(padding: EdgeInsets.only(bottom: 12.0, top: 8.0, left: 4.0), child: Text('Kategoriler', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold))),
            Expanded(child: ListView.builder(itemCount: categories.length, itemBuilder: (context, index) { final entry = categories.entries.elementAt(index); return _buildCategoryListItem(context, entry.key, entry.value); })),
          ],
        ),
      ),
    );
  }
}