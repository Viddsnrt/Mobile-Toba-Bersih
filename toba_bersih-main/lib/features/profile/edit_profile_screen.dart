import 'package:flutter/material.dart';

class EditProfileScreen extends StatelessWidget {
  const EditProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Profil'),
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            Center(
              child: Stack(
                alignment: Alignment.bottomRight,
                children: [
                  const CircleAvatar(
                    radius: 60,
                    backgroundColor: Colors.green,
                    child: Icon(Icons.person, size: 70, color: Colors.white),
                  ),
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.green, width: 2),
                    ),
                    child: Icon(Icons.camera_alt, color: Colors.green),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 30),
            _buildTextField('Nama Lengkap', 'David Gian Filbert', Icons.person),
            const SizedBox(height: 16),
            _buildTextField('Nomor Telepon', '+62 812-3456-7890', Icons.phone),
            const SizedBox(height: 16),
            _buildTextField('Alamat Lengkap', 'Balige Kota, Kab. Toba', Icons.location_on),
            const SizedBox(height: 16),
            _buildTextField('Email', 'david@example.com', Icons.email),
            const SizedBox(height: 40),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Profil berhasil diperbarui!')),
                  );
                  Navigator.pop(context); 
                },
                child: const Text('Simpan Perubahan', style: TextStyle(fontSize: 16, color: Colors.white)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(String label, String initialValue, IconData icon) {
    return TextFormField(
      initialValue: initialValue,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, color: Colors.green),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.green.shade700, width: 2),
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
  }
}