import 'package:flutter/material.dart';

class ReportDetailScreen extends StatelessWidget {
  final Map<String, dynamic> reportData;

  const ReportDetailScreen({super.key, required this.reportData});

  @override
  Widget build(BuildContext context) {
    final String status = reportData['status'] ?? 'PENDING';
    
    bool step1 = true; 
    bool step2 = status == 'DIPROSES' || status == 'DITINDAKLANJUTI' || status == 'SELESAI';
    bool step3 = status == 'SELESAI';

    String formattedDate = "Waktu tidak diketahui";
    if (reportData['createdAt'] != null) {
      DateTime dt = DateTime.parse(reportData['createdAt']).toLocal();
      List<String> months = ['Jan', 'Feb', 'Mar', 'Apr', 'Mei', 'Jun', 'Jul', 'Agu', 'Sep', 'Okt', 'Nov', 'Des'];
      formattedDate = "${dt.day.toString().padLeft(2,'0')} ${months[dt.month - 1]} ${dt.year}, ${dt.hour.toString().padLeft(2,'0')}:${dt.minute.toString().padLeft(2,'0')} WIB";
    }

    String statusLabel = 'Dilaporkan';
    Color statusColor = Colors.blue.shade600;
    if (status == 'DIPROSES' || status == 'DITINDAKLANJUTI') { 
      statusLabel = 'Diproses'; 
      statusColor = Colors.orange.shade700; 
    }
    if (status == 'SELESAI') { 
      statusLabel = 'Selesai'; 
      statusColor = Colors.green.shade600; 
    }

    String jenisSampah = reportData['jenisSampah'] ?? 'Laporan Umum';
    jenisSampah = jenisSampah.replaceAll('_', ' ');

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        foregroundColor: Colors.black87,
        title: const Text('Detail Laporan', style: TextStyle(fontWeight: FontWeight.w900, fontSize: 18)),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Gambar Hero dengan Shadow melayang
            Hero(
              tag: 'report_image_${reportData['id']}',
              child: Container(
                width: double.infinity,
                height: 260,
                margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(24),
                  color: Colors.grey.shade100,
                  boxShadow: [
                    BoxShadow(color: Colors.black.withOpacity(0.08), blurRadius: 20, offset: const Offset(0, 10)),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(24),
                  child: reportData['photoUrl'] != null && reportData['photoUrl'].toString().isNotEmpty
                      ? Image.network(reportData['photoUrl'], fit: BoxFit.cover)
                      : Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.image_not_supported_rounded, size: 60, color: Colors.grey.shade400),
                            const SizedBox(height: 8),
                            Text("Foto tidak tersedia", style: TextStyle(color: Colors.grey.shade500, fontWeight: FontWeight.w600)),
                          ],
                        ),
                ),
              ),
            ),

            Padding(
              padding: const EdgeInsets.fromLTRB(24, 24, 24, 40),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Badge Status & ID
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        decoration: BoxDecoration(
                          color: statusColor.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(30),
                        ),
                        child: Row(
                          children: [
                            Icon(Icons.circle, size: 10, color: statusColor),
                            const SizedBox(width: 8),
                            Text(
                              statusLabel.toUpperCase(),
                              style: TextStyle(color: statusColor, fontSize: 12, fontWeight: FontWeight.w900, letterSpacing: 0.5),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(color: Colors.grey.shade100, borderRadius: BorderRadius.circular(8)),
                        child: Text(
                          'ID #${reportData['id'].toString().padLeft(5, '0')}',
                          style: TextStyle(color: Colors.grey.shade700, fontSize: 12, fontWeight: FontWeight.w900),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),

                  // Jenis Sampah & Deskripsi
                  Text(
                    jenisSampah,
                    style: TextStyle(fontSize: 13, fontWeight: FontWeight.w900, color: Colors.green.shade700, letterSpacing: 0.5),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    reportData['description'] ?? 'Tidak ada deskripsi rinci dari pelapor.',
                    style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, height: 1.4, color: Colors.black87),
                  ),
                  const SizedBox(height: 24),

                  // Card Informasi (Tanggal & GPS)
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: Colors.grey.shade200),
                      boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 10, offset: const Offset(0, 4))]
                    ),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(color: Colors.blue.shade50, shape: BoxShape.circle),
                              child: Icon(Icons.calendar_month_rounded, size: 20, color: Colors.blue.shade600),
                            ),
                            const SizedBox(width: 16),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Waktu Laporan', style: TextStyle(color: Colors.grey.shade500, fontSize: 12, fontWeight: FontWeight.w600)),
                                const SizedBox(height: 2),
                                Text(formattedDate, style: TextStyle(color: Colors.black87, fontSize: 14, fontWeight: FontWeight.w800)),
                              ],
                            ),
                          ],
                        ),
                        const Padding(
                          padding: EdgeInsets.symmetric(vertical: 16),
                          child: Divider(height: 1),
                        ),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(color: Colors.red.shade50, shape: BoxShape.circle),
                              child: Icon(Icons.location_on_rounded, size: 20, color: Colors.red.shade600),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('Titik Koordinat', style: TextStyle(color: Colors.grey.shade500, fontSize: 12, fontWeight: FontWeight.w600)),
                                  const SizedBox(height: 2),
                                  Text(
                                    '${reportData['latitude'] ?? '-'}, ${reportData['longitude'] ?? '-'}',
                                    style: const TextStyle(color: Colors.black87, fontSize: 14, fontWeight: FontWeight.w800),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  
                  const SizedBox(height: 36),

                  // Lacak Progress Timeline
                  const Text(
                    'Riwayat Penanganan',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w900),
                  ),
                  const SizedBox(height: 24),

                  _buildTimelineItem(
                    isFirst: true, 
                    isDone: step1, 
                    isActive: status == 'PENDING',
                    icon: Icons.assignment_turned_in_rounded, 
                    title: 'Laporan Diterima', 
                    subtitle: 'Laporan berhasil masuk ke sistem Toba Bersih',
                  ),
                  
                  _buildTimelineItem(
                    isDone: step2, 
                    isActive: status == 'DIPROSES' || status == 'DITINDAKLANJUTI',
                    icon: Icons.local_shipping_rounded, 
                    title: 'Sedang Ditindaklanjuti', 
                    subtitle: step2 
                      ? 'Petugas kebersihan sedang memproses laporan Anda' 
                      : 'Menunggu penjadwalan petugas',
                  ),
                  
                  _buildTimelineItem(
                    isLast: true, 
                    isDone: step3, 
                    isActive: status == 'SELESAI',
                    icon: Icons.check_circle_rounded, 
                    title: 'Laporan Selesai', 
                    subtitle: step3 
                      ? 'Tumpukan sampah / masalah telah berhasil diatasi!' 
                      : 'Menunggu penanganan selesai sepenuhnya',
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // WIDGET KUSTOM TIMELINE PROGRESS
  Widget _buildTimelineItem({
    bool isFirst = false,
    bool isLast = false,
    required bool isDone,
    required bool isActive,
    required IconData icon,
    required String title,
    required String subtitle,
  }) {
    Color primaryColor = Colors.green.shade600;
    
    Color iconBgColor = isActive ? primaryColor.withOpacity(0.15) : (isDone ? primaryColor : Colors.grey.shade100);
    Color iconColor = isActive ? primaryColor : (isDone ? Colors.white : Colors.grey.shade400);
    Color lineColor = isDone && !isLast ? primaryColor : Colors.grey.shade200;
    Color titleColor = isActive || isDone ? Colors.black87 : Colors.grey.shade500;

    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Garis & Ikon
          SizedBox(
            width: 50,
            child: Column(
              children: [
                Expanded(flex: 1, child: Container(width: 3, color: isFirst ? Colors.transparent : lineColor)),
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: iconBgColor,
                    shape: BoxShape.circle,
                    border: isActive ? Border.all(color: primaryColor, width: 2.5) : null,
                  ),
                  child: Icon(icon, color: iconColor, size: 20),
                ),
                Expanded(flex: 3, child: Container(width: 3, color: isLast ? Colors.transparent : lineColor)),
              ],
            ),
          ),
          const SizedBox(width: 16),
          
          // Teks Judul & Subjudul
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(top: 10.0, bottom: 32.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: TextStyle(fontSize: 16, fontWeight: FontWeight.w900, color: titleColor)),
                  const SizedBox(height: 6),
                  Text(
                    subtitle, 
                    style: TextStyle(
                      fontSize: 13, 
                      height: 1.4,
                      color: isActive ? primaryColor : Colors.grey.shade500,
                      fontWeight: isActive ? FontWeight.w700 : FontWeight.w500
                    )
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