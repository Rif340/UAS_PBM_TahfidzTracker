import 'package:flutter/material.dart';
import 'login_screen.dart';

class OnboardingScreen extends StatelessWidget {
  const OnboardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        // Linear Gradient sesuai Foto 2 Figma: BAC781 (40%) ke 5B613F (0%)
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            stops: [0.0, 1.0],
            colors: [
              Color(0x66BAC781), // #BAC781 dengan Opacity 40% (0x66)
              Color(0x005B613F), // #5B613F dengan Opacity 0% (0x00)
            ],
          ),
        ),
        child: SafeArea(
          bottom: false,
          child: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const SizedBox(height: 36),

                        // 1. Judul Aplikasi: Font Freude
                        const Text(
                          'Tahfizd Tracker',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontFamily: 'Freude',
                            fontSize: 34,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF0F6D44),
                            letterSpacing: 0.5,
                          ),
                        ),

                        const SizedBox(height: 6),

                        // 2. Sub-judul: Font Poppins
                        const Text(
                          'Akses Pembelajaran Kapan Pun dan Dimana Pun',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontFamily: 'Poppins',
                            fontSize: 12,
                            fontWeight: FontWeight.w400,
                            fontStyle: FontStyle.italic,
                            color: Color(0xFF2C3E2D),
                          ),
                        ),

                        const SizedBox(height: 32),

                        // 3. Logo Sekolah At-Taubah
                        Image.asset(
                          'assets/images/Logo_At-Taubah_Karawang.png',
                          height: 220,
                        ),

                        const SizedBox(height: 36),

                        // 4. Masuk Sebagai: Font Plus Jakarta Sans
                        const Text(
                          'Masuk Sebagai',
                          style: TextStyle(
                            fontFamily: 'Plus Jakarta Sans',
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                            color: Color(0xFF202020),
                          ),
                        ),

                        const SizedBox(height: 4),

                        // 5. Pilih peran Anda untuk melanjutkan: Font Poppins
                        const Text(
                          'Pilih peran Anda untuk melanjutkan',
                          style: TextStyle(
                            fontFamily: 'Poppins',
                            fontSize: 12,
                            fontWeight: FontWeight.w400,
                            fontStyle: FontStyle.italic,
                            color: Color(0xFF4A4A4A),
                          ),
                        ),

                        const SizedBox(height: 24),

                        // 6. Tombol Peran (Murid & Guru): Font Kronika
                        Row(
                          children: [
                            // Tombol Murid
                            Expanded(
                              child: _buildRoleButton(
                                label: 'Murid',
                                backgroundColor: const Color(0xFF3F4F46),
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => const LoginScreen(isGuru: false),
                                    ),
                                  );
                                },
                              ),
                            ),
                            const SizedBox(width: 16),
                            // Tombol Guru
                            Expanded(
                              child: _buildRoleButton(
                                label: 'Guru',
                                backgroundColor: const Color(0xFF0F6D44),
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => const LoginScreen(isGuru: true),
                                    ),
                                  );
                                },
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 28),

                        // Belum Memiliki Akun? Daftar Disini ! : Font Poppins
                        Row(
                          children: [
                            const Expanded(child: Divider(color: Color(0xFF6B7280), thickness: 0.8)),
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 10.0),
                              child: RichText(
                                text: const TextSpan(
                                  style: TextStyle(
                                    fontFamily: 'Poppins',
                                    fontSize: 11,
                                    color: Color(0xFF333333),
                                  ),
                                  children: [
                                    TextSpan(text: 'Belum Memiliki Akun? '),
                                    TextSpan(
                                      text: 'Daftar Disini !',
                                      style: TextStyle(
                                        color: Color(0xFF0F6D44),
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            const Expanded(child: Divider(color: Color(0xFF6B7280), thickness: 0.8)),
                          ],
                        ),

                        const SizedBox(height: 18),
                      ],
                    ),
                  ),
                ),
              ),

              // Footer Kubah Melengkung Hijau: Murni kode Flutter (rapat & presisi)
              _buildCurvedFooter(context),
            ],
          ),
        ),
      ),
    );
  }

  // Widget Tombol Murid / Guru dengan Font Kronika
  Widget _buildRoleButton({
    required String label,
    required Color backgroundColor,
    required VoidCallback onPressed,
  }) {
    return Container(
      height: 48,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.18),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: backgroundColor,
          foregroundColor: Colors.white,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),
        ),
        child: Text(
          label,
          style: const TextStyle(
            fontFamily: 'Kronika',
            fontSize: 15,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.3,
          ),
        ),
      ),
    );
  }

  // Footer Kubah Melengkung Hijau (Sempurna & Rapat di bawah tanpa celah)
  Widget _buildCurvedFooter(BuildContext context) {
    return ClipPath(
      clipper: DomeFooterClipper(),
      child: Container(
        width: double.infinity,
        height: 70,
        color: const Color(0xFF0F6D44),
        alignment: Alignment.center,
        padding: const EdgeInsets.only(top: 14),
        child: const Text(
          'Copyright © 2026. Kelompok 3',
          style: TextStyle(
            fontFamily: 'Poppins',
            color: Colors.white,
            fontSize: 12,
            fontWeight: FontWeight.w400,
          ),
        ),
      ),
    );
  }
}

// Clipper untuk menghasilkan kurva kubah yang rapi dari tepi kiri ke kanan
class DomeFooterClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final Path path = Path();
    path.moveTo(0, size.height);
    path.lineTo(0, 28);
    // Membuat lengkungan kurva kubah yang elegan
    path.quadraticBezierTo(size.width / 2, -18, size.width, 28);
    path.lineTo(size.width, size.height);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}