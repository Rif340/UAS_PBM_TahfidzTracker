import 'package:flutter/material.dart';
import 'scan_barcode_screen.dart';
import 'riwayat_absensi_screen.dart';

class AbsensiGuruScreen extends StatefulWidget {
  const AbsensiGuruScreen({super.key});

  @override
  State<AbsensiGuruScreen> createState() => _AbsensiGuruScreenState();
}

class _AbsensiGuruScreenState extends State<AbsensiGuruScreen> {
  // Data list kelas yang diajar (untuk horizontal scroll card)
  final List<Map<String, String>> kelasDiajarList = [
    {
      'sekolah': 'SDIT At-Taubah',
      'lokasi': 'Karawang, Jawa Barat',
      'kelas': 'Kelas 5A',
    },
    {
      'sekolah': 'SDIT At-Taubah',
      'lokasi': 'Karawang, Jawa Barat',
      'kelas': 'Kelas 6A',
    },
    {
      'sekolah': 'SDIT At-Taubah',
      'lokasi': 'Karawang, Jawa Barat',
      'kelas': 'Kelas 4B',
    },
  ];

  // Riwayat absensi terbaru
  final List<Map<String, String>> riwayatAbsensi = [
    {
      'tanggal': 'Senin, 5 Oktober 2026',
      'jam': 'Masuk 06:50 • Pulang 14:10 WIB',
    },
    {
      'tanggal': 'Jumat, 2 Oktober 2026',
      'jam': 'Masuk 06:52 • Pulang 11:30 WIB',
    },
    {
      'tanggal': 'Jumat, 2 Oktober 2026',
      'jam': 'Masuk 06:52 • Pulang 11:30 WIB',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFAFBF8),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 1. BAGIAN ATAS: HEADER HIJAU MELENGKUNG (GAMBAR 1 & 2)
            _buildHeader(),

            const SizedBox(height: 20),

            // 2. BAGIAN ISI: HORIZONTAL SCROLL CARD KELAS YANG DIAJAR (GAMBAR 1 & 3 & 4 & 5)
            _buildKelasDiajarHorizontal(),

            const SizedBox(height: 20),

            // 3. CARD ABSENSI HARI INI
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: _buildAbsensiHariIniCard(context),
            ),

            const SizedBox(height: 24),

            // 4. RIWAYAT TERBARU
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: _buildRiwayatTerbaru(),
            ),

            const SizedBox(height: 36),
          ],
        ),
      ),
    );
  }

  // ============================================================================
  // 1. HEADER ATAS (GAMBAR 1 & 2)
  // ============================================================================
  Widget _buildHeader() {
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
            // Profil Guru (Foto Avatar + Nama + Tanggal)
            Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(24),
                  child: Image.asset(
                    'assets/images/Foto_Belinda_Blanche_Di_Card_Kelas.png',
                    width: 48,
                    height: 48,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => Container(
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(
                        color: Colors.black26,
                        borderRadius: BorderRadius.circular(24),
                      ),
                      child: const Icon(Icons.person, color: Colors.white, size: 28),
                    ),
                  ),
                ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text(
                      'Hai, Belinda Blanche, S.Kom',
                      style: TextStyle(
                        fontFamily: 'Plus Jakarta Sans',
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 3),
                    Text(
                      'Selasa, 6 Oktober 2026',
                      style: TextStyle(
                        fontFamily: 'Plus Jakarta Sans',
                        color: Colors.white70,
                        fontSize: 13,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          // Judul Header: "Absensi Guru"
          const Center(
            child: Text(
              'Absensi Guru',
              style: TextStyle(
                fontFamily: 'Plus Jakarta Sans',
                color: Colors.white,
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    ),
    );
  }

  // ============================================================================
  // 2. HORIZONTAL SCROLL CARD KELAS YANG DIAJAR (GAMBAR 1, 3, 4, 5)
  // Tinggi: 140, Lebar: 320, Radius: 20, Border: E6EBDD
  // Card Atas: Linear Gradient (#BAC781 -> #799263), Shadow: X=0, Y=4, Blur=12, Spread=0, #324522 5.1%
  // ============================================================================
  Widget _buildKelasDiajarHorizontal() {
    return SizedBox(
      height: 140,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 24),
        itemCount: kelasDiajarList.length,
        itemBuilder: (context, index) {
          final item = kelasDiajarList[index];
          return Container(
            width: 320,
            margin: EdgeInsets.only(right: index == kelasDiajarList.length - 1 ? 0 : 16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: const Color(0xFFE6EBDD), width: 1.2),
            ),
            child: Column(
              children: [
                // Bagian Card Atas (Tinggi ~86, Linear Gradient, Radius 20 atas)
                Container(
                  height: 86,
                  padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(20),
                      topRight: Radius.circular(20),
                    ),
                    gradient: const LinearGradient(
                      colors: [Color(0xFFBAC781), Color(0xFF799263)],
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFF324522).withOpacity(0.051),
                        offset: const Offset(0, 4),
                        blurRadius: 12,
                        spreadRadius: 0,
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            item['sekolah']!,
                            style: const TextStyle(
                              fontFamily: 'Inter',
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(height: 3),
                          Text(
                            item['lokasi']!,
                            style: const TextStyle(
                              fontFamily: 'Plus Jakarta Sans',
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                      // Icon School / Topi Wisuda
                      Image.asset(
                        'assets/icons/icon_school.png',
                        width: 44,
                        height: 44,
                        color: Colors.white,
                        errorBuilder: (context, error, stackTrace) => Image.asset(
                          'assets/icons/Icon_Topi_Wisuda_Yang_Dibawah_Dari_Aksi_Cepat.png',
                          width: 48,
                          height: 48,
                          color: Colors.white,
                          errorBuilder: (context, error, stackTrace) =>
                              const Icon(Icons.school, size: 42, color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                ),

                // Bagian Card Bawah (Tinggi ~50)
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 18),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Kelas yang diajar',
                          style: TextStyle(
                            fontFamily: 'Plus Jakarta Sans',
                            fontSize: 12,
                            fontWeight: FontWeight.normal,
                            color: Color(0xFF72786C),
                          ),
                        ),
                        Text(
                          item['kelas']!,
                          style: const TextStyle(
                            fontFamily: 'Plus Jakarta Sans',
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF263023),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  // ============================================================================
  // 3. CARD ABSENSI HARI INI
  // ============================================================================
  Widget _buildAbsensiHariIniCard(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFE6EBDD), width: 1.2),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Baris Judul & Badge "Belum absen"
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Absensi hari ini',
                style: TextStyle(
                  fontFamily: 'Plus Jakarta Sans',
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF263023),
                ),
              ),
              // Badge "Belum absen" (Warna 857445, Fill F5F0DF, Lebar 85, Tinggi 24, Padding 8x4)
              Container(
                width: 85,
                height: 24,
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: const Color(0xFFF5F0DF),
                  borderRadius: BorderRadius.circular(6),
                ),
                alignment: Alignment.center,
                child: const Text(
                  'Belum absen',
                  style: TextStyle(
                    fontFamily: 'Plus Jakarta Sans',
                    fontSize: 10.5,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF857445),
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          // Kolom Masuk & Pulang
          Row(
            children: [
              // Kolom Masuk
              Expanded(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Image.asset(
                      'assets/icons/icon_logout.png',
                      width: 20,
                      height: 20,
                      errorBuilder: (context, error, stackTrace) => const Icon(
                        Icons.login,
                        color: Color(0xFF5B7042),
                        size: 20,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Text(
                          'Masuk',
                          style: TextStyle(
                            fontFamily: 'Plus Jakarta Sans',
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF263023),
                          ),
                        ),
                        SizedBox(height: 2),
                        Text(
                          'Belum tercatat',
                          style: TextStyle(
                            fontFamily: 'Plus Jakarta Sans',
                            fontSize: 11,
                            color: Color(0xFF72786C),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              // Garis Vertikal Pemisah
              Container(
                height: 36,
                width: 1,
                color: const Color(0xFFE5E7EB),
                margin: const EdgeInsets.symmetric(horizontal: 12),
              ),

              // Kolom Pulang
              Expanded(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Image.asset(
                      'assets/icons/icon_logout.png',
                      width: 20,
                      height: 20,
                      errorBuilder: (context, error, stackTrace) => const Icon(
                        Icons.logout,
                        color: Color(0xFF5B7042),
                        size: 20,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Text(
                          'Pulang',
                          style: TextStyle(
                            fontFamily: 'Plus Jakarta Sans',
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF263023),
                          ),
                        ),
                        SizedBox(height: 2),
                        Text(
                          'Belum tercatat',
                          style: TextStyle(
                            fontFamily: 'Plus Jakarta Sans',
                            fontSize: 11,
                            color: Color(0xFF72786C),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 20),

          // Tombol Scan Barcode (Warna 799263 / AAB881, Icon icon_scan.png, Teks 16 Bold)
          SizedBox(
            width: double.infinity,
            height: 48,
            child: ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const ScanBarcodeScreen()),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF799263),
                foregroundColor: Colors.white,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    'assets/icons/icon_scan.png',
                    width: 22,
                    height: 22,
                    color: Colors.white,
                    errorBuilder: (context, error, stackTrace) =>
                        const Icon(Icons.qr_code_scanner, color: Colors.white, size: 22),
                  ),
                  const SizedBox(width: 10),
                  const Text(
                    'Scan Barcode',
                    style: TextStyle(
                      fontFamily: 'Plus Jakarta Sans',
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 12),

          // Keterangan di bawah tombol
          const Center(
            child: Text(
              'Pindai barcode sekolah untuk mencatat\nabsensi masuk atau pulang.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: 'Plus Jakarta Sans',
                fontSize: 11,
                fontWeight: FontWeight.normal,
                height: 1.35,
                color: Color(0xFF72786C),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================================
  // 4. RIWAYAT TERBARU
  // ============================================================================
  Widget _buildRiwayatTerbaru() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Riwayat terbaru',
              style: TextStyle(
                fontFamily: 'Plus Jakarta Sans',
                fontSize: 15,
                fontWeight: FontWeight.bold,
                color: Color(0xFF263023),
              ),
            ),
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const RiwayatAbsensiScreen(),
                  ),
                );
              },
              child: const Text(
                'Lihat semua',
                style: TextStyle(
                  fontFamily: 'Plus Jakarta Sans',
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF72786C),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),

        // List Item Riwayat
        ...riwayatAbsensi.map((r) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 12.0),
            child: Row(
              children: [
                // Icon kalender checklist
                Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    color: const Color(0xFFF3F7E9),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  alignment: Alignment.center,
                  child: Image.asset(
                    'assets/icons/icon_calender_ada_checklis.png',
                    width: 20,
                    height: 20,
                    errorBuilder: (context, error, stackTrace) =>
                        const Icon(Icons.event_available, color: Color(0xFF5B7042), size: 20),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        r['tanggal']!,
                        style: const TextStyle(
                          fontFamily: 'Plus Jakarta Sans',
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF263023),
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        r['jam']!,
                        style: const TextStyle(
                          fontFamily: 'Plus Jakarta Sans',
                          fontSize: 11,
                          color: Color(0xFF72786C),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        }),
      ],
    );
  }
}
