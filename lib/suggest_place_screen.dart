// lib/suggest_place_screen.dart

import 'package:flutter/material.dart';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';

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
  String? _placeAddressNote;
  String? _selectedCategory;

  File? _placeImage;

  final _formKey = GlobalKey<FormState>();

  // --- Dropdown Verileri (İstediğiniz gibi genişletebilirsiniz) ---
  final List<String> _categories = ['Yemek', 'Gezilecek Yerler', 'Alışveriş', 'Eğlence Yerleri'];

  // Ankara için basit ilçe ve mahalle verileri
  final Map<String, List<String>> _districtsAndNeighbourhoods = {
    'Altındağ':['Altındağ','Aydınlıkevler','Hasköy','Hisar','Ulubay','Ulucan','Ulus/İsmetpaşa','Yeşilöz'],
    'Çankaya': ['Anıttepe','Ayrancı', 'Bahçelievler','Balgat','Bilkent/Bilkentplaza/Beytepe', 'Cebeci','Çayyolu/Ümitköy', 'Dikmen','Kızılay', 'ODTÜ','Sıhhiye','Kurtuluş','Tunalı Hilmi'],
    'Etimesgut':['Çarşı','Elvankent','Eryaman','Güvercinlik','Merkez','Şaşmaz'],
    'Keçiören': ['Aktepe', 'Bağlum','Esertepe','Etlik','Merkez','Sanatoryum','Ufuktepe'],
    'Mamak':['Abidinpaşa','Akdere','Boğaziçi','Demirlibahçe','Gülveren','Hüseyingazi','Kayaş','Mamak','Misket'],
    'Pursaklar':['Altınova','Merkez','Saray'],
    'Sincan':['Fatih','Sincan','Temelli','Yenikent'],
    'Yenimahalle': ['Atatürk Orman Çiftliği','Batıkent','Demetevler','İstasyon','Karşıyaka','Ostim','Susuz','Şentepe','Yenimahalle'],


  };

  // Eski metodu sildikten sonra buraya yapıştırın.
// lib/suggest_place_screen.dart dosyası

  void _submitSuggestion() async { // <-- ASYNC KELİMESİ EKLEDİK
    if (_formKey.currentState!.validate()) {

      final suggestionData = {
        'city': _selectedCity,
        'district': _selectedDistrict,
        'neighbourhood': _selectedNeighbourhood,
        'category': _selectedCategory,
        'address_note': _placeAddressNote,
        'timestamp': FieldValue.serverTimestamp(),
      };

      try {
        await FirebaseFirestore.instance
            .collection('place_suggestions') // Veri buraya kaydedilecek
            .add(suggestionData);

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Öneriniz başarıyla kaydedildi!')),
        );

        Navigator.of(context).pop();

      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Hata oluştu: Veri kaydedilemedi. Güvenlik kurallarını kontrol edin.')),
        );
        print('Firestore kayıt hatası: $e');
      }
    }
  }

  // lib/suggest_place_screen.dart

  void _pickImage() async { // Metodu async yapın
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);
    // Kullanıcıdan galeriden fotoğraf seçmesini istedik

    if (image != null) {
      setState(() {
        _placeImage = File(image.path); // Seçilen dosyayı değişkene atayın
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Fotoğraf başarıyla seçildi!')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Fotoğraf seçimi iptal edildi.')),
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
              // --- 1. Konum Seçimi Başlık ---
              const Text(
                'Konum Bilgileri (Zorunlu)',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.blue),
              ),
              const SizedBox(height: 10),

              // Şehir Seçimi (Şimdilik sabit: Ankara)
              _buildDropdownField(
                'Şehir (Sabit)',
                null,
                ['Ankara'],
                _selectedCity,
                    (newValue) {}, // Değişiklik yapılmasına izin verilmiyor
                isEnabled: false,
              ),

              // İlçe Seçimi
              _buildDropdownField(
                'İlçe Seçin *',
                'Lütfen bir ilçe seçin.',
                _districtsAndNeighbourhoods.keys.toList(),
                _selectedDistrict,
                    (String? newValue) {
                  setState(() {
                    _selectedDistrict = newValue;
                    _selectedNeighbourhood = null; // İlçe değişince mahalleyi sıfırla
                  });
                },
              ),

              // Mahalle Seçimi
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
              // --- YENİ ADRES TARİFİ NOT ALANI BURADA BAŞLIYOR ---
              const SizedBox(height: 10),
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'Açık Adres Tarifi (Örn: Şu parkın karşısı, caminin yanı)',
                  hintText: 'Zorunlu değil, ancak yer tespiti için önemlidir.',
                  border: OutlineInputBorder(),
                  alignLabelWithHint: true,
                ),
                maxLines: 3,
                minLines: 2,
                keyboardType: TextInputType.multiline,
                onChanged: (newValue) {
                  // Kullanıcı metin girdikçe değişkeni günceller
                  setState(() {
                    _placeAddressNote = newValue;
                  });
                },
              ),
              // --- ADRES TARİFİ NOT ALANI BURADA BİTİYOR ---

              const Divider(height: 30),
              const Divider(height: 30),

              // --- 2. Kategori Seçimi Başlık ---
              const Text(
                'Kategori Seçimi (Zorunlu)',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.blue),
              ),
              const SizedBox(height: 10),

              // Kategori Seçimi
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

              const Divider(height: 30),

              // --- 3. Fotoğraf Ekleme (İsteğe Bağlı) ---
              const Text(
                'Fotoğraf Ekle (İsteğe Bağlı)',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),

              ElevatedButton.icon(
                onPressed: _pickImage,
                icon: const Icon(Icons.camera_alt),
                label: const Text('Fotoğraf Seç / Çek'),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  backgroundColor: Colors.grey.shade300,
                  foregroundColor: Colors.black87,
                ),
              ),

              const SizedBox(height: 30),

              // --- 4. Gönderme Butonu ---
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

  // Genel Dropdown Form Alanı Widget'ı
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