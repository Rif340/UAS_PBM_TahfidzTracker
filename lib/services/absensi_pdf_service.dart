import 'package:flutter/services.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

class AbsensiPdfRow {
  final int no;
  final String namaGuru;
  final String jabatan;
  final int hadir;
  final int terlambat;
  final int izin;
  final int sakit;
  final int tanpaKeterangan;
  final int hariKerja;

  const AbsensiPdfRow({
    required this.no,
    required this.namaGuru,
    required this.jabatan,
    required this.hadir,
    required this.terlambat,
    required this.izin,
    required this.sakit,
    required this.tanpaKeterangan,
    required this.hariKerja,
  });
}

class AbsensiPdfService {
  static const double _pageW = 797.89; // A4 Landscape width - 2*22 margin

  static Future<List<int>> generatePdf() async {
    final pdf = pw.Document();

    final ByteData logoData =
        await rootBundle.load('assets/images/Logo_At-Taubah_Karawang.png');
    final logoImage = pw.MemoryImage(logoData.buffer.asUint8List());

    final fontR = pw.Font.ttf(await rootBundle.load('assets/fonts/Tinos-Regular.ttf'));
    final fontB = pw.Font.ttf(await rootBundle.load('assets/fonts/Tinos-Bold.ttf'));

    final rows = [
      const AbsensiPdfRow(
        no: 1,
        namaGuru: 'Belinda Blanche, S.Kom',
        jabatan: 'Guru SD',
        hadir: 22,
        terlambat: 0,
        izin: 0,
        sakit: 0,
        tanpaKeterangan: 0,
        hariKerja: 22,
      ),
    ];

    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4.landscape,
        margin: const pw.EdgeInsets.symmetric(horizontal: 22, vertical: 20),
        build: (pw.Context ctx) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            mainAxisSize: pw.MainAxisSize.min,
            children: [
              _buildKop(logoImage, fontB, fontR),
              pw.SizedBox(height: 8),
              _buildTitle(fontB, fontR),
              pw.SizedBox(height: 8),
              _buildMeta(fontR),
              pw.SizedBox(height: 8),
              _buildTable(rows, fontB, fontR),
              pw.SizedBox(height: 4),
              pw.Text(
                'Contoh format laporan — data rekap belum diisi',
                style: pw.TextStyle(
                  font: fontR,
                  fontStyle: pw.FontStyle.italic,
                  fontSize: 7.5,
                ),
              ),
              pw.SizedBox(height: 16),
              _buildSignature(fontR),
            ],
          );
        },
      ),
    );

    return pdf.save();
  }

  // 1. KOP SURAT
  static pw.Widget _buildKop(pw.MemoryImage logo, pw.Font fontB, pw.Font fontR) {
    const double logoW = 54.0;
    const double gap = 12.0;
    const double textW = _pageW - logoW - gap - 54.0; // Counterbalanced

    return pw.Column(
      mainAxisSize: pw.MainAxisSize.min,
      children: [
        pw.Row(
          crossAxisAlignment: pw.CrossAxisAlignment.center,
          children: [
            pw.Image(logo, width: logoW, height: logoW),
            pw.SizedBox(width: gap),
            pw.SizedBox(
              width: textW,
              child: pw.Column(
                mainAxisSize: pw.MainAxisSize.min,
                crossAxisAlignment: pw.CrossAxisAlignment.center,
                children: [
                  pw.Text(
                    'SDIT AT-TAUBAH',
                    style: pw.TextStyle(
                      font: fontB,
                      fontSize: 18.0,
                    ),
                  ),
                  pw.SizedBox(height: 3),
                  pw.Text(
                    'Jl. KH. Ahmad Dahlan No. E/4 Kaum 1, Kelurahan Karawang Kulon, Kecamatan Karawang Barat, Kabupaten Karawang, Jawa Barat',
                    textAlign: pw.TextAlign.center,
                    style: pw.TextStyle(
                      font: fontR,
                      fontSize: 8.5,
                    ),
                  ),
                ],
              ),
            ),
            pw.SizedBox(width: 54.0),
          ],
        ),
        pw.SizedBox(height: 6),
        // Garis Pembatas Kop
        pw.Container(
          width: _pageW,
          height: 2.2,
          color: PdfColors.black,
        ),
        pw.SizedBox(height: 1.2),
        pw.Container(
          width: _pageW,
          height: 0.6,
          color: PdfColors.black,
        ),
      ],
    );
  }

  // 2. JUDUL LAPORAN
  static pw.Widget _buildTitle(pw.Font fontB, pw.Font fontR) {
    return pw.SizedBox(
      width: _pageW,
      child: pw.Column(
        mainAxisSize: pw.MainAxisSize.min,
        crossAxisAlignment: pw.CrossAxisAlignment.center,
        children: [
          pw.Text(
            'LAPORAN REKAPITULASI KEHADIRAN GURU',
            style: pw.TextStyle(
              font: fontB,
              fontSize: 13.0,
              decoration: pw.TextDecoration.underline,
            ),
          ),
          pw.SizedBox(height: 3),
          pw.Text(
            'Periode Oktober 2026',
            style: pw.TextStyle(
              font: fontR,
              fontSize: 8.5,
            ),
          ),
        ],
      ),
    );
  }

  // 3. METADATA 2 KOLOM
  static pw.Widget _buildMeta(pw.Font fontR) {
    const halfW = _pageW / 2;
    final metaStyle = pw.TextStyle(font: fontR, fontSize: 8.0);

    return pw.SizedBox(
      width: _pageW,
      child: pw.Row(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.SizedBox(
            width: halfW,
            child: pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              mainAxisSize: pw.MainAxisSize.min,
              children: [
                _metaRow('Periode laporan', 'Oktober 2026', 80, metaStyle),
                pw.SizedBox(height: 2),
                _metaRow('Guru dalam laporan', '1 orang', 80, metaStyle),
              ],
            ),
          ),
          pw.SizedBox(
            width: halfW,
            child: pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              mainAxisSize: pw.MainAxisSize.min,
              children: [
                _metaRow('Jumlah hari kerja', '22', 80, metaStyle),
                pw.SizedBox(height: 2),
                _metaRow('Tanggal cetak', '6 Oktober 2026', 80, metaStyle),
              ],
            ),
          ),
        ],
      ),
    );
  }

  static pw.Widget _metaRow(String label, String value, double labelW, pw.TextStyle style) {
    return pw.Row(
      mainAxisSize: pw.MainAxisSize.min,
      children: [
        pw.SizedBox(width: labelW, child: pw.Text(label, style: style)),
        pw.Text(': ', style: style),
        pw.Text(value, style: style),
      ],
    );
  }

  // 4. TABEL REKAPITULASI KEHADIRAN GURU (GAMBAR 4)
  // Lebar kolom terukur persis: Total ~ 740pt
  static pw.Widget _buildTable(List<AbsensiPdfRow> rows, pw.Font fontB, pw.Font fontR) {
    const double colNo = 34.0;
    const double colNama = 200.0;
    const double colJabatan = 100.0;
    const double colRekapEach = 70.0; // x 5 = 350.0
    const double colHariKerja = 68.0;
    const double totalTableW = colNo + colNama + colJabatan + (colRekapEach * 5) + colHariKerja; // 752.0

    final border = pw.TableBorder.all(color: PdfColors.black, width: 0.7);

    return pw.Table(
      border: border,
      columnWidths: {
        0: const pw.FixedColumnWidth(colNo),
        1: const pw.FixedColumnWidth(colNama),
        2: const pw.FixedColumnWidth(colJabatan),
        3: const pw.FixedColumnWidth(colRekapEach),
        4: const pw.FixedColumnWidth(colRekapEach),
        5: const pw.FixedColumnWidth(colRekapEach),
        6: const pw.FixedColumnWidth(colRekapEach),
        7: const pw.FixedColumnWidth(colRekapEach),
        8: const pw.FixedColumnWidth(colHariKerja),
      },
      children: [
        // Header Baris 1
        pw.TableRow(
          decoration: const pw.BoxDecoration(color: PdfColors.white),
          children: [
            _tableCellCenter('No', fontB, 8.5, height: 32),
            _tableCellCenter('Nama Guru', fontB, 8.5, height: 32),
            _tableCellCenter('Jabatan', fontB, 8.5, height: 32),
            // Header Grup Rekapitulasi Kehadiran (Spanning visual)
            _tableCellCenter('Hadir', fontB, 8.0, height: 32),
            _tableCellCenter('Terlambat', fontB, 8.0, height: 32),
            _tableCellCenter('Izin', fontB, 8.0, height: 32),
            _tableCellCenter('Sakit', fontB, 8.0, height: 32),
            _tableCellCenter('Tanpa\nKeterangan', fontB, 7.5, height: 32),
            _tableCellCenter('Hari\nKerja', fontB, 8.0, height: 32),
          ],
        ),

        // Data Rows
        ...rows.map((r) {
          return pw.TableRow(
            children: [
              _tableCellCenter('${r.no}', fontR, 8.5, height: 22),
              _tableCellLeft(r.namaGuru, fontR, 8.5, height: 22),
              _tableCellCenter(r.jabatan, fontR, 8.5, height: 22),
              _tableCellCenter('${r.hadir}', fontR, 8.5, height: 22),
              _tableCellCenter('${r.terlambat}', fontR, 8.5, height: 22),
              _tableCellCenter('${r.izin}', fontR, 8.5, height: 22),
              _tableCellCenter('${r.sakit}', fontR, 8.5, height: 22),
              _tableCellCenter('${r.tanpaKeterangan}', fontR, 8.5, height: 22),
              _tableCellCenter('${r.hariKerja}', fontR, 8.5, height: 22),
            ],
          );
        }),

        // Baris TOTAL
        pw.TableRow(
          decoration: const pw.BoxDecoration(color: PdfColors.white),
          children: [
            _tableCellCenter('', fontB, 8.5, height: 22),
            _tableCellCenter('', fontB, 8.5, height: 22),
            _tableCellCenter('TOTAL', fontB, 8.5, height: 22),
            _tableCellCenter('22', fontB, 8.5, height: 22),
            _tableCellCenter('0', fontB, 8.5, height: 22),
            _tableCellCenter('0', fontB, 8.5, height: 22),
            _tableCellCenter('0', fontB, 8.5, height: 22),
            _tableCellCenter('0', fontB, 8.5, height: 22),
            _tableCellCenter('22', fontB, 8.5, height: 22),
          ],
        ),
      ],
    );
  }

  static pw.Widget _tableCellCenter(String text, pw.Font font, double fontSize, {double height = 20}) {
    return pw.Container(
      height: height,
      alignment: pw.Alignment.center,
      padding: const pw.EdgeInsets.symmetric(horizontal: 4, vertical: 2),
      child: pw.Text(
        text,
        textAlign: pw.TextAlign.center,
        style: pw.TextStyle(font: font, fontSize: fontSize),
      ),
    );
  }

  static pw.Widget _tableCellLeft(String text, pw.Font font, double fontSize, {double height = 20}) {
    return pw.Container(
      height: height,
      alignment: pw.Alignment.centerLeft,
      padding: const pw.EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      child: pw.Text(
        text,
        style: pw.TextStyle(font: font, fontSize: fontSize),
      ),
    );
  }

  // 5. TANDA TANGAN DI POJOK KANAN BAWAH
  static pw.Widget _buildSignature(pw.Font fontR) {
    const signBoxW = 200.0;
    final signStyle = pw.TextStyle(font: fontR, fontSize: 8.5);

    return pw.SizedBox(
      width: _pageW,
      child: pw.Row(
        children: [
          pw.SizedBox(width: _pageW - signBoxW - 40),
          pw.SizedBox(
            width: signBoxW,
            child: pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.center,
              children: [
                pw.Text('Karawang, 6 Oktober 2026', style: signStyle),
                pw.SizedBox(height: 2),
                pw.Text('Kepala SDIT At-Taubah', style: signStyle),
                pw.SizedBox(height: 48), // Tempat tanda tangan
                pw.Text('(                                                      )', style: signStyle),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
