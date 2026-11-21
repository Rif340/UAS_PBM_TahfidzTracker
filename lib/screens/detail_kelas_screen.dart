import 'package:flutter/material.dart';
import 'cetak_rekap_pdf_screen.dart';
import 'detail_siswa_screen.dart';

class DetailKelasScreen extends StatefulWidget {
  const DetailKelasScreen({super.key});

  @override
  State<DetailKelasScreen> createState() => _DetailKelasScreenState();
}

class _DetailKelasScreenState extends State<DetailKelasScreen> {
  bool isTabSiswa = true; // true = Siswa, false = Rekap Kelas
  String searchQuery = '';

  // Data Siswa untuk Tab Siswa
  final List<Map<String, String>> daftarSiswa = [
    {
      'nama': 'Bilal Hakim',
      'surat': 'An-Naba, ayat 22/40',
      'inisial': 'BH',
    },
    {
      'nama': 'Aisyah Putri',
      'surat': 'An-Naba, ayat 10/40',
      'inisial': 'AP',
    },
    {
      'nama': 'Citra Zahra',
      'surat': 'An-Naba, ayat 10/40',
      'inisial': 'CZ',
    },
    {
      'nama': 'Daffa Rizki',
      'surat': 'Belum ada setoran',
      'inisial': 'DR',
    },
    {
      'nama': 'Fara Aulia',
      'surat': 'An-Nazi\'at, ayat 46/46',
      'inisial': 'FA',
    },
    {
      'nama': 'Gibran Fadhil',
      'surat': '\'Abasa, ayat 42/42',
      'inisial': 'GF',
    },
  ];

  // Data Tabel Rekap
  final List<Map<String, dynamic>> rekapList = [
    {'nama': 'Aisyah Putri', 'naba': '10', 'naziat': '—', 'abasa': '—'},
    {'nama': 'Bilal Hakim', 'naba': 'centang', 'naziat': '20', 'abasa': '—'},
    {'nama': 'Citra Zahra', 'naba': '10', 'naziat': '—', 'abasa': '—'},
    {'nama': 'Daffa Rizki', 'naba': '—', 'naziat': '—', 'abasa': '—'},
    {'nama': 'Fara Aulia', 'naba': 'centang', 'naziat': 'centang', 'abasa': '—'},
    {'nama': 'Gibran Fadhil', 'naba': 'centang', 'naziat': 'centang', 'abasa': 'centang'},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFAFBF8),
      body: Stack(
        children: [
          // KONTEN UTAMA SCROLLABLE
          SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 1. HEADER HIJAU GRADASI
                _buildHeader(context),

                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // 2. BANNER KELAS TAHFIZD
                      ClipRRect(
                        borderRadius: BorderRadius.circular(16),
                        child: Image.asset(
                          'assets/images/Gambar_Banner_Kelas_Tahfizd.png',
                          width: double.infinity,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) => Container(
                            height: 100,
                            decoration: BoxDecoration(
                              color: const Color(0xFF8B9E68),
                              borderRadius: BorderRadius.circular(16),
                            ),
                            alignment: Alignment.center,
                            child: const Text('Banner Kelas 6A', style: TextStyle(color: Colors.white)),
                          ),
                        ),
                      ),

                      const SizedBox(height: 16),

                      // 3. BENTO GRID STATISTIK
                      _buildBentoSection(),

                      const SizedBox(height: 20),

                      // 4. SEGMENTED TAB (SISWA & REKAP KELAS)
                      _buildSegmentedTab(),

                      const SizedBox(height: 20),

                      // 5. ISI KONTEN TAB: SISWA ATAU REKAP
                      if (isTabSiswa) ...[
                        _buildTabSiswaContent(),
                      ] else ...[
                        _buildTabRekapContent(),
                      ],

                      const SizedBox(height: 24),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Header Hijau Melengkung dengan Icon Back (38x38)
  Widget _buildHeader(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.only(top: 16, left: 24, right: 24, bottom: 26),
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
            // Baris Back + Judul
            Row(
            children: [
              InkWell(
                onTap: () => Navigator.pop(context),
                borderRadius: BorderRadius.circular(10),
                child: Container(
                  width: 38,
                  height: 38,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.22),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  alignment: Alignment.center,
                  child: Image.asset(
                    'assets/icons/icon_back_untuk_header.png',
                    width: 38,
                    height: 38,
                    fit: BoxFit.contain,
                    errorBuilder: (context, error, stackTrace) =>
                        const Icon(Icons.arrow_back_ios_new, color: Colors.white, size: 18),
                  ),
                ),
              ),
              const SizedBox(width: 14),
              const Expanded(
                child: Text(
                  'Detail\nTahfizd Kelas',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: 'Plus Jakarta Sans',
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                    height: 1.25,
                  ),
                ),
              ),
              const SizedBox(width: 38),
            ],
          ),
        ],
      ),
    ),
    );
  }

  // Bento Grid Statistik
  Widget _buildBentoSection() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Bento Kiri: Total Siswa (Tinggi Penuh)
        Expanded(
          flex: 5,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: Image.asset(
              'assets/images/Gambar_Bento_Total_Siswa.png',
              fit: BoxFit.contain,
              errorBuilder: (context, error, stackTrace) => Container(
                height: 200,
                color: const Color(0xFF6B7E50),
                alignment: Alignment.center,
                child: const Text('Total Siswa: 21', style: TextStyle(color: Colors.white)),
              ),
            ),
          ),
        ),
        const SizedBox(width: 12),

        // Bento Kanan: Target Hafalan & Mencapai Target
        Expanded(
          flex: 6,
          child: Column(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: Image.asset(
                  'assets/images/Gambar_Bento_Total_Target_Hafalan.png',
                  fit: BoxFit.contain,
                  errorBuilder: (context, error, stackTrace) => Container(
                    height: 94,
                    color: const Color(0xFFEFF3E8),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: Image.asset(
                  'assets/images/Gambar_Bento_Total_Murid_Yang_Capai_Target_Sudah_Berapa_Berapa.png',
                  fit: BoxFit.contain,
                  errorBuilder: (context, error, stackTrace) => Container(
                    height: 94,
                    color: const Color(0xFF4E5E3B),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // Segmented Tab Masuk / Rekap
  Widget _buildSegmentedTab() {
    return Container(
      height: 46,
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: const Color(0xFFF3F5ED),
        borderRadius: BorderRadius.circular(12),
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final double tabWidth = constraints.maxWidth / 2;
          return Stack(
            children: [
              AnimatedAlign(
                duration: const Duration(milliseconds: 260),
                curve: Curves.easeInOutCubic,
                alignment: isTabSiswa ? Alignment.centerLeft : Alignment.centerRight,
                child: Container(
                  width: tabWidth,
                  height: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(9),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.06),
                        blurRadius: 4,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                ),
              ),
              Row(
                children: [
                  Expanded(
                    child: InkWell(
                      onTap: () => setState(() => isTabSiswa = true),
                      borderRadius: BorderRadius.circular(9),
                      child: Center(
                        child: Text(
                          'Siswa',
                          style: TextStyle(
                            fontFamily: 'Plus Jakarta Sans',
                            fontSize: 13,
                            fontWeight: isTabSiswa ? FontWeight.bold : FontWeight.w500,
                            color: isTabSiswa ? const Color(0xFF2C3E2D) : const Color(0xFF8E9B85),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: InkWell(
                      onTap: () => setState(() => isTabSiswa = false),
                      borderRadius: BorderRadius.circular(9),
                      child: Center(
                        child: Text(
                          'Rekap Kelas',
                          style: TextStyle(
                            fontFamily: 'Plus Jakarta Sans',
                            fontSize: 13,
                            fontWeight: !isTabSiswa ? FontWeight.bold : FontWeight.w500,
                            color: !isTabSiswa ? const Color(0xFF2C3E2D) : const Color(0xFF8E9B85),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          );
        },
      ),
    );
  }

  // ==========================================
  // TAB 1: KONTEN DAFTAR SISWA (GAMBAR 2)
  // ==========================================
  Widget _buildTabSiswaContent() {
    final filtered = daftarSiswa.where((s) {
      if (searchQuery.isNotEmpty && !s['nama']!.toLowerCase().contains(searchQuery.toLowerCase())) {
        return false;
      }
      return true;
    }).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Search Bar dengan icon_search_untuk_field_di_detail_kelas.png (19x19)
        Container(
          height: 48,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(
            color: const Color(0xFFFAFBF8),
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: const Color(0xFFDFE4D5), width: 1.2),
          ),
          child: Row(
            children: [
              Image.asset(
                'assets/icons/icon_search_untuk_field_di_detail_kelas.png',
                width: 19,
                height: 19,
                errorBuilder: (context, error, stackTrace) =>
                    const Icon(Icons.search, size: 20, color: Color(0xFF9E9E9E)),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: TextField(
                  onChanged: (val) => setState(() => searchQuery = val),
                  style: const TextStyle(
                    fontFamily: 'Plus Jakarta Sans',
                    fontSize: 14,
                    color: Color(0xFF333333),
                  ),
                  decoration: const InputDecoration(
                    hintText: 'Cari nama siswa...',
                    hintStyle: TextStyle(
                      fontFamily: 'Plus Jakarta Sans',
                      fontSize: 14,
                      color: Color(0xFF9E9E9E),
                    ),
                    border: InputBorder.none,
                    isDense: true,
                    contentPadding: EdgeInsets.zero,
                  ),
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 12),

        // Subjudul: Daftar Siswa (Font Plus Jakarta Sans, 13, Bold)
        const Text(
          'Daftar Siswa',
          style: TextStyle(
            fontFamily: 'Plus Jakarta Sans',
            fontSize: 13,
            fontWeight: FontWeight.bold,
            color: Color(0xFF263023),
          ),
        ),

        const SizedBox(height: 8),

        // List Kartu Siswa
        ListView.builder(
          padding: EdgeInsets.zero,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: filtered.length,
          itemBuilder: (context, index) {
            final siswa = filtered[index];
            return Container(
              margin: const EdgeInsets.only(bottom: 12),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: const Color(0xFFDFE4D5), width: 1.2),
              ),
              child: Row(
                children: [
                  // Bagian yang bisa di-klik: Avatar + Nama & Hafalan mengarahkan ke DetailSiswaScreen
                  Expanded(
                    child: GestureDetector(
                      behavior: HitTestBehavior.opaque,
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => DetailSiswaScreen(siswa: siswa),
                          ),
                        );
                      },
                      child: Row(
                        children: [
                          // Avatar Bulat (Ukuran 44x44, Radius 22, Warna DCE7C7, Teks BH 465635 14 Bold)
                          Container(
                            width: 44,
                            height: 44,
                            decoration: BoxDecoration(
                              color: const Color(0xFFDCE7C7),
                              borderRadius: BorderRadius.circular(22),
                            ),
                            alignment: Alignment.center,
                            child: Text(
                              siswa['inisial']!,
                              style: const TextStyle(
                                fontFamily: 'Plus Jakarta Sans',
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF465635),
                              ),
                            ),
                          ),
                          const SizedBox(width: 14),

                          // Detail Nama & Hafalan
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  siswa['nama']!,
                                  style: const TextStyle(
                                    fontFamily: 'Plus Jakarta Sans',
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFF263023),
                                  ),
                                ),
                                const SizedBox(height: 3),
                                Text(
                                  siswa['surat']!,
                                  style: const TextStyle(
                                    fontFamily: 'Plus Jakarta Sans',
                                    fontSize: 12,
                                    fontWeight: FontWeight.w400,
                                    color: Color(0xFF72786C),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  // Tombol "Setoran" (Warna B0BF7C, Teks 465635, Lebar 100, Tinggi 32, Padding 12x8)
                  Container(
                    width: 100,
                    height: 32,
                    decoration: BoxDecoration(
                      color: const Color(0xFFB0BF7C),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: ElevatedButton(
                      onPressed: () => _showCatatSetoranBottomSheet(siswa),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.transparent,
                        shadowColor: Colors.transparent,
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 0),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: const Text(
                        'Setoran',
                        style: TextStyle(
                          fontFamily: 'Plus Jakarta Sans',
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF465635),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ],
    );
  }

  // ==========================================
  // TAB 2: KONTEN REKAP KELAS (GAMBAR 4 & 5)
  // ==========================================
  Widget _buildTabRekapContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 1. KARTU CAPAIAN TARGET KELAS (Tinggi 134, Fill F6F8F1, Padding 16)
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: const Color(0xFFF6F8F1),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Judul: Capaian target kelas (Warna 263023, 13, Semibold)
              const Text(
                'Capaian target kelas',
                style: TextStyle(
                  fontFamily: 'Plus Jakarta Sans',
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF263023),
                ),
              ),
              const SizedBox(height: 8),

              // Baris: 10/36 Siswa (22, Bold) dan 38% (22, Bold)
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: const [
                  Text(
                    '10/36 Siswa',
                    style: TextStyle(
                      fontFamily: 'Plus Jakarta Sans',
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF263023),
                    ),
                  ),
                  Text(
                    '38%',
                    style: TextStyle(
                      fontFamily: 'Plus Jakarta Sans',
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF263023),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),

              // Progress Bar (Aktif B0BF7C, Belum E9EDE0)
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: LinearProgressIndicator(
                  value: 0.38,
                  minHeight: 6,
                  backgroundColor: const Color(0xFFE9EDE0),
                  valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFFB0BF7C)),
                ),
              ),
              const SizedBox(height: 10),

              // Subteks: 1 dari 36 siswa selesai seluruh target (Warna 72786C, 12, Regular)
              const Text(
                '1 dari 36 siswa selesai seluruh target',
                style: TextStyle(
                  fontFamily: 'Plus Jakarta Sans',
                  fontSize: 12,
                  fontWeight: FontWeight.w400,
                  color: Color(0xFF72786C),
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 24),

        // Judul: Rekap Setoran Tahfizd Kelas 6A (15, Bold, Warna 263023)
        const Text(
          'Rekap Setoran Tahfizd  Kelas 6A',
          style: TextStyle(
            fontFamily: 'Plus Jakarta Sans',
            fontSize: 15,
            fontWeight: FontWeight.bold,
            color: Color(0xFF263023),
          ),
        ),

        const SizedBox(height: 14),

        // 2. TABEL SETORAN (HORIZONTAL SCROLL)
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: const Color(0xFFDFE4D5), width: 1.2),
            ),
            child: DataTable(
              headingRowHeight: 52,
              dataRowMinHeight: 46,
              dataRowMaxHeight: 46,
              headingRowColor: WidgetStateProperty.all(const Color(0xFFF6F8F1)),
              border: TableBorder(
                horizontalInside: BorderSide(color: const Color(0xFFE5E7EB), width: 1),
                verticalInside: BorderSide(color: const Color(0xFFE5E7EB), width: 1),
              ),
              columns: const [
                DataColumn(
                  label: Text(
                    'Nama siswa',
                    style: TextStyle(
                      fontFamily: 'Plus Jakarta Sans',
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF263023),
                    ),
                  ),
                ),
                DataColumn(
                  label: Text(
                    'An-Naba\n(40)',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontFamily: 'Plus Jakarta Sans',
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF263023),
                    ),
                  ),
                ),
                DataColumn(
                  label: Text(
                    'An-Nazi\'at\n(46)',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontFamily: 'Plus Jakarta Sans',
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF263023),
                    ),
                  ),
                ),
                DataColumn(
                  label: Text(
                    '\'Abasa\n(42)',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontFamily: 'Plus Jakarta Sans',
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF263023),
                    ),
                  ),
                ),
              ],
              rows: rekapList.map((row) {
                return DataRow(
                  cells: [
                    DataCell(
                      Text(
                        row['nama'],
                        style: const TextStyle(
                          fontFamily: 'Plus Jakarta Sans',
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          color: Color(0xFF263023),
                        ),
                      ),
                    ),
                    _buildDataTableCell(row['naba']),
                    _buildDataTableCell(row['naziat']),
                    _buildDataTableCell(row['abasa']),
                  ],
                );
              }).toList(),
            ),
          ),
        ),

        const SizedBox(height: 24),

        // 3. TOMBOL CETAK REKAP (OUTLINE BUTTON)
        SizedBox(
          width: double.infinity,
          height: 48,
          child: OutlinedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const CetakRekapPdfScreen(),
                ),
              );
            },
            style: OutlinedButton.styleFrom(
              side: const BorderSide(color: Color(0xFFAAB881), width: 1.5),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              backgroundColor: Colors.white,
            ),
            child: const Text(
              'Cetak Rekap',
              style: TextStyle(
                fontFamily: 'Plus Jakarta Sans',
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: Color(0xFF465635),
              ),
            ),
          ),
        ),
      ],
    );
  }

  // Helper Sel Tabel (Angka / Centang / Strip)
  DataCell _buildDataTableCell(dynamic value) {
    if (value == 'centang') {
      return DataCell(
        Center(
          child: Image.asset(
            'assets/icons/icon_centang_untuk_tabel_detail_setoran.png',
            width: 16,
            height: 16,
            errorBuilder: (context, error, stackTrace) =>
                const Icon(Icons.check, size: 18, color: Color(0xFF5B6E3F)),
          ),
        ),
      );
    }
    return DataCell(
      Center(
        child: Text(
          value.toString(),
          style: const TextStyle(
            fontFamily: 'Plus Jakarta Sans',
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: Color(0xFF263023),
          ),
        ),
      ),
    );
  }

  void _showCatatSetoranBottomSheet(Map<String, String> siswa) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      barrierColor: Colors.black.withOpacity(0.5),
      builder: (context) {
        return _CatatSetoranModal(siswa: siswa);
      },
    );
  }
}

// ============================================================================
// MODAL BOTTOM SHEET: CATAT SETORAN
// ============================================================================
class _CatatSetoranModal extends StatefulWidget {
  final Map<String, String> siswa;

  const _CatatSetoranModal({required this.siswa});

  @override
  State<_CatatSetoranModal> createState() => _CatatSetoranModalState();
}

class _CatatSetoranModalState extends State<_CatatSetoranModal> {
  String selectedSurat = 'An-Naba';
  String hasilSetoran = 'Mengulang'; // 'Diterima' atau 'Mengulang'
  final TextEditingController _ayatMulaiController = TextEditingController(text: '11');
  final TextEditingController _ayatAkhirController = TextEditingController(text: '20');

  final List<String> daftarSurat = [
    'An-Naba',
    "An-Nazi'at",
    "'Abasa",
    'At-Takwir',
    'Al-Infitar',
    'Al-Mutaffifin',
    'Al-Insyiqaq',
    'Al-Buruj',
    'At-Tariq',
    "Al-A'la",
    'Al-Ghasyiyah',
    'Al-Fajr',
    'Al-Balad',
    'Asy-Syams',
    'Al-Lail',
    'Ad-Duha',
    'Al-Insyirah',
    'At-Tin',
    "Al-'Alaq",
    'Al-Qadr',
    'Al-Bayyinah',
    'Az-Zalzalah',
    "Al-'Adiyat",
    "Al-Qari'ah",
    'At-Takasur',
    "Al-'Asr",
    'Al-Humazah',
    'Al-Fil',
    'Quraisy',
    "Al-Ma'un",
    'Al-Kausar',
    'Al-Kafirun',
    'An-Nasr',
    'Al-Lahab',
    'Al-Ikhlas',
    'Al-Falaq',
    'An-Nas',
  ];

  @override
  void dispose() {
    _ayatMulaiController.dispose();
    _ayatAkhirController.dispose();
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

                // 2. Header: Judul "Catat Setoran" & Tombol Close
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Catat Setoran',
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF5B7042),
                      ),
                    ),
                    IconButton(
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                      icon: const Icon(Icons.close, color: Color(0xFF374151), size: 22),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                // 3. Info Kartu Siswa (Nama, Kelas, Avatar Bulat)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF7F9F3),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              widget.siswa['nama'] ?? 'Siswa',
                              style: const TextStyle(
                                fontFamily: 'Plus Jakarta Sans',
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF1F2937),
                              ),
                            ),
                            const SizedBox(height: 2),
                            const Text(
                              'Kelas 6A',
                              style: TextStyle(
                                fontFamily: 'Plus Jakarta Sans',
                                fontSize: 13,
                                color: Color(0xFF6B7280),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        width: 44,
                        height: 44,
                        decoration: BoxDecoration(
                          color: const Color(0xFFDCE7C7),
                          borderRadius: BorderRadius.circular(22),
                        ),
                        alignment: Alignment.center,
                        child: Text(
                          widget.siswa['inisial'] ?? 'S',
                          style: const TextStyle(
                            fontFamily: 'Plus Jakarta Sans',
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF465635),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),

                // 4. Dropdown Surat
                const Text(
                  'Surat',
                  style: TextStyle(
                    fontFamily: 'Plus Jakarta Sans',
                    fontSize: 13,
                    color: Color(0xFF4B5563),
                  ),
                ),
                const SizedBox(height: 6),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 2),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: const Color(0xFFDFE4D5), width: 1.2),
                  ),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      value: selectedSurat,
                      isExpanded: true,
                      icon: const Icon(Icons.keyboard_arrow_down, color: Color(0xFF6F824E)),
                      items: daftarSurat.map((surat) {
                        return DropdownMenuItem<String>(
                          value: surat,
                          child: Text(
                            surat,
                            style: const TextStyle(
                              fontFamily: 'Plus Jakarta Sans',
                              fontSize: 14,
                              color: Color(0xFF1F2937),
                            ),
                          ),
                        );
                      }).toList(),
                      onChanged: (val) {
                        if (val != null) setState(() => selectedSurat = val);
                      },
                    ),
                  ),
                ),
                const SizedBox(height: 14),

                // 5. Ayat Mulai & Ayat Akhir
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Ayat mulai',
                            style: TextStyle(
                              fontFamily: 'Plus Jakarta Sans',
                              fontSize: 13,
                              color: Color(0xFF4B5563),
                            ),
                          ),
                          const SizedBox(height: 6),
                          Container(
                            height: 48,
                            padding: const EdgeInsets.symmetric(horizontal: 14),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(color: const Color(0xFFDFE4D5), width: 1.2),
                            ),
                            alignment: Alignment.centerLeft,
                            child: TextField(
                              controller: _ayatMulaiController,
                              keyboardType: TextInputType.number,
                              style: const TextStyle(
                                fontFamily: 'Plus Jakarta Sans',
                                fontSize: 14,
                                color: Color(0xFF1F2937),
                              ),
                              decoration: const InputDecoration(
                                border: InputBorder.none,
                                isDense: true,
                                contentPadding: EdgeInsets.zero,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Ayat akhir',
                            style: TextStyle(
                              fontFamily: 'Plus Jakarta Sans',
                              fontSize: 13,
                              color: Color(0xFF4B5563),
                            ),
                          ),
                          const SizedBox(height: 6),
                          Container(
                            height: 48,
                            padding: const EdgeInsets.symmetric(horizontal: 14),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(color: const Color(0xFFDFE4D5), width: 1.2),
                            ),
                            alignment: Alignment.centerLeft,
                            child: TextField(
                              controller: _ayatAkhirController,
                              keyboardType: TextInputType.number,
                              style: const TextStyle(
                                fontFamily: 'Plus Jakarta Sans',
                                fontSize: 14,
                                color: Color(0xFF1F2937),
                              ),
                              decoration: const InputDecoration(
                                border: InputBorder.none,
                                isDense: true,
                                contentPadding: EdgeInsets.zero,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                // 6. Hasil Setoran (Radio/Pilihan Diterima & Mengulang)
                const Text(
                  'Hasil setoran',
                  style: TextStyle(
                    fontFamily: 'Plus Jakarta Sans',
                    fontSize: 13,
                    color: Color(0xFF4B5563),
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    // Opsi Diterima
                    GestureDetector(
                      onTap: () => setState(() => hasilSetoran = 'Diterima'),
                      child: Row(
                        children: [
                          Container(
                            width: 22,
                            height: 22,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: hasilSetoran == 'Diterima'
                                  ? const Color(0xFFA6BA79)
                                  : const Color(0xFFD1D5DB),
                            ),
                          ),
                          const SizedBox(width: 8),
                          const Text(
                            'Diterima',
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
                    // Opsi Mengulang
                    GestureDetector(
                      onTap: () => setState(() => hasilSetoran = 'Mengulang'),
                      child: Row(
                        children: [
                          Container(
                            width: 22,
                            height: 22,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: hasilSetoran == 'Mengulang'
                                  ? const Color(0xFFA6BA79)
                                  : const Color(0xFFD1D5DB),
                            ),
                          ),
                          const SizedBox(width: 8),
                          const Text(
                            'Mengulang',
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
                const SizedBox(height: 14),

                // 8. Keterangan teks tipis & divider
                const Divider(color: Color(0xFFE5E7EB), thickness: 1),
                const SizedBox(height: 6),
                const Text(
                  'Periksa rentang ayat dan hasil sebelum menyimpan. Hanya ayat diterima yang menambah progres.',
                  style: TextStyle(
                    fontFamily: 'Plus Jakarta Sans',
                    fontSize: 11.5,
                    height: 1.35,
                    color: Color(0xFF6B7280),
                  ),
                ),
                const SizedBox(height: 16),

                // 9. Tombol Simpan Setoran
                SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Setoran ${widget.siswa['nama']} berhasil disimpan!'),
                          backgroundColor: const Color(0xFF7A8B58),
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
                      'Simpan Setoran',
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
}
