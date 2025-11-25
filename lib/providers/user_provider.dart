import 'package:flutter/material.dart';
import '../models/user.dart';
import '../services/local_auth_service.dart';

class UserNotifier extends ChangeNotifier {
  User? _currentUser;
  User? get currentUser => _currentUser;

  void login(User user) {
    _currentUser = user;
    notifyListeners();
  }

  void logout() {
    _currentUser = null;
    notifyListeners();
  }

  void guestLogin() {
    _currentUser = null;
    notifyListeners();
  }

  void updateUser(User oldUser, {
    required String isimSoyisim,
    required String kullaniciAdi,
    required String email,
    required String telefon,
  }) {
    final newUser = User(
      isimSoyisim: isimSoyisim,
      kullaniciAdi: kullaniciAdi,
      email: email,
      telefon: telefon,
      sifre: oldUser.sifre,
      favoritePlaceIds: oldUser.favoritePlaceIds,
    );
    _currentUser = newUser;
    notifyListeners();
  }

  String? changePassword(User oldUser, String oldSifre, String newSifre) {
    if (oldUser.sifre != oldSifre) {
      return 'Hata: Mevcut şifreniz yanlış.';
    }
    final newUser = User(
      isimSoyisim: oldUser.isimSoyisim,
      kullaniciAdi: oldUser.kullaniciAdi,
      email: oldUser.email,
      telefon: oldUser.telefon,
      sifre: newSifre,
      favoritePlaceIds: oldUser.favoritePlaceIds,
    );
    _currentUser = newUser;
    notifyListeners();
    return null;
  }

  Future<void> toggleFavorite(int placeId) async {
    if (_currentUser == null) return;

    List<int> currentFavorites = List.from(_currentUser!.favoritePlaceIds);
    bool isFavorite = currentFavorites.contains(placeId);

    if (isFavorite) {
      currentFavorites.remove(placeId);
    } else {
      currentFavorites.add(placeId);
    }

    final LocalAuthService authService = LocalAuthService();
    final bool success = await authService.updateUserFavorites(_currentUser!, currentFavorites);

    if (success) {
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