import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'detail_absen_berhasil_screen.dart';

class ScanBarcodeScreen extends StatefulWidget {
  final bool isMurid;

  const ScanBarcodeScreen({
    super.key,
    this.isMurid = false,
  });

  @override
  State<ScanBarcodeScreen> createState() => _ScanBarcodeScreenState();
}

class _ScanBarcodeScreenState extends State<ScanBarcodeScreen> {
  final MobileScannerController _scannerController = MobileScannerController(
    detectionSpeed: DetectionSpeed.noDuplicates,
    facing: CameraFacing.back,
  );

  bool _isNavigating = false;

  @override
  void dispose() {
    _scannerController.dispose();
    super.dispose();
  }

  void _onDetect(BarcodeCapture capture) {
    if (_isNavigating) return;
    final List<Barcode> barcodes = capture.barcodes;
    if (barcodes.isNotEmpty) {
      _isNavigating = true;
      _navigateToSuccess();
    }
  }

  void _navigateToSuccess() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => DetailAbsenBerhasilScreen(
          isMurid: widget.isMurid,
          nama: widget.isMurid ? 'Bilal Hakim' : 'Belinda Blanche, S.Kom',
          kelas: 'Kelas 6A',
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          // 1. KAMERA LIVE DENGAN MOBILE SCANNER
          Positioned.fill(
            child: MobileScanner(
              controller: _scannerController,
              onDetect: _onDetect,
              errorBuilder: (context, error) {
                // Tampilan fallback jika kamera tidak tersedia / error di emulator
                return Container(
                  color: const Color(0xFF1E2419),
                  alignment: Alignment.center,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.camera_alt_outlined, size: 64, color: Colors.white.withOpacity(0.4)),
                      const SizedBox(height: 12),
                      Text(
                        'Kamera aktif atau mode preview emulator',
                        style: TextStyle(
                          fontFamily: 'Plus Jakarta Sans',
                          color: Colors.white.withOpacity(0.6),
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),

          // 2. OVERLAY FRAME SCANNER DENGAN KOTAK PUTIH & SCANNING LINE
          Center(
            child: SizedBox(
              width: 280,
              height: 280,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  // Teks "Scanning..." di bagian bawah kotak scan
                  Positioned(
                    bottom: 20,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.6),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Text(
                        'Scanning...',
                        style: TextStyle(
                          fontFamily: 'Plus Jakarta Sans',
                          color: Color(0xFF67B7D1),
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),

                  // 4 Sudut Garis Putih Scanner (Corner Border Lines)
                  // Kiri Atas
                  Positioned(
                    top: 0,
                    left: 0,
                    child: Container(
                      width: 40,
                      height: 40,
                      decoration: const BoxDecoration(
                        border: Border(
                          top: BorderSide(color: Colors.white, width: 4.5),
                          left: BorderSide(color: Colors.white, width: 4.5),
                        ),
                      ),
                    ),
                  ),
                  // Kanan Atas
                  Positioned(
                    top: 0,
                    right: 0,
                    child: Container(
                      width: 40,
                      height: 40,
                      decoration: const BoxDecoration(
                        border: Border(
                          top: BorderSide(color: Colors.white, width: 4.5),
                          right: BorderSide(color: Colors.white, width: 4.5),
                        ),
                      ),
                    ),
                  ),
                  // Kiri Bawah
                  Positioned(
                    bottom: 0,
                    left: 0,
                    child: Container(
                      width: 40,
                      height: 40,
                      decoration: const BoxDecoration(
                        border: Border(
                          bottom: BorderSide(color: Colors.white, width: 4.5),
                          left: BorderSide(color: Colors.white, width: 4.5),
                        ),
                      ),
                    ),
                  ),
                  // Kanan Bawah
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: Container(
                      width: 40,
                      height: 40,
                      decoration: const BoxDecoration(
                        border: Border(
                          bottom: BorderSide(color: Colors.white, width: 4.5),
                          right: BorderSide(color: Colors.white, width: 4.5),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // 3. BAGIAN ATAS: HEADER HIJAU MELENGKUNG (GAMBAR 1)
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: Container(
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
                    // Row Tombol Kembali & Judul "Absensi"
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
                            child: const Icon(Icons.chevron_left, color: Colors.white, size: 24),
                          ),
                        ),
                      ),
                      const Expanded(
                        child: Text(
                          'Absensi',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontFamily: 'Plus Jakarta Sans',
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const SizedBox(width: 38), // Counterbalance
                    ],
                  ),
                ],
              ),
            ),
            ),
          ),

          // 4. BAGIAN BAWAH: CARD PUTIH DENGAN TOMBOL "Ketuk Untuk Scan!" (GAMBAR 1)
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: Container(
              padding: const EdgeInsets.only(left: 24, right: 24, top: 22, bottom: 32),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(28),
                  topRight: Radius.circular(28),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 16,
                    offset: Offset(0, -4),
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Judul: "Arahkan ke QR Code"
                  const Text(
                    'Arahkan ke QR Code',
                    style: TextStyle(
                      fontFamily: 'Plus Jakarta Sans',
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF8BA061),
                    ),
                  ),
                  const SizedBox(height: 6),

                  // Keterangan teks tipis
                  const Text(
                    'Pastikan QR Code berada di dalam garis kotak putih untuk melakukan absensi.',
                    style: TextStyle(
                      fontFamily: 'Plus Jakarta Sans',
                      fontSize: 12,
                      color: Color(0xFF72786C),
                      height: 1.35,
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Tombol Kotak Scan Hijau (Bisa diketuk manual juga untuk trigger scan)
                  Center(
                    child: Column(
                      children: [
                        GestureDetector(
                          onTap: () {
                            if (!_isNavigating) {
                              _isNavigating = true;
                              _navigateToSuccess();
                            }
                          },
                          child: Container(
                            width: 60,
                            height: 60,
                            decoration: BoxDecoration(
                              color: const Color(0xFFA6BA79),
                              borderRadius: BorderRadius.circular(16),
                              boxShadow: [
                                BoxShadow(
                                  color: const Color(0xFFA6BA79).withOpacity(0.35),
                                  blurRadius: 12,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
                            alignment: Alignment.center,
                            child: Image.asset(
                              'assets/icons/icon_scan.png',
                              width: 32,
                              height: 32,
                              color: Colors.white,
                              errorBuilder: (context, error, stackTrace) =>
                                  const Icon(Icons.qr_code_scanner, color: Colors.white, size: 30),
                            ),
                          ),
                        ),
                        const SizedBox(height: 10),
                        const Text(
                          'Ketuk Untuk Scan!',
                          style: TextStyle(
                            fontFamily: 'Plus Jakarta Sans',
                            fontSize: 12.5,
                            fontWeight: FontWeight.w600,
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
        ],
      ),
    );
  }
}
