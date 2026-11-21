import 'package:flutter/material.dart';
import '../widgets/class_card.dart';
import 'riwayat_absensi_screen.dart';
import 'form_target_hafalan_screen.dart';
import 'murid_tahfidz_screen.dart';
import 'detail_kelas_screen.dart';

class DashboardScreen extends StatelessWidget {
  final VoidCallback onNavigateToTahfidz;

  const DashboardScreen({super.key, required this.onNavigateToTahfidz});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          // BAGIAN ATAS: HEADER GRADIENT DENGAN FOTO PROFIL ASLI (GAMBAR 3)
          _buildHeader(context),

          // BAGIAN ISI: KONTEN LENGKAP (GAMBAR 4)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 1. KELAS BERIKUTNYA
                const Text(
                  'Kelas berikutnya',
                  style: TextStyle(
                    fontFamily: 'Plus Jakarta Sans',
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF2C3E2D),
                  ),
                ),
                const SizedBox(height: 12),
                ClassCard(
                  kelas: 'Tahfizd',
                  subKelas: 'Kelas 6A',
                  waktu: 'Selasa, 07.00–10.00',
                  guru: 'Belinda Blanche',
                  buttonLabel: 'Lihat kelas',
                  onButtonPressed: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const DetailKelasScreen()),
                  ),
                ),

                const SizedBox(height: 24),

                // 2. AKSI CEPAT DENGAN IKON ASLI DARI ASSETS
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
                _buildQuickActions(context),

                const SizedBox(height: 16),

                // 3. MENU PINTASAN DENGAN IKON ASLI DARI ASSETS
                Row(
                  children: [
                    Expanded(
                      child: InkWell(
                        onTap: onNavigateToTahfidz,
                        borderRadius: BorderRadius.circular(16),
                        child: _buildShortMenu(
                          assetIcon: 'assets/icons/Icon_Buku.png',
                          fallbackIcon: Icons.menu_book_outlined,
                          title: 'Tahfidz',
                          subtitle: 'Daftar kelas',
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: InkWell(
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => MuridTahfidzScreen(onBack: () => Navigator.pop(context)),
                          ),
                        ),
                        borderRadius: BorderRadius.circular(16),
                        child: _buildShortMenu(
                          assetIcon: 'assets/icons/Icon_Topi_Wisuda_Yang_Dibawah_Dari_Aksi_Cepat.png',
                          fallbackIcon: Icons.school_outlined,
                          title: 'Siswa',
                          subtitle: 'Kelola Siswa',
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 24),

                // 4. AKTIVITAS TAHFIDZ
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Aktivitas tahfidz',
                      style: TextStyle(
                        fontFamily: 'Plus Jakarta Sans',
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF2C3E2D),
                      ),
                    ),
                    GestureDetector(
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const RiwayatAbsensiScreen()),
                      ),
                      child: const Text(
                        'Jelajahi ringkasan',
                        style: TextStyle(
                          fontFamily: 'Plus Jakarta Sans',
                          fontSize: 12,
                          color: Colors.black45,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                _buildActivityCard(),

                const SizedBox(height: 90), // Ruang agar tidak terpotong navbar
              ],
            ),
          ),
        ],
      ),
    );
  }

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
            Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text(
                    'LMS AI - Taubah',
                    style: TextStyle(
                      fontFamily: 'Plus Jakarta Sans',
                      color: Colors.white70,
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    'Hai, Belinda Blanche!',
                    style: TextStyle(
                      fontFamily: 'Plus Jakarta Sans',
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    'Siap mendampingi belajar hari ini?',
                    style: TextStyle(
                      fontFamily: 'Plus Jakarta Sans',
                      color: Colors.white70,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
              // Foto Profil Asli Belinda Blanche
              ClipOval(
                child: Image.asset(
                  'assets/images/Foto_Belinda_Blanche_Di_Card_Kelas.png',
                  width: 52,
                  height: 52,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) =>
                      const CircleAvatar(radius: 26, backgroundColor: Colors.white30),
                ),
              ),
            ],
          ),
        ],
      ),
      ),
    );
  }

  Widget _buildQuickActions(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        _buildActionItem(
          assetIcon: 'assets/icons/Icon_Calender.png',
          fallbackIcon: Icons.calendar_month_outlined,
          title: 'Riwayat\nAbsensi',
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const RiwayatAbsensiScreen()),
          ),
        ),
        _buildActionItem(
          assetIcon: 'assets/icons/Icon_Profile.png',
          fallbackIcon: Icons.account_circle_outlined,
          title: 'Perbarui\nProfile',
          onTap: () => ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Fitur Perbarui Profile segera hadir')),
          ),
        ),
        _buildActionItem(
          assetIcon: 'assets/icons/icon_panah_target.png',
          fallbackIcon: Icons.track_changes_outlined,
          title: 'Membuat\nTarget Hafalan',
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const FormTargetHafalanScreen()),
          ),
        ),
      ],
    );
  }

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
            width: 60,
            height: 60,
            decoration: const BoxDecoration(
              color: Color(0xFFAAB881),
              shape: BoxShape.circle,
            ),
            alignment: Alignment.center,
            child: Image.asset(
              assetIcon,
              width: 30,
              height: 30,
              color: Colors.white,
              errorBuilder: (context, error, stackTrace) =>
                  Icon(fallbackIcon, color: Colors.white, size: 28),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            title,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontFamily: 'Plus Jakarta Sans',
              fontSize: 11,
              color: Color(0xFF333333),
              fontWeight: FontWeight.w600,
              height: 1.25,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildShortMenu({
    required String assetIcon,
    required IconData fallbackIcon,
    required String title,
    required String subtitle,
  }) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFFEFF3E8),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Image.asset(
            assetIcon,
            width: 24,
            height: 24,
            color: const Color(0xFF5B6E3F),
            errorBuilder: (context, error, stackTrace) =>
                Icon(fallbackIcon, color: const Color(0xFF5B6E3F), size: 24),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontFamily: 'Plus Jakarta Sans',
                    fontWeight: FontWeight.bold,
                    fontSize: 13,
                    color: Color(0xFF2C3E2D),
                  ),
                ),
                Text(
                  subtitle,
                  style: const TextStyle(
                    fontFamily: 'Plus Jakarta Sans',
                    fontSize: 10,
                    color: Colors.black45,
                  ),
                ),
              ],
            ),
          ),
          const Icon(Icons.arrow_forward_ios, size: 12, color: Color(0xFF5B6E3F)),
        ],
      ),
    );
  }

  Widget _buildActivityCard() {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE2E7D8)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: const Color(0xFFF1F5E9),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(Icons.edit_note_rounded, color: Color(0xFF6F824E), size: 24),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text(
                  'Pendampingan hafalan',
                  style: TextStyle(
                    fontFamily: 'Plus Jakarta Sans',
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF2C3E2D),
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  'Tinjau setoran dan catatan murajaah melalui Tahfidz.',
                  style: TextStyle(
                    fontFamily: 'Plus Jakarta Sans',
                    fontSize: 10,
                    color: Colors.black45,
                  ),
                ),
              ],
            ),
          ),
          const Icon(Icons.arrow_forward_ios, size: 13, color: Colors.black38),
        ],
      ),
    );
  }
}