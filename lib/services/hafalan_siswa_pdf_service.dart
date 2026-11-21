import 'package:flutter/services.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

class HafalanSiswaPdfService {
  static const List<String> juz30Surahs = [
    'An-Naba', "An-Nazi'at", "'Abasa", 'At-Takwir', 'Al-Infitar',
    'Al-Mutaffifin', 'Al-Insyiqaq', 'Al-Buruj', 'At-Tariq', "Al-A'la",
    'Al-Ghasyiyah', 'Al-Fajr', 'Al-Balad', 'Asy-Syams', 'Al-Lail',
    'Ad-Duha', 'Al-Insyirah', 'At-Tin', "Al-'Alaq", 'Al-Qadr',
    'Al-Bayyinah', 'Az-Zalzalah', "Al-'Adiyat", "Al-Qari'ah", 'At-Takasur',
    "Al-'Asr", 'Al-Humazah', 'Al-Fil', 'Quraisy', "Al-Ma'un",
    'Al-Kausar', 'Al-Kafirun', 'An-Nasr', 'Al-Lahab', 'Al-Ikhlas',
    'Al-Falaq', 'An-Nas',
  ];

  static const List<int> juz30Ayat = [
    40, 46, 42, 29, 19, 36, 25, 22, 17, 19,
    26, 30, 20, 15, 21, 11, 8, 8, 19, 5,
    8, 8, 11, 11, 8, 3, 9, 5, 4, 7,
    3, 6, 3, 5, 4, 5, 6,
  ];

  // Sample setoran values for demo (✓ = selesai, M = menyetor, — = belum, numeric = ayat ke-)
  static const List<String> _sampleSetoran = [
    '✓', '12', 'M', '—', '1', '✓', '12', '8', '6', '17',
    '—', '17', '11', '✓', '19', '✓', '✓', '5', '✓', '✓',
    '✓', 'M', '14', '8', '✓', 'M', '14', '1', '✓', '1',
    '✓', '✓', '✓', '2', '1', '—', '✓',
  ];

  /// Generate a PDF for one student's hafalan progress.
  static Future<List<int>> generatePdf({
    required String namaLengkap,
    required String nisn,
    required String kelas,
    required String rombel,
    required String tahunAjaran,
    List<String>? setoran, // length 37, one per surah
    PdfPageFormat pageFormat = PdfPageFormat.a4,
  }) async {
    final pdf = pw.Document();

    final ByteData logoData =
        await rootBundle.load('assets/images/Logo_At-Taubah_Karawang.png');
    final logoImage = pw.MemoryImage(logoData.buffer.asUint8List());

    final fontR = pw.Font.ttf(
        await rootBundle.load('assets/fonts/Tinos-Regular.ttf'));
    final fontB = pw.Font.ttf(
        await rootBundle.load('assets/fonts/Tinos-Bold.ttf'));
    final fontJB = pw.Font.ttf(
        await rootBundle.load('assets/fonts/PlusJakartaSans-Bold.ttf'));

    final List<String> setoranData = setoran ?? _sampleSetoran;

    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.symmetric(horizontal: 28, vertical: 22),
        build: (pw.Context ctx) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            mainAxisSize: pw.MainAxisSize.min,
            children: [
              _kop(logoImage, fontB, fontR),
              pw.SizedBox(height: 8),
              _titleBlock(fontB, fontR),
              pw.SizedBox(height: 6),
              _infoSiswa(
                namaLengkap: namaLengkap,
                nisn: nisn,
                kelas: kelas,
                rombel: rombel,
                tahunAjaran: tahunAjaran,
                fontB: fontB,
                fontR: fontR,
              ),
              pw.SizedBox(height: 8),
              _table(setoranData, fontB, fontR, fontJB),
              pw.SizedBox(height: 10),
              _sign(fontR, fontB),
            ],
          );
        },
      ),
    );

    return pdf.save();
  }

  // ── KOP ────────────────────────────────────────────────────────────────────
  static pw.Widget _kop(pw.ImageProvider logo, pw.Font bold, pw.Font regular) {
    return pw.Column(
      mainAxisSize: pw.MainAxisSize.min,
      crossAxisAlignment: pw.CrossAxisAlignment.stretch,
      children: [
        pw.Row(
          crossAxisAlignment: pw.CrossAxisAlignment.center,
          children: [
            pw.SizedBox(
              width: 54,
              height: 54,
              child: pw.Image(logo, fit: pw.BoxFit.contain),
            ),
            pw.SizedBox(width: 10),
            pw.Expanded(
              child: pw.Column(
                mainAxisSize: pw.MainAxisSize.min,
                crossAxisAlignment: pw.CrossAxisAlignment.center,
                children: [
                  pw.Text(
                    'SDIT AT-TAUBAH',
                    textAlign: pw.TextAlign.center,
                    style: pw.TextStyle(
                      font: bold,
                      fontSize: 16,
                      color: PdfColor.fromHex('#1a2a18'),
                    ),
                  ),
                  pw.Text(
                    'Jl. Taubah No. 1, Karawang, Jawa Barat',
                    textAlign: pw.TextAlign.center,
                    style: pw.TextStyle(font: regular, fontSize: 8),
                  ),
                  pw.Text(
                    'Telp. (0267) 123-4567 | Email: info@sdit-attaubah.sch.id',
                    textAlign: pw.TextAlign.center,
                    style: pw.TextStyle(font: regular, fontSize: 8),
                  ),
                ],
              ),
            ),
          ],
        ),
        pw.SizedBox(height: 4),
        pw.Divider(thickness: 2, color: PdfColor.fromHex('#4a6130')),
        pw.Divider(thickness: 0.5, color: PdfColor.fromHex('#4a6130')),
      ],
    );
  }

  // ── TITLE ──────────────────────────────────────────────────────────────────
  static pw.Widget _titleBlock(pw.Font bold, pw.Font regular) {
    return pw.Center(
      child: pw.Column(
        mainAxisSize: pw.MainAxisSize.min,
        children: [
          pw.Text(
            'REKAPITULASI SETORAN TAHFIZD JUZ 30',
            textAlign: pw.TextAlign.center,
            style: pw.TextStyle(font: bold, fontSize: 12, letterSpacing: 0.5),
          ),
          pw.SizedBox(height: 2),
          pw.Text(
            'Tahun Pelajaran 2026/2027 | Bulan Oktober',
            textAlign: pw.TextAlign.center,
            style: pw.TextStyle(font: regular, fontSize: 8.5),
          ),
        ],
      ),
    );
  }

  // ── INFO SISWA ──────────────────────────────────────────────────────────────
  static pw.Widget _infoSiswa({
    required String namaLengkap,
    required String nisn,
    required String kelas,
    required String rombel,
    required String tahunAjaran,
    required pw.Font fontB,
    required pw.Font fontR,
  }) {
    pw.Widget row(String label, String value) => pw.Row(
          children: [
            pw.SizedBox(
              width: 90,
              child: pw.Text(label,
                  style: pw.TextStyle(font: fontR, fontSize: 9)),
            ),
            pw.Text(': ',
                style: pw.TextStyle(font: fontR, fontSize: 9)),
            pw.Text(value,
                style: pw.TextStyle(font: fontB, fontSize: 9)),
          ],
        );

    return pw.Container(
      padding: const pw.EdgeInsets.all(8),
      decoration: pw.BoxDecoration(
        border: pw.Border.all(color: PdfColor.fromHex('#b0c080'), width: 0.8),
        borderRadius: const pw.BorderRadius.all(pw.Radius.circular(4)),
        color: PdfColor.fromHex('#f7faf2'),
      ),
      child: pw.Row(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Expanded(
            child: pw.Column(
              mainAxisSize: pw.MainAxisSize.min,
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                row('Nama Lengkap', namaLengkap),
                pw.SizedBox(height: 3),
                row('NISN', nisn),
              ],
            ),
          ),
          pw.SizedBox(width: 12),
          pw.Expanded(
            child: pw.Column(
              mainAxisSize: pw.MainAxisSize.min,
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                row('Kelas', '$kelas$rombel'),
                pw.SizedBox(height: 3),
                row('Tahun Ajaran', tahunAjaran),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ── TABLE (SURAHS LISTED VERTICALLY) ───────────────────────────────────────
  static pw.Widget _table(
    List<String> setoran,
    pw.Font bold,
    pw.Font regular,
    pw.Font jakartaBold,
  ) {
    const double colNo = 22;
    const double colSurah = 120;
    const double colAyat = 40;
    const double colSetoran = 60;
    const double colStatus = 80;

    final PdfColor headerBg = PdfColor.fromHex('#4a6130');
    final PdfColor altRowBg = PdfColor.fromHex('#f0f5e8');
    final PdfColor borderColor = PdfColor.fromHex('#b0c080');
    const double rowH = 16;
    const double headerH = 20;

    pw.Widget cell(
      String text, {
      pw.Font? font,
      double fontSize = 8.5,
      PdfColor? color,
      PdfColor? bg,
      pw.TextAlign align = pw.TextAlign.center,
      double height = rowH,
      double? width,
    }) {
      return pw.Container(
        width: width,
        height: height,
        color: bg,
        alignment: align == pw.TextAlign.left
            ? pw.Alignment.centerLeft
            : pw.Alignment.center,
        padding: const pw.EdgeInsets.symmetric(horizontal: 4),
        child: pw.Text(
          text,
          textAlign: align,
          style: pw.TextStyle(
            font: font ?? regular,
            fontSize: fontSize,
            color: color ?? PdfColors.black,
          ),
        ),
      );
    }

    // ── Header Row ──
    final headerRow = pw.Container(
      decoration: pw.BoxDecoration(color: headerBg),
      height: headerH,
      child: pw.Row(
        children: [
          cell('No', font: bold, color: PdfColors.white, bg: headerBg,
              width: colNo, height: headerH),
          _vline(headerBg),
          cell('Nama Surat', font: bold, color: PdfColors.white, bg: headerBg,
              width: colSurah, height: headerH, align: pw.TextAlign.left),
          _vline(headerBg),
          cell('Jml Ayat', font: bold, color: PdfColors.white, bg: headerBg,
              width: colAyat, height: headerH),
          _vline(headerBg),
          cell('Setoran', font: bold, color: PdfColors.white, bg: headerBg,
              width: colSetoran, height: headerH),
          _vline(headerBg),
          cell('Status', font: bold, color: PdfColors.white, bg: headerBg,
              height: headerH),
        ],
      ),
    );

    // ── Data Rows ──
    int selesaiCount = 0;
    final dataRows = List.generate(juz30Surahs.length, (i) {
      final s = setoran.length > i ? setoran[i] : '—';
      final isSelesai = s == '✓';
      if (isSelesai) selesaiCount++;
      final rowBg = i % 2 == 0 ? PdfColors.white : altRowBg;
      final statusText = isSelesai
          ? 'Selesai'
          : s == 'M'
              ? 'Menyetor'
              : s == '—'
                  ? 'Belum Mulai'
                  : 'Dalam Proses';
      final statusColor = isSelesai
          ? PdfColor.fromHex('#4a6130')
          : s == '—'
              ? PdfColor.fromHex('#9e9e9e')
              : PdfColor.fromHex('#c17f24');

      return pw.Container(
        color: rowBg,
        height: rowH,
        child: pw.Row(
          children: [
            cell('${i + 1}', width: colNo, bg: rowBg),
            _vline(borderColor),
            cell(juz30Surahs[i],
                width: colSurah,
                align: pw.TextAlign.left,
                bg: rowBg),
            _vline(borderColor),
            cell('${juz30Ayat[i]}', width: colAyat, bg: rowBg),
            _vline(borderColor),
            cell(s, width: colSetoran, bg: rowBg,
                color: isSelesai
                    ? PdfColor.fromHex('#4a6130')
                    : PdfColors.black),
            _vline(borderColor),
            cell(statusText, color: statusColor, bg: rowBg,
                font: isSelesai ? bold : regular),
          ],
        ),
      );
    });

    // ── Total Row ──
    final totalRow = pw.Container(
      color: PdfColor.fromHex('#e8f0d8'),
      height: rowH,
      child: pw.Row(
        children: [
          cell('', width: colNo, bg: PdfColor.fromHex('#e8f0d8')),
          _vline(borderColor),
          cell('TOTAL SURAT SELESAI',
              font: bold,
              align: pw.TextAlign.left,
              width: colSurah,
              bg: PdfColor.fromHex('#e8f0d8')),
          _vline(borderColor),
          cell('', width: colAyat, bg: PdfColor.fromHex('#e8f0d8')),
          _vline(borderColor),
          cell('', width: colSetoran, bg: PdfColor.fromHex('#e8f0d8')),
          _vline(borderColor),
          cell('$selesaiCount / 37',
              font: bold,
              color: PdfColor.fromHex('#4a6130'),
              bg: PdfColor.fromHex('#e8f0d8')),
        ],
      ),
    );

    return pw.Container(
      decoration: pw.BoxDecoration(
        border: pw.Border.all(color: borderColor, width: 0.8),
      ),
      child: pw.Column(
        mainAxisSize: pw.MainAxisSize.min,
        crossAxisAlignment: pw.CrossAxisAlignment.stretch,
        children: [
          headerRow,
          pw.Divider(thickness: 0.5, color: borderColor, height: 0),
          ...dataRows.expand((r) => [
                r,
                pw.Divider(thickness: 0.3, color: borderColor, height: 0),
              ]),
          totalRow,
        ],
      ),
    );
  }

  static pw.Widget _vline(PdfColor color) => pw.Container(
        width: 0.5,
        color: color,
      );

  // ── TANDA TANGAN ──────────────────────────────────────────────────────────
  static pw.Widget _sign(pw.Font regular, pw.Font bold) {
    pw.Widget signCol(String role, String name) => pw.Column(
          mainAxisSize: pw.MainAxisSize.min,
          crossAxisAlignment: pw.CrossAxisAlignment.center,
          children: [
            pw.Text(role,
                style: pw.TextStyle(font: regular, fontSize: 8.5),
                textAlign: pw.TextAlign.center),
            pw.SizedBox(height: 36),
            pw.Container(
              width: 100,
              height: 0.5,
              color: PdfColors.black,
            ),
            pw.SizedBox(height: 2),
            pw.Text(name,
                style: pw.TextStyle(font: bold, fontSize: 8.5),
                textAlign: pw.TextAlign.center),
          ],
        );

    return pw.Row(
      mainAxisAlignment: pw.MainAxisAlignment.spaceAround,
      children: [
        signCol('Mengetahui,\nKepala Sekolah', 'Ahmad Fauzan, S.Pd.I'),
        signCol('Guru Tahfizd', 'Belinda Blanche, S.Kom'),
        signCol('Orang Tua / Wali', '___________________'),
      ],
    );
  }
}
