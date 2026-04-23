import 'package:flutter/material.dart';

// 🔥 Import kedua halaman tab yang akan kita buat
import 'operator_dashboard_tab.dart';
import 'operator_profile_tab.dart';

class OperatorHomeScreen extends StatefulWidget {
  final String driverId;

  const OperatorHomeScreen({super.key, required this.driverId});

  @override
  State<OperatorHomeScreen> createState() => _OperatorHomeScreenState();
}

class _OperatorHomeScreenState extends State<OperatorHomeScreen> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    // Memasukkan halaman ke dalam List
    final List<Widget> pages = [
      OperatorDashboardTab(driverId: widget.driverId),
      OperatorProfileTab(driverId: widget.driverId),
    ];

    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      // Menampilkan halaman sesuai index tab yang diklik
      body: pages[_currentIndex],
      
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 20, offset: const Offset(0, -5))],
        ),
        child: BottomNavigationBar(
          backgroundColor: Colors.white,
          currentIndex: _currentIndex,
          onTap: (index) {
            setState(() {
              _currentIndex = index;
            });
          },
          selectedItemColor: Colors.green.shade700,
          unselectedItemColor: Colors.grey.shade400,
          selectedLabelStyle: const TextStyle(fontWeight: FontWeight.w900, fontSize: 12),
          unselectedLabelStyle: const TextStyle(fontWeight: FontWeight.w600, fontSize: 12),
          elevation: 0,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.assignment_outlined),
              activeIcon: Icon(Icons.assignment_rounded),
              label: 'Tugas',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.badge_outlined),
              activeIcon: Icon(Icons.badge_rounded),
              label: 'Profil Supir',
            ),
          ],
        ),
      ),
    );
  }
}