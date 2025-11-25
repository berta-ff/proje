import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/user.dart';
import '../providers/user_provider.dart';
import '../services/local_auth_service.dart';

// 1. PROFİL BİLGİ EKRANI
class ProfileInfoScreen extends StatelessWidget {
  final bool showAppBar;
  const ProfileInfoScreen({super.key, this.showAppBar = false});

  Widget _buildProfileDetail(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, color: Colors.grey),
              const SizedBox(width: 8),
              Text('$label:', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            ],
          ),
          const SizedBox(height: 4),
          Text(value, style: const TextStyle(fontSize: 16, color: Colors.blue)),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final User? currentUser = Provider.of<UserNotifier>(context).currentUser;
    final bool isLoggedIn = currentUser != null;

    final userName = currentUser?.kullaniciAdi ?? 'Misafir';
    final userEmail = currentUser?.email ?? 'Giriş Yapılmadı';
    final userPhone = currentUser?.telefon ?? '-';
    final userIsimSoyisim = currentUser?.isimSoyisim ?? 'Giriş Yapılmadı';

    return Scaffold(
      appBar: showAppBar ? AppBar(title: const Text('Hesap Bilgileri'), backgroundColor: Colors.deepPurple) : null,
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(30.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              CircleAvatar(radius: 60, child: Icon(Icons.person, size: 80, color: isLoggedIn ? Colors.white : Colors.grey)),
              const SizedBox(height: 30),

              _buildProfileDetail(Icons.badge, 'Ad Soyad', userIsimSoyisim),
              _buildProfileDetail(Icons.person, 'Kullanıcı Adı', userName),
              _buildProfileDetail(Icons.email, 'E-posta', userEmail),
              _buildProfileDetail(Icons.phone, 'Telefon', userPhone),

              const SizedBox(height: 20),

              if (isLoggedIn)
                ElevatedButton(
                  onPressed: () => Navigator.pushNamed(context, '/edit_profile'),
                  child: const Text('Bilgileri Düzenle'),
                )
              else
                ElevatedButton(
                  onPressed: () => Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false),
                  child: const Text('Giriş Yap'),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

// 2. PROFİL DÜZENLEME EKRANI
class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});
  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController isimSoyisimController;
  late TextEditingController kullaniciAdiController;
  late TextEditingController emailController;
  late TextEditingController telefonController;
  final LocalAuthService _authService = LocalAuthService();
  bool _isLoading = false;
  late User _oldUser;

  @override
  void initState() {
    super.initState();
    _oldUser = Provider.of<UserNotifier>(context, listen: false).currentUser!;
    isimSoyisimController = TextEditingController(text: _oldUser.isimSoyisim);
    kullaniciAdiController = TextEditingController(text: _oldUser.kullaniciAdi);
    emailController = TextEditingController(text: _oldUser.email);
    telefonController = TextEditingController(text: _oldUser.telefon);
  }

  @override
  void dispose() {
    isimSoyisimController.dispose();
    kullaniciAdiController.dispose();
    emailController.dispose();
    telefonController.dispose();
    super.dispose();
  }

  void _saveProfile() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isLoading = true);

      final updatedUser = User(
        email: emailController.text,
        sifre: _oldUser.sifre,
        isimSoyisim: isimSoyisimController.text,
        kullaniciAdi: kullaniciAdiController.text,
        telefon: telefonController.text,
        favoritePlaceIds: _oldUser.favoritePlaceIds,
      );

      final bool updateSuccess = await _authService.updateUser(oldUser: _oldUser, newUser: updatedUser);

      if (!mounted) return;

      if (updateSuccess) {
        Provider.of<UserNotifier>(context, listen: false).updateUser(
          _oldUser,
          isimSoyisim: isimSoyisimController.text,
          kullaniciAdi: kullaniciAdiController.text,
          email: emailController.text,
          telefon: telefonController.text,
        );
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Bilgiler güncellendi!')));
        Navigator.pop(context);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Hata: E-posta zaten kullanımda olabilir.')));
      }
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Bilgileri Düzenle'), backgroundColor: Colors.deepPurple),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(30.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(controller: isimSoyisimController, decoration: const InputDecoration(labelText: 'İsim Soyisim')),
              const SizedBox(height: 20),
              TextFormField(controller: kullaniciAdiController, decoration: const InputDecoration(labelText: 'Kullanıcı Adı')),
              const SizedBox(height: 20),
              TextFormField(controller: emailController, decoration: const InputDecoration(labelText: 'E-posta')),
              const SizedBox(height: 20),
              TextFormField(controller: telefonController, decoration: const InputDecoration(labelText: 'Telefon')),
              const SizedBox(height: 30),
              TextButton(onPressed: () => Navigator.pushNamed(context, '/change_password'), child: const Text('Şifreyi Değiştir')),
              const SizedBox(height: 20),
              _isLoading
                  ? const CircularProgressIndicator()
                  : ElevatedButton(onPressed: _saveProfile, child: const Text('BİLGİLERİ KAYDET')),
            ],
          ),
        ),
      ),
    );
  }
}

// 3. ŞİFRE DEĞİŞTİRME EKRANI
class ChangePasswordScreen extends StatefulWidget {
  const ChangePasswordScreen({super.key});
  @override
  State<ChangePasswordScreen> createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController currentPasswordController = TextEditingController();
  final TextEditingController newPasswordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();
  final LocalAuthService _authService = LocalAuthService();
  bool _isLoading = false;

  void _saveNewPassword() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isLoading = true);
      final User? oldUser = Provider.of<UserNotifier>(context, listen: false).currentUser;

      if (oldUser == null || oldUser.sifre != currentPasswordController.text) {
        setState(() => _isLoading = false);
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Hata: Mevcut şifre yanlış.')));
        return;
      }

      final bool success = await _authService.updateUserPassword(oldUser, newPasswordController.text);

      if (!mounted) return;
      setState(() => _isLoading = false);

      if (success) {
        Provider.of<UserNotifier>(context, listen: false).changePassword(oldUser, currentPasswordController.text, newPasswordController.text);
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Şifre güncellendi!')));
        Navigator.pop(context);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Bir hata oluştu.')));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Şifre Değiştir'), backgroundColor: Colors.deepPurple),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(30.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(controller: currentPasswordController, obscureText: true, decoration: const InputDecoration(labelText: 'Mevcut Şifre')),
              const SizedBox(height: 20),
              TextFormField(controller: newPasswordController, obscureText: true, decoration: const InputDecoration(labelText: 'Yeni Şifre')),
              const SizedBox(height: 20),
              TextFormField(
                controller: confirmPasswordController,
                obscureText: true,
                decoration: const InputDecoration(labelText: 'Yeni Şifre Tekrar'),
                validator: (val) => val != newPasswordController.text ? 'Şifreler uyuşmuyor' : null,
              ),
              const SizedBox(height: 30),
              _isLoading
                  ? const CircularProgressIndicator()
                  : ElevatedButton(onPressed: _saveNewPassword, child: const Text('ŞİFREYİ GÜNCELLE')),
            ],
          ),
        ),
      ),
    );
  }
}