import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/data_model.dart';
import '../constants.dart';
import '../providers/user_provider.dart';

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
    _searchController.addListener(() => setState(() => _searchQuery = _searchController.text));
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<Map<String, dynamic>> get _filteredPlaceList {
    if (_searchQuery.isEmpty) return DataModel.items;
    final query = _searchQuery.toLowerCase();
    return DataModel.items.where((place) {
      return (place['name']?.toLowerCase() ?? '').contains(query) ||
          (place['description']?.toLowerCase() ?? '').contains(query) ||
          (place['category']?.toLowerCase() ?? '').contains(query);
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final accentColor = Theme.of(context).colorScheme.secondary;
    final UserNotifier userNotifier = Provider.of<UserNotifier>(context);
    final List<int> favoriteIds = userNotifier.currentUser?.favoritePlaceIds ?? [];
    final List<Map<String, dynamic>> results = _filteredPlaceList;

    return Scaffold(
      appBar: AppBar(title: const Text('Ara'), backgroundColor: accentColor),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                labelText: 'Mekan, kategori veya açıklama ara',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: _searchQuery.isNotEmpty ? IconButton(icon: const Icon(Icons.clear), onPressed: () => _searchController.clear()) : null,
              ),
            ),
          ),
          Expanded(
            child: results.isEmpty && _searchQuery.isNotEmpty
                ? const Center(child: Text('Sonuç bulunamadı.'))
                : ListView.builder(
              itemCount: results.length,
              itemBuilder: (context, index) {
                final item = results[index];
                final isFavorite = favoriteIds.contains(item['id']);
                return Card(
                  margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  child: ListTile(
                    leading: Icon(categories[item['category']] ?? Icons.place, color: accentColor),
                    title: Text(item['name']!),
                    subtitle: Text('Puan: ${item['rating']} - ${item['category']}'),
                    trailing: IconButton(
                      icon: Icon(isFavorite ? Icons.favorite : Icons.favorite_border, color: isFavorite ? Colors.red : Colors.grey),
                      onPressed: () => userNotifier.toggleFavorite(item['id'] as int),
                    ),
                    onTap: () => Navigator.pushNamed(context, '/detail', arguments: item),
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