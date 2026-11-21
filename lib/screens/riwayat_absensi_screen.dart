import 'dart:math' as math;
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:printing/printing.dart';
import '../services/absensi_pdf_service.dart';

class RiwayatAbsensiScreen extends StatefulWidget {
  final String nama;

  const RiwayatAbsensiScreen({
    super.key,
    this.nama = 'Belinda Blance',
  });

  @override
  State<RiwayatAbsensiScreen> createState() => _RiwayatAbsensiScreenState();
}

class _RiwayatAbsensiScreenState extends State<RiwayatAbsensiScreen> {
  // Data Tabel Sesuai Gambar 3
  final List<Map<String, dynamic>> riwayatTable = [
    {
      'no': 1,
      'hari': 'Selasa',
      'tanggal': '2026-10-06',
      'status': 'terlambat',
      'lokasi': 'Karawang',
      'absenMasuk': '13:12:20',
      'absenPulang': '15:44:32',
      'jamMasuk': '07:00:00',
      'jamPulang': '16:00:00',
    },
    {
      'no': 2,
      'hari': 'Rabu',
      'tanggal': '2026-10-06',
      'status': 'terlambat',
      'lokasi': 'Karawang',
      'absenMasuk': '13:12:20',
      'absenPulang': '15:44:32',
      'jamMasuk': '07:00:00',
      'jamPulang': '16:00:00',
    },
    {
      'no': 2,
      'hari': 'Rabu',
      'tanggal': '2026-10-06',
      'status': 'terlambat',
      'lokasi': 'Karawang',
      'absenMasuk': '13:12:20',
      'absenPulang': '15:44:32',
      'jamMasuk': '07:00:00',
      'jamPulang': '16:00:00',
    },
    {
      'no': 2,
      'hari': 'Rabu',
      'tanggal': '2026-10-06',
      'status': 'terlambat',
      'lokasi': 'Karawang',
      'absenMasuk': '13:12:20',
      'absenPulang': '15:44:32',
      'jamMasuk': '07:00:00',
      'jamPulang': '16:00:00',
    },
  ];

  bool _isPrinting = false;

  Future<void> _cetakLaporanPdf() async {
    setState(() => _isPrinting = true);
    try {
      final pdfBytes = await AbsensiPdfService.generatePdf();
      await Printing.sharePdf(
        bytes: Uint8List.fromList(pdfBytes),
        filename: 'Laporan_Kehadiran_Guru_Oktober_2026.pdf',
      );
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Gagal mencetak PDF: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _isPrinting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFAFBF8),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 1. BAGIAN ATAS: HEADER HIJAU MELENGKUNG DENGAN TOMBOL CETAK
            _buildHeader(context),

            const SizedBox(height: 20),

            // 2. BAGIAN TENGAH / ISI: TABEL RIWAYAT & STATISTIK ABSENSI (DONUT CHART)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // SUBJUDUL: Daftar riwayat sejajar dengan Tombol Cetak
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Daftar riwayat',
                        style: TextStyle(
                          fontFamily: 'Plus Jakarta Sans',
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF263023),
                        ),
                      ),
                      // Tombol Cetak PDF Sejajar
                      Container(
                        height: 36,
                        decoration: BoxDecoration(
                          color: const Color(0xFFAAB881),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: TextButton.icon(
                          onPressed: _isPrinting ? null : _cetakLaporanPdf,
                          style: TextButton.styleFrom(
                            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 0),
                          ),
                          icon: _isPrinting
                              ? const SizedBox(
                                  width: 14,
                                  height: 14,
                                  child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                                )
                              : const Icon(Icons.print_outlined, size: 18, color: Colors.white),
                          label: const Text(
                            'Cetak',
                            style: TextStyle(
                              fontFamily: 'Plus Jakarta Sans',
                              fontSize: 13,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 12),

                  // TABEL DAFTAR RIWAYAT (BISA SCROLL KESAMPING & KEBAWAH - GAMBAR 2 & 3)
                  _buildTabelRiwayat(),

                  const SizedBox(height: 28),

                  // SUBJUDUL: Statistik absensi
                  const Text(
                    'Statistik absensi',
                    style: TextStyle(
                      fontFamily: 'Plus Jakarta Sans',
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF263023),
                    ),
                  ),

                  const SizedBox(height: 8),

                  Text(
                    widget.nama,
                    style: const TextStyle(
                      fontFamily: 'Plus Jakarta Sans',
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1F2937),
                    ),
                  ),

                  const SizedBox(height: 16),

                  // DONUT CHART STATISTIK ABSENSI (GAMBAR 2)
                  Center(
                    child: _buildDonutChart(),
                  ),

                  const SizedBox(height: 20),

                  // LEGENDA / KETERANGAN WARNA DONUT CHART
                  _buildChartLegend(),

                  const SizedBox(height: 36),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ============================================================================
  // 1. HEADER ATAS (HIJAU GRADASI DENGAN TOMBOL BACK & TOMBOL CETAK)
  // ============================================================================
  Widget _buildHeader(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.only(top: 16, left: 20, right: 20, bottom: 26),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFFB5C384), Color(0xFF7A8B58)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(32),
          bottomRight: Radius.circular(32),
        ),
      ),
      child: SafeArea(
        bottom: false,
        child: Column(
          children: [
            // Header Bar dengan tombol back, judul, dan tombol Cetak
            Row(
            children: [
              GestureDetector(
                onTap: () => Navigator.pop(context),
                child: Image.asset(
                  'assets/icons/icon_back_untuk_header.png',
                  width: 38,
                  height: 38,
                  errorBuilder: (context, error, stackTrace) => Container(
                    width: 38,
                    height: 38,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Icon(Icons.chevron_left, color: Colors.white, size: 24),
                  ),
                ),
              ),
              const Expanded(
                child: Text(
                  'Riwayat\nAbsensi Guru',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: 'Plus Jakarta Sans',
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    height: 1.25,
                  ),
                ),
              ),
              const SizedBox(width: 38), // Counterbalance tombol back
            ],
          ),
        ],
      ),
    ),
    );
  }

  // ============================================================================
  // 2. TABEL RIWAYAT (BISA DI-SCROLL KESAMPING & KEBAWAH - GAMBAR 2 & 3)
  // Header: Warna AAB881, Teks Hitam/Bold dengan panah sort
  // Border: Border.all Color DFE4D5 / Radius 16
  // ============================================================================
  Widget _buildTabelRiwayat() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFDFE4D5), width: 1.2),
      ),
      clipBehavior: Clip.antiAlias,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: DataTable(
          headingRowHeight: 44,
          dataRowMinHeight: 44,
          dataRowMaxHeight: 44,
          horizontalMargin: 16,
          columnSpacing: 26,
          headingRowColor: MaterialStateProperty.all(const Color(0xFFAAB881)),
          columns: const [
            DataColumn(
              label: Row(
                children: [
                  Text('No', style: TextStyle(fontFamily: 'Plus Jakarta Sans', fontWeight: FontWeight.bold, fontSize: 13, color: Colors.black)),
                  SizedBox(width: 4),
                  Icon(Icons.arrow_upward, size: 12, color: Colors.black87),
                ],
              ),
            ),
            DataColumn(
              label: Row(
                children: [
                  Text('Hari', style: TextStyle(fontFamily: 'Plus Jakarta Sans', fontWeight: FontWeight.bold, fontSize: 13, color: Colors.black)),
                  SizedBox(width: 4),
                  Icon(Icons.arrow_upward, size: 12, color: Colors.black87),
                ],
              ),
            ),
            DataColumn(label: Text('Tanggal', style: TextStyle(fontFamily: 'Plus Jakarta Sans', fontWeight: FontWeight.bold, fontSize: 13, color: Colors.black))),
            DataColumn(label: Text('Status', style: TextStyle(fontFamily: 'Plus Jakarta Sans', fontWeight: FontWeight.bold, fontSize: 13, color: Colors.black))),
            DataColumn(label: Text('Lokasi', style: TextStyle(fontFamily: 'Plus Jakarta Sans', fontWeight: FontWeight.bold, fontSize: 13, color: Colors.black))),
            DataColumn(label: Text('Absensi Masuk', style: TextStyle(fontFamily: 'Plus Jakarta Sans', fontWeight: FontWeight.bold, fontSize: 13, color: Colors.black))),
            DataColumn(label: Text('Absensi Pulang', style: TextStyle(fontFamily: 'Plus Jakarta Sans', fontWeight: FontWeight.bold, fontSize: 13, color: Colors.black))),
            DataColumn(label: Text('Jam Masuk', style: TextStyle(fontFamily: 'Plus Jakarta Sans', fontWeight: FontWeight.bold, fontSize: 13, color: Colors.black))),
            DataColumn(label: Text('Jam Pulang', style: TextStyle(fontFamily: 'Plus Jakarta Sans', fontWeight: FontWeight.bold, fontSize: 13, color: Colors.black))),
          ],
          rows: riwayatTable.map((row) {
            return DataRow(
              cells: [
                DataCell(Text('${row['no']}', style: const TextStyle(fontFamily: 'Plus Jakarta Sans', fontSize: 12.5, color: Color(0xFF263023)))),
                DataCell(Text('${row['hari']}', style: const TextStyle(fontFamily: 'Plus Jakarta Sans', fontSize: 12.5, color: Color(0xFF263023)))),
                DataCell(Text('${row['tanggal']}', style: const TextStyle(fontFamily: 'Plus Jakarta Sans', fontSize: 12.5, color: Color(0xFF263023)))),
                DataCell(Text('${row['status']}', style: const TextStyle(fontFamily: 'Plus Jakarta Sans', fontSize: 12.5, color: Color(0xFF263023)))),
                DataCell(Text('${row['lokasi']}', style: const TextStyle(fontFamily: 'Plus Jakarta Sans', fontSize: 12.5, color: Color(0xFF263023)))),
                DataCell(Text('${row['absenMasuk']}', style: const TextStyle(fontFamily: 'Plus Jakarta Sans', fontSize: 12.5, color: Color(0xFF263023)))),
                DataCell(Text('${row['absenPulang']}', style: const TextStyle(fontFamily: 'Plus Jakarta Sans', fontSize: 12.5, color: Color(0xFF263023)))),
                DataCell(Text('${row['jamMasuk']}', style: const TextStyle(fontFamily: 'Plus Jakarta Sans', fontSize: 12.5, color: Color(0xFF263023)))),
                DataCell(Text('${row['jamPulang']}', style: const TextStyle(fontFamily: 'Plus Jakarta Sans', fontSize: 12.5, color: Color(0xFF263023)))),
              ],
            );
          }).toList(),
        ),
      ),
    );
  }

  // ============================================================================
  // 3. DONUT CHART STATISTIK ABSENSI (GAMBAR 2)
  // Total: 300
  // Tepat Waktu: 93 (Biru #6B88FE), Terlambat: 85 (Hijau #63CE96), Sakit: 53 (Oranye #FFA848),
  // Izin: 43 (Cyan #00E1FD), Tanpa Keterangan: 26 (Ungu Muda #8F7DFD)
  // ============================================================================
  Widget _buildDonutChart() {
    return SizedBox(
      width: 220,
      height: 220,
      child: Stack(
        alignment: Alignment.center,
        children: [
          CustomPaint(
            size: const Size(220, 220),
            painter: _DonutChartPainter(
              data: [
                _DonutSlice(value: 93, color: const Color(0xFF6B88FE)),
                _DonutSlice(value: 85, color: const Color(0xFF63CE96)),
                _DonutSlice(value: 53, color: const Color(0xFFFFA848)),
                _DonutSlice(value: 43, color: const Color(0xFF00E1FD)),
                _DonutSlice(value: 26, color: const Color(0xFF8F7DFD)),
              ],
            ),
          ),
          // Lingkaran Putih di Tengah
          Container(
            width: 86,
            height: 86,
            decoration: const BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                Text(
                  'Total',
                  style: TextStyle(
                    fontFamily: 'Plus Jakarta Sans',
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: Color(0xFF4B5563),
                  ),
                ),
                Text(
                  '300',
                  style: TextStyle(
                    fontFamily: 'Plus Jakarta Sans',
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1F2937),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================================
  // 4. LEGENDA WARNA
  // ============================================================================
  Widget _buildChartLegend() {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _legendItem(const Color(0xFF6B88FE), 'Tepat Waktu'),
            const SizedBox(width: 14),
            _legendItem(const Color(0xFF63CE96), 'Terlambat'),
            const SizedBox(width: 14),
            _legendItem(const Color(0xFFFFA848), 'Sakit'),
            const SizedBox(width: 14),
            _legendItem(const Color(0xFF00E1FD), 'Izin'),
          ],
        ),
        const SizedBox(height: 10),
        Center(
          child: _legendItem(const Color(0xFF8F7DFD), 'Tanpa Keterangan'),
        ),
      ],
    );
  }

  Widget _legendItem(Color color, String text) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 10,
          height: 10,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: 6),
        Text(
          text,
          style: const TextStyle(
            fontFamily: 'Plus Jakarta Sans',
            fontSize: 11.5,
            color: Color(0xFF4B5563),
          ),
        ),
      ],
    );
  }
}

// ============================================================================
// CUSTOM PAINTER: DONUT CHART DENGAN TEKS ANGKA DI TENGAH IRISAN
// ============================================================================
class _DonutSlice {
  final double value;
  final Color color;
  const _DonutSlice({required this.value, required this.color});
}

class _DonutChartPainter extends CustomPainter {
  final List<_DonutSlice> data;

  _DonutChartPainter({required this.data});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;
    const strokeWidth = 66.0;

    final double total = data.fold(0, (sum, slice) => sum + slice.value);
    double startAngle = -math.pi / 2;

    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth;

    for (final slice in data) {
      final sweepAngle = (slice.value / total) * 2 * math.pi;

      paint.color = slice.color;
      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius - strokeWidth / 2),
        startAngle,
        sweepAngle,
        false,
        paint,
      );

      // Gambar Teks Angka di tengah-tengah irisan
      final midAngle = startAngle + sweepAngle / 2;
      final textRadius = radius - strokeWidth / 2;
      final textPos = Offset(
        center.dx + textRadius * math.cos(midAngle),
        center.dy + textRadius * math.sin(midAngle),
      );

      final textSpan = TextSpan(
        text: '${slice.value.toInt()}',
        style: const TextStyle(
          color: Color(0xFF1E2419),
          fontSize: 11,
          fontWeight: FontWeight.bold,
          fontFamily: 'Plus Jakarta Sans',
        ),
      );
      final textPainter = TextPainter(
        text: textSpan,
        textDirection: TextDirection.ltr,
      );
      textPainter.layout();
      textPainter.paint(
        canvas,
        Offset(textPos.dx - textPainter.width / 2, textPos.dy - textPainter.height / 2),
      );

      startAngle += sweepAngle;
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
