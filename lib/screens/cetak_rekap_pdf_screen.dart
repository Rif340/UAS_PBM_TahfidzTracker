import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:pdf/pdf.dart';
import 'package:printing/printing.dart';
import '../services/rekap_pdf_service.dart';

class CetakRekapPdfScreen extends StatefulWidget {
  const CetakRekapPdfScreen({super.key});

  @override
  State<CetakRekapPdfScreen> createState() => _CetakRekapPdfScreenState();
}

class _CetakRekapPdfScreenState extends State<CetakRekapPdfScreen> {
  bool _isGenerating = false;
  bool _isDone = false;
  String? _errorMsg;

  @override
  void initState() {
    super.initState();
    // Langsung generate dan share PDF begitu halaman terbuka
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _generateAndSharePdf();
    });
  }

  Future<void> _generateAndSharePdf() async {
    setState(() {
      _isGenerating = true;
      _errorMsg = null;
    });

    try {
      final pdfBytes = await RekapPdfService.generatePdf(
        pageFormat: PdfPageFormat.a4.landscape,
      );

      // Share/download PDF langsung ke device (tanpa perlu preview)
      await Printing.sharePdf(
        bytes: Uint8List.fromList(pdfBytes),
        filename: 'Rekapitulasi_Setoran_Tahfizd_6A_Oktober_2026.pdf',
      );

      if (mounted) {
        setState(() {
          _isDone = true;
          _isGenerating = false;
        });
        // Kembali ke halaman sebelumnya setelah share
        Navigator.pop(context);
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isGenerating = false;
          _errorMsg = 'Gagal membuat PDF: $e';
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9FAF6),
      body: Column(
        children: [
          // HEADER
          _buildHeader(context),

          // AREA KONTEN
          Expanded(
            child: Center(
              child: Padding(
                padding: const EdgeInsets.all(32),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (_isGenerating) ...[
                      const SizedBox(
                        width: 60,
                        height: 60,
                        child: CircularProgressIndicator(
                          color: Color(0xFF7A8B58),
                          strokeWidth: 4,
                        ),
                      ),
                      const SizedBox(height: 24),
                      const Text(
                        'Menyiapkan Dokumen PDF...',
                        style: TextStyle(
                          fontFamily: 'Plus Jakarta Sans',
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF465635),
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        'Sedang memproses laporan rekap\nsetoran tahfizd kelas 6A',
                        style: TextStyle(
                          fontFamily: 'Plus Jakarta Sans',
                          fontSize: 13,
                          color: Color(0xFF72786C),
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ] else if (_errorMsg != null) ...[
                      const Icon(
                        Icons.error_outline,
                        size: 60,
                        color: Color(0xFFE57373),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        _errorMsg!,
                        style: const TextStyle(
                          fontFamily: 'Plus Jakarta Sans',
                          fontSize: 14,
                          color: Color(0xFF465635),
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 24),
                      ElevatedButton.icon(
                        onPressed: _generateAndSharePdf,
                        icon: const Icon(Icons.refresh),
                        label: const Text('Coba Lagi'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF7A8B58),
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 24,
                            vertical: 12,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),
                    ] else if (_isDone) ...[
                      const Icon(
                        Icons.check_circle_outline,
                        size: 60,
                        color: Color(0xFF7A8B58),
                      ),
                      const SizedBox(height: 16),
                      const Text(
                        'PDF berhasil dibuat!',
                        style: TextStyle(
                          fontFamily: 'Plus Jakarta Sans',
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF465635),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.only(top: 16, left: 24, right: 24, bottom: 20),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFFB5C384), Color(0xFF7A8B58)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(28),
          bottomRight: Radius.circular(28),
        ),
      ),
      child: SafeArea(
        bottom: false,
        child: Column(
          children: [
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
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white24,
                    ),
                    child: const Icon(
                      Icons.arrow_back_ios_new,
                      color: Colors.white,
                      size: 18,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 14),
              const Expanded(
                child: Text(
                  'Cetak Rekap Tahfizd',
                  style: TextStyle(
                    fontFamily: 'Plus Jakarta Sans',
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
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
}
