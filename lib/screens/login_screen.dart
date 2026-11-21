import 'package:flutter/material.dart';
import 'main_screen.dart';
import 'main_murid_screen.dart';

class LoginScreen extends StatefulWidget {
  final bool isGuru; // true = Guru (NIP), false = Murid (NISN)

  const LoginScreen({super.key, this.isGuru = true});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool isLoginTab = true; // true = Masuk, false = Daftar
  bool rememberMe = false;

  late final TextEditingController _emailController;
  late final TextEditingController _idController;
  final TextEditingController _passwordController =
      TextEditingController(text: '••••••••');

  @override
  void initState() {
    super.initState();
    _emailController = TextEditingController(
      text: widget.isGuru ? 'BelindaBlance@gmail.com' : 'BilalHakim@gmail.com',
    );
    _idController = TextEditingController(
      text: widget.isGuru ? '198705152010011003' : '0001234567',
    );
  }

  @override
  void dispose() {
    _emailController.dispose();
    _idController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final String idLabel = widget.isGuru ? 'NIP' : 'NISN';

    return Scaffold(
      backgroundColor: const Color(0xFFFAFAF7),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // ==========================================
            // BAGIAN ATAS: HEADER GRADIENT (GAMBAR 2)
            // ==========================================
            _buildHeader(context),

            // ==========================================
            // BAGIAN ISI: FORM LOGIN / DAFTAR (GAMBAR 3)
            // ==========================================
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 1. Tab Pilihan Masuk / Daftar dengan animasi geser halus
                  _buildSegmentedTab(),

                  const SizedBox(height: 24),

                  // Area Field Formulir dengan Efek Transisi Halus (Smooth Cross-fade & subtle slide)
                  AnimatedSwitcher(
                    duration: const Duration(milliseconds: 320),
                    switchInCurve: Curves.easeInOutCubic,
                    switchOutCurve: Curves.easeInOutCubic,
                    transitionBuilder: (Widget child, Animation<double> animation) {
                      return FadeTransition(
                        opacity: animation,
                        child: SlideTransition(
                          position: Tween<Offset>(
                            begin: const Offset(0, 0.05),
                            end: Offset.zero,
                          ).animate(animation),
                          child: child,
                        ),
                      );
                    },
                    child: KeyedSubtree(
                      key: ValueKey<bool>(isLoginTab),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // 2. Field Email
                          const Text(
                            'Email :',
                            style: TextStyle(
                              fontFamily: 'Plus Jakarta Sans',
                              fontSize: 13,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF8B9E68),
                            ),
                          ),
                          const SizedBox(height: 6),
                          _buildInputField(
                            controller: _emailController,
                            prefixIcon: Icons.mail_outline_rounded,
                          ),

                          const SizedBox(height: 18),

                          // 3. Field NIP / NISN
                          Text(
                            '$idLabel :',
                            style: const TextStyle(
                              fontFamily: 'Plus Jakarta Sans',
                              fontSize: 13,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF8B9E68),
                            ),
                          ),
                          const SizedBox(height: 6),
                          _buildInputField(
                            controller: _idController,
                          ),

                          const SizedBox(height: 18),

                          // 4. Field Password
                          const Text(
                            'Password :',
                            style: TextStyle(
                              fontFamily: 'Plus Jakarta Sans',
                              fontSize: 13,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF8B9E68),
                            ),
                          ),
                          const SizedBox(height: 6),
                          _buildInputField(
                            controller: _passwordController,
                            isPassword: true,
                          ),

                          const SizedBox(height: 14),

                          // 5. Checkbox Ingat Saya & Lupa Sandi
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  SizedBox(
                                    width: 22,
                                    height: 22,
                                    child: Checkbox(
                                      value: rememberMe,
                                      activeColor: const Color(0xFF708855),
                                      side: const BorderSide(color: Color(0xFFB5C39E), width: 1.5),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(5),
                                      ),
                                      onChanged: (val) {
                                        setState(() {
                                          rememberMe = val ?? false;
                                        });
                                      },
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  const Text(
                                    'Ingat Saya',
                                    style: TextStyle(
                                      fontFamily: 'Plus Jakarta Sans',
                                      fontSize: 12,
                                      color: Color(0xFF9E9E9E),
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                              TextButton(
                                onPressed: () {},
                                style: TextButton.styleFrom(padding: EdgeInsets.zero),
                                child: Text(
                                  isLoginTab ? 'Lupa Sandi?' : 'Bantuan',
                                  style: const TextStyle(
                                    fontFamily: 'Plus Jakarta Sans',
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFF708855),
                                  ),
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(height: 16),

                          // 6. Tombol Utama (Masuk / Daftar) ➔ Navigasi ke Dashboard
                          SizedBox(
                            width: double.infinity,
                            height: 48,
                            child: ElevatedButton(
                              onPressed: () {
                                // Masuk ke Halaman Utama Guru atau Murid
                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => widget.isGuru
                                        ? const MainScreen()
                                        : const MainMuridScreen(),
                                  ),
                                );
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF718956),
                                foregroundColor: Colors.white,
                                elevation: 0,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                              child: Text(
                                isLoginTab ? 'Masuk' : 'Daftar',
                                style: const TextStyle(
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

                  const SizedBox(height: 22),

                  // 7. Garis Pembatas "atau"
                  Row(
                    children: const [
                      Expanded(child: Divider(color: Color(0xFF4A4A4A), thickness: 0.8)),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 14.0),
                        child: Text(
                          'atau',
                          style: TextStyle(
                            fontFamily: 'Plus Jakarta Sans',
                            fontSize: 12,
                            color: Color(0xFF333333),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      Expanded(child: Divider(color: Color(0xFF4A4A4A), thickness: 0.8)),
                    ],
                  ),

                  const SizedBox(height: 20),

                  // 8. Tombol Lanjutkan Dengan Google
                  SizedBox(
                    width: double.infinity,
                    height: 48,
                    child: OutlinedButton(
                      onPressed: () {},
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: Color(0xFFD6DEC9), width: 1.2),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        backgroundColor: Colors.white,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          // Ikon Google
                          Image.network(
                            'https://upload.wikimedia.org/wikipedia/commons/thumb/c/c1/Google_%22G%22_logo.svg/120px-Google_%22G%22_logo.svg.png',
                            height: 20,
                            errorBuilder: (context, error, stackTrace) =>
                                const Icon(Icons.g_mobiledata, color: Colors.red, size: 24),
                          ),
                          const SizedBox(width: 10),
                          const Text(
                            'Lanjutkan Dengan Google',
                            style: TextStyle(
                              fontFamily: 'Plus Jakarta Sans',
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF202020),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 24),

                  // 9. Bawah: Tidak Punya Akun? / Sudah Punya Akun?
                  Center(
                    child: InkWell(
                      onTap: () {
                        setState(() {
                          isLoginTab = !isLoginTab;
                        });
                      },
                      child: RichText(
                        text: TextSpan(
                          style: const TextStyle(
                            fontFamily: 'Plus Jakarta Sans',
                            fontSize: 12,
                            color: Color(0xFF9E9E9E),
                            fontWeight: FontWeight.w500,
                          ),
                          children: [
                            TextSpan(
                              text: isLoginTab
                                  ? 'Tidak Punya Akun? '
                                  : 'Sudah Punya Akun? ',
                            ),
                            TextSpan(
                              text: isLoginTab ? 'Daftar' : 'Masuk',
                              style: const TextStyle(
                                color: Color(0xFF708855),
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Header Melengkung Hijau Atas (Gambar 2)
  Widget _buildHeader(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.only(top: 16, left: 20, right: 20, bottom: 32),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Color(0xFFB5C384),
            Color(0xFF6E8150),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(36),
          bottomRight: Radius.circular(36),
        ),
      ),
      child: SafeArea(
        bottom: false,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Tombol Kembali di kiri
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
                child: const Icon(
                  Icons.arrow_back_ios_new,
                  color: Colors.white,
                  size: 18,
                ),
              ),
            ),
            const SizedBox(width: 14),

            // Teks Judul dan Subjudul di sebelah kanan tombol back
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text(
                    'Jaga Hafalanmu\nRaih Berkahmu',
                    style: TextStyle(
                      fontFamily: 'Plus Jakarta Sans',
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      height: 1.25,
                    ),
                  ),
                  SizedBox(height: 6),
                  Text(
                    'Pantau progres hafalan dan murojaah\nAl-Qur\'anmu di sini.',
                    style: TextStyle(
                      fontFamily: 'Plus Jakarta Sans',
                      color: Colors.white70,
                      fontSize: 11,
                      height: 1.3,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Segmented Tab Masuk & Daftar dengan animasi geser mulus
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
          final double tabWidth = (constraints.maxWidth) / 2;
          return Stack(
            children: [
              // Background Putih yang Meluncur Halus (Sliding Indicator)
              AnimatedAlign(
                duration: const Duration(milliseconds: 260),
                curve: Curves.easeInOutCubic,
                alignment: isLoginTab ? Alignment.centerLeft : Alignment.centerRight,
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

              // Tombol Teks Masuk & Daftar
              Row(
                children: [
                  Expanded(
                    child: InkWell(
                      onTap: () {
                        if (!isLoginTab) setState(() => isLoginTab = true);
                      },
                      borderRadius: BorderRadius.circular(9),
                      child: Center(
                        child: AnimatedDefaultTextStyle(
                          duration: const Duration(milliseconds: 200),
                          style: TextStyle(
                            fontFamily: 'Plus Jakarta Sans',
                            fontSize: 13,
                            fontWeight: isLoginTab ? FontWeight.bold : FontWeight.w500,
                            color: isLoginTab ? const Color(0xFF2C3E2D) : const Color(0xFF8E9B85),
                          ),
                          child: const Text('Masuk'),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: InkWell(
                      onTap: () {
                        if (isLoginTab) setState(() => isLoginTab = false);
                      },
                      borderRadius: BorderRadius.circular(9),
                      child: Center(
                        child: AnimatedDefaultTextStyle(
                          duration: const Duration(milliseconds: 200),
                          style: TextStyle(
                            fontFamily: 'Plus Jakarta Sans',
                            fontSize: 13,
                            fontWeight: !isLoginTab ? FontWeight.bold : FontWeight.w500,
                            color: !isLoginTab ? const Color(0xFF2C3E2D) : const Color(0xFF8E9B85),
                          ),
                          child: const Text('Daftar'),
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

  // Input Field Container
  Widget _buildInputField({
    required TextEditingController controller,
    IconData? prefixIcon,
    bool isPassword = false,
  }) {
    return Container(
      height: 48,
      padding: const EdgeInsets.symmetric(horizontal: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: const Color(0xFFD6DEC9), width: 1.2),
      ),
      child: Row(
        children: [
          if (prefixIcon != null) ...[
            Icon(prefixIcon, color: const Color(0xFFB5C39E), size: 20),
            const SizedBox(width: 10),
          ],
          Expanded(
            child: TextField(
              controller: controller,
              obscureText: isPassword,
              style: const TextStyle(
                fontFamily: 'Plus Jakarta Sans',
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: Color(0xFF4A4A4A),
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
    );
  }
}
