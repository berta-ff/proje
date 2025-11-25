import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_auth/firebase_auth.dart';
class SuggestPlaceScreen extends StatefulWidget {
  const SuggestPlaceScreen({super.key});

  @override
  State<SuggestPlaceScreen> createState() => _SuggestPlaceScreenState();
}

class _SuggestPlaceScreenState extends State<SuggestPlaceScreen> {
  // --- Form Verileri ---
  String? _selectedCity = 'Ankara'; // Varsayılan şehir
  String? _selectedDistrict;
  String? _selectedNeighbourhood;
  String? _selectedCategory;
  String? _addressDetails;
  String? _placeName;
  String? _placeDescription;
  final _formKey = GlobalKey<FormState>();

  XFile? _selectedImage;
  final ImagePicker _picker= ImagePicker();

  // --- Dropdown Verileri ---
  final List<String> _categories = ['Yemek', 'Gezilecek Yerler', 'Alışveriş', 'Eğlence Yerleri'];

  final Map<String, List<String>> _districtsAndNeighbourhoods = {
    'Çankaya': ['Anıttepe','Ayrancı', 'Bahçelievler','Balgat','Bilkent/Bilkentplaza/Beytepe', 'Cebeci','Çayyolu/Ümitköy', 'Dikmen','Kızılay', 'ODTÜ','Sıhhiye','Kurtuluş','Tunalı Hilmi', ],
    'Keçiören': ['Aktepe', 'Bağlum','Esertepe','Etlik','Merkez','Sanatoryum','Ufuktepe'],
    'Kahramanakazan':['Kazan'],
    'Yenimahalle': ['Atatürk Orman Çiftliği','Batıkent','Demetevler','İstasyon','Karşıyaka','Ostim','Susuz','Şentepe','Yenimahalle'],
    'Etimesgut':['Çarşı','Elvankent','Eryaman','Güvercinlik', ],
  };


  void _submitSuggestion() async { // Metodu 'async' yaptık!
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      // Loading göstergesi
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Öneri Gönderiliyor, Lütfen Bekleyin...')),
      );

      try {
        await _uploadFileAndSaveData(); // 2. Adımda oluşturduğumuz metodu çağır

        // Başarılı olursa eski Snackbar'ı kapat ve yeni başarılı mesajı göster.
        ScaffoldMessenger.of(context).hideCurrentSnackBar();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('✅ Öneri Başarıyla Gönderildi!')),
        );

        // Ekrandan Geri Dön
        Navigator.of(context).pop();

      } catch (error) {
        // Hata durumunda kullanıcıya hata mesajını göster
        ScaffoldMessenger.of(context).hideCurrentSnackBar();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('❌ Gönderim Hatası: ${error.toString()}')),
        );
      }
    }
  }

  Future<void> _uploadFileAndSaveData() async {
    // 1. Kullanıcıdan UID alınması (zorunlu, Firebase Auth'a bağlı)
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      // Kullanıcı oturum açmadıysa hata ver
      throw Exception("Oturum açmış bir kullanıcı bulunamadı.");
    }
    final userId = user.uid;
    String? imageUrl;

    // 2. Fotoğraf Yükleme (Sadece fotoğraf seçilmişse)
    if (_selectedImage != null) {
      final storageRef = FirebaseStorage.instance
          .ref()
          .child('place_images') // Ana klasör adı
          .child('${DateTime.now().millisecondsSinceEpoch}_${_selectedImage!.name}'); // Benzersiz dosya adı

      // XFile'dan Byte dizisi alıp yükleme
      await storageRef.putData(await _selectedImage!.readAsBytes());

      // Yükleme tamamlandı, şimdi URL'yi al
      imageUrl = await storageRef.getDownloadURL();
    }

    // 3. Firestore'a Kaydedilecek Veri Haritası
    final placeData = {
      'placeName': _placeName ?? 'İsimsiz Mekan', // Mekan adı eklenince değişecek
      'category': _selectedCategory,
      'city': _selectedCity,
      'district': _selectedDistrict,
      'neighbourhood': _selectedNeighbourhood,
      'addressDetails': _addressDetails ?? '',
      'description': _placeDescription ?? '', // Açıklama eklenince değişecek
      'imageUrl': imageUrl, // Yüklenen fotoğrafın URL'si
      'suggestedBy': userId, // Kimin önerdiği
      'timestamp': FieldValue.serverTimestamp(), // Kayıt zamanı
    };

    // 4. Firestore'a Kaydetme
    await FirebaseFirestore.instance.collection('suggestions').add(placeData);
  }


  void _pickImage() async {
    final XFile? pickedFile = await _picker.pickImage(
      source: ImageSource.gallery, // İlk olarak galeriyi açar.
      imageQuality: 50, // İsteğe bağlı: Dosya boyutunu küçültmek için kalite ayarı
    );

    if (pickedFile != null) {
      setState(() {
        // Seçilen fotoğrafı File tipinde değişkene atarız.
        _selectedImage = pickedFile;
      });
    } else {
      // Kullanıcı fotoğraf seçmeden geri döndüyse
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Fotoğraf seçilmedi.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Yeni Mekan Önerisi'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              const Text(
                'Konum Bilgileri (Zorunlu)',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.blue),
              ),
              const SizedBox(height: 10),

              _buildDropdownField(
                'Şehir (Sabit)',
                null,
                ['Ankara'],
                _selectedCity,
                    (newValue) {},
                isEnabled: false,
              ),

              _buildDropdownField(
                'İlçe Seçin *',
                'Lütfen bir ilçe seçin.',
                _districtsAndNeighbourhoods.keys.toList(),
                _selectedDistrict,
                    (String? newValue) {
                  setState(() {
                    _selectedDistrict = newValue;
                    _selectedNeighbourhood = null;
                  });
                },
              ),

              if (_selectedDistrict != null)
                _buildDropdownField(
                  'Mahalle Seçin *',
                  'Lütfen bir mahalle seçin.',
                  _districtsAndNeighbourhoods[_selectedDistrict]!,
                  _selectedNeighbourhood,
                      (String? newValue) {
                    setState(() {
                      _selectedNeighbourhood = newValue;
                    });
                  },
                ),


              const Divider(height: 30),

              const Text(
                'Kategori Seçimi (Zorunlu)',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.blue),
              ),
              const SizedBox(height: 10),

              _buildDropdownField(
                'Kategori Seçin *',
                'Lütfen bir kategori seçin.',
                _categories,
                _selectedCategory,
                    (String? newValue) {
                  setState(() {
                    _selectedCategory = newValue;
                  });
                },
              ),
              const SizedBox(height: 15),

              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'Açık Adres / Detaylı Tarif',
                  hintText: 'Örn: Ana Cadde 5/A, Parkın yanı, caminin karşısı.',
                  border: OutlineInputBorder(),
                  alignLabelWithHint: true,
                ),
                maxLines: 3, // Birden fazla satır yazılabilir
                keyboardType: TextInputType.multiline,
                onSaved: (value) {
                  _addressDetails = value; // 1. Adımda tanımladığımız değişkene kaydediyoruz
                },
              ),

              const Divider(height: 30),

              const Text(
                'Fotoğraf Ekle (İsteğe Bağlı)',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),

              // Seçilen fotoğraf varsa, onu göster (YENİ KOD BAŞLANGICI)
              // Seçilen fotoğraf varsa, onu göster (YENİ KOD BLOĞU)
              if (_selectedImage != null)
                Padding(
                  padding: const EdgeInsets.only(bottom: 10.0),
                  child: Image.network(
                    _selectedImage!.path, // Web'de bu, tarayıcının geçici dosya URL'sidir.
                    height: 200,
                    fit: BoxFit.cover,
                    // Eğer Flutter Web kullanıyorsanız ve XFile.path direkt çalışmazsa,
                    // bu Image.network kullanımı genellikle image_picker'ın Web tarafı implementasyonu sayesinde çalışır.
                  ),
                ),

              // Fotoğraf seçme/değiştirme butonu
              ElevatedButton.icon(
                onPressed: _pickImage,
                // Fotoğraf seçilmişse "değiştir" ikonunu göster, yoksa "kamera" ikonunu.
                icon: Icon(_selectedImage != null ? Icons.change_circle : Icons.camera_alt),
                // Butonun yazısını da duruma göre değiştir.
                label: Text(_selectedImage != null ? 'Fotoğrafı Değiştir' : 'Fotoğraf Seç / Çek'),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  // Seçili fotoğraf varsa rengini değiştir.
                  backgroundColor: _selectedImage != null ? Colors.blue.shade100 : Colors.grey.shade300,
                  foregroundColor: Colors.black87,
                ),
              ), // (YENİ KOD BİTİŞİ)

              const SizedBox(height: 30),

              ElevatedButton(
                onPressed: _submitSuggestion,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue.shade700,
                  padding: const EdgeInsets.symmetric(vertical: 18),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                ),
                child: const Text(
                  'Öneriyi Gönder',
                  style: TextStyle(fontSize: 18, color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDropdownField(
      String label,
      String? validatorMessage,
      List<String> items,
      String? selectedValue,
      Function(String?) onChanged,
      {bool isEnabled = true}
      ) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15.0),
      child: DropdownButtonFormField<String>(
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
        ),
        value: selectedValue,
        items: items.map((String value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Text(value),
          );
        }).toList(),
        onChanged: isEnabled ? onChanged : null,
        validator: validatorMessage != null ? (value) {
          if (value == null) {
            return validatorMessage;
          }
          return null;
        } : null,
      ),
    );
  }
}