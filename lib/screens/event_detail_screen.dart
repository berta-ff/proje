import 'package:flutter/material.dart';
import '../constants.dart'; // Kategori ikonları ve renkleri için

class EventDetailScreen extends StatelessWidget {
  final Map<String, dynamic> event;
  const EventDetailScreen({super.key, required this.event});

  @override
  Widget build(BuildContext context) {
    final Color eventColor = event['color'] as Color? ?? Colors.grey;

    return Scaffold(
      appBar: AppBar(
        title: Text(event['name']!),
        backgroundColor: eventColor,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 150,
              width: double.infinity,
              decoration: BoxDecoration(
                color: eventColor.withOpacity(0.5),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Center(
                child: Icon(
                  categories[event['category']] ?? Icons.event,
                  size: 80,
                  color: Colors.white,
                ),
              ),
            ),
            const SizedBox(height: 20),
            Text(
              event['name']!,
              style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 15),

            _buildDetailRow(context, Icons.calendar_today, 'Tarih', event['date']!),
            _buildDetailRow(context, Icons.access_time, 'Saat', event['time']!),
            _buildDetailRow(context, Icons.location_on, 'Konum', event['location']!),
            _buildDetailRow(context, categories[event['category']] ?? Icons.category, 'Kategori', event['category']!),
            const Divider(height: 30),

            const Text('Etkinlik Açıklaması', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            Text(
              'Bu etkinlik, ${event['category']} alanında düzenlenmektedir. Katılımcıların keyifli vakit geçirmesi hedeflenmektedir.',
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 30),
            ElevatedButton.icon(
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('${event['name']} için işlem yapılıyor...')));
              },
              icon: const Icon(Icons.confirmation_number),
              label: const Text('Bilet Al / Detaylı Bilgi'),
              style: ElevatedButton.styleFrom(backgroundColor: eventColor),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(BuildContext context, IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: Theme.of(context).colorScheme.secondary, size: 20),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('$label:', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                Text(value, style: const TextStyle(fontSize: 16)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}