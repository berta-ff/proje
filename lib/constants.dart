import 'package:flutter/material.dart';

// constants.dart dosyası içinde:
enum SortingType {
  none,
  ratingHighToLow,
  ratingLowToHigh,
  // 🔥 FAVORİ SIRALAMA SEÇENEKLERİ BURAYA EKLENİYOR
  favoritesHighToLow, // Favori: Çoktan Aza
  favoritesLowToHigh, // Favori: Azdan Çoğa
}

// Renkler
const Color accentColor = Colors.lightBlue;
const Color inputFillColor = Color(0xFFEFEFEF);
const Color hintColor = Colors.grey;

// Kategoriler
final Map<String, IconData> categories = {
  '🍴 Yeme & İçme Yerleri': Icons.restaurant,
  '🏛️ Tarihi Yerler': Icons.museum,
  '🏞️ Doğa & Parklar': Icons.park,
  '🛍️ Alışveriş': Icons.shopping_bag,
  '🎉 Eğlence Yerleri': Icons.celebration,
  '🎭 Sanat & Kültür Yerleri': Icons.palette,
};

final List<String> foodSubCategories = [
  'Cafe',
  'Tatlı & Pastane',
  'Fast Food',
  'Türk Mutfağı',
  'Dünya Mutfağı',
];

final List<String> internationalCuisines = [
  'Çin Mutfağı',
  'Japon Mutfağı',
  'İtalyan Mutfağı',
  'Meksika Mutfağı',
];

final List<String> artCultureSubCategories = [
  'Müze',
  'Tiyatro',
  'Sanat Galerisi',
];

final List<String> shoppingSubCategories = [
  'Alışveriş Merkezi',
  'Çarşı & Pazar & Cadde',
];



