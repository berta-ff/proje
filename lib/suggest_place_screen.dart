// lib/suggest_place_screen.dart

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

  // --- Dropdown Verileri (İstediğiniz gibi genişletebilirsiniz) ---
  final List<String> _categories = ['Yemek', 'Gezilecek Yerler', 'Alışveriş', 'Eğlence Yerleri'];

  // Ankara için basit ilçe ve mahalle verileri
  final Map<String, List<String>> _districtsAndNeighbourhoods = {
    'Çankaya': ['Anıttepe','Ayrancı', 'Bahçelievler','Balgat','Bilkent/Bilkentplaza/Beytepe', 'Cebeci','Çayyolu/Ümitköy', 'Dikmen','Kızılay', 'ODTÜ','Sıhhiye','Kurtuluş','Tunalı Hilmi', ],
    'Keçiören': ['Aktepe', 'Bağlum','Esertepe','Etlik','Merkez','Sanatoryum','Ufuktepe'],
    'Yenimahalle': ['Atatürk Orman Çiftliği','Batıkent','Demetevler','İstasyon','Karşıyaka','Ostim','Susuz','Şentepe','Yenimahalle'],
    'Etimesgut':['Çarşı','Elvankent','Eryaman','Güvercinlik', ],
  };

  // --- Metotlar ---
  void _submitSuggestion() {
    if (_formKey.currentState!.validate()) {
      // Zorunlu alanlar dolduruldu. Gönderim işlemi burada yapılacak.

      // Şimdilik sadece başarılı mesaj gösterelim.
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Öneriniz başarıyla alındı: $_selectedCity, $_selectedDistrict, $_selectedCategory')),
      );
      // TODO: Burada gerçek Firebase/API gönderim kodunu ekleyeceksiniz.
      Navigator.of(context).pop(); // Formu gönderdikten sonra geri git
    }
  }

  // Fotoğraf ekleme fonksiyonu (Şimdilik sadece bir yer tutucu)
  void _pickImage() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Fotoğraf seçme arayüzü açılacak...')),
    );
    // TODO: Burada 'image_picker' paketi ile fotoğraf çekme/seçme kodunu ekleyeceksiniz.
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