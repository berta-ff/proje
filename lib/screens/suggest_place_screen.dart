import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/material.dart';

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
  final _formKey = GlobalKey<FormState>();

  File? _selectedImage;
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

  // --- Metotlar ---
  void _submitSuggestion() {
    if (_formKey.currentState!.validate()) {
      if(_selectedImage !=null){
        print('Yüklenecek Fotoğraf Yolu: ${_selectedImage!.path}');
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Öneriniz başarıyla alındı: $_selectedCity, $_selectedDistrict, $_selectedCategory')),
      );
      // TODO: Burada gerçek Firebase/API gönderim kodunu ekleyeceksiniz.
      Navigator.of(context).pop();
    }
  }

  void _pickImage() async {
    final XFile? pickedFile = await _picker.pickImage(
      source: ImageSource.gallery, // İlk olarak galeriyi açar.
      imageQuality: 50, // İsteğe bağlı: Dosya boyutunu küçültmek için kalite ayarı
    );

    if (pickedFile != null) {
      setState(() {
        // Seçilen fotoğrafı File tipinde değişkene atarız.
        _selectedImage = File(pickedFile.path);
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

              const Divider(height: 30),

              const Text(
                'Fotoğraf Ekle (İsteğe Bağlı)',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),

              // Seçilen fotoğraf varsa, onu göster (YENİ KOD BAŞLANGICI)
              if (_selectedImage != null)
                Padding(
                  padding: const EdgeInsets.only(bottom: 10.0),
                  child: Image.file(
                    _selectedImage!,
                    height: 200,
                    fit: BoxFit.cover,
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