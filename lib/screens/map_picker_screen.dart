import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapPickerScreen extends StatefulWidget {
  // Başlangıç konumunu almak için
  final LatLng initialLocation;

  const MapPickerScreen({
    super.key,
    required this.initialLocation,
  });

  @override
  State<MapPickerScreen> createState() => _MapPickerScreenState();
}

class _MapPickerScreenState extends State<MapPickerScreen> {
  LatLng? _pickedLocation;

  @override
  void initState() {
    super.initState();
    // Başlangıçta işaretleyici, ilk konuma ayarlanır
    _pickedLocation = widget.initialLocation;
  }

  // Kullanıcı haritaya dokunduğunda konumu günceller
  void _selectLocation(LatLng position) {
    setState(() {
      _pickedLocation = position;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Konumu İşaretleyin'),
        actions: [
          IconButton(
            icon: const Icon(Icons.check),
            onPressed: _pickedLocation != null
                ? () {
              // Seçilen konumu ana forma geri gönder
              Navigator.of(context).pop(_pickedLocation);
            }
                : null,
          ),
        ],
      ),
      body: GoogleMap(
        // Haritanın başlangıç kamera konumu
        initialCameraPosition: CameraPosition(
          target: widget.initialLocation,
          zoom: 13,
        ),
        mapType: MapType.normal,
        // Haritada herhangi bir yere tıklandığında konumu kaydet
        onTap: _selectLocation,
        // İşaretleyiciyi (Marker) göster
        markers: _pickedLocation == null
            ? {}
            : {
          Marker(
            markerId: const MarkerId('m1'),
            position: _pickedLocation!,
            infoWindow: const InfoWindow(title: 'Seçilen Konum'),
          ),
        },
      ),
    );
  }
}