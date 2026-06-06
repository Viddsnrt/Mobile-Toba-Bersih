import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:geolocator/geolocator.dart';
import 'dart:async';
import 'dart:io'; 
import 'package:image_picker/image_picker.dart'; 
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:http/http.dart' as http; 
import 'dart:convert'; 

class DriverMapScreen extends StatefulWidget {
  final String taskId; 
  final double destinationLat;
  final double destinationLng;
  final String destinationName;
  final String taskType;

  const DriverMapScreen({
    super.key,
    required this.taskId, 
    required this.destinationLat,
    required this.destinationLng,
    required this.destinationName,
    required this.taskType,
  });

  @override
  State<DriverMapScreen> createState() => _DriverMapScreenState();
}

class _DriverMapScreenState extends State<DriverMapScreen> {
  final MapController _mapController = MapController();
  final ImagePicker _picker = ImagePicker(); 

  LatLng? _currentDriverPos;
  StreamSubscription<Position>? _positionStream;
  double _distanceToTarget = 9999.0; 
  bool _isWithinRadius = false;
  final double _allowedRadiusInMeters = 50.0; 

  // 🔥 STATE BARU: Menampung banyak foto bukti
  List<XFile> _buktiFotoList = []; 

  IO.Socket? socket;
  final String ipAddress = '10.107.61.195'; 

  @override
  void initState() {
    super.initState();
    _initSocket();
    _startLocationTracking();
  }

  void _initSocket() {
    socket = IO.io('http://$ipAddress:5000', <String, dynamic>{
      'transports': ['websocket'],
      'autoConnect': false,
    });

    socket!.connect();
    socket!.onConnect(
      (_) => debugPrint('🔌 [Supir] Terhubung ke WebSocket Server!'),
    );
  }

  Future<void> _startLocationTracking() async {
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied ||
        permission == LocationPermission.deniedForever) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Izin lokasi diperlukan untuk navigasi.')),
        );
      }
      return;
    }

    Position initialPos = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );

    if (mounted) {
      setState(() {
        _currentDriverPos = LatLng(initialPos.latitude, initialPos.longitude);
        _calculateDistance();
      });
      _mapController.move(_currentDriverPos!, 16.0);
    }

    const LocationSettings locationSettings = LocationSettings(
      accuracy: LocationAccuracy.high,
      distanceFilter: 5, 
    );

    _positionStream = Geolocator.getPositionStream(
      locationSettings: locationSettings,
    ).listen((Position position) {
      if (mounted) {
        setState(() {
          _currentDriverPos = LatLng(position.latitude, position.longitude);
          _calculateDistance();
          _mapController.move(_currentDriverPos!, _mapController.camera.zoom);

          if (socket != null && socket!.connected) {
            socket!.emit('driver_location_update', {
              'driverId': '2', 
              'latitude': position.latitude,
              'longitude': position.longitude,
            });
          }
        });
      }
    });
  }

  void _calculateDistance() {
    if (_currentDriverPos == null) return;
    _distanceToTarget = Geolocator.distanceBetween(
      _currentDriverPos!.latitude,
      _currentDriverPos!.longitude,
      widget.destinationLat,
      widget.destinationLng,
    );
    _isWithinRadius = _distanceToTarget <= _allowedRadiusInMeters;
  }

  // 🔥 FUNGSI BARU: Membuka Kamera Langsung & Membatasi Resolusi (Anti-Lag)
  Future<void> _ambilFotoBukti() async {
    try {
      final XFile? foto = await _picker.pickImage(
        source: ImageSource.camera, 
        imageQuality: 70,           // Kompresi kualitas gambar agar hemat storage
        maxWidth: 1024,             // Batasi lebar resolusi (Kunci anti-lag RAM HP)
        maxHeight: 1024,            // Batasi tinggi resolusi
      );

      if (foto != null) {
        setState(() {
          _buktiFotoList.add(foto); // Masukkan foto ke dalam daftar list
        });
      }
    } catch (e) {
      debugPrint("Error mengambil foto: $e");
    }
  }

  // 🔥 FUNGSI BARU: Mengirimkan Semua Bukti Foto Bersamaan ke Backend
  Future<void> _kirimTugasSelesai() async {
    if (_buktiFotoList.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Wajib mengambil minimal 1 foto bukti tumpukan sampah sebelum menyelesaikan tugas!'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    try {
      // Tampilkan Loading Dialog
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => const Center(
          child: CircularProgressIndicator(color: Colors.green),
        ),
      );

      var uri = Uri.parse('http://$ipAddress:5000/api/penugasan/${widget.taskId}/status');
      var request = http.MultipartRequest('PATCH', uri);

      request.fields['status'] = 'SELESAI';

      // 🔥 LOOPING MULTIPART: Masukkan seluruh foto yang ada di list ke field request 'photos'
      for (var foto in _buktiFotoList) {
        var multipartFile = await http.MultipartFile.fromPath('photos', foto.path);
        request.files.add(multipartFile);
      }

      var streamedResponse = await request.send().timeout(const Duration(seconds: 45)); 
      var response = await http.Response.fromStream(streamedResponse);
      
      if (!mounted) return;
      Navigator.pop(context); // Tutup Loading

      if (response.statusCode == 200) {
        Navigator.pop(context, true); // Kembali ke list tugas & trigger refresh data
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Tugas Selesai & Seluruh Bukti Foto Berhasil Diunggah!'),
            backgroundColor: Colors.green,
          ),
        );
      } else {
        final Map<String, dynamic> data = jsonDecode(response.body);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Gagal: ${data['message']}'), backgroundColor: Colors.red),
        );
      }
    } catch (e) {
      if (!mounted) return;
      Navigator.pop(context); 
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error jaringan backend: $e'), backgroundColor: Colors.red),
      );
    }
  }

  @override
  void dispose() {
    _positionStream?.cancel(); 
    socket?.disconnect(); 
    socket?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final destination = LatLng(widget.destinationLat, widget.destinationLng);
    final bool isAduan = widget.taskType == 'ADUAN';
    final Color themeColor = isAduan ? Colors.orange.shade700 : Colors.indigo.shade600;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Navigasi Tugas', style: TextStyle(fontWeight: FontWeight.w900, fontSize: 18)),
        backgroundColor: themeColor,
        foregroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
      ),
      body: Stack(
        children: [
          FlutterMap(
            mapController: _mapController,
            options: MapOptions(
              initialCenter: _currentDriverPos ?? destination,
              initialZoom: 15.0,
            ),
            children: [
              TileLayer(
                urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                userAgentPackageName: 'com.example.toba_bersih',
              ),
              CircleLayer(
                circles: [
                  CircleMarker(
                    point: destination,
                    color: themeColor.withOpacity(0.2),
                    borderColor: themeColor.withOpacity(0.5),
                    borderStrokeWidth: 2,
                    radius: _allowedRadiusInMeters, 
                    useRadiusInMeter: true,
                  ),
                ],
              ),
              MarkerLayer(
                markers: [
                  Marker(
                    point: destination,
                    width: 80,
                    height: 80,
                    child: Column(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(8),
                            boxShadow: const [BoxShadow(color: Colors.black26, blurRadius: 4)],
                          ),
                          child: const Text('Tujuan', style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold)),
                        ),
                        Icon(Icons.location_on_rounded, color: themeColor, size: 40),
                      ],
                    ),
                  ),
                  if (_currentDriverPos != null)
                    Marker(
                      point: _currentDriverPos!,
                      width: 60,
                      height: 60,
                      child: Column(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(4),
                            decoration: const BoxDecoration(
                              color: Colors.white,
                              shape: BoxShape.circle,
                              boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 4)],
                            ),
                            child: const Icon(Icons.drive_eta_rounded, color: Colors.blue, size: 24),
                          ),
                        ],
                      ),
                    ),
                ],
              ),
            ],
          ),

          // PANEL MONITORING BAWAH
          Positioned(
            bottom: 0, left: 0, right: 0,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(topLeft: Radius.circular(32), topRight: Radius.circular(32)),
                boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 20, offset: Offset(0, -5))],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 40, height: 5,
                    decoration: BoxDecoration(color: Colors.grey.shade300, borderRadius: BorderRadius.circular(10)),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(color: themeColor.withOpacity(0.1), borderRadius: BorderRadius.circular(16)),
                        child: Icon(isAduan ? Icons.warning_rounded : Icons.route_rounded, color: themeColor, size: 28),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              isAduan ? 'Menuju Lokasi Aduan' : 'Menuju Rute Rutin',
                              style: TextStyle(fontSize: 13, fontWeight: FontWeight.w900, color: themeColor, letterSpacing: 0.5),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              widget.destinationName,
                              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w900, color: Colors.black87),
                            ),
                            const SizedBox(height: 6),
                            Row(
                              children: [
                                Icon(
                                  _isWithinRadius ? Icons.check_circle_rounded : Icons.social_distance_rounded,
                                  size: 16,
                                  color: _isWithinRadius ? Colors.green.shade600 : Colors.red.shade600,
                                ),
                                const SizedBox(width: 6),
                                Text(
                                  _isWithinRadius ? "Anda sudah tiba di lokasi!" : "Jarak: ${_distanceToTarget.toStringAsFixed(0)} meter lagi",
                                  style: TextStyle(
                                    color: _isWithinRadius ? Colors.green.shade700 : Colors.red.shade700,
                                    fontSize: 13,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),

                  // 🔥 UI PREVIEW DAFTAR FOTO (Muncul secara horizontal jika list tidak kosong)
                  if (_buktiFotoList.isNotEmpty) ...[
                    const Divider(height: 24),
                    SizedBox(
                      height: 85,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: _buktiFotoList.length,
                        itemBuilder: (context, index) {
                          return Stack(
                            children: [
                              Container(
                                margin: const EdgeInsets.only(right: 12),
                                width: 80,
                                height: 80,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(color: Colors.grey.shade300),
                                  image: DecorationImage(
                                    image: FileImage(File(_buktiFotoList[index].path)),
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                              // Tombol X Kecil merah untuk menghapus foto tertentu
                              Positioned(
                                top: 2, right: 14,
                                child: GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      _buktiFotoList.removeAt(index);
                                    });
                                  },
                                  child: const CircleAvatar(
                                    radius: 10,
                                    backgroundColor: Colors.red,
                                    child: Icon(Icons.close_rounded, size: 12, color: Colors.white),
                                  ),
                                ),
                              ),
                            ],
                          );
                        },
                      ),
                    ),
                  ],

                  const SizedBox(height: 20),

                  // 🔥 PANEL INTERAKSI DUA TOMBOL (AMBIL FOTO & SELESAI)
                  Row(
                    children: [
                      // Tombol Kamera (Hanya aktif jika supir sudah berada dalam radius)
                      Expanded(
                        flex: 2,
                        child: SizedBox(
                          height: 54,
                          child: OutlinedButton.icon(
                            style: OutlinedButton.styleFrom(
                              foregroundColor: _isWithinRadius ? Colors.blue.shade700 : Colors.grey.shade400,
                              side: BorderSide(color: _isWithinRadius ? Colors.blue.shade600 : Colors.grey.shade300, width: 2),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                            ),
                            onPressed: _isWithinRadius ? _ambilFotoBukti : null,
                            icon: const Icon(Icons.camera_alt_rounded),
                            label: Text(
                              _buktiFotoList.isEmpty ? "Ambil Foto" : "Foto (${_buktiFotoList.length})",
                              style: const TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      
                      // Tombol Submit Form Penyelesaian Tugas
                      Expanded(
                        flex: 3,
                        child: SizedBox(
                          height: 54,
                          child: ElevatedButton.icon(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: (_isWithinRadius && _buktiFotoList.isNotEmpty) ? Colors.green.shade600 : Colors.grey.shade300,
                              foregroundColor: Colors.white,
                              disabledBackgroundColor: Colors.grey.shade200,
                              disabledForegroundColor: Colors.grey.shade400,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                              elevation: 0,
                            ),
                            onPressed: (_isWithinRadius && _buktiFotoList.isNotEmpty) ? _kirimTugasSelesai : null,
                            icon: Icon(_isWithinRadius ? Icons.check_circle_outline : Icons.lock_rounded),
                            label: const Text(
                              'Selesaikan Tugas',
                              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}