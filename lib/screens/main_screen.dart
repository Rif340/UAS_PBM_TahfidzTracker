import 'package:flutter/material.dart';
import 'dashboard_screen.dart';
import 'jadwal_tahfidz_screen.dart';
import 'form_tambah_tahfidz_screen.dart';
import 'form_target_hafalan_screen.dart';
import 'murid_tahfidz_screen.dart';
import 'absensi_guru_screen.dart';
import '../widgets/custom_bottom_nav.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> with SingleTickerProviderStateMixin {
  int _selectedIndex = 0;
  bool _isFabExpanded = false;

  late AnimationController _fabAnimController;
  late Animation<double> _expandAnimation;
  late Animation<double> _rotateAnimation;

  @override
  void initState() {
    super.initState();
    _fabAnimController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 260),
    );
    _expandAnimation = CurvedAnimation(
      parent: _fabAnimController,
      curve: Curves.easeInOutCubic,
    );
    _rotateAnimation = Tween<double>(begin: 0.0, end: 0.125).animate(
      CurvedAnimation(parent: _fabAnimController, curve: Curves.easeInOutCubic),
    );
  }

  @override
  void dispose() {
    _fabAnimController.dispose();
    super.dispose();
  }

  void _toggleFab() {
    setState(() {
      _isFabExpanded = !_isFabExpanded;
      if (_isFabExpanded) {
        _fabAnimController.forward();
      } else {
        _fabAnimController.reverse();
      }
    });
  }

  void _closeFab() {
    if (_isFabExpanded) {
      setState(() {
        _isFabExpanded = false;
        _fabAnimController.reverse();
      });
    }
  }

  void _switchTab(int index) {
    _closeFab();
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> pages = [
      DashboardScreen(onNavigateToTahfidz: () => _switchTab(1)),
      const JadwalTahfidzScreen(),
      const AbsensiGuruScreen(),
      MuridTahfidzScreen(onBack: () => _switchTab(0)),
    ];

    return Scaffold(
      body: Stack(
        children: [
          pages[_selectedIndex],

          // Backdrop transparan jika menu FAB sedang terbuka (klik di luar untuk menutup)
          if (_isFabExpanded)
            GestureDetector(
              onTap: _closeFab,
              behavior: HitTestBehavior.opaque,
              child: Container(
                color: Colors.black.withOpacity(0.08),
              ),
            ),
        ],
      ),
      // Speed Dial Mengambang (Hanya di Tab Tahfidz, Gambar 1)
      floatingActionButton: _selectedIndex == 1 ? _buildFloatingSpeedDial(context) : null,
      bottomNavigationBar: CustomBottomNav(
        currentIndex: _selectedIndex,
        onTap: _switchTab,
      ),
    );
  }

  // Speed Dial Menu Mengambang
  Widget _buildFloatingSpeedDial(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        // 1. Menu Kapsul "Target Hafalan" (Paling Atas)
        ScaleTransition(
          scale: _expandAnimation,
          alignment: Alignment.bottomRight,
          child: Padding(
            padding: const EdgeInsets.only(bottom: 12.0),
            child: _buildDialItem(
              label: 'Target Hafalan',
              onTap: () {
                _closeFab();
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const FormTargetHafalanScreen()),
                );
              },
            ),
          ),
        ),

        // 2. Menu Kapsul "Kelas Tahfizd" (Tengah) ➔ Buka Form Tambah Tahfizd
        ScaleTransition(
          scale: _expandAnimation,
          alignment: Alignment.bottomRight,
          child: Padding(
            padding: const EdgeInsets.only(bottom: 14.0),
            child: _buildDialItem(
              label: 'Kelas Tahfizd',
              onTap: () {
                _closeFab();
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const FormTambahTahfidzScreen()),
                );
              },
            ),
          ),
        ),

        // 3. Tombol FAB Utama (+ berputar jadi X)
        FloatingActionButton(
          onPressed: _toggleFab,
          backgroundColor: const Color(0xFF0F6D44),
          elevation: 4,
          shape: const CircleBorder(),
          child: RotationTransition(
            turns: _rotateAnimation,
            child: Icon(
              _isFabExpanded ? Icons.close : Icons.add,
              color: Colors.white,
              size: 30,
            ),
          ),
        ),
      ],
    );
  }

  // Widget Kapsul Hijau Mengambang (Gambar 1)
  Widget _buildDialItem({required String label, required VoidCallback onTap}) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(24),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          decoration: BoxDecoration(
            color: const Color(0xFF0F6D44),
            borderRadius: BorderRadius.circular(24),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.18),
                blurRadius: 8,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Text(
            label,
            style: const TextStyle(
              fontFamily: 'Plus Jakarta Sans',
              color: Colors.white,
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }
}