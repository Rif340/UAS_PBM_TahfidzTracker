import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:pdf/pdf.dart';
import 'package:printing/printing.dart';
import '../services/hafalan_siswa_pdf_service.dart';

class DetailSiswaScreen extends StatefulWidget {
  final Map<String, String> siswa;

  const DetailSiswaScreen({
    super.key,
    required this.siswa,
  });

  @override
  State<DetailSiswaScreen> createState() => _DetailSiswaScreenState();
}

class _DetailSiswaScreenState extends State<DetailSiswaScreen> {
  // Tab: true = Data Diri, false = Detail Hafalan
  bool isTabDataDiri = true;

  late String currentNama;
  late String currentInisial;
  String currentNisn = '0001234567';
  String currentKelas = '6';
  String currentRombel = 'A';
  String currentTahunAjaran = '2026/2027';
  String currentStatus = 'Aktif';
  bool _isCetakLoading = false;

  @override
  void initState() {
    super.initState();
    currentNama = widget.siswa['nama'] ?? 'Bilal Hakim';
    currentInisial = widget.siswa['inisial'] ?? 'BH';
  }

  Future<void> _cetakHafalanPdf() async {
    setState(() => _isCetakLoading = true);
    try {
      final pdfBytes = await HafalanSiswaPdfService.generatePdf(
        namaLengkap: currentNama,
        nisn: currentNisn,
        kelas: currentKelas,
        rombel: currentRombel,
        tahunAjaran: currentTahunAjaran,
        pageFormat: PdfPageFormat.a4,
      );
      await Printing.sharePdf(
        bytes: Uint8List.fromList(pdfBytes),
        filename: 'Hafalan_${currentNama.replaceAll(' ', '_')}.pdf',
      );
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Gagal membuat PDF: $e'),
            backgroundColor: Colors.red.shade600,
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _isCetakLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFAFBF8),
      body: Stack(
        children: [
          // KONTEN UTAMA YANG DAPAT DI-SCROLL
          SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 1. BAGIAN ATAS: HEADER HIJAU MELENGKUNG
                _buildHeader(context),

                const SizedBox(height: 20),

                // 2. BAGIAN TENGAH / ISI
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // TAB TOGGLE (Data Diri vs Detail Hafalan)
                      _buildTabToggle(),

                      const SizedBox(height: 20),

                      // KONTEN SESUAI TAB YANG AKTIF
                      if (isTabDataDiri) ...[
                        _buildTabDataDiri(),
                      ] else ...[
                        _buildTabDetailHafalan(),
                      ],

                      // Ruang di bawah agar tidak tertutup sticky footer jika ada
                      const SizedBox(height: 120),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // 3. BAGIAN BAWAH: STICKY FOOTER "Kembali ke Beranda"
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: Container(
              padding: const EdgeInsets.only(left: 24, right: 24, top: 14, bottom: 24),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                    offset: const Offset(0, -4),
                  ),
                ],
              ),
              child: SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: () {
                    // Kembali ke beranda utama
                    Navigator.popUntil(context, (route) => route.isFirst);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFAAB881),
                    foregroundColor: Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  child: const Text(
                    'Kembali ke Beranda',
                    style: TextStyle(
                      fontFamily: 'Plus Jakarta Sans',
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================================
  // 1. HEADER ATAS (HIJAU GRADASI DENGAN BACK BUTTON)
  // ============================================================================
  Widget _buildHeader(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.only(top: 16, left: 24, right: 24, bottom: 28),
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
            // Header Bar dengan tombol back dan Judul
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
                      border: Border.all(color: Colors.white.withOpacity(0.3)),
                    ),
                    child: const Icon(
                      Icons.chevron_left,
                      color: Colors.white,
                      size: 24,
                    ),
                  ),
                ),
              ),
              Expanded(
                child: Text(
                  isTabDataDiri ? 'Detail Murid\nTahfizd' : 'Detail\nData Siswa',
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontFamily: 'Plus Jakarta Sans',
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                    height: 1.25,
                  ),
                ),
              ),
              const SizedBox(width: 38), // Counterbalance icon back
            ],
          ),
        ],
      ),
      ),
    );
  }

  // ============================================================================
  // TAB TOGGLE (Data Diri | Detail Hafalan)
  // ============================================================================
  Widget _buildTabToggle() {
    return Container(
      height: 48,
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: const Color(0xFFF3F5EE),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          // Tab 1: Data Diri
          Expanded(
            child: GestureDetector(
              onTap: () => setState(() => isTabDataDiri = true),
              child: Container(
                decoration: BoxDecoration(
                  color: isTabDataDiri ? Colors.white : Colors.transparent,
                  borderRadius: BorderRadius.circular(9),
                  boxShadow: isTabDataDiri
                      ? [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.04),
                            blurRadius: 4,
                            offset: const Offset(0, 2),
                          ),
                        ]
                      : [],
                ),
                alignment: Alignment.center,
                child: Text(
                  'Data Diri',
                  style: TextStyle(
                    fontFamily: 'Plus Jakarta Sans',
                    fontSize: 13,
                    fontWeight: isTabDataDiri ? FontWeight.bold : FontWeight.w500,
                    color: isTabDataDiri ? const Color(0xFF263023) : const Color(0xFF72786C),
                  ),
                ),
              ),
            ),
          ),

          // Tab 2: Detail Hafalan
          Expanded(
            child: GestureDetector(
              onTap: () => setState(() => isTabDataDiri = false),
              child: Container(
                decoration: BoxDecoration(
                  color: !isTabDataDiri ? Colors.white : Colors.transparent,
                  borderRadius: BorderRadius.circular(9),
                  boxShadow: !isTabDataDiri
                      ? [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.04),
                            blurRadius: 4,
                            offset: const Offset(0, 2),
                          ),
                        ]
                      : [],
                ),
                alignment: Alignment.center,
                child: Text(
                  'Detail Hafalan',
                  style: TextStyle(
                    fontFamily: 'Plus Jakarta Sans',
                    fontSize: 13,
                    fontWeight: !isTabDataDiri ? FontWeight.bold : FontWeight.w500,
                    color: !isTabDataDiri ? const Color(0xFF263023) : const Color(0xFF72786C),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================================
  // TAB 1: KONTEN DATA DIRI (GAMBAR 4)
  // ============================================================================
  Widget _buildTabDataDiri() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Ringkasan Profil Singkat Siswa
        Row(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: const Color(0xFFDCE7C7),
                borderRadius: BorderRadius.circular(24),
              ),
              alignment: Alignment.center,
              child: Text(
                currentInisial,
                style: const TextStyle(
                  fontFamily: 'Plus Jakarta Sans',
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF465635),
                ),
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    currentNama,
                    style: const TextStyle(
                      fontFamily: 'Plus Jakarta Sans',
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF263023),
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    'Kelas $currentKelas$currentRombel | NISN $currentNisn',
                    style: const TextStyle(
                      fontFamily: 'Plus Jakarta Sans',
                      fontSize: 13,
                      color: Color(0xFF72786C),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),

        const SizedBox(height: 20),

        // CARD DATA DIRI
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: const Color(0xFFDFE4D5), width: 1.2),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header Card: Status & Badge "Aktif" / "Nonaktif"
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Status',
                    style: TextStyle(
                      fontFamily: 'Plus Jakarta Sans',
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF8BA061),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                    decoration: BoxDecoration(
                      color: currentStatus == 'Aktif'
                          ? const Color(0xFFA6BA79)
                          : const Color(0xFF9E9E9E),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      currentStatus,
                      style: const TextStyle(
                        fontFamily: 'Plus Jakarta Sans',
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 16),

              _buildDataDiriRow('Nama Lengkap', currentNama),
              const SizedBox(height: 12),
              _buildDataDiriRow('NISN', currentNisn),
              const SizedBox(height: 12),
              _buildDataDiriRow('Kelas', currentKelas),
              const SizedBox(height: 12),
              _buildDataDiriRow('Rombel', currentRombel),
              const SizedBox(height: 12),
              _buildDataDiriRow('Tahun Ajaran', currentTahunAjaran),
            ],
          ),
        ),

        const SizedBox(height: 24),

        // TOMBOL "Perbarui Data"
        SizedBox(
          width: double.infinity,
          height: 48,
          child: ElevatedButton(
            onPressed: _showPerbaruiDataBottomSheet,
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFAAB881),
              foregroundColor: Colors.white,
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: const Text(
              'Perbarui Data',
              style: TextStyle(
                fontFamily: 'Plus Jakarta Sans',
                fontSize: 15,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDataDiriRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontFamily: 'Plus Jakarta Sans',
            fontSize: 13,
            color: Color(0xFF72786C),
          ),
        ),
        Text(
          value,
          style: const TextStyle(
            fontFamily: 'Plus Jakarta Sans',
            fontSize: 13,
            fontWeight: FontWeight.bold,
            color: Color(0xFF263023),
          ),
        ),
      ],
    );
  }

  // ============================================================================
  // TAB 2: KONTEN DETAIL HAFALAN (GAMBAR 3)
  // ============================================================================
  Widget _buildTabDetailHafalan() {
    final nama = widget.siswa['nama'] ?? 'Bilal Hakim';
    final inisial = widget.siswa['inisial'] ?? 'BH';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Row Profil Siswa + Tombol Cetak Hafalan
        Row(
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: const Color(0xFFF3F7E9),
                borderRadius: BorderRadius.circular(22),
              ),
              alignment: Alignment.center,
              child: Text(
                inisial,
                style: const TextStyle(
                  fontFamily: 'Plus Jakarta Sans',
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF5B6E3F),
                ),
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    nama,
                    style: const TextStyle(
                      fontFamily: 'Plus Jakarta Sans',
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF263023),
                    ),
                  ),
                  const SizedBox(height: 2),
                  const Text(
                    'Kelas 6A',
                    style: TextStyle(
                      fontFamily: 'Plus Jakarta Sans',
                      fontSize: 13,
                      color: Color(0xFF72786C),
                    ),
                  ),
                ],
              ),
            ),
            // Tombol Cetak Hafalan
            Container(
              height: 32,
              decoration: BoxDecoration(
                color: _isCetakLoading
                    ? const Color(0xFFAAB881).withOpacity(0.6)
                    : const Color(0xFFAAB881),
                borderRadius: BorderRadius.circular(8),
              ),
              child: TextButton(
                onPressed: _isCetakLoading ? null : _cetakHafalanPdf,
                style: TextButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 0),
                  minimumSize: Size.zero,
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
                child: _isCetakLoading
                    ? const SizedBox(
                        width: 14,
                        height: 14,
                        child: CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 2,
                        ),
                      )
                    : const Text(
                        'Cetak Hafalan',
                        style: TextStyle(
                          fontFamily: 'Plus Jakarta Sans',
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
              ),
            ),
          ],
        ),

        const SizedBox(height: 20),

        // CARD CAPAIAN HAFALAN
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            color: const Color(0xFFF6F8F1),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Capaian hafalan',
                style: TextStyle(
                  fontFamily: 'Plus Jakarta Sans',
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF263023),
                ),
              ),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: const [
                  Text(
                    '10 Surat',
                    style: TextStyle(
                      fontFamily: 'Plus Jakarta Sans',
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF263023),
                    ),
                  ),
                  Text(
                    '8%',
                    style: TextStyle(
                      fontFamily: 'Plus Jakarta Sans',
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF5B6E3F),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 4),
              const Text(
                '10/37 surat selesai',
                style: TextStyle(
                  fontFamily: 'Plus Jakarta Sans',
                  fontSize: 12,
                  color: Color(0xFF72786C),
                ),
              ),
              const SizedBox(height: 12),
              // Progress Bar
              ClipRRect(
                borderRadius: BorderRadius.circular(4),
                child: const LinearProgressIndicator(
                  value: 0.08,
                  minHeight: 6,
                  backgroundColor: Color(0xFFE4EAD6),
                  valueColor: AlwaysStoppedAnimation<Color>(Color(0xFFAAB881)),
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 22),

        // SUBJUDUL: Progres per surat
        const Text(
          'Progres per surat',
          style: TextStyle(
            fontFamily: 'Plus Jakarta Sans',
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: Color(0xFF263023),
          ),
        ),
        const SizedBox(height: 10),

        // Item Surat 1: An-Naba
        _buildProgresSuratCard(
          surat: 'An-Naba',
          status: 'Dalam proses',
          progressText: '10/40',
          progress: 10 / 40,
        ),
        const SizedBox(height: 10),

        // Item Surat 2: An-Nazi'at
        _buildProgresSuratCard(
          surat: "An-Nazi'at",
          status: 'Belum mulai',
          progressText: '0/46',
          progress: 0.0,
        ),
        const SizedBox(height: 10),

        // Item Surat 3: Abasa
        _buildProgresSuratCard(
          surat: 'Abasa',
          status: 'Belum mulai',
          progressText: '0/42',
          progress: 0.0,
        ),

        const SizedBox(height: 22),

        // SUBJUDUL: Riwayat setoran & 1 setoran
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: const [
            Text(
              'Riwayat setoran',
              style: TextStyle(
                fontFamily: 'Plus Jakarta Sans',
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: Color(0xFF263023),
              ),
            ),
            Text(
              '1 setoran',
              style: TextStyle(
                fontFamily: 'Plus Jakarta Sans',
                fontSize: 12,
                color: Color(0xFF72786C),
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),

        // Card Riwayat Setoran
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: const Color(0xFFDFE4D5), width: 1.2),
          ),
          child: Row(
            children: [
              const Icon(
                Icons.menu_book_outlined,
                color: Color(0xFF465635),
                size: 24,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text(
                      'An-Naba, ayat 1–10',
                      style: TextStyle(
                        fontFamily: 'Plus Jakarta Sans',
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF263023),
                      ),
                    ),
                    SizedBox(height: 2),
                    Text(
                      '2 Oktober 2026',
                      style: TextStyle(
                        fontFamily: 'Plus Jakarta Sans',
                        fontSize: 12,
                        color: Color(0xFF72786C),
                      ),
                    ),
                  ],
                ),
              ),
              // Badge "Mengulang"
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: const Color(0xFFCFD998),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Text(
                  'Mengulang',
                  style: TextStyle(
                    fontFamily: 'Plus Jakarta Sans',
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF465635),
                  ),
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 12),

        const Text(
          'Progres dihitung dari surat dan ayat terakhir diterima.',
          style: TextStyle(
            fontFamily: 'Plus Jakarta Sans',
            fontSize: 11,
            color: Color(0xFF72786C),
          ),
        ),
      ],
    );
  }

  Widget _buildProgresSuratCard({
    required String surat,
    required String status,
    required String progressText,
    required double progress,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFDFE4D5), width: 1.2),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                surat,
                style: const TextStyle(
                  fontFamily: 'Plus Jakarta Sans',
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF263023),
                ),
              ),
              Text(
                progressText,
                style: const TextStyle(
                  fontFamily: 'Plus Jakarta Sans',
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF263023),
                ),
              ),
            ],
          ),
          const SizedBox(height: 2),
          Text(
            status,
            style: const TextStyle(
              fontFamily: 'Plus Jakarta Sans',
              fontSize: 12,
              color: Color(0xFF72786C),
            ),
          ),
          const SizedBox(height: 8),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: progress,
              minHeight: 5,
              backgroundColor: const Color(0xFFE4EAD6),
              valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFFAAB881)),
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================================
  // BOTTOM SHEET: PERBARUI DATA MURID
  // ============================================================================
  void _showPerbaruiDataBottomSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => _PerbaruiDataMuridModal(
        initialNama: currentNama,
        initialNisn: currentNisn,
        initialKelas: currentKelas,
        initialRombel: currentRombel,
        initialTahunAjaran: currentTahunAjaran,
        initialStatus: currentStatus,
        onSave: (nama, nisn, kelas, rombel, tahunAjaran, status) {
          setState(() {
            currentNama = nama;
            currentNisn = nisn;
            currentKelas = kelas;
            currentRombel = rombel;
            currentTahunAjaran = tahunAjaran;
            currentStatus = status;

            // Perbarui inisial dari nama yang baru
            final parts = nama.trim().split(' ').where((s) => s.isNotEmpty).toList();
            if (parts.length >= 2) {
              currentInisial = '${parts[0][0]}${parts[1][0]}'.toUpperCase();
            } else if (parts.isNotEmpty && parts[0].isNotEmpty) {
              currentInisial = parts[0].substring(0, parts[0].length >= 2 ? 2 : 1).toUpperCase();
            }
          });
        },
      ),
    );
  }
}

// ============================================================================
// MODAL BOTTOM SHEET WIDGET: PERBARUI DATA MURID
// ============================================================================
class _PerbaruiDataMuridModal extends StatefulWidget {
  final String initialNama;
  final String initialNisn;
  final String initialKelas;
  final String initialRombel;
  final String initialTahunAjaran;
  final String initialStatus;
  final Function(
    String nama,
    String nisn,
    String kelas,
    String rombel,
    String tahunAjaran,
    String status,
  ) onSave;

  const _PerbaruiDataMuridModal({
    required this.initialNama,
    required this.initialNisn,
    required this.initialKelas,
    required this.initialRombel,
    required this.initialTahunAjaran,
    required this.initialStatus,
    required this.onSave,
  });

  @override
  State<_PerbaruiDataMuridModal> createState() => _PerbaruiDataMuridModalState();
}

class _PerbaruiDataMuridModalState extends State<_PerbaruiDataMuridModal> {
  late final TextEditingController _namaController;
  late final TextEditingController _nisnController;

  String? selectedKelas;
  String? selectedRombel;
  String? selectedTahunAjaran;
  late String statusMurid;

  final List<String> listKelas = ['1', '2', '3', '4', '5', '6'];
  final List<String> listRombel = ['A', 'B', 'C', 'D', 'E', 'F'];
  final List<String> listTahunAjaran = [
    '2023/2024',
    '2024/2025',
    '2025/2026',
    '2026/2027',
    '2027/2028',
  ];

  @override
  void initState() {
    super.initState();
    _namaController = TextEditingController(text: widget.initialNama);
    _nisnController = TextEditingController(text: widget.initialNisn);
    selectedKelas = widget.initialKelas.startsWith('Kelas')
        ? widget.initialKelas
        : 'Kelas ${widget.initialKelas}';
    selectedRombel = widget.initialRombel.startsWith('Rombel')
        ? widget.initialRombel
        : 'Rombel ${widget.initialRombel}';
    selectedTahunAjaran = widget.initialTahunAjaran;
    statusMurid = widget.initialStatus;
  }

  @override
  void dispose() {
    _namaController.dispose();
    _nisnController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(24),
          topRight: Radius.circular(24),
        ),
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: EdgeInsets.only(
            left: 20,
            right: 20,
            top: 12,
            bottom: MediaQuery.of(context).viewInsets.bottom + 16,
          ),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 1. Drag Handle
                Center(
                  child: Container(
                    width: 48,
                    height: 4,
                    decoration: BoxDecoration(
                      color: const Color(0xFFD1D5DB),
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                // 2. Header: Judul "Perbarui Data Murid" & Tombol Close (X)
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Perbarui Data Murid',
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF1F2937),
                      ),
                    ),
                    IconButton(
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                      icon: const Icon(Icons.close, color: Color(0xFF1F2937), size: 24),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ],
                ),
                const SizedBox(height: 4),

                // Subjudul: "Tambahkan Murid untuk Kelas Tahfizd"
                const Text(
                  'Tambahkan Murid untuk Kelas Tahfizd',
                  style: TextStyle(
                    fontFamily: 'Plus Jakarta Sans',
                    fontSize: 13,
                    color: Color(0xFF6B7280),
                  ),
                ),
                const SizedBox(height: 18),

                // 3. Masukan Nama Lengkap
                const Text(
                  'Masukan Nama Lengkap :',
                  style: TextStyle(
                    fontFamily: 'Plus Jakarta Sans',
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF4B5563),
                  ),
                ),
                const SizedBox(height: 6),
                _buildInputField(
                  controller: _namaController,
                  hintText: 'Belinda Blanche',
                ),
                const SizedBox(height: 14),

                // 4. Masukan NISN
                const Text(
                  'Masukan NISN :',
                  style: TextStyle(
                    fontFamily: 'Plus Jakarta Sans',
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF4B5563),
                  ),
                ),
                const SizedBox(height: 6),
                _buildInputField(
                  controller: _nisnController,
                  hintText: '0001234567',
                  keyboardType: TextInputType.number,
                ),
                const SizedBox(height: 14),

                // 5. Masukan Kelas Dropdown
                const Text(
                  'Masukan Kelas :',
                  style: TextStyle(
                    fontFamily: 'Plus Jakarta Sans',
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF4B5563),
                  ),
                ),
                const SizedBox(height: 6),
                _buildDropdownField(
                  hint: 'Pilih Kelas 1–6',
                  value: selectedKelas,
                  items: listKelas.map((k) => 'Kelas $k').toList(),
                  onChanged: (val) => setState(() => selectedKelas = val),
                ),
                const SizedBox(height: 14),

                // 6. Pilih Rombel Dropdown
                const Text(
                  'Pilih Rombel :',
                  style: TextStyle(
                    fontFamily: 'Plus Jakarta Sans',
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF4B5563),
                  ),
                ),
                const SizedBox(height: 6),
                _buildDropdownField(
                  hint: 'Tentukan Rombel A-F',
                  value: selectedRombel,
                  items: listRombel.map((r) => 'Rombel $r').toList(),
                  onChanged: (val) => setState(() => selectedRombel = val),
                ),
                const SizedBox(height: 14),

                // 7. Pilih Tahun Ajaran Dropdown
                const Text(
                  'Pilih Tahun Ajaran :',
                  style: TextStyle(
                    fontFamily: 'Plus Jakarta Sans',
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF4B5563),
                  ),
                ),
                const SizedBox(height: 6),
                _buildDropdownField(
                  hint: 'Tentukan Tahun Ajaran',
                  value: selectedTahunAjaran,
                  items: listTahunAjaran,
                  onChanged: (val) => setState(() => selectedTahunAjaran = val),
                ),
                const SizedBox(height: 16),

                // 8. Status : Nonaktif & Aktif
                const Text(
                  'Status :',
                  style: TextStyle(
                    fontFamily: 'Plus Jakarta Sans',
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF4B5563),
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    // Opsi Nonaktif
                    GestureDetector(
                      onTap: () => setState(() => statusMurid = 'Nonaktif'),
                      child: Row(
                        children: [
                          Container(
                            width: 22,
                            height: 22,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: statusMurid == 'Nonaktif'
                                  ? const Color(0xFFA6BA79)
                                  : const Color(0xFFD1D5DB),
                            ),
                          ),
                          const SizedBox(width: 8),
                          const Text(
                            'Nonaktif',
                            style: TextStyle(
                              fontFamily: 'Plus Jakarta Sans',
                              fontSize: 13,
                              color: Color(0xFF1F2937),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 28),
                    // Opsi Aktif
                    GestureDetector(
                      onTap: () => setState(() => statusMurid = 'Aktif'),
                      child: Row(
                        children: [
                          Container(
                            width: 22,
                            height: 22,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: statusMurid == 'Aktif'
                                  ? const Color(0xFFA6BA79)
                                  : const Color(0xFFD1D5DB),
                            ),
                          ),
                          const SizedBox(width: 8),
                          const Text(
                            'Aktif',
                            style: TextStyle(
                              fontFamily: 'Plus Jakarta Sans',
                              fontSize: 13,
                              color: Color(0xFF1F2937),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),

                // 9. Tombol "Perbarui Data"
                SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: ElevatedButton(
                    onPressed: () {
                      final inputNama = _namaController.text.trim();
                      final inputNisn = _nisnController.text.trim();
                      final nama = inputNama.isNotEmpty ? inputNama : widget.initialNama;
                      final nisn = inputNisn.isNotEmpty ? inputNisn : widget.initialNisn;
                      final kelas = selectedKelas != null
                          ? selectedKelas!.replaceAll('Kelas ', '')
                          : widget.initialKelas;
                      final rombel = selectedRombel != null
                          ? selectedRombel!.replaceAll('Rombel ', '')
                          : widget.initialRombel;
                      final tahunAjaran = selectedTahunAjaran ?? widget.initialTahunAjaran;

                      widget.onSave(nama, nisn, kelas, rombel, tahunAjaran, statusMurid);
                      Navigator.pop(context);

                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Data murid berhasil diperbarui!'),
                          backgroundColor: Color(0xFF7A8B58),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFAAB881),
                      foregroundColor: Colors.white,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: const Text(
                      'Perbarui Data',
                      style: TextStyle(
                        fontFamily: 'Plus Jakarta Sans',
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInputField({
    required TextEditingController controller,
    required String hintText,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return Container(
      height: 48,
      padding: const EdgeInsets.symmetric(horizontal: 14),
      decoration: BoxDecoration(
        color: const Color(0xFFFAFBF8),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: const Color(0xFFDFE4D5), width: 1.2),
      ),
      alignment: Alignment.centerLeft,
      child: TextField(
        controller: controller,
        keyboardType: keyboardType,
        style: const TextStyle(
          fontFamily: 'Plus Jakarta Sans',
          fontSize: 14,
          color: Color(0xFF1F2937),
        ),
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: const TextStyle(
            fontFamily: 'Plus Jakarta Sans',
            fontSize: 14,
            color: Color(0xFFB0B7A6),
          ),
          border: InputBorder.none,
          isDense: true,
          contentPadding: EdgeInsets.zero,
        ),
      ),
    );
  }

  Widget _buildDropdownField({
    required String hint,
    required String? value,
    required List<String> items,
    required ValueChanged<String?> onChanged,
  }) {
    return Container(
      height: 48,
      padding: const EdgeInsets.symmetric(horizontal: 14),
      decoration: BoxDecoration(
        color: const Color(0xFFFAFBF8),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: const Color(0xFFDFE4D5), width: 1.2),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: value,
          isExpanded: true,
          hint: Text(
            hint,
            style: const TextStyle(
              fontFamily: 'Plus Jakarta Sans',
              fontSize: 13,
              color: Color(0xFFB0B7A6),
            ),
          ),
          icon: const Icon(Icons.keyboard_arrow_down, color: Color(0xFF6F824E)),
          items: items.map((item) {
            return DropdownMenuItem<String>(
              value: item,
              child: Text(
                item,
                style: const TextStyle(
                  fontFamily: 'Plus Jakarta Sans',
                  fontSize: 14,
                  color: Color(0xFF1F2937),
                ),
              ),
            );
          }).toList(),
          onChanged: onChanged,
        ),
      ),
    );
  }
}
