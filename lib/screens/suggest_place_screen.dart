import 'dart:io';
import 'dart:typed_data'; // Web için gerekli
import 'package:flutter/foundation.dart'; // kIsWeb için gerekli
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:cloud_firestore/cloud_firestore.dart'; // Firebase için
import 'package:firebase_storage/firebase_storage.dart'; // Storage için

class SuggestPlaceScreen extends StatefulWidget {
  const SuggestPlaceScreen({super.key});

  @override
  State<SuggestPlaceScreen> createState() => _SuggestPlaceScreenState();
}

class _SuggestPlaceScreenState extends State<SuggestPlaceScreen> {
  // --- Form Verileri ---
  String? _selectedCity = 'Ankara';
  String? _selectedDistrict;
  String? _selectedNeighbourhood;
  String? _selectedCategory;
  String? _placeAddressNote; // Adres notu
  final _formKey = GlobalKey<FormState>();

  // --- Resim Değişkenleri ---
  File? _selectedImage;    // Mobilde dosya yolu
  Uint8List? _webImage;    // Webde resim verisi (bytes)
  final ImagePicker _picker = ImagePicker();

  bool _isSubmitting = false; // Loading durumu

  // --- Dropdown Verileri ---
  final List<String> _categories = ['Yemek', 'Gezilecek Yerler', 'Alışveriş', 'Eğlence Yerleri'];

  final Map<String, List<String>> _districtsAndNeighbourhoods = {
    'Çankaya': ['Anıttepe','Ayrancı', 'Bahçelievler','Balgat','Bilkent/Bilkentplaza/Beytepe', 'Cebeci','Çayyolu/Ümitköy', 'Dikmen','Kızılay', 'ODTÜ','Sıhhiye','Kurtuluş','Tunalı Hilmi', ],
    'Keçiören': ['Aktepe', 'Bağlum','Esertepe','Etlik','Merkez','Sanatoryum','Ufuktepe'],
    'Kahramanakazan':['Kazan'],
    'Yenimahalle': ['Atatürk Orman Çiftliği','Batıkent','Demetevler','İstasyon','Karşıyaka','Ostim','Susuz','Şentepe','Yenimahalle'],
    'Etimesgut':['Çarşı','Elvankent','Eryaman','Güvercinlik', ],
  };

  // --- Metotlar ---
  void _submitSuggestion() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isSubmitting = true);

      // Veritabanına gönderilecek veri
      final suggestionData = {
        'city': _selectedCity,
        'district': _selectedDistrict,
        'neighbourhood': _selectedNeighbourhood,
        'category': _selectedCategory,
        'address_note': _placeAddressNote,
        'has_image': (_selectedImage != null || _webImage != null),
        'timestamp': FieldValue.serverTimestamp(),
      };

      try {
        await FirebaseFirestore.instance.collection('place_suggestions').add(suggestionData);

        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Öneriniz başarıyla kaydedildi!')),
        );
        Navigator.of(context).pop();

      } catch (e) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Hata: $e')));
      } finally {
        if (mounted) setState(() => _isSubmitting = false);
      }
    }
  }

  // 🔥 RESİM SEÇME METODU (WEB ve MOBİL UYUMLU)
  void _pickImage() async {
    try {
      final XFile? pickedFile = await _picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 50,
      );

      // 1. KONTROL: Resim seçilirken kullanıcı ekranı kapattı mı?
      if (!mounted) return;

      if (pickedFile != null) {
        if (kIsWeb) {
          // Web ise: Resmi 'byte' olarak oku
          var f = await pickedFile.readAsBytes();

          // 2. KONTROL: Okuma işlemi bittiğinde ekran hala açık mı?
          if (!mounted) return;

          setState(() {
            _webImage = f;
            _selectedImage = File('a'); // Form kontrolü için sahte dosya
          });
        } else {
          // Mobil ise: Normal dosya yolunu al
          setState(() {
            _selectedImage = File(pickedFile.path);
          });
        }
      } else {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Fotoğraf seçilmedi.')),
        );
      }
    } catch (e) {
      debugPrint("Hata: $e");
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

              _buildDropdownField('Şehir (Sabit)', null, ['Ankara'], _selectedCity, (v){}, isEnabled: false),

              _buildDropdownField(
                'İlçe Seçin *',
                'Lütfen bir ilçe seçin.',
                _districtsAndNeighbourhoods.keys.toList(),
                _selectedDistrict,
                    (val) {
                  setState(() {
                    _selectedDistrict = val;
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
                      (val) => setState(() => _selectedNeighbourhood = val),
                ),

              const SizedBox(height: 10),
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'Açık Adres Tarifi',
                  border: OutlineInputBorder(),
                ),
                maxLines: 2,
                onChanged: (val) => _placeAddressNote = val,
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
                    (val) => setState(() => _selectedCategory = val),
              ),

              const Divider(height: 30),

              const Text(
                'Fotoğraf Ekle (İsteğe Bağlı)',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),

              // 🔥 RESİM GÖSTERME ALANI (WEB ve MOBİL UYUMLU)
              if (_selectedImage != null || _webImage != null)
                Padding(
                  padding: const EdgeInsets.only(bottom: 10.0),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: kIsWeb
                        ? Image.memory(_webImage!, height: 200, fit: BoxFit.cover)
                        : Image.file(_selectedImage!, height: 200, fit: BoxFit.cover),
                  ),
                ),

              ElevatedButton.icon(
                onPressed: _pickImage,
                icon: Icon((_selectedImage != null || _webImage != null) ? Icons.change_circle : Icons.camera_alt),
                label: Text((_selectedImage != null || _webImage != null) ? 'Fotoğrafı Değiştir' : 'Fotoğraf Seç / Çek'),
              ),

              const SizedBox(height: 30),

              _isSubmitting
                  ? const Center(child: CircularProgressIndicator())
                  : ElevatedButton(
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