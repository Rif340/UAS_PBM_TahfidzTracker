import 'package:flutter/material.dart';

class CustomBottomNav extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;

  const CustomBottomNav({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 72,
      decoration: const BoxDecoration(
        color: Color(0xFFF2F6FA),
        border: Border(top: BorderSide(color: Color(0xFFE6ECF2), width: 1)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildNavItem(0, 'assets/icons/Icon_Beranda_Yang_Jadi_Tabbar.png', 'Beranda', Icons.home_filled),
          _buildNavItem(1, 'assets/icons/Icon_Tahfizd_Yang_Di_Tabbar.png', 'Tahfizd', Icons.menu_book),
          _buildNavItem(2, 'assets/icons/icon_absensi_yang_jadi_tabbar.png', 'Absensi', Icons.fingerprint),
          _buildNavItem(3, 'assets/icons/Icon_murid_yang_jadi_Tabbar.png', 'Murid', Icons.school_outlined),
        ],
      ),
    );
  }

  Widget _buildNavItem(int index, String assetPath, String label, IconData fallbackIcon) {
    final bool isSelected = currentIndex == index;
    return InkWell(
      onTap: () => onTap(index),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
            decoration: BoxDecoration(
              color: isSelected ? const Color(0xFFD6E4B9) : Colors.transparent,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Image.asset(
              assetPath,
              width: 22,
              height: 22,
              color: isSelected ? const Color(0xFF2C3E2D) : const Color(0xFF6B7280),
              errorBuilder: (context, error, stackTrace) => Icon(
                fallbackIcon,
                size: 22,
                color: isSelected ? const Color(0xFF2C3E2D) : Colors.black54,
              ),
            ),
          ),
          const SizedBox(height: 2),
          Text(
            label,
            style: TextStyle(
              fontFamily: 'Plus Jakarta Sans',
              fontSize: 11,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
              color: isSelected ? const Color(0xFF2C3E2D) : const Color(0xFF6B7280),
            ),
          ),
        ],
      ),
    );
  }
}