// lib/models/user.dart

class User {
  final String isimSoyisim;
  final String kullaniciAdi;
  final String email;
  final String telefon;
  final String sifre;

  // YENİ ALAN: Favorilere eklenen mekan ID'lerinin listesi
  final List<int> favoritePlaceIds;

  User({
    required this.email,
    required this.sifre,
    this.isimSoyisim = 'Yeni Kullanıcı',
    this.kullaniciAdi = 'kullanici',
    this.telefon = 'Bilinmiyor',
    // Varsayılan boş liste olarak ayarlandı
    List<int>? favoritePlaceIds,
  }) : favoritePlaceIds = favoritePlaceIds ?? []; // 'this.' kaldırıldı


  // Map'ten User nesnesi oluşturma (JSON'dan okuma)
  factory User.fromJson(Map<String, dynamic> json) {
    // Favori ID'lerini JSON'dan listeye dönüştür
    final List<int> favorites = (json['favoritePlaceIds'] as List<dynamic>?)
        ?.map((e) => e as int)
        .toList() ?? [];

    return User(
      email: json['email'] as String,
      sifre: json['sifre'] as String,
      isimSoyisim: json['isimSoyisim'] as String? ?? 'Yeni Kullanıcı',
      kullaniciAdi: json['kullaniciAdi'] as String? ?? 'kullanici',
      telefon: json['telefon'] as String? ?? 'Bilinmiyor',
      favoritePlaceIds: favorites, // Listeyi atayın
    );
  }

  // User nesnesinden Map oluşturma (JSON'a yazma)
  Map<String, dynamic> toJson() {
    return {
      'isimSoyisim': isimSoyisim,
      'kullaniciAdi': kullaniciAdi,
      'email': email,
      'telefon': telefon,
      'sifre': sifre,
      'favoritePlaceIds': favoritePlaceIds, // Favori listesi eklendi
    };
  }
}