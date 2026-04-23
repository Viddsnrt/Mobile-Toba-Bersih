import 'package:flutter/material.dart';
import 'package:toba_bersih/features/history/history_screen.dart';

// 🔥 IMPORT PENTING: Untuk memanggil MainScreen
// Sesuaikan path ini dengan tempat kamu meletakkan MainScreen 
// (Misal di 'package:toba_bersih/main.dart' atau 'package:toba_bersih/features/report/masyarakat_home.dart')
import 'package:toba_bersih/main.dart'; 

class SuccessScreen extends StatelessWidget {
  const SuccessScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(24),
      ),
      elevation: 10,
      backgroundColor: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisSize: MainAxisSize.min, 
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.green.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.check_circle_rounded,
                color: Colors.green,
                size: 80,
              ),
            ),
            const SizedBox(height: 24),
            
            const Text(
              "Laporan Terkirim!",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w900,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 12),
            
            const Text(
              "Terima kasih! Laporan kamu telah kami terima dan akan segera diproses oleh tim kami.",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                color: Colors.black54,
                height: 1.5,
              ),
            ),
            const SizedBox(height: 32),
            
            // 🚀 TOMBOL 1: KEMBALI KE BERANDA
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green.shade600,
                foregroundColor: Colors.white,
                elevation: 0,
                minimumSize: const Size(double.infinity, 50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onPressed: () {
                // 🔥 PERBAIKAN: Menghapus semua riwayat layar sebelumnya, 
                // lalu membangun ulang MainScreen (yang otomatis ada di Tab 0 / Beranda)
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => const MainScreen()),
                  (route) => false,
                );
              },
              child: const Text(
                "Kembali ke Beranda",
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 12),
            
            // 📊 TOMBOL 2: LIHAT STATUS LAPORAN
            OutlinedButton(
              style: OutlinedButton.styleFrom(
                foregroundColor: Colors.green.shade700,
                side: BorderSide(color: Colors.green.shade600, width: 1.5),
                minimumSize: const Size(double.infinity, 50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onPressed: () {
                // 🔥 PERBAIKAN: Menutup dialog Pop-up ini terlebih dahulu
                Navigator.pop(context);
                
                // Lalu membuka halaman Riwayat (HistoryScreen)
                Navigator.push(
                  context, 
                  MaterialPageRoute(builder: (context) => const HistoryScreen())
                );
              },
              child: const Text(
                "Lihat Status Laporan",
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ),
    );
  }
}