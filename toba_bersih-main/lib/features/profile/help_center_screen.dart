import 'package:flutter/material.dart';

class HelpCenterScreen extends StatelessWidget {
  const HelpCenterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Help Center'),
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: const [
          ExpansionTile(
            title: Text('Bagaimana cara melaporkan tumpukan sampah?', style: TextStyle(fontWeight: FontWeight.bold)),
            children: [
              Padding(
                padding: EdgeInsets.all(16.0),
                child: Text('Buka menu "Lapor" di bagian bawah layar. Fotolah tumpukan sampah, isi deskripsi, pastikan lokasi GPS menyala, lalu tekan tombol Kirim.'),
              )
            ],
          ),
          ExpansionTile(
            title: Text('Kapan truk sampah akan datang?', style: TextStyle(fontWeight: FontWeight.bold)),
            children: [
              Padding(
                padding: EdgeInsets.all(16.0),
                child: Text('Setelah laporan Anda diverifikasi oleh Admin, armada Truk DLH akan segera ditugaskan ke lokasi Anda sesuai antrean operasional.'),
              )
            ],
          ),
          ExpansionTile(
            title: Text('Bagaimana jika laporan saya ditolak?', style: TextStyle(fontWeight: FontWeight.bold)),
            children: [
              Padding(
                padding: EdgeInsets.all(16.0),
                child: Text('Pastikan foto yang dilampirkan jelas dan lokasi GPS akurat. Laporan palsu atau foto tidak relevan akan otomatis ditolak oleh sistem.'),
              )
            ],
          ),
        ],
      ),
    );
  }
}