import 'package:flutter/material.dart';

class PrivacyPolicyScreen extends StatelessWidget {
  const PrivacyPolicyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        foregroundColor: Colors.black87,
        title: const Text('Kebijakan Privasi', style: TextStyle(fontWeight: FontWeight.w900, fontSize: 18)),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header Illustration / Icon
            Center(
              child: Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.green.shade50,
                  shape: BoxShape.circle,
                ),
                child: Icon(Icons.privacy_tip_rounded, size: 60, color: Colors.green.shade600),
              ),
            ),
            const SizedBox(height: 24),
            
            const Text(
              'Privasi Anda adalah \nPrioritas Kami',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.w900, color: Colors.black87, height: 1.3),
            ),
            const SizedBox(height: 12),
            Text(
              'Aplikasi Toba Bersih berkomitmen untuk melindungi informasi pribadi Anda. Berikut adalah cara kami mengelola data Anda.',
              style: TextStyle(fontSize: 14, color: Colors.grey.shade600, height: 1.5),
            ),
            const SizedBox(height: 32),

            // Section 1: Pengumpulan Data
            _buildPolicySection(
              icon: Icons.data_usage_rounded,
              iconColor: Colors.blue,
              title: 'Data yang Kami Kumpulkan',
              content: 'Saat Anda menggunakan aplikasi ini, kami mengumpulkan informasi dasar seperti Nama, Email, dan Nomor Telepon saat pendaftaran. Kami juga meminta akses Lokasi (GPS) dan Kamera secara eksklusif hanya untuk keperluan pelaporan tumpukan sampah.',
            ),
            
            // Section 2: Penggunaan Data
            _buildPolicySection(
              icon: Icons.published_with_changes_rounded,
              iconColor: Colors.orange,
              title: 'Bagaimana Data Digunakan',
              content: 'Data lokasi dan foto yang Anda kirimkan digunakan oleh petugas Dinas Lingkungan Hidup (DLH) untuk menemukan dan menindaklanjuti laporan sampah Anda. Kami tidak akan pernah menjual data Anda ke pihak ketiga.',
            ),

            // Section 3: Keamanan
            _buildPolicySection(
              icon: Icons.security_rounded,
              iconColor: Colors.green,
              title: 'Keamanan Data Anda',
              content: 'Seluruh data yang dikirimkan antara aplikasi Anda dan server kami dienkripsi dengan standar keamanan modern. Anda dapat meminta penghapusan akun dan data Anda kapan saja melalui pengaturan aplikasi.',
            ),

            const SizedBox(height: 24),
            
            // Footer update date
            Center(
              child: Text(
                'Terakhir diperbarui: 18 April 2026',
                style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Colors.grey.shade400),
              ),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  // Widget Kustom untuk Kartu Poin Privasi
  Widget _buildPolicySection({
    required IconData icon,
    required MaterialColor iconColor,
    required String title,
    required String content,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 15, offset: const Offset(0, 5)),
        ],
        border: Border.all(color: Colors.grey.shade100),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: iconColor.shade50,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, color: iconColor.shade600, size: 20),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w800, color: Colors.black87),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            content,
            style: TextStyle(fontSize: 14, color: Colors.grey.shade600, height: 1.6),
          ),
        ],
      ),
    );
  }
}