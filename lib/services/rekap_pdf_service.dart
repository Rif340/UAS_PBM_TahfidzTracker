import 'package:flutter/services.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

class SurahTarget {
  final String name;
  final int ayat;
  const SurahTarget(this.name, this.ayat);
}

class SiswaRekapRow {
  final int no;
  final String nama;
  final List<String> setoran; // Length 37
  final String total;
  const SiswaRekapRow({
    required this.no,
    required this.nama,
    required this.setoran,
    required this.total,
  });
}

class RekapPdfService {
  static const List<SurahTarget> juz30Surahs = [
    SurahTarget('An-Naba', 40),
    SurahTarget("An-Nazi'at", 46),
    SurahTarget("'Abasa", 42),
    SurahTarget('At-Takwir', 29),
    SurahTarget('Al-Infitar', 19),
    SurahTarget('Al-Mutaffifin', 36),
    SurahTarget('Al-Insyiqaq', 25),
    SurahTarget('Al-Buruj', 22),
    SurahTarget('At-Tariq', 17),
    SurahTarget("Al-A'la", 19),
    SurahTarget('Al-Ghasyiyah', 26),
    SurahTarget('Al-Fajr', 30),
    SurahTarget('Al-Balad', 20),
    SurahTarget('Asy-Syams', 15),
    SurahTarget('Al-Lail', 21),
    SurahTarget('Ad-Duha', 11),
    SurahTarget('Al-Insyirah', 8),
    SurahTarget('At-Tin', 8),
    SurahTarget("Al-'Alaq", 19),
    SurahTarget('Al-Qadr', 5),
    SurahTarget('Al-Bayyinah', 8),
    SurahTarget('Az-Zalzalah', 8),
    SurahTarget("Al-'Adiyat", 11),
    SurahTarget("Al-Qari'ah", 11),
    SurahTarget('At-Takasur', 8),
    SurahTarget("Al-'Asr", 3),
    SurahTarget('Al-Humazah', 9),
    SurahTarget('Al-Fil', 5),
    SurahTarget('Quraisy', 4),
    SurahTarget("Al-Ma'un", 7),
    SurahTarget('Al-Kausar', 3),
    SurahTarget('Al-Kafirun', 6),
    SurahTarget('An-Nasr', 3),
    SurahTarget('Al-Lahab', 5),
    SurahTarget('Al-Ikhlas', 4),
    SurahTarget('Al-Falaq', 5),
    SurahTarget('An-Nas', 6),
  ];

  static const List<String> _sampleRow = [
    '✓', '12', 'M', '-', '1', '✓', '12', '8', '6', '17', '-', '17', '11', '✓',
    '19', '✓', '✓', '5', '✓', '✓', '✓', 'M', '14', '8', '✓', 'M', '14', '1',
    '✓', '1', '✓', '✓', '✓', '2', '1', '-', '✓'
  ];

  static List<SiswaRekapRow> getSampleRows() {
    return [
      SiswaRekapRow(no: 1, nama: 'Bahlil', setoran: _sampleRow, total: '14'),
      SiswaRekapRow(no: 2, nama: 'Subianto', setoran: _sampleRow, total: '14'),
      SiswaRekapRow(no: 3, nama: 'Pigai', setoran: _sampleRow, total: '14'),
      SiswaRekapRow(no: 4, nama: 'Widodo', setoran: _sampleRow, total: '14'),
      SiswaRekapRow(no: 5, nama: 'Gibran', setoran: _sampleRow, total: '14'),
      SiswaRekapRow(no: 6, nama: 'Prabowo', setoran: _sampleRow, total: '14'),
      SiswaRekapRow(no: 7, nama: 'Baswedan', setoran: _sampleRow, total: '14'),
    ];
  }

  // ──────────────────────────────────────────────────────────────────────────
  // CONSTANTS
  // A4 landscape: 841.89 x 595.28 pt
  // Margin horizontal: 22*2 = 44 → content width ≈ 798 pt
  // Margin vertical  : 20*2 = 40 → content height ≈ 555 pt
  //
  // Column widths: 22 + 85 + 37*17 + 39 = 22+85+629+39 = 775pt ✓
  // ──────────────────────────────────────────────────────────────────────────
  static const double _pageW    = 797.89; // usable after margins
  static const double _colNo    = 22.0;
  static const double _colNama  = 85.0;
  static const double _colSurah = 17.0;
  static const double _colTotal = 39.0;

  static const double _hdrGroup  = 16.0;  // "Rekapitulasi Setoran" group row
  static const double _hdrSurah  = 24.0;  // surah name + ayat row
  static const double _hdrTotal  = _hdrGroup + _hdrSurah; // 40

  static const double _dataRow   = 17.0;  // each data row height
  static const double _totalRow  = 17.0;  // footer total row height

  // KOP heights
  static const double _kopLogoH  = 52.0;
  static const double _kopH      = _kopLogoH + 5 + 2 + 1.5 + 0.8; // ~62

  // Font sizes
  static const double _fsKopTitle   = 18.0;
  static const double _fsKopAddr    = 8.5;
  static const double _fsTitle      = 13.0;
  static const double _fsPeriode    = 8.5;
  static const double _fsMeta       = 8.0;
  static const double _fsHdrGroup   = 8.0;
  static const double _fsHdrCol     = 8.5;
  static const double _fsSurahName  = 5.5;
  static const double _fsAyat       = 5.0;
  static const double _fsCell       = 7.5;
  static const double _fsSign       = 8.5;

  // ──────────────────────────────────────────────────────────────────────────
  static Future<List<int>> generatePdf({
    PdfPageFormat pageFormat = PdfPageFormat.a4,
  }) async {
    final pdf = pw.Document();

    final ByteData logoData =
        await rootBundle.load('assets/images/Logo_At-Taubah_Karawang.png');
    final logoImage = pw.MemoryImage(logoData.buffer.asUint8List());

    final fontR  = pw.Font.ttf(await rootBundle.load('assets/fonts/Tinos-Regular.ttf'));
    final fontB  = pw.Font.ttf(await rootBundle.load('assets/fonts/Tinos-Bold.ttf'));
    final fontJB = pw.Font.ttf(await rootBundle.load('assets/fonts/PlusJakartaSans-Bold.ttf'));

    final rows = getSampleRows();

    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4.landscape,
        margin: const pw.EdgeInsets.symmetric(horizontal: 22, vertical: 20),
        build: (pw.Context ctx) {
          // Everything is explicit-sized — no pw.Expanded / pw.Align
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            mainAxisSize: pw.MainAxisSize.min,
            children: [
              _kop(logoImage, fontB, fontR),
              pw.SizedBox(height: 6),
              _title(fontB, fontR),
              pw.SizedBox(height: 5),
              _meta(fontR),
              pw.SizedBox(height: 5),
              _table(rows, fontB, fontR, fontJB),
              pw.SizedBox(height: 8),
              _sign(fontR),
            ],
          );
        },
      ),
    );

    return pdf.save();
  }

  // ──────────────────────────────────────────────────────────────────────────
  // KOP SURAT
  // Uses SizedBox with fixed widths instead of Expanded
  // ──────────────────────────────────────────────────────────────────────────
  static pw.Widget _kop(pw.ImageProvider logo, pw.Font bold, pw.Font regular) {
    const double logoW = 52;
    const double gap   = 12;
    const double balancer = 64;
    final double textW = _pageW - logoW - gap - balancer;

    return pw.Column(
      mainAxisSize: pw.MainAxisSize.min,
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.SizedBox(
          height: _kopLogoH,
          child: pw.Row(
            crossAxisAlignment: pw.CrossAxisAlignment.center,
            children: [
              pw.SizedBox(
                width: logoW,
                height: logoW,
                child: pw.Image(logo, fit: pw.BoxFit.contain),
              ),
              pw.SizedBox(width: gap),
              // Fixed-width text block (no Expanded)
              pw.SizedBox(
                width: textW,
                child: pw.Column(
                  mainAxisSize: pw.MainAxisSize.min,
                  crossAxisAlignment: pw.CrossAxisAlignment.center,
                  children: [
                    pw.Text(
                      'SDIT AT-TAUBAH',
                      textAlign: pw.TextAlign.center,
                      style: pw.TextStyle(
                          font: bold, fontSize: _fsKopTitle, color: PdfColors.black),
                    ),
                    pw.SizedBox(height: 2),
                    pw.Text(
                      'Jl. KH. Ahmad Dahlan No. E/4 Kaum 1, Kelurahan Karawang Kulon,\n'
                      'Kecamatan Karawang Barat, Kabupaten Karawang, Jawa Barat',
                      textAlign: pw.TextAlign.center,
                      style: pw.TextStyle(
                          font: regular, fontSize: _fsKopAddr, color: PdfColors.black),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        pw.SizedBox(height: 5),
        pw.SizedBox(
          width: _pageW,
          height: 2,
          child: pw.Container(color: PdfColors.black),
        ),
        pw.SizedBox(height: 1.5),
        pw.SizedBox(
          width: _pageW,
          height: 0.8,
          child: pw.Container(color: PdfColors.black),
        ),
      ],
    );
  }

  // ──────────────────────────────────────────────────────────────────────────
  // JUDUL
  // ──────────────────────────────────────────────────────────────────────────
  static pw.Widget _title(pw.Font bold, pw.Font regular) {
    return pw.SizedBox(
      width: _pageW,
      child: pw.Column(
        mainAxisSize: pw.MainAxisSize.min,
        crossAxisAlignment: pw.CrossAxisAlignment.center,
        children: [
          pw.Text(
            'LAPORAN REKAPITULASI SETORAN TAHFIZD',
            textAlign: pw.TextAlign.center,
            style: pw.TextStyle(
              font: bold,
              fontSize: _fsTitle,
              decoration: pw.TextDecoration.underline,
              color: PdfColors.black,
            ),
          ),
          pw.SizedBox(height: 2),
          pw.Text(
            'Periode Oktober 2026',
            textAlign: pw.TextAlign.center,
            style: pw.TextStyle(
                font: regular, fontSize: _fsPeriode, color: PdfColors.black),
          ),
        ],
      ),
    );
  }

  // ──────────────────────────────────────────────────────────────────────────
  // METADATA
  // Uses fixed-width halves instead of MainAxisAlignment.spaceBetween
  // ──────────────────────────────────────────────────────────────────────────
  static pw.Widget _meta(pw.Font regular) {
    final double halfW = _pageW / 2;

    pw.Widget metaRow(String label, String value) {
      return pw.Row(children: [
        pw.SizedBox(
          width: 108,
          child: pw.Text(label,
              style: pw.TextStyle(
                  font: regular, fontSize: _fsMeta, color: PdfColors.black)),
        ),
        pw.Text(': $value',
            style: pw.TextStyle(
                font: regular, fontSize: _fsMeta, color: PdfColors.black)),
      ]);
    }

    return pw.SizedBox(
      width: _pageW,
      child: pw.Row(
        children: [
          pw.SizedBox(
            width: halfW,
            child: pw.Column(
              mainAxisSize: pw.MainAxisSize.min,
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                metaRow('Kelas', '6A'),
                pw.SizedBox(height: 2),
                metaRow('Guru Pengampu', 'Belinda Blanche S.Kom'),
              ],
            ),
          ),
          pw.SizedBox(
            width: halfW,
            child: pw.Column(
              mainAxisSize: pw.MainAxisSize.min,
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                metaRow('Jumlah Capai Target', '10 Orang'),
                pw.SizedBox(height: 2),
                metaRow('Tanggal cetak', '6 Oktober 2026'),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ──────────────────────────────────────────────────────────────────────────
  // TABLE
  // ALL containers have EXPLICIT heights → no infinite constraint
  // ──────────────────────────────────────────────────────────────────────────
  static pw.Widget _table(
    List<SiswaRekapRow> rows,
    pw.Font bold,
    pw.Font regular,
    pw.Font jakartaBold,
  ) {
    const double surahTotalW = _colSurah * 37; // 629.0

    final borderH = 0.5;
    final bAll = pw.Border.all(color: PdfColors.black, width: borderH);
    final bRight = pw.Border(
        right: pw.BorderSide(color: PdfColors.black, width: borderH));
    final bBottom = pw.Border(
        bottom: pw.BorderSide(color: PdfColors.black, width: borderH));

    // ── Fixed-size header cell ──
    pw.Widget hCell(String text, double w, {bool rightBorder = true, double? fontSize}) {
      return pw.SizedBox(
        width: w,
        height: _hdrTotal,
        child: pw.Container(
          decoration: pw.BoxDecoration(
              border: rightBorder
                  ? pw.BoxDecoration(border: bRight).border
                  : null),
          alignment: pw.Alignment.center,
          child: pw.Text(
            text,
            textAlign: pw.TextAlign.center,
            style: pw.TextStyle(
                font: bold,
                fontSize: fontSize ?? _fsHdrCol,
                color: PdfColors.black),
          ),
        ),
      );
    }

    // ── Surah column group header ──
    // Split into two rows: "Rekapitulasi Setoran" + individual surah names
    final surahGroupHeader = pw.SizedBox(
      width: surahTotalW,
      height: _hdrTotal,
      child: pw.Column(
        mainAxisSize: pw.MainAxisSize.min,
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          // Group label row
          pw.SizedBox(
            width: surahTotalW,
            height: _hdrGroup,
            child: pw.Container(
              decoration: pw.BoxDecoration(border: bBottom),
              alignment: pw.Alignment.center,
              child: pw.Text(
                'Rekapitulasi Setoran',
                style: pw.TextStyle(
                    font: bold, fontSize: _fsHdrGroup, color: PdfColors.black),
              ),
            ),
          ),
          // Surah name row
          pw.SizedBox(
            width: surahTotalW,
            height: _hdrSurah,
            child: pw.Row(
              children: juz30Surahs.map((s) {
                return pw.SizedBox(
                  width: _colSurah,
                  height: _hdrSurah,
                  child: pw.Container(
                    decoration: pw.BoxDecoration(
                        border: pw.BoxDecoration(border: bRight).border),
                    padding: const pw.EdgeInsets.symmetric(horizontal: 0.5),
                    alignment: pw.Alignment.center,
                    child: pw.Column(
                      mainAxisSize: pw.MainAxisSize.min,
                      crossAxisAlignment: pw.CrossAxisAlignment.center,
                      children: [
                        pw.Text(
                          s.name,
                          textAlign: pw.TextAlign.center,
                          maxLines: 1,
                          style: pw.TextStyle(
                              font: jakartaBold,
                              fontSize: _fsSurahName,
                              color: PdfColors.black),
                        ),
                        pw.Text(
                          '(${s.ayat})',
                          textAlign: pw.TextAlign.center,
                          style: pw.TextStyle(
                              font: jakartaBold,
                              fontSize: _fsAyat,
                              color: PdfColors.black),
                        ),
                      ],
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );

    // ── Header row (EXPLICIT height!) ──
    final headerRow = pw.SizedBox(
      height: _hdrTotal,
      width: _pageW,
      child: pw.Container(
        decoration: pw.BoxDecoration(border: bBottom),
        child: pw.Row(
          children: [
            hCell('No', _colNo),
            hCell('Nama Siswa', _colNama),
            surahGroupHeader,
            hCell('Total\nSetor', _colTotal, rightBorder: false),
          ],
        ),
      ),
    );

    // ── Data row (EXPLICIT height) ──
    pw.Widget dataRow(SiswaRekapRow siswa) {
      return pw.SizedBox(
        height: _dataRow,
        width: _pageW,
        child: pw.Container(
          decoration: pw.BoxDecoration(border: bBottom),
          child: pw.Row(
            children: [
              // No
              pw.SizedBox(
                width: _colNo,
                height: _dataRow,
                child: pw.Container(
                  decoration: pw.BoxDecoration(
                      border: pw.BoxDecoration(border: bRight).border),
                  alignment: pw.Alignment.center,
                  child: pw.Text('${siswa.no}',
                      style: pw.TextStyle(
                          font: regular,
                          fontSize: _fsCell,
                          color: PdfColors.black)),
                ),
              ),
              // Nama
              pw.SizedBox(
                width: _colNama,
                height: _dataRow,
                child: pw.Container(
                  decoration: pw.BoxDecoration(
                      border: pw.BoxDecoration(border: bRight).border),
                  padding: const pw.EdgeInsets.only(left: 3),
                  alignment: pw.Alignment.centerLeft,
                  child: pw.Text(siswa.nama,
                      style: pw.TextStyle(
                          font: regular,
                          fontSize: _fsCell,
                          color: PdfColors.black)),
                ),
              ),
              // Surah columns
              ...List.generate(37, (i) {
                return pw.SizedBox(
                  width: _colSurah,
                  height: _dataRow,
                  child: pw.Container(
                    decoration: pw.BoxDecoration(
                        border: pw.BoxDecoration(border: bRight).border),
                    alignment: pw.Alignment.center,
                    child: _cell(siswa.setoran[i], regular),
                  ),
                );
              }),
              // Total
              pw.SizedBox(
                width: _colTotal,
                height: _dataRow,
                child: pw.Container(
                  alignment: pw.Alignment.center,
                  child: pw.Text(siswa.total,
                      style: pw.TextStyle(
                          font: regular,
                          fontSize: _fsCell,
                          color: PdfColors.black)),
                ),
              ),
            ],
          ),
        ),
      );
    }

    // ── Total/footer row ──
    final totalRow = pw.SizedBox(
      height: _totalRow,
      width: _pageW,
      child: pw.Row(
        children: [
          pw.SizedBox(
            width: _colNo + _colNama,
            height: _totalRow,
            child: pw.Container(
              decoration: pw.BoxDecoration(
                  border: pw.BoxDecoration(border: bRight).border),
              padding: const pw.EdgeInsets.only(right: 6),
              alignment: pw.Alignment.centerRight,
              child: pw.Text('TOTAL',
                  style: pw.TextStyle(
                      font: bold, fontSize: _fsCell, color: PdfColors.black)),
            ),
          ),
          ...List.generate(37, (_) {
            return pw.SizedBox(
              width: _colSurah,
              height: _totalRow,
              child: pw.Container(
                  decoration: pw.BoxDecoration(
                      border: pw.BoxDecoration(border: bRight).border)),
            );
          }),
          pw.SizedBox(
            width: _colTotal,
            height: _totalRow,
            child: pw.Container(
              alignment: pw.Alignment.center,
              child: pw.Text('23',
                  style: pw.TextStyle(
                      font: bold, fontSize: _fsCell, color: PdfColors.black)),
            ),
          ),
        ],
      ),
    );

    return pw.Container(
      width: _pageW,
      decoration: pw.BoxDecoration(border: bAll),
      child: pw.Column(
        mainAxisSize: pw.MainAxisSize.min,
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          headerRow,
          ...rows.map(dataRow),
          totalRow,
        ],
      ),
    );
  }

  // ── Cell renderer ──
  static pw.Widget _cell(String val, pw.Font regular) {
    if (val == '✓') {
      return pw.CustomPaint(
        size: const PdfPoint(8, 8),
        painter: (PdfGraphics g, PdfPoint s) {
          g
            ..setColor(PdfColors.black)
            ..setLineWidth(1.1)
            ..moveTo(s.x * 0.1, s.y * 0.5)
            ..lineTo(s.x * 0.4, s.y * 0.2)
            ..lineTo(s.x * 0.9, s.y * 0.85)
            ..strokePath();
        },
      );
    } else if (val == '-' || val == '—') {
      return pw.SizedBox(
          width: 6, height: 1, child: pw.Container(color: PdfColors.black));
    } else {
      return pw.Text(val,
          style: pw.TextStyle(
              font: regular, fontSize: _fsCell, color: PdfColors.black));
    }
  }

  // ──────────────────────────────────────────────────────────────────────────
  // TANDA TANGAN
  // Uses Row(mainAxisAlignment.end) instead of Align (Align needs bounded H)
  // ──────────────────────────────────────────────────────────────────────────
  static pw.Widget _sign(pw.Font regular) {
    final col = pw.Column(
      mainAxisSize: pw.MainAxisSize.min,
      crossAxisAlignment: pw.CrossAxisAlignment.center,
      children: [
        pw.Text('Karawang, 6 Oktober 2026',
            style: pw.TextStyle(
                font: regular, fontSize: _fsSign, color: PdfColors.black)),
        pw.SizedBox(height: 2),
        pw.Text('Kepala SDIT At-Taubah',
            style: pw.TextStyle(
                font: regular, fontSize: _fsSign, color: PdfColors.black)),
        pw.SizedBox(height: 28),
        pw.Text('(                                        )',
            style: pw.TextStyle(
                font: regular, fontSize: _fsSign, color: PdfColors.black)),
      ],
    );

    // Use Row + Spacer pattern (SizedBox) instead of Align
    return pw.SizedBox(
      width: _pageW,
      child: pw.Row(
        children: [
          pw.SizedBox(width: _pageW * 0.65),
          col,
        ],
      ),
    );
  }
}
