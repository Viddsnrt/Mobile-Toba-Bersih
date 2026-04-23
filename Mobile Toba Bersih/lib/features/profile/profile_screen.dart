import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart'; 

// 🔥 Semua jalur file diaktifkan karena berada di folder yang sama
import 'edit_profile_screen.dart';
import 'notification_settings_screen.dart';
import 'privacy_policy_screen.dart';
import 'help_center_screen.dart';
import 'about_screen.dart';

// Sesuaikan path ini dengan letak LoginScreen kamu
import 'package:toba_bersih/auth/login_screen.dart'; 

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  String _fullName = "Memuat...";
  String _email = "Memuat...";
  String _phone = "-";

  @override
  void initState() {
    super.initState();
    _syncUserData();
  }

  Future<void> _syncUserData() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _fullName = prefs.getString('user_name') ?? "Pengguna Toba"; 
      _email = prefs.getString('user_email') ?? "Belum ada email";
      _phone = prefs.getString('user_phone') ?? "-";
    });
  }

  void _logout() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        title: const Column(
          children: [
            Icon(Icons.logout_rounded, size: 50, color: Colors.red),
            SizedBox(height: 16),
            Text('Keluar Aplikasi', style: TextStyle(fontWeight: FontWeight.w900, fontSize: 20)),
          ],
        ),
        content: const Text(
          'Apakah Anda yakin ingin keluar dari akun ini? Anda harus login kembali nantinya.',
          textAlign: TextAlign.center,
          style: TextStyle(color: Colors.black54, height: 1.4),
        ),
        actionsAlignment: MainAxisAlignment.spaceEvenly,
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Batal', style: TextStyle(color: Colors.grey, fontWeight: FontWeight.bold)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red.shade600, 
              foregroundColor: Colors.white,
              elevation: 0,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))
            ),
            onPressed: () async {
              final prefs = await SharedPreferences.getInstance();
              await prefs.clear(); 

              if (!context.mounted) return;
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => const LoginScreen()),
                (route) => false,
              );
            },
            child: const Text('Ya, Keluar', style: TextStyle(fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50, 
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          children: [
            _buildProfileHeader(),
            const SizedBox(height: 16),
            _buildMenuSection(context),
          ],
        ),
      ),
    );
  }

  // ✨ HEADER PROFIL MELAYANG (FLOATING CARD)
  Widget _buildProfileHeader() {
    return Stack(
      clipBehavior: Clip.none,
      alignment: Alignment.bottomCenter,
      children: [
        // Background Hijau Melengkung
        Container(
          height: 220,
          width: double.infinity,
          decoration: BoxDecoration(
            color: Colors.green.shade700,
            borderRadius: const BorderRadius.only(
              bottomLeft: Radius.circular(40),
              bottomRight: Radius.circular(40),
            ),
          ),
          child: const SafeArea(
            child: Padding(
              padding: EdgeInsets.only(top: 16.0),
              child: Text(
                'Profil Saya',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w900),
              ),
            ),
          ),
        ),
        
        // Kartu Informasi Profil
        Positioned(
          top: 110,
          left: 24,
          right: 24,
          child: Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(24),
              boxShadow: [
                BoxShadow(color: Colors.black.withOpacity(0.08), blurRadius: 20, offset: const Offset(0, 10)),
              ],
            ),
            child: Column(
              children: [
                // Avatar
                Stack(
                  alignment: Alignment.bottomRight,
                  children: [
                    Container(
                      height: 80,
                      width: 80,
                      decoration: BoxDecoration(
                        color: Colors.green.shade100,
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white, width: 4),
                        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 10)],
                      ),
                      child: Center(
                        child: Text(
                          _fullName.isNotEmpty ? _fullName.substring(0, 1).toUpperCase() : "U", 
                          style: TextStyle(fontSize: 32, fontWeight: FontWeight.w900, color: Colors.green.shade700),
                        ),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: Colors.green.shade600,
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white, width: 2),
                      ),
                      child: const Icon(Icons.edit_rounded, size: 14, color: Colors.white),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                
                // Nama & Email
                Text(
                  _fullName,
                  style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w900, color: Colors.black87),
                ),
                const SizedBox(height: 4),
                Text(
                  _email,
                  style: TextStyle(fontSize: 14, color: Colors.grey.shade500, fontWeight: FontWeight.w500),
                ),
                const SizedBox(height: 12),
                
                // Badge Nomor HP
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.blue.shade50, 
                    borderRadius: BorderRadius.circular(20)
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.phone_android_rounded, size: 14, color: Colors.blue.shade700),
                      const SizedBox(width: 6),
                      Text(
                        _phone, 
                        style: TextStyle(fontSize: 13, color: Colors.blue.shade800, fontWeight: FontWeight.bold)
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        
        const SizedBox(height: 240), 
      ],
    );
  }

  Widget _buildMenuSection(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 130), 
          
          Text('Pengaturan Akun', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w900, color: Colors.grey.shade500, letterSpacing: 1)),
          const SizedBox(height: 12),
          
          // 🔥 TOMBOL-TOMBOL INI SEKARANG AKTIF
          _buildListTile(Icons.person_outline_rounded, 'Edit Profil Pribadi', Colors.blue, () async {
  // 🔥 PERBAIKAN: Gunakan 'await' untuk menunggu hasil dari halaman Edit
  final result = await Navigator.push(
    context, 
    MaterialPageRoute(builder: (context) => const EditProfileScreen())
  );

  // Jika result bernilai true (artinya user menekan tombol Simpan), panggil ulang fungsi sync
  if (result == true) {
    _syncUserData(); 
  }
}),
          _buildListTile(Icons.notifications_outlined, 'Pengaturan Notifikasi', Colors.orange, () {
            Navigator.push(context, MaterialPageRoute(builder: (context) => const NotificationSettingsScreen()));
          }),
          
          const SizedBox(height: 24),
          Text('Informasi & Bantuan', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w900, color: Colors.grey.shade500, letterSpacing: 1)),
          const SizedBox(height: 12),
          
          _buildListTile(Icons.shield_outlined, 'Kebijakan Privasi', Colors.purple, () {
            Navigator.push(context, MaterialPageRoute(builder: (context) => const PrivacyPolicyScreen()));
          }),
          _buildListTile(Icons.help_outline_rounded, 'Pusat Bantuan', Colors.teal, () {
            Navigator.push(context, MaterialPageRoute(builder: (context) => const HelpCenterScreen()));
          }),
          _buildListTile(Icons.info_outline_rounded, 'Tentang Toba Bersih', Colors.indigo, () {
            Navigator.push(context, MaterialPageRoute(builder: (context) => const AboutScreen()));
          }),
          
          const SizedBox(height: 32),
          _buildListTile(Icons.logout_rounded, 'Keluar Akun', Colors.red, _logout, isLogout: true),
          const SizedBox(height: 40),
        ],
      ),
    );
  }

  Widget _buildListTile(IconData icon, String title, MaterialColor themeColor, VoidCallback onTap, {bool isLogout = false}) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 10, offset: const Offset(0, 4))],
        border: Border.all(color: Colors.grey.shade100)
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: isLogout ? Colors.red.shade50 : themeColor.shade50,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(icon, color: isLogout ? Colors.red.shade600 : themeColor.shade600, size: 22),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Text(
                    title,
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      color: isLogout ? Colors.red.shade700 : Colors.black87,
                    ),
                  ),
                ),
                Icon(Icons.arrow_forward_ios_rounded, size: 14, color: Colors.grey.shade400),
              ],
            ),
          ),
        ),
      ),
    );
  }
}