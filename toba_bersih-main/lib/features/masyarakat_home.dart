import 'package:flutter/material.dart';

class MasyarakatHomeScreen extends StatelessWidget {
  const MasyarakatHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Beranda Masyarakat')),
      body: const Center(child: Text('Selamat datang, Warga Toba!', style: TextStyle(fontSize: 20))),
    );
  }
}