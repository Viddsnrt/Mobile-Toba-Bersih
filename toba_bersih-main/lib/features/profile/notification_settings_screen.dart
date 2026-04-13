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
      appBar: AppBar(
        title: const Text('Pengaturan Notifikasi'),
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Padding(
            padding: EdgeInsets.all(8.0),
            child: Text('Pilih notifikasi yang ingin Anda terima:', style: TextStyle(fontSize: 16, color: Colors.grey)),
          ),
          SwitchListTile(
            title: const Text('Notifikasi Push (Aplikasi)'),
            subtitle: const Text('Muncul di layar HP Anda'),
            activeColor: Colors.green,
            value: pushNotif,
            onChanged: (bool value) {
              setState(() { pushNotif = value; });
            },
          ),
          const Divider(),
          SwitchListTile(
            title: const Text('Jadwal Truk Sampah'),
            subtitle: const Text('Peringatan saat truk menuju area Anda'),
            activeColor: Colors.green,
            value: truckNotif,
            onChanged: (bool value) {
              setState(() { truckNotif = value; });
            },
          ),
          const Divider(),
          SwitchListTile(
            title: const Text('Pembaruan & Berita Email'),
            subtitle: const Text('Kirim ke email terdaftar'),
            activeColor: Colors.green,
            value: emailNotif,
            onChanged: (bool value) {
              setState(() { emailNotif = value; });
            },
          ),
        ],
      ),
    );
  }
}