import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:toba_bersih/auth/login_screen.dart';

class SupirHomeScreen extends StatefulWidget {
  final String driverId;
  final String driverName;

  const SupirHomeScreen({
    super.key, 
    this.driverId = 'DRV-001', // Nanti pastikan parameter ini terisi dari login
    this.driverName = 'Pak Supir'
  });

  @override
  State<SupirHomeScreen> createState() => _SupirHomeScreenState();
}

class _SupirHomeScreenState extends State<SupirHomeScreen> {
  bool _isAvailable = true;
  bool _isLoading = true;
  List<dynamic> _tasks = [];

  @override
  void initState() {
    super.initState();
    _fetchTasks();
  }

  // Logic mengambil daftar tugas dari database
  Future<void> _fetchTasks() async {
    setState(() {
      _isLoading = true;
    });

    try {
      var url = Uri.parse('http://10.0.2.2/api/driver/tasks/available');
      var response = await http.get(url);
      var data = jsonDecode(response.body);

      if (response.statusCode == 200 && data['success'] == true) {
        setState(() {
          _tasks = data['data'];
        });
      } else {
        _showError('Gagal mengambil data tugas');
      }
    } catch (e) {
      _showError('Terjadi kesalahan jaringan: $e');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  // Logic mengubah status supir
  Future<void> _updateStatus(bool status) async {
    setState(() {
      _isAvailable = status;
    });

    try {
      var url = Uri.parse('http://10.61.166.195:5000/api/driver/status');
      await http.put(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'driverId': widget.driverId,
          'isAvailable': status,
        }),
      );
    } catch (e) {
      _showError('Gagal mengubah status');
      setState(() {
        _isAvailable = !status; // Kembalikan switch jika gagal
      });
    }
  }

  void _showError(String message) {
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey,
      body: Column(
        children: [
          _buildCustomHeader(),
          Expanded(
            child: _buildTaskList(),
          ),
        ],
      ),
    );
  }

  Widget _buildCustomHeader() {
    return Container(
      padding: const EdgeInsets.only(top: 50, left: 20, right: 20, bottom: 30),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFFE65100), Color(0xFFFF9800)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(30),
          bottomRight: Radius.circular(30),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  const CircleAvatar(
                    radius: 24,
                    backgroundColor: Colors.white,
                    child: Icon(Icons.person, color: Colors.orange, size: 30),
                  ),
                  const SizedBox(width: 15),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Selamat Bertugas,',
                        style: TextStyle(color: Colors.white70, fontSize: 14),
                      ),
                      Text(
                        widget.driverName,
                        style: const TextStyle(
                          color: Colors.white, 
                          fontSize: 20, 
                          fontWeight: FontWeight.bold
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              IconButton(
                icon: const Icon(Icons.logout, color: Colors.white),
                onPressed: () {
                  Navigator.pushReplacement(
                    context, 
                    MaterialPageRoute(builder: (context) => const LoginScreen())
                  );
                },
              )
            ],
          ),
          const SizedBox(height: 25),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(15),
              border: Border.all(color: Colors.white.withOpacity(0.4)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(
                      _isAvailable ? Icons.check_circle : Icons.pause_circle_filled, 
                      color: Colors.white,
                    ),
                    const SizedBox(width: 10),
                    Text(
                      _isAvailable ? 'Truk Siap Menerima Tugas' : 'Truk Sedang Istirahat',
                      style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                Switch(
                  value: _isAvailable,
                  activeColor: Colors.white,
                  activeTrackColor: Colors.green,
                  inactiveThumbColor: Colors.grey,
                  inactiveTrackColor: Colors.grey,
                  onChanged: (value) => _updateStatus(value),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _buildTaskList() {
    if (!_isAvailable) {
      return const Center(
        child: Text(
          'Anda sedang beristirahat.\nAktifkan status untuk melihat tugas.',
          textAlign: TextAlign.center,
          style: TextStyle(color: Colors.grey, fontSize: 16),
        ),
      );
    }

    if (_isLoading) {
      return const Center(child: CircularProgressIndicator(color: Colors.orange));
    }

    if (_tasks.isEmpty) {
      return const Center(
        child: Text('Belum ada tugas laporan baru.', style: TextStyle(color: Colors.grey)),
      );
    }

    return RefreshIndicator(
      onRefresh: _fetchTasks,
      color: Colors.orange,
      child: ListView.builder(
        padding: const EdgeInsets.only(top: 20, left: 16, right: 16),
        itemCount: _tasks.length,
        itemBuilder: (context, index) {
          final task = _tasks[index];
          return _buildTaskCard(task);
        },
      ),
    );
  }

  Widget _buildTaskCard(Map<String, dynamic> task) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.orange.withOpacity(0.08),
            blurRadius: 15,
            offset: const Offset(0, 5),
          )
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.orange,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    task['status'] ?? 'Menunggu',
                    style: TextStyle(color: Colors.orange, fontSize: 12, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 15),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.grey,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(Icons.delete_outline, color: Colors.orange, size: 30),
                ),
                const SizedBox(width: 15),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        task['title'] ?? 'Tanpa Judul',
                        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 5),
                      Row(
                        children: [
                          const Icon(Icons.location_on, color: Colors.grey, size: 14),
                          const SizedBox(width: 4),
                          Expanded(
                            child: Text(
                              'Lat: ${task['latitude']}, Lng: ${task['longitude']}', 
                              style: const TextStyle(color: Colors.grey, fontSize: 13),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 15),
            const Divider(color: Colors.black12),
            const SizedBox(height: 5),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Mengambil tugas...'))
                      );
                    },
                    icon: const Icon(Icons.check_circle, color: Colors.white),
                    label: const Text('Ambil Tugas', style: TextStyle(color: Colors.white)),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.orange,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}