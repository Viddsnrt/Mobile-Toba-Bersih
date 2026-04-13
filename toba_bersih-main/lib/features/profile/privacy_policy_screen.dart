import 'package:flutter/material.dart';

class PrivacyPolicyScreen extends StatelessWidget {
  const PrivacyPolicyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Privacy Policy'),
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Kebijakan Privasi Toba Bersih', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.green)),
            const SizedBox(height: 16),
            const Text(
              'Aplikasi ini dirancang untuk membantu pengelolaan sampah di wilayah Kabupaten Toba. Kami sangat menghargai privasi Anda.\n\n'
              '1. Pengumpulan Data\nKami mengumpulkan data nama, nomor telepon, dan koordinat lokasi (saat Anda mengirimkan laporan sampah) semata-mata untuk keperluan operasional Dinas Lingkungan Hidup.\n\n'
              '2. Penggunaan Kamera\nAplikasi membutuhkan akses kamera untuk memfoto tumpukan sampah sebagai bukti lampiran laporan.\n\n'
              '3. Keamanan Data\nData Anda disimpan dengan aman di server kami dan tidak akan diperjualbelikan kepada pihak ketiga.',
              style: TextStyle(fontSize: 15, height: 1.5),
            ),
          ],
        ),
      ),
    );
  }
}