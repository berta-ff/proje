import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/data_model.dart';
import '../models/user.dart';
import '../constants.dart';
import '../providers/user_provider.dart';

class FavoritesContent extends StatelessWidget {
  const FavoritesContent({super.key});

  @override
  Widget build(BuildContext context) {
    final accentColor = Theme.of(context).colorScheme.secondary;
    final UserNotifier userNotifier = Provider.of<UserNotifier>(context);
    final User? currentUser = userNotifier.currentUser;

    if (currentUser == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Favoriler'), backgroundColor: Colors.pink),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text('Favorileri görmek için giriş yapın.'),
              ElevatedButton(onPressed: () => Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false), child: const Text('Giriş Yap')),
            ],
          ),
        ),
      );
    }

    final favoritePlaces = DataModel.items.where((item) => currentUser.favoritePlaceIds.contains(item['id'])).toList();

    return Scaffold(
      appBar: AppBar(title: const Text('Favoriler'), backgroundColor: Colors.pink),
      body: favoritePlaces.isEmpty
          ? const Center(child: Text('Henüz favoriniz yok.'))
          : ListView.builder(
        itemCount: favoritePlaces.length,
        itemBuilder: (context, index) {
          final item = favoritePlaces[index];
          return Card(
            margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            child: ListTile(
              leading: Icon(categories[item['category']] ?? Icons.place, color: accentColor),
              title: Text(item['name']!),
              trailing: IconButton(
                icon: const Icon(Icons.favorite, color: Colors.red),
                onPressed: () => userNotifier.toggleFavorite(item['id'] as int),
              ),
              onTap: () => Navigator.pushNamed(context, '/detail', arguments: item),
            ),
          );
        },
      ),
    );
  }
}