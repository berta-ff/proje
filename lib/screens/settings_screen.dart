import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/theme_provider.dart';
import '../providers/user_provider.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});
  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool isPrivacyEnabled = true;

  @override
  Widget build(BuildContext context) {
    final themeNotifier = Provider.of<ThemeNotifier>(context);
    bool isDarkMode = themeNotifier.themeMode == ThemeMode.dark;

    return Scaffold(
      appBar: AppBar(title: const Text('Ayarlar'), backgroundColor: Colors.deepPurple),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          SwitchListTile(
            title: const Text('Karanlık Mod'),
            value: isDarkMode,
            onChanged: (value) => themeNotifier.setThemeMode(value ? ThemeMode.dark : ThemeMode.light),
            secondary: Icon(Icons.brightness_2, color: isDarkMode ? Colors.yellow : Colors.blueGrey),
          ),
          const Divider(),
          SwitchListTile(
            title: const Text('Gizlilik Ayarları'),
            value: isPrivacyEnabled,
            onChanged: (value) => setState(() => isPrivacyEnabled = value),
            secondary: const Icon(Icons.lock),
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.security, color: Colors.red),
            title: const Text('Hesabı Sil', style: TextStyle(color: Colors.red)),
            onTap: () {
              // Silme dialogu buraya
              Provider.of<UserNotifier>(context, listen: false).logout();
              Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);
            },
          ),
        ],
      ),
    );
  }
}