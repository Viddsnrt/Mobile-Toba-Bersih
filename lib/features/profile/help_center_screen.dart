import 'package:flutter/material.dart';

class HelpCenterScreen extends StatelessWidget {
  const HelpCenterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        title: const Text('Pusat Bantuan', style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.green.shade700,
        foregroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
      ),
      body: ListView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.all(20),
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(color: Colors.green.shade50, borderRadius: BorderRadius.circular(16)),
            child: Row(
              children: [
                Icon(Icons.support_agent_rounded, size: 40, color: Colors.green.shade700),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Halo! Ada yang bisa dibantu?', style: TextStyle(fontWeight: FontWeight.w900, fontSize: 16, color: Colors.green.shade900)),
                      const SizedBox(height: 4),
                      Text('Temukan jawaban dari pertanyaan yang sering diajukan di bawah.', style: TextStyle(fontSize: 12, color: Colors.green.shade700)),
                    ],
                  ),
                )
              ],
            ),
          ),
          const SizedBox(height: 24),
          const Text('Pertanyaan Umum (FAQ)', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          const SizedBox(height: 16),
          _buildFAQItem('Bagaimana cara melaporkan tumpukan sampah?', 'Buka menu "Lapor" di bagian bawah layar. Fotolah tumpukan sampah, isi deskripsi, pastikan lokasi GPS menyala, lalu tekan tombol Kirim.'),
          _buildFAQItem('Kapan truk sampah akan datang?', 'Setelah laporan diverifikasi oleh Admin, armada Truk DLH akan ditugaskan ke lokasi Anda. Anda dapat melihat estimasi kedatangannya di Beranda.'),
          _buildFAQItem('Bagaimana jika laporan saya ditolak?', 'Pastikan foto yang dilampirkan jelas dan lokasi GPS akurat. Laporan palsu atau foto tidak relevan akan otomatis ditolak oleh sistem.'),
        ],
      ),
    );
  }

  Widget _buildFAQItem(String question, String answer) {
    return Card(
      elevation: 0,
      margin: const EdgeInsets.only(bottom: 12),
      // 🔥 PERBAIKAN: Mengganti 'border: Border.all(...)' menjadi 'side: BorderSide(...)'
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16), 
        side: BorderSide(color: Colors.grey.shade200)
      ),
      child: Theme(
        data: ThemeData().copyWith(dividerColor: Colors.transparent), 
        child: ExpansionTile(
          iconColor: Colors.green.shade700,
          collapsedIconColor: Colors.grey.shade400,
          tilePadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
          title: Text(question, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Colors.black87)),
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
              child: Text(answer, style: TextStyle(color: Colors.grey.shade600, height: 1.5, fontSize: 13)),
            )
          ],
        ),
      ),
    );
  }
}