import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  // 🔥 Kunci Global Form
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _passwordConfirmController = TextEditingController(); // 🔥 TAMBAHAN UNTUK KONFIRMASI PASSWORD
  final TextEditingController _addressController = TextEditingController(); // 🔥 TAMBAHAN UNTUK DETAIL ALAMAT

  bool _isLoading = false;
  bool _isPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;

  // 🔥 STATE UNTUK ZONASI WILAYAH
  List<dynamic> _wilayahList = [];
  String? _selectedWilayahId;
  bool _isLoadingWilayah = true;

  final String ipAddress = '10.215.41.195'; // Pastikan IP sesuai

  @override
  void initState() {
    super.initState();
    _fetchWilayah(); // Panggil data wilayah saat halaman dibuka
  }

  // 🔥 FUNGSI MENGAMBIL DATA WILAYAH DARI BACKEND
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
      if (mounted) {
        setState(() {
          _isLoadingWilayah = false;
        });
        _showErrorSnackBar('Gagal memuat daftar wilayah. Periksa koneksi Anda.');
      }
    }
  }

  Future<void> _register() async {
    // Jalankan validasi secara real-time
    if (!_formKey.currentState!.validate()) {
      _showErrorSnackBar('Mohon perbaiki data yang masih merah.');
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      var url = Uri.parse('http://$ipAddress:5000/api/auth/register');
      var response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'fullName': _nameController.text.trim(),
          'email': _emailController.text.trim(),
          'password': _passwordController.text.trim(),
          'passwordConfirm': _passwordConfirmController.text.trim(), // 🔥 Sesuai dengan controller backend
          'address': _addressController.text.trim(), // 🔥 Mengirim alamat detail
          'wilayahId': _selectedWilayahId, // 🔥 Mengirim ID zonasi
        }),
      );

      var data = jsonDecode(response.body);

      if (response.statusCode == 201 && data['success'] == true) {
        if (mounted) {
          _showSuccessSnackBar(data['message'] ?? 'Pendaftaran Berhasil!');
          Future.delayed(const Duration(seconds: 2), () {
            if (mounted) Navigator.pop(context); // Kembali ke halaman Login
          });
        }
      } else {
        if (mounted) _showErrorSnackBar(data['message'] ?? 'Gagal mendaftar');
      }
    } catch (e) {
      if (mounted) _showErrorSnackBar('Terjadi kesalahan jaringan. Coba lagi nanti.');
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  void _showSuccessSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.check_circle, color: Colors.white),
            const SizedBox(width: 8),
            Expanded(child: Text(message, style: const TextStyle(fontWeight: FontWeight.bold))),
          ],
        ),
        backgroundColor: Colors.green.shade600,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        margin: const EdgeInsets.all(16),
      ),
    );
  }

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.error_outline, color: Colors.white),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                message,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
        backgroundColor: Colors.red.shade600,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        margin: const EdgeInsets.all(16),
      ),
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _passwordConfirmController.dispose();
    _addressController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.green.shade700),
      ),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 32.0, vertical: 10.0),
            physics: const BouncingScrollPhysics(),
            child: Form(
              key: _formKey,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Center(
                    child: Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.green.shade50,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.person_add_alt_1_rounded,
                        size: 60,
                        color: Colors.green.shade600,
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  const Text(
                    'Buat Akun Baru',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.w900,
                      color: Colors.black87,
                      letterSpacing: -0.5,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Mari bergabung untuk Toba yang lebih bersih.',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 14, color: Colors.grey, height: 1.5),
                  ),
                  const SizedBox(height: 32),

                  // ======================= INPUT NAMA =======================
                  Text('Nama Lengkap', style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Colors.grey.shade700)),
                  const SizedBox(height: 8),
                  TextFormField(
                    controller: _nameController,
                    keyboardType: TextInputType.name,
                    style: const TextStyle(fontWeight: FontWeight.w500),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) return 'Nama wajib diisi';
                      if (value.trim().length < 3) return 'Nama minimal 3 karakter';
                      return null;
                    },
                    decoration: _inputDecoration(hint: 'John Doe', icon: Icons.person_outline_rounded),
                  ),
                  const SizedBox(height: 20),

                  // ======================= INPUT EMAIL =======================
                  Text('Email Aktif', style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Colors.grey.shade700)),
                  const SizedBox(height: 8),
                  TextFormField(
                    controller: _emailController,
                    keyboardType: TextInputType.emailAddress,
                    style: const TextStyle(fontWeight: FontWeight.w500),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) return 'Email wajib diisi';
                      if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
                        return 'Format email tidak valid';
                      }
                      return null;
                    },
                    decoration: _inputDecoration(hint: 'contoh@gmail.com', icon: Icons.email_outlined),
                  ),
                  const SizedBox(height: 20),

                  // ======================= DROPDOWN ZONASI =======================
                  Text('Wilayah / Kelurahan Anda', style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Colors.grey.shade700)),
                  const SizedBox(height: 8),
                  _isLoadingWilayah
                      ? const Center(child: CircularProgressIndicator(color: Colors.green))
                      : DropdownButtonFormField<String>(
                          value: _selectedWilayahId,
                          icon: Icon(Icons.keyboard_arrow_down_rounded, color: Colors.green.shade700),
                          validator: (value) => value == null ? 'Pilih domisili Anda terlebih dahulu' : null,
                          decoration: _inputDecoration(hint: 'Pilih lokasi...', icon: Icons.map_outlined),
                          items: _wilayahList.map((wilayah) {
                            return DropdownMenuItem<String>(
                              value: wilayah['id'].toString(),
                              child: Text(wilayah['name'], style: const TextStyle(fontWeight: FontWeight.w500)),
                            );
                          }).toList(),
                          onChanged: (value) {
                            setState(() {
                              _selectedWilayahId = value;
                            });
                          },
                        ),
                  const SizedBox(height: 20),

                  // ======================= INPUT DETAIL ALAMAT =======================
                  Text('Detail Alamat Rumah', style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Colors.grey.shade700)),
                  const SizedBox(height: 8),
                  TextFormField(
                    controller: _addressController,
                    keyboardType: TextInputType.streetAddress,
                    style: const TextStyle(fontWeight: FontWeight.w500),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) return 'Alamat detail wajib diisi';
                      return null;
                    },
                    decoration: _inputDecoration(hint: 'Jl. Contoh No. 12, RT/RW...', icon: Icons.home_outlined),
                  ),
                  const SizedBox(height: 20),

                  // ======================= INPUT PASSWORD =======================
                  Text('Buat Password', style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Colors.grey.shade700)),
                  const SizedBox(height: 8),
                  TextFormField(
                    controller: _passwordController,
                    obscureText: !_isPasswordVisible,
                    style: const TextStyle(fontWeight: FontWeight.w500),
                    validator: (value) {
                      if (value == null || value.isEmpty) return 'Password wajib diisi';
                      if (value.length < 8) return 'Password minimal 8 karakter';
                      return null;
                    },
                    decoration: _inputDecoration(hint: 'Minimal 8 karakter', icon: Icons.lock_outline_rounded).copyWith(
                      suffixIcon: IconButton(
                        icon: Icon(_isPasswordVisible ? Icons.visibility_rounded : Icons.visibility_off_rounded, color: Colors.grey.shade500),
                        onPressed: () => setState(() => _isPasswordVisible = !_isPasswordVisible),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),

                  // ======================= KONFIRMASI PASSWORD =======================
                  Text('Konfirmasi Password', style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Colors.grey.shade700)),
                  const SizedBox(height: 8),
                  TextFormField(
                    controller: _passwordConfirmController,
                    obscureText: !_isConfirmPasswordVisible,
                    style: const TextStyle(fontWeight: FontWeight.w500),
                    validator: (value) {
                      if (value == null || value.isEmpty) return 'Konfirmasi password wajib diisi';
                      if (value != _passwordController.text) return 'Password tidak cocok';
                      return null;
                    },
                    decoration: _inputDecoration(hint: 'Ulangi password di atas', icon: Icons.lock_outline_rounded).copyWith(
                      suffixIcon: IconButton(
                        icon: Icon(_isConfirmPasswordVisible ? Icons.visibility_rounded : Icons.visibility_off_rounded, color: Colors.grey.shade500),
                        onPressed: () => setState(() => _isConfirmPasswordVisible = !_isConfirmPasswordVisible),
                      ),
                    ),
                  ),
                  const SizedBox(height: 40),

                  // ======================= TOMBOL REGISTER =======================
                  Container(
                    height: 56,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [BoxShadow(color: Colors.green.withOpacity(0.3), blurRadius: 12, offset: const Offset(0, 6))],
                    ),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green.shade600,
                        elevation: 0,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                      ),
                      onPressed: _isLoading ? null : _register,
                      child: _isLoading
                          ? const SizedBox(height: 24, width: 24, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 3))
                          : const Text(
                              'Daftar Sekarang',
                              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white, letterSpacing: 0.5),
                            ),
                    ),
                  ),

                  const SizedBox(height: 24),
                  Text(
                    'Dengan mendaftar, Anda menyetujui Syarat & Ketentuan dari Toba Bersih.',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 12, color: Colors.grey.shade500),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  // 🔥 Helper untuk merapikan desain input
  InputDecoration _inputDecoration({required String hint, required IconData icon}) {
    return InputDecoration(
      hintText: hint,
      hintStyle: TextStyle(color: Colors.grey.shade400),
      filled: true,
      fillColor: Colors.grey.shade50,
      prefixIcon: Icon(icon, color: Colors.green.shade600),
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide.none),
      focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide(color: Colors.green.shade500, width: 2)),
      errorBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide(color: Colors.red.shade300, width: 1.5)),
      focusedErrorBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide(color: Colors.red.shade600, width: 2)),
      contentPadding: const EdgeInsets.symmetric(vertical: 18),
    );
  }
}