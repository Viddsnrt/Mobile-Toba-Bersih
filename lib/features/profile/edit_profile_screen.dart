import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();

  bool _isLoading = true;
  
  // 🔥 STATE UNTUK ZONASI WILAYAH
  List<dynamic> _wilayahList = [];
  String? _selectedWilayahId;
  bool _isLoadingWilayah = true;
  
  final String ipAddress = '10.215.41.195'; // Pastikan IP ini sesuai dengan IP laptop/backend

  @override
  void initState() {
    super.initState();
    _fetchWilayah().then((_) => _loadUserData());
  }

  // 🔥 Mengambil daftar wilayah dari Backend
  Future<void> _fetchWilayah() async {
    try {
      var url = Uri.parse('http://$ipAddress:5000/api/wilayah/public');
      var response = await http.get(url);

      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        if (data['success'] == true && mounted) {
          setState(() {
            _wilayahList = data['data'];
            _isLoadingWilayah = false;
          });
        }
      }
    } catch (e) {
      debugPrint("Error fetching wilayah: $e");
      if (mounted) setState(() => _isLoadingWilayah = false);
    }
  }

  // Menarik data asli dari SharedPreferences
  Future<void> _loadUserData() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _nameController.text = prefs.getString('user_name') ?? '';
      _emailController.text = prefs.getString('user_email') ?? '';
      _phoneController.text = prefs.getString('user_phone') ?? '';
      _addressController.text = prefs.getString('user_address') ?? '';
      
      // Set dropdown wilayah ke wilayah user saat ini (jika ada)
      String? savedWilayahId = prefs.getString('user_wilayah_id');
      
      // Pastikan savedWilayahId ada di dalam daftar yang ditarik dari API
      bool exists = _wilayahList.any((w) => w['id'].toString() == savedWilayahId);
      if (exists) {
        _selectedWilayahId = savedWilayahId;
      }
      
      _isLoading = false;
    });
  }

  // Menyimpan data kembali ke SharedPreferences & Database
  Future<void> _saveUserData() async {
    FocusScope.of(context).unfocus(); // Tutup keyboard
    
    setState(() {
      _isLoading = true; // Munculkan loading
    });

    try {
      final prefs = await SharedPreferences.getInstance();
      String? userId = prefs.getString('userId');

      // 🔥 Tembak API Update Profil ke Backend
      var url = Uri.parse('http://$ipAddress:5000/api/auth/update-profile');
      var response = await http.put(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'userId': userId,
          'fullName': _nameController.text.trim(),
          'phoneNumber': _phoneController.text.trim(),
          'address': _addressController.text.trim(),
          'locationId': _selectedWilayahId,
        }),
      );

      if (response.statusCode == 200) {
        // Cari nama wilayah berdasarkan ID yang dipilih
        String selectedWilayahName = 'Balige';
        if (_selectedWilayahId != null) {
          var wilayah = _wilayahList.firstWhere((w) => w['id'].toString() == _selectedWilayahId, orElse: () => null);
          if (wilayah != null) selectedWilayahName = wilayah['name'];
        }

        // Simpan pembaruan ke Local Storage HP agar Beranda dan Profil langsung berubah
        await prefs.setString('user_name', _nameController.text.trim());
        await prefs.setString('user_phone', _phoneController.text.trim());
        await prefs.setString('user_address', _addressController.text.trim());
        await prefs.setString('user_wilayah_id', _selectedWilayahId ?? '');
        await prefs.setString('user_wilayah_name', selectedWilayahName);

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: const Row(
                children: [
                  Icon(Icons.check_circle, color: Colors.white),
                  SizedBox(width: 8),
                  Text('Profil berhasil diperbarui permanen!', style: TextStyle(fontWeight: FontWeight.bold)),
                ],
              ),
              backgroundColor: Colors.green.shade600,
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            ),
          );
          Navigator.pop(context, true); // Kembali ke halaman sebelumnya dan kirim sinyal refresh
        }
      } else {
        throw Exception("Gagal update database");
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Terjadi kesalahan jaringan! Coba lagi nanti.'), 
            backgroundColor: Colors.red
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Edit Profil', style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black87,
        elevation: 0,
        centerTitle: true,
      ),
      body: _isLoading 
        ? Center(child: CircularProgressIndicator(color: Colors.green.shade600))
        : SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Stack(
                    alignment: Alignment.bottomRight,
                    children: [
                      Container(
                        width: 110, height: 110,
                        decoration: BoxDecoration(
                          color: Colors.green.shade100,
                          shape: BoxShape.circle,
                        ),
                        child: Center(
                          child: Text(
                            _nameController.text.isNotEmpty ? _nameController.text[0].toUpperCase() : 'U',
                            style: TextStyle(fontSize: 40, fontWeight: FontWeight.w900, color: Colors.green.shade700),
                          ),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.green.shade600,
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.white, width: 3),
                        ),
                        child: const Icon(Icons.camera_alt_rounded, color: Colors.white, size: 20),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 40),
                
                _buildTextFieldLabel('Nama Lengkap'),
                _buildTextField(_nameController, Icons.person_outline_rounded, 'Masukkan nama Anda'),
                const SizedBox(height: 20),
                
                _buildTextFieldLabel('Nomor Telepon'),
                _buildTextField(_phoneController, Icons.phone_outlined, 'Masukkan nomor telepon', isPhone: true),
                const SizedBox(height: 20),

                // 🔥 DROPDOWN ZONASI
                _buildTextFieldLabel('Wilayah / Kelurahan'),
                _isLoadingWilayah
                    ? const Center(child: CircularProgressIndicator(color: Colors.green))
                    : DropdownButtonFormField<String>(
                        value: _selectedWilayahId,
                        icon: Icon(Icons.keyboard_arrow_down_rounded, color: Colors.green.shade700),
                        decoration: InputDecoration(
                          hintText: 'Pilih domisili saat ini...',
                          hintStyle: TextStyle(color: Colors.grey.shade400, fontWeight: FontWeight.normal),
                          filled: true,
                          fillColor: Colors.grey.shade50,
                          prefixIcon: Icon(Icons.map_outlined, color: Colors.green.shade600),
                          contentPadding: const EdgeInsets.symmetric(vertical: 18),
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide.none),
                          focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide(color: Colors.green.shade500, width: 2)),
                        ),
                        items: _wilayahList.map((wilayah) {
                          return DropdownMenuItem<String>(
                            value: wilayah['id'].toString(),
                            child: Text(wilayah['name'], style: const TextStyle(fontWeight: FontWeight.w600)),
                          );
                        }).toList(),
                        onChanged: (value) {
                          setState(() {
                            _selectedWilayahId = value;
                          });
                        },
                      ),
                const SizedBox(height: 20),
                
                _buildTextFieldLabel('Alamat Lengkap (Detail)'),
                _buildTextField(_addressController, Icons.location_on_outlined, 'Masukkan jalan, nomor rumah'),
                const SizedBox(height: 20),
                
                _buildTextFieldLabel('Email Aktif (Tidak dapat diubah)'),
                _buildTextField(_emailController, Icons.email_outlined, 'Masukkan email', isEmail: true, readOnly: true), 
                
                const SizedBox(height: 48),
                SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green.shade600,
                      elevation: 0,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                    ),
                    onPressed: _saveUserData,
                    child: const Text('Simpan Perubahan', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
                  ),
                ),
                const SizedBox(height: 40),
              ],
            ),
          ),
    );
  }

  Widget _buildTextFieldLabel(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Text(text, style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Colors.grey.shade700)),
    );
  }

  Widget _buildTextField(TextEditingController controller, IconData icon, String hint, {bool isPhone = false, bool isEmail = false, bool readOnly = false}) {
    return TextField(
      controller: controller,
      readOnly: readOnly, // Mengunci ketikan jika readOnly = true
      keyboardType: isPhone ? TextInputType.phone : (isEmail ? TextInputType.emailAddress : TextInputType.text),
      style: TextStyle(
        fontWeight: FontWeight.w600, 
        color: readOnly ? Colors.grey.shade500 : Colors.black87, // Warna teks pudar jika dikunci
      ),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: TextStyle(color: Colors.grey.shade400, fontWeight: FontWeight.normal),
        filled: true,
        fillColor: readOnly ? Colors.grey.shade200 : Colors.grey.shade50, // Latar belakang abu-abu kalau dikunci
        prefixIcon: Icon(icon, color: readOnly ? Colors.grey.shade400 : Colors.green.shade600),
        contentPadding: const EdgeInsets.symmetric(vertical: 18),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide.none),
        focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide(color: readOnly ? Colors.transparent : Colors.green.shade500, width: 2)),
      ),
    );
  }
}