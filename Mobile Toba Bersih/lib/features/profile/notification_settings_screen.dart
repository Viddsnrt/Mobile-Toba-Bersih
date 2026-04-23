import 'package:flutter/material.dart';

class NotificationSettingsScreen extends StatefulWidget {
  const NotificationSettingsScreen({super.key});

  @override
  State<NotificationSettingsScreen> createState() => _NotificationSettingsScreenState();
}

class _NotificationSettingsScreenState extends State<NotificationSettingsScreen> {
  bool pushNotif = true;
  bool emailNotif = false;
  bool truckNotif = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        title: const Text('Notifikasi', style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.green.shade700, // Menyesuaikan warna Appbar agar konsisten dengan desain lain
        foregroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
      ),
      body: ListView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.all(20),
        children: [
          const Text('Atur Notifikasi', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w900)),
          const SizedBox(height: 8),
          Text('Pilih pemberitahuan apa saja yang ingin Anda terima dari Toba Bersih.', style: TextStyle(fontSize: 13, color: Colors.grey.shade600)),
          const SizedBox(height: 24),
          
          _buildSwitchCard(
            title: 'Notifikasi Aplikasi (Push)',
            subtitle: 'Muncul langsung di layar HP Anda',
            icon: Icons.notifications_active_rounded,
            value: pushNotif,
            onChanged: (val) => setState(() => pushNotif = val),
          ),
          _buildSwitchCard(
            title: 'Jadwal Truk Sampah',
            subtitle: 'Peringatan saat truk menuju area Anda',
            icon: Icons.local_shipping_rounded,
            value: truckNotif,
            onChanged: (val) => setState(() => truckNotif = val),
          ),
          _buildSwitchCard(
            title: 'Pembaruan & Berita via Email',
            subtitle: 'Berita seputar kebersihan langsung ke inbox',
            icon: Icons.email_rounded,
            value: emailNotif,
            onChanged: (val) => setState(() => emailNotif = val),
          ),
        ],
      ),
    );
  }

  Widget _buildSwitchCard({required String title, required String subtitle, required IconData icon, required bool value, required Function(bool) onChanged}) {
    return Card(
      elevation: 0,
      margin: const EdgeInsets.only(bottom: 16),
      // 🔥 PERBAIKAN: Mengganti 'border: Border.all(...)' menjadi 'side: BorderSide(...)'
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16), 
        side: BorderSide(color: Colors.grey.shade200)
      ),
      child: SwitchListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
        secondary: Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(color: value ? Colors.green.shade50 : Colors.grey.shade100, borderRadius: BorderRadius.circular(12)),
          child: Icon(icon, color: value ? Colors.green.shade600 : Colors.grey.shade400),
        ),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 4.0),
          child: Text(subtitle, style: TextStyle(fontSize: 12, color: Colors.grey.shade600)),
        ),
        activeColor: Colors.white,
        activeTrackColor: Colors.green.shade600,
        value: value,
        onChanged: onChanged,
      ),
    );
  }
}