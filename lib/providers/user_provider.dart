// lib/providers/user_provider.dart
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as fba;
import '../models/user.dart';

class UserNotifier extends ChangeNotifier {
  User? _currentUser;
  User? get currentUser => _currentUser;

  // Manuel giriş için (Login ekranı çağırır)
  void login(User user) {
    _currentUser = user;
    notifyListeners();
  }

  // Çıkış yapma
  void logout() async {
    await fba.FirebaseAuth.instance.signOut();
    _currentUser = null;
    notifyListeners();
  }

  // Misafir girişi
  void guestLogin() {
    _currentUser = null;
    notifyListeners();
  }

  // Kullanıcı verisini veritabanından çekme
  Future<void> fetchUser(String uid) async {
    try {
      DocumentSnapshot doc = await FirebaseFirestore.instance.collection('users').doc(uid).get();

      if (doc.exists) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;

        List<dynamic> favDyn = data['favoritePlaceIds'] ?? [];
        List<int> favList = favDyn.map((e) => int.parse(e.toString())).toList();

        _currentUser = User(
          isimSoyisim: data['isimSoyisim'] ?? '',
          kullaniciAdi: data['kullaniciAdi'] ?? '',
          email: data['email'] ?? '',
          telefon: data['telefon'] ?? '',
          sifre: "", // Güvenlik gereği şifreyi çekmiyoruz
          favoritePlaceIds: favList,
        );
        notifyListeners();
      }
    } catch (e) {
      debugPrint("Kullanıcı verisi çekilemedi: $e");
    }
  }

  // 🔥 EKLENEN 1: Profil Güncelleme (Firestore Uyumlu)
  Future<bool> updateUser(User oldUser, {
    required String isimSoyisim,
    required String kullaniciAdi,
    required String email,
    required String telefon,
  }) async {
    try {
      final uid = fba.FirebaseAuth.instance.currentUser?.uid;
      if (uid == null) return false;

      // 1. Veritabanını güncelle
      await FirebaseFirestore.instance.collection('users').doc(uid).update({
        'isimSoyisim': isimSoyisim,
        'kullaniciAdi': kullaniciAdi,
        'email': email,
        'telefon': telefon,
      });

      // 2. Auth e-postasını güncelle (İsteğe bağlı, kritik işlem)
      if (oldUser.email != email) {
        await fba.FirebaseAuth.instance.currentUser?.verifyBeforeUpdateEmail(email);
      }

      // 3. Lokal veriyi güncelle
      _currentUser = User(
        isimSoyisim: isimSoyisim,
        kullaniciAdi: kullaniciAdi,
        email: email,
        telefon: telefon,
        sifre: oldUser.sifre,
        favoritePlaceIds: oldUser.favoritePlaceIds,
      );
      notifyListeners();
      return true;
    } catch (e) {
      debugPrint("Profil güncelleme hatası: $e");
      return false;
    }
  }

  // 🔥 EKLENEN 2: Şifre Değiştirme (Firestore + Auth Uyumlu)
  Future<String?> changePassword(User oldUser, String oldSifre, String newSifre) async {
    try {
      final user = fba.FirebaseAuth.instance.currentUser;
      if (user == null) return 'Kullanıcı oturumu bulunamadı.';

      // 1. Firebase Auth şifresini güncelle
      // (Güvenlik için önce yeniden giriş yapmak gerekebilir ama basitçe deniyoruz)
      await user.updatePassword(newSifre);

      // 2. Lokal veriyi güncelle (Eğer modelde şifre tutuyorsak)
      _currentUser = User(
        isimSoyisim: oldUser.isimSoyisim,
        kullaniciAdi: oldUser.kullaniciAdi,
        email: oldUser.email,
        telefon: oldUser.telefon,
        sifre: "", // Şifreyi açık tutmuyoruz
        favoritePlaceIds: oldUser.favoritePlaceIds,
      );
      notifyListeners();
      return null; // Hata yok, başarılı
    } on fba.FirebaseAuthException catch (e) {
      if (e.code == 'requires-recent-login') {
        return 'Güvenlik nedeniyle tekrar giriş yapıp deneyin.';
      } else if (e.code == 'weak-password') {
        return 'Şifre çok zayıf.';
      }
      return 'Hata: ${e.message}';
    } catch (e) {
      return 'Beklenmedik hata: $e';
    }
  }

  // Favori Ekleme/Çıkarma
  Future<void> toggleFavorite(int placeId) async {
    if (_currentUser == null) return;

    List<int> currentFavorites = List.from(_currentUser!.favoritePlaceIds);
    bool isFavorite = currentFavorites.contains(placeId);

    if (isFavorite) {
      currentFavorites.remove(placeId);
    } else {
      currentFavorites.add(placeId);
    }

    try {
      final uid = fba.FirebaseAuth.instance.currentUser?.uid;
      if (uid != null) {
        await FirebaseFirestore.instance
            .collection('users')
            .doc(uid)
            .update({'favoritePlaceIds': currentFavorites});

        _currentUser = User(
          isimSoyisim: _currentUser!.isimSoyisim,
          kullaniciAdi: _currentUser!.kullaniciAdi,
          email: _currentUser!.email,
          telefon: _currentUser!.telefon,
          sifre: _currentUser!.sifre,
          favoritePlaceIds: currentFavorites,
        );
        notifyListeners();
      }
    } catch (e) {
      debugPrint("Favori hatası: $e");
    }
  }
}