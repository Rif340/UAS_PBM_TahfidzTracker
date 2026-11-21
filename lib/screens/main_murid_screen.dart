import 'package:flutter/material.dart';
import 'scan_barcode_screen.dart';
import 'riwayat_absensi_screen.dart';
import 'detail_siswa_screen.dart';
import 'cetak_rekap_pdf_screen.dart';

class MainMuridScreen extends StatefulWidget {
  const MainMuridScreen({super.key});

  @override
  State<MainMuridScreen> createState() => _MainMuridScreenState();
}

class _MainMuridScreenState extends State<MainMuridScreen> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFAFAF7),
      body: _selectedIndex == 0
          ? _DashboardMuridContent(
              onNavigateToAbsensi: () => setState(() => _selectedIndex = 1),
            )
          : const ScanBarcodeScreen(isMurid: true),
      bottomNavigationBar: _buildMuridBottomNav(),
    );
  }

  // ============================================================================
  // BOTTOM NAVIGATION BAR MURID (HANYA 2 TAB: Beranda & Absensi - GAMBAR 3)
  // ============================================================================
  Widget _buildMuridBottomNav() {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFF3F5FA),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 10,
            offset: const Offset(0, -3),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildNavItem(
                index: 0,
                label: 'Beranda',
                iconPath: 'assets/icons/Icon_Beranda_Yang_Jadi_Tabbar.png',
                fallbackIcon: Icons.home_rounded,
              ),
              _buildNavItem(
                index: 1,
                label: 'Absensi',
                iconPath: 'assets/icons/icon_absensi_yang_jadi_tabbar.png',
                fallbackIcon: Icons.fingerprint_rounded,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem({
    required int index,
    required String label,
    required String iconPath,
    required IconData fallbackIcon,
  }) {
    final isSelected = _selectedIndex == index;

    return GestureDetector(
      onTap: () => setState(() => _selectedIndex = index),
      behavior: HitTestBehavior.opaque,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 6),
            decoration: BoxDecoration(
              color: isSelected ? const Color(0xFFD6E2B3) : Colors.transparent,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Image.asset(
              iconPath,
              width: 24,
              height: 24,
              color: isSelected ? const Color(0xFF2C3E2D) : const Color(0xFF5A6658),
              errorBuilder: (context, error, stackTrace) => Icon(
                fallbackIcon,
                size: 24,
                color: isSelected ? const Color(0xFF2C3E2D) : const Color(0xFF5A6658),
              ),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              fontFamily: 'Plus Jakarta Sans',
              fontSize: 12,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
              color: isSelected ? const Color(0xFF2C3E2D) : const Color(0xFF6B7280),
            ),
          ),
        ],
      ),
    );
  }
}

// ============================================================================
// KONTEN DASHBOARD MURID (GAMBAR 3)
// ============================================================================
class _DashboardMuridContent extends StatelessWidget {
  final VoidCallback onNavigateToAbsensi;

  const _DashboardMuridContent({required this.onNavigateToAbsensi});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 1. BAGIAN ATAS: HEADER HIJAU DENGAN NAMA BILAL HAKIM (GAMBAR 3)
          _buildHeader(context),

          const SizedBox(height: 20),

          // 2. BAGIAN TENGAH / ISI
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // SUBJUDUL: Aksi Cepat
                const Text(
                  'Aksi Cepat',
                  style: TextStyle(
                    fontFamily: 'Plus Jakarta Sans',
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF2C3E2D),
                  ),
                ),
                const SizedBox(height: 16),

                // 3 IKON AKSI CEPAT: Riwayat Absensi, Pantau Akun Mu, Cek Hafalan Mu
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    // Aksi 1: Riwayat Absensi ➔ Buka RiwayatAbsensiScreen
                    _buildActionItem(
                      assetIcon: 'assets/icons/Icon_Calender.png',
                      fallbackIcon: Icons.calendar_month_outlined,
                      title: 'Riwayat\nAbsensi',
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const RiwayatAbsensiScreen(nama: 'Bilal Hakim'),
                          ),
                        );
                      },
                    ),

                    // Aksi 2: Pantau Akun Mu ➔ Buka DetailSiswaScreen (Detail Murid Tahfizd)
                    _buildActionItem(
                      assetIcon: 'assets/icons/Icon_Profile.png',
                      fallbackIcon: Icons.account_circle_outlined,
                      title: 'Pantau\nAkun Mu',
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const DetailSiswaScreen(
                              siswa: {
                                'nama': 'Bilal Hakim',
                                'surat': 'An-Naba, ayat 22/40',
                                'inisial': 'BH',
                              },
                            ),
                          ),
                        );
                      },
                    ),

                    // Aksi 3: Cek Hafalan Mu ➔ Buka CetakRekapPdfScreen
                    _buildActionItem(
                      assetIcon: 'assets/icons/Icon_Buku.png',
                      fallbackIcon: Icons.menu_book_outlined,
                      title: 'Cek\nHafalan Mu',
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const CetakRekapPdfScreen(),
                          ),
                        );
                      },
                    ),
                  ],
                ),

                const SizedBox(height: 24),

                // SUBJUDUL: Daftar Kelas
                const Text(
                  'Daftar Kelas',
                  style: TextStyle(
                    fontFamily: 'Plus Jakarta Sans',
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF2C3E2D),
                  ),
                ),
                const SizedBox(height: 14),

                // CARD KELAS TAHFIZD (GAMBAR 3)
                _buildCardKelas(context),

                const SizedBox(height: 36),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================================
  // HEADER DASHBOARD MURID (GAMBAR 3)
  // "LMS AI - Taubah", "Hai, Bilal Hakim!", "Siap Belajar belajar hari ini?", Avatar "BH"
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
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Salam & Avatar BH
            Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text(
                    'LMS At-Taubah',
                    style: TextStyle(
                      fontFamily: 'Plus Jakarta Sans',
                      color: Colors.white70,
                      fontSize: 11,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    'Hai, Bilal Hakim!',
                    style: TextStyle(
                      fontFamily: 'Plus Jakarta Sans',
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    'Siap Belajar belajar hari ini?',
                    style: TextStyle(
                      fontFamily: 'Plus Jakarta Sans',
                      color: Colors.white70,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
              // Avatar Bulat Inisial BH
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: const Color(0xFFDCE7C7),
                  borderRadius: BorderRadius.circular(24),
                ),
                alignment: Alignment.center,
                child: const Text(
                  'BH',
                  style: TextStyle(
                    fontFamily: 'Plus Jakarta Sans',
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF465635),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    ),
    );
  }

  // ============================================================================
  // ITEM AKSI CEPAT
  // ============================================================================
  Widget _buildActionItem({
    required String assetIcon,
    required IconData fallbackIcon,
    required String title,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            width: 58,
            height: 58,
            decoration: BoxDecoration(
              color: const Color(0xFFB4C385),
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFFB4C385).withOpacity(0.3),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            alignment: Alignment.center,
            child: Image.asset(
              assetIcon,
              width: 26,
              height: 26,
              color: const Color(0xFF3B4833),
              errorBuilder: (context, error, stackTrace) => Icon(
                fallbackIcon,
                color: const Color(0xFF3B4833),
                size: 26,
              ),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            title,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontFamily: 'Plus Jakarta Sans',
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: Color(0xFF333333),
              height: 1.25,
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================================
  // CARD KELAS TAHFIZD (GAMBAR 3)
  // ============================================================================
  Widget _buildCardKelas(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFDFE4D5), width: 1.2),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          // Bagian Header Card (Hijau Gradasi)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(15),
                topRight: Radius.circular(15),
              ),
              gradient: LinearGradient(
                colors: [Color(0xFFBAC781), Color(0xFF799263)],
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text(
                      'Tahfizd',
                      style: TextStyle(
                        fontFamily: 'Plus Jakarta Sans',
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      'Kelas 6A',
                      style: TextStyle(
                        fontFamily: 'Plus Jakarta Sans',
                        fontSize: 13,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(height: 2),
                    Text(
                      'Selasa, 07.00 – 10.00',
                      style: TextStyle(
                        fontFamily: 'Plus Jakarta Sans',
                        fontSize: 12,
                        color: Colors.white70,
                      ),
                    ),
                  ],
                ),
                // Icon Topi Wisuda
                Image.asset(
                  'assets/icons/Icon_Topi_Wisuda_Yang_Dibawah_Dari_Aksi_Cepat.png',
                  width: 52,
                  height: 52,
                  color: Colors.white,
                  errorBuilder: (context, error, stackTrace) =>
                      const Icon(Icons.school, size: 48, color: Colors.white),
                ),
              ],
            ),
          ),

          // Bagian Footer Card: Guru Pengampu & Tombol Pergi
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Row(
              children: [
                ClipOval(
                  child: Image.asset(
                    'assets/images/Foto_Belinda_Blanche_Di_Card_Kelas.png',
                    width: 40,
                    height: 40,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) =>
                        const CircleAvatar(radius: 20, backgroundColor: Colors.black26),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Text(
                        'Guru Pengampu:',
                        style: TextStyle(
                          fontFamily: 'Plus Jakarta Sans',
                          fontSize: 11,
                          color: Color(0xFF72786C),
                        ),
                      ),
                      SizedBox(height: 2),
                      Text(
                        'Belinda Blanche, S.Kom',
                        style: TextStyle(
                          fontFamily: 'Plus Jakarta Sans',
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF263023),
                        ),
                      ),
                    ],
                  ),
                ),
                // Tombol Pergi
                Container(
                  height: 32,
                  decoration: BoxDecoration(
                    color: const Color(0xFF799263),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const DetailSiswaScreen(
                            siswa: {
                              'nama': 'Bilal Hakim',
                              'surat': 'An-Naba, ayat 22/40',
                              'inisial': 'BH',
                            },
                          ),
                        ),
                      );
                    },
                    style: TextButton.styleFrom(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 0),
                      minimumSize: Size.zero,
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    ),
                    child: const Text(
                      'Pergi',
                      style: TextStyle(
                        fontFamily: 'Plus Jakarta Sans',
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
