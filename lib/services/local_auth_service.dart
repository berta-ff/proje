// lib/services/local_auth_service.dart

import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user.dart'; // User modelini import et

class LocalAuthService {
  static const _keyUsers = 'registeredUsers';

  // Kayıtlı kullanıcı listesini Shared Preferences'tan yükler
  Future<List<User>> _loadUsers() async {
    final prefs = await SharedPreferences.getInstance();
    final String? usersJson = prefs.getString(_keyUsers);
    if (usersJson == null) {
      return [];
    }
    // JSON dizisini User listesine dönüştür
    final List<dynamic> usersList = jsonDecode(usersJson);
    return usersList.map((json) => User.fromJson(json as Map<String, dynamic>)).toList();
  }

  // Kullanıcı listesini Shared Preferences'a kaydeder
  Future<void> _saveUsers(List<User> users) async {
    final prefs = await SharedPreferences.getInstance();
    // User listesini JSON dizisine dönüştür
    final List<Map<String, dynamic>> usersJson = users.map((user) => user.toJson()).toList();
    prefs.setString(_keyUsers, jsonEncode(usersJson));
  }

  // Yeni kayıt metodu
  Future<bool> registerUser(User newUser) async {
    final users = await _loadUsers();

    // E-posta (username) zaten kayıtlı mı kontrol et
    if (users.any((user) => user.email == newUser.email)) {
      return false; // E-posta zaten kayıtlı
    }

    users.add(newUser);
    await _saveUsers(users);
    return true;
  }

  // Giriş yapma metodu
  Future<User?> authenticateUser(String email, String sifre) async {
    final users = await _loadUsers();
    try {
      final user = users.firstWhere(
            (user) => user.email == email && user.sifre == sifre,
      );
      return user;
    } catch (e) {
      return null; // Kullanıcı bulunamadı
    }
  }

  // GÜNCELLENDİ: Kullanıcı profil bilgilerini günceller
  Future<bool> updateUser({
    required User oldUser, // Eski kullanıcı nesnesi
    required User newUser, // Yeni kullanıcı nesnesi
  }) async {
    final users = await _loadUsers();

    // Eski e-posta adresi ile kullanıcıyı bul
    final int index = users.indexWhere((user) => user.email == oldUser.email);

    if (index == -1) {
      return false; // Kullanıcı bulunamadı
    }

    // Yeni e-posta adresi farklı ve zaten kayıtlıysa hata ver
    if (oldUser.email != newUser.email && users.any((user) => user.email == newUser.email)) {
      return false; // Yeni e-posta zaten kullanımda
    }

    // Listede güncel kullanıcıyı eski yerine koy
    users[index] = newUser;

    await _saveUsers(users);
    return true;
  }

  // Kullanıcının favori listesini günceller
  Future<bool> updateUserFavorites(User oldUser, List<int> newFavorites) async {
    final users = await _loadUsers();

    // Kullanıcının indeksi
    final int index = users.indexWhere((user) => user.email == oldUser.email);

    if (index == -1) {
      return false; // Kullanıcı bulunamadı
    }

    // Yeni favori listesi ile yeni User nesnesi oluştur
    final updatedUser = User(
      email: oldUser.email,
      sifre: oldUser.sifre,
      isimSoyisim: oldUser.isimSoyisim,
      kullaniciAdi: oldUser.kullaniciAdi,
      telefon: oldUser.telefon,
      favoritePlaceIds: newFavorites, // YENİ FAVORİ LİSTESİ
    );

    // Listede güncel kullanıcıyı eski yerine koy
    users[index] = updatedUser;

    await _saveUsers(users);
    return true; // Favoriler başarıyla güncellendi
  }

  // Kullanıcının şifresini günceller
  Future<bool> updateUserPassword(User oldUser, String newSifre) async {
    final users = await _loadUsers();

    // Kullanıcının indeksi
    final int index = users.indexWhere((user) => user.email == oldUser.email);

    if (index == -1) {
      return false; // Kullanıcı bulunamadı
    }

    // Yeni şifre ile yeni User nesnesi oluştur
    final updatedUser = User(
      email: oldUser.email,
      sifre: newSifre, // Yeni şifre
      isimSoyisim: oldUser.isimSoyisim,
      kullaniciAdi: oldUser.kullaniciAdi,
      telefon: oldUser.telefon,
      favoritePlaceIds: oldUser.favoritePlaceIds,
    );

    // Listede güncel kullanıcıyı eski yerine koy
    users[index] = updatedUser;

    await _saveUsers(users);
    return true;
  }
}