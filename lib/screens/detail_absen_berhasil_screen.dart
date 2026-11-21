import 'package:flutter/material.dart';

class DetailAbsenBerhasilScreen extends StatelessWidget {
  final bool isMurid;
  final String nama;
  final String kelas;

  const DetailAbsenBerhasilScreen({
    super.key,
    this.isMurid = false,
    this.nama = 'Belinda Blanche, S.Kom',
    this.kelas = 'Kelas 6A',
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFAFBF8),
      body: Stack(
        children: [
          // 1. KONTEN YANG DAPAT DI-SCROLL
          SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // BAGIAN ATAS: HEADER HIJAU MELENGKUNG (GAMBAR 2 & 4)
                _buildHeader(context),

                const SizedBox(height: 20),

                // BAGIAN TENGAH / ISI: CARD SDIT AT-TAUBAH & CARD RINGKASAN ABSENSI (GAMBAR 4)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0),
                  child: Column(
                    children: [
                      // CARD SDIT AT-TAUBAH (GAMBAR 4 ATAS)
                      _buildSekolahCard(),

                      const SizedBox(height: 18),

                      // CARD RINGKASAN ABSENSI (GAMBAR 4 BAWAH)
                      _buildRingkasanAbsensiCard(),
                    ],
                  ),
                ),

                // Spasi bawah agar tidak tertutup sticky footer
                const SizedBox(height: 110),
              ],
            ),
          ),

          // 2. BAGIAN BAWAH: STICKY FOOTER "Kembali ke Beranda" (GAMBAR 4)
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
                    color: Colors.black.withOpacity(0.06),
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
                    // Kembali langsung ke halaman awal / beranda
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
  // BAGIAN ATAS: HEADER HIJAU (GAMBAR 2 & 4)
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
            // Bar Tombol Kembali + Judul "Absen Telah Berhasil"
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
              const Expanded(
                child: Text(
                  'Absen Telah\nBerhasil',
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
              const SizedBox(width: 38), // Counterbalance icon back
            ],
          ),

          const SizedBox(height: 12),

          // Subjudul Header:
          // "Absensi Anda telah berhasil dicatat. Terima kasih telah melakukan absensi."
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.0),
            child: Text(
              'Absensi Anda telah berhasil dicatat. Terima kasih\ntelah melakukan absensi.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: 'Plus Jakarta Sans',
                color: Colors.white,
                fontSize: 11.5,
                fontWeight: FontWeight.w400,
                height: 1.35,
              ),
            ),
          ),
        ],
      ),
    ),
    );
  }

  // ============================================================================
  // CARD SDIT AT-TAUBAH (GAMBAR 4 ATAS)
  // Untuk Murid: Labelnya "Kelas Tahfizd", untuk Guru: "Kelas yang diajar"
  // ============================================================================
  Widget _buildSekolahCard() {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFFE6EBDD), width: 1.2),
      ),
      child: Column(
        children: [
          // Bagian Header Atas Card (Hijau Gradasi)
          Container(
            padding: const EdgeInsets.all(16),
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(17),
                topRight: Radius.circular(17),
              ),
              gradient: LinearGradient(
                colors: [Color(0xFFBAC781), Color(0xFF799263)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Box Icon School
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.25),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  alignment: Alignment.center,
                  child: Image.asset(
                    'assets/icons/icon_school.png',
                    width: 24,
                    height: 24,
                    color: Colors.white,
                    errorBuilder: (context, error, stackTrace) =>
                        const Icon(Icons.account_balance, color: Colors.white, size: 24),
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Text(
                        'SDIT At-Taubah',
                        style: TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        'Jl. KH. Ahmad Dahlan No. E/4 Kaum 1, Kelurahan Karawang Kulon, Kecamatan Karawang Barat, Kabupaten Karawang, Jawa Barat.',
                        style: TextStyle(
                          fontFamily: 'Plus Jakarta Sans',
                          fontSize: 11,
                          height: 1.35,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Bagian Bawah Card (Waktu Masuk & Kelas)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            child: Row(
              children: [
                // Kolom Waktu Masuk
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Text(
                        'Waktu masuk',
                        style: TextStyle(
                          fontFamily: 'Plus Jakarta Sans',
                          fontSize: 12,
                          color: Color(0xFF72786C),
                        ),
                      ),
                      SizedBox(height: 3),
                      Text(
                        '06:55 WIB',
                        style: TextStyle(
                          fontFamily: 'Plus Jakarta Sans',
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF263023),
                        ),
                      ),
                    ],
                  ),
                ),

                // Garis Pembatas Vertikal
                Container(
                  width: 1,
                  height: 32,
                  color: const Color(0xFFE5E7EB),
                  margin: const EdgeInsets.symmetric(horizontal: 12),
                ),

                // Kolom Kelas Tahfizd (Murid) / Kelas yang diajar (Guru)
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        isMurid ? 'Kelas Tahfizd' : 'Kelas yang diajar',
                        style: const TextStyle(
                          fontFamily: 'Plus Jakarta Sans',
                          fontSize: 12,
                          color: Color(0xFF72786C),
                        ),
                      ),
                      const SizedBox(height: 3),
                      Text(
                        kelas,
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
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================================
  // CARD RINGKASAN ABSENSI (GAMBAR 4 BAWAH)
  // Untuk Murid: "Nama Lengkap" Bilal Hakim (tanpa baris Lokasi di Gambar 4)
  // ============================================================================
  Widget _buildRingkasanAbsensiCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFFE6EBDD), width: 1.2),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header Card: Ringkasan Absensi & Badge "Hadir"
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Ringkasan Absensi',
                style: TextStyle(
                  fontFamily: 'Plus Jakarta Sans',
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF8BA061),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                decoration: BoxDecoration(
                  color: const Color(0xFFA6BA79),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Text(
                  'Hadir',
                  style: TextStyle(
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

          _buildDataRow(isMurid ? 'Nama Lengkap' : 'Nama Guru', nama),
          const SizedBox(height: 12),
          _buildDataRow('Tanggal', 'Selasa, 6 Oktober 2026'),
          const SizedBox(height: 12),
          _buildDataRow('Waktu', '06:55 WIB'),
          const SizedBox(height: 12),
          _buildDataRow('Jenis Absen', 'Absen Masuk'),
          const SizedBox(height: 12),

          // Jika Guru, tampilkan detail lokasi
          if (!isMurid) ...[
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text(
                  'Lokasi',
                  style: TextStyle(
                    fontFamily: 'Plus Jakarta Sans',
                    fontSize: 12.5,
                    color: Color(0xFF72786C),
                  ),
                ),
                SizedBox(width: 16),
                Expanded(
                  child: Text(
                    'Jl. KH. Ahmad Dahlan No. E/4 Kaum 1, Kelurahan Karawang Kulon, Kecamatan Karawang Barat, Kabupaten Karawang, Jawa Barat.',
                    textAlign: TextAlign.right,
                    style: TextStyle(
                      fontFamily: 'Plus Jakarta Sans',
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      height: 1.35,
                      color: Color(0xFF263023),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 14),
          ],

          // Row Status: Hadir / Tepat Waktu
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: const [
              Text(
                'Status',
                style: TextStyle(
                  fontFamily: 'Plus Jakarta Sans',
                  fontSize: 12.5,
                  color: Color(0xFF72786C),
                ),
              ),
              Text(
                'Hadir / Tepat Waktu',
                style: TextStyle(
                  fontFamily: 'Plus Jakarta Sans',
                  fontSize: 12.5,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF8BA061),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDataRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontFamily: 'Plus Jakarta Sans',
            fontSize: 12.5,
            color: Color(0xFF72786C),
          ),
        ),
        Text(
          value,
          style: const TextStyle(
            fontFamily: 'Plus Jakarta Sans',
            fontSize: 12.5,
            fontWeight: FontWeight.bold,
            color: Color(0xFF263023),
          ),
        ),
      ],
    );
  }
}
