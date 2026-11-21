import 'package:flutter/material.dart';
import 'detail_siswa_screen.dart';

class MuridTahfidzScreen extends StatefulWidget {
  final VoidCallback? onBack;

  const MuridTahfidzScreen({
    super.key,
    this.onBack,
  });

  @override
  State<MuridTahfidzScreen> createState() => _MuridTahfidzScreenState();
}

class _MuridTahfidzScreenState extends State<MuridTahfidzScreen> {
  // Daftar murid contoh sesuai desain (Gambar 1 & 5)
  final List<Map<String, String>> daftarMurid = [
    {'nama': 'Bilal Hakim', 'kelas': 'Kelas 6A', 'inisial': 'BH'},
    {'nama': 'Bilal Hakim', 'kelas': 'Kelas 6A', 'inisial': 'BH'},
    {'nama': 'Bilal Hakim', 'kelas': 'Kelas 6A', 'inisial': 'BH'},
    {'nama': 'Bilal Hakim', 'kelas': 'Kelas 6A', 'inisial': 'BH'},
    {'nama': 'Bilal Hakim', 'kelas': 'Kelas 6A', 'inisial': 'BH'},
    {'nama': 'Bilal Hakim', 'kelas': 'Kelas 6A', 'inisial': 'BH'},
  ];

  void _navigateToDetailSiswa(Map<String, String> siswa) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => DetailSiswaScreen(
          siswa: {
            'nama': siswa['nama'] ?? 'Bilal Hakim',
            'surat': 'An-Naba, ayat 22/40',
            'inisial': siswa['inisial'] ?? 'BH',
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFAFBF8),
      body: Stack(
        children: [
          // 1. KONTEN YANG DAPAT DI-SCROLL
          SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // BAGIAN ATAS: HEADER HIJAU
                _buildHeader(context),

                const SizedBox(height: 20),

                // BAGIAN TENGAH / ISI: DAFTAR KARTU MURID (GAMBAR 1 & 5)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0),
                  child: ListView.builder(
                    padding: EdgeInsets.zero,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: daftarMurid.length,
                    itemBuilder: (context, index) {
                      final item = daftarMurid[index];
                      return Container(
                        margin: const EdgeInsets.only(bottom: 14),
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(color: const Color(0xFFDFE4D5), width: 1.2),
                        ),
                        child: Row(
                          children: [
                            // Avatar Bulat
                            GestureDetector(
                              onTap: () => _navigateToDetailSiswa(item),
                              child: Container(
                                width: 44,
                                height: 44,
                                decoration: BoxDecoration(
                                  color: const Color(0xFFDCE7C7),
                                  borderRadius: BorderRadius.circular(22),
                                ),
                                alignment: Alignment.center,
                                child: Text(
                                  item['inisial']!,
                                  style: const TextStyle(
                                    fontFamily: 'Plus Jakarta Sans',
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFF465635),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 14),

                            // Detail Nama & Kelas
                            Expanded(
                              child: GestureDetector(
                                behavior: HitTestBehavior.opaque,
                                onTap: () => _navigateToDetailSiswa(item),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      item['nama']!,
                                      style: const TextStyle(
                                        fontFamily: 'Plus Jakarta Sans',
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold,
                                        color: Color(0xFF263023),
                                      ),
                                    ),
                                    const SizedBox(height: 3),
                                    Text(
                                      item['kelas']!,
                                      style: const TextStyle(
                                        fontFamily: 'Plus Jakarta Sans',
                                        fontSize: 12,
                                        color: Color(0xFF72786C),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),

                            // Tombol "Detail" (Warna B0BF7C, Teks 465635 12 Bold)
                            Container(
                              height: 34,
                              decoration: BoxDecoration(
                                color: const Color(0xFFAAB881),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: TextButton(
                                onPressed: () => _navigateToDetailSiswa(item),
                                style: TextButton.styleFrom(
                                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 0),
                                  minimumSize: Size.zero,
                                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                ),
                                child: const Text(
                                  'Detail',
                                  style: TextStyle(
                                    fontFamily: 'Plus Jakarta Sans',
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                    color: Color(0xFF465635),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),

                // Ruang bawah agar list tidak tertutup sticky footer tombol "Tambah Murid Baru"
                const SizedBox(height: 90),
              ],
            ),
          ),

          // 2. BAGIAN BAWAH PERTAMA: STICKY FOOTER "Tambah Murid Baru" (GAMBAR 1 & 4)
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: Container(
              padding: const EdgeInsets.only(left: 24, right: 24, top: 12, bottom: 14),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.06),
                    blurRadius: 8,
                    offset: const Offset(0, -3),
                  ),
                ],
              ),
              child: SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton(
                  onPressed: _showTambahMuridBottomSheet,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFAAB881),
                    foregroundColor: Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    'Tambah Murid Baru',
                    style: TextStyle(
                      fontFamily: 'Plus Jakarta Sans',
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================================
  // BAGIAN ATAS: HEADER HIJAU GRADASI DENGAN BACK BUTTON & SUBJUDUL (GAMBAR 2)
  // ============================================================================
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
          children: [
            // Header Bar dengan tombol back dan Judul "Tambah Murid Tahfizd"
            Row(
            children: [
              GestureDetector(
                onTap: () {
                  if (widget.onBack != null) {
                    widget.onBack!();
                  } else {
                    Navigator.maybePop(context);
                  }
                },
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
                    child: const Icon(
                      Icons.chevron_left,
                      color: Colors.white,
                      size: 24,
                    ),
                  ),
                ),
              ),
              const Expanded(
                child: Text(
                  'Tambah\nMurid Tahfizd',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: 'Plus Jakarta Sans',
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                    height: 1.25,
                  ),
                ),
              ),
              const SizedBox(width: 38), // Counterbalance tombol back
            ],
          ),

          const SizedBox(height: 12),

          // Subjudul Header (Gambar 2):
          // "Daftarkan murid baru dan mulai pantau perjalanan hafalan Al-Qur'annya di sini."
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.0),
            child: Text(
              'Daftarkan murid baru dan mulai pantau perjalanan\nhafalan Al-Qur\'annya di sini.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: 'Plus Jakarta Sans',
                color: Colors.white,
                fontSize: 11.5,
                fontWeight: FontWeight.w400,
                height: 1.35,
              ),
            ),
          ),
        ],
      ),
    ),
    );
  }

  void _showTambahMuridBottomSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      barrierColor: Colors.black.withOpacity(0.5),
      builder: (context) {
        return _TambahMuridModal(
          onMuridAdded: (nama, kelas) {
            setState(() {
              final inisial = nama.trim().split(' ').map((e) => e.isNotEmpty ? e[0] : '').take(2).join().toUpperCase();
              daftarMurid.insert(0, {
                'nama': nama,
                'kelas': kelas,
                'inisial': inisial.isNotEmpty ? inisial : 'MR',
              });
            });
          },
        );
      },
    );
  }
}

// ============================================================================
// MODAL BOTTOM SHEET: TAMBAH MURID (SESUAI GAMBAR 1 & 2)
// ============================================================================
class _TambahMuridModal extends StatefulWidget {
  final void Function(String nama, String kelas) onMuridAdded;

  const _TambahMuridModal({required this.onMuridAdded});

  @override
  State<_TambahMuridModal> createState() => _TambahMuridModalState();
}

class _TambahMuridModalState extends State<_TambahMuridModal> {
  final TextEditingController _namaController = TextEditingController();
  final TextEditingController _nisnController = TextEditingController();

  String? selectedKelas;
  String? selectedRombel;
  String? selectedTahunAjaran;
  String statusMurid = 'Aktif'; // 'Nonaktif' atau 'Aktif'

  final List<String> listKelas = ['1', '2', '3', '4', '5', '6'];
  final List<String> listRombel = ['A', 'B', 'C', 'D', 'E', 'F'];
  final List<String> listTahunAjaran = ['2024/2025', '2025/2026', '2026/2027'];

  @override
  void dispose() {
    _namaController.dispose();
    _nisnController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(24),
          topRight: Radius.circular(24),
        ),
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: EdgeInsets.only(
            left: 20,
            right: 20,
            top: 12,
            bottom: MediaQuery.of(context).viewInsets.bottom + 16,
          ),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 1. Drag Handle (Abu-abu D1D5DB, Lebar 48, Tinggi 4)
                Center(
                  child: Container(
                    width: 48,
                    height: 4,
                    decoration: BoxDecoration(
                      color: const Color(0xFFD1D5DB),
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                // 2. Header: Judul "Tambah Murid" & Tombol Close (X)
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Tambah Murid',
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF1F2937),
                      ),
                    ),
                    IconButton(
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                      icon: const Icon(Icons.close, color: Color(0xFF1F2937), size: 24),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ],
                ),
                const SizedBox(height: 4),

                // Subjudul: "Tambahkan Murid untuk Kelas Tahfizd"
                const Text(
                  'Tambahkan Murid untuk Kelas Tahfizd',
                  style: TextStyle(
                    fontFamily: 'Plus Jakarta Sans',
                    fontSize: 13,
                    color: Color(0xFF6B7280),
                  ),
                ),
                const SizedBox(height: 18),

                // 3. Masukan Nama Lengkap
                const Text(
                  'Masukan Nama Lengkap :',
                  style: TextStyle(
                    fontFamily: 'Plus Jakarta Sans',
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF4B5563),
                  ),
                ),
                const SizedBox(height: 6),
                _buildInputField(
                  controller: _namaController,
                  hintText: 'Belinda Blanche',
                ),
                const SizedBox(height: 14),

                // 4. Masukan NISN
                const Text(
                  'Masukan NISN :',
                  style: TextStyle(
                    fontFamily: 'Plus Jakarta Sans',
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF4B5563),
                  ),
                ),
                const SizedBox(height: 6),
                _buildInputField(
                  controller: _nisnController,
                  hintText: '0001234567',
                  keyboardType: TextInputType.number,
                ),
                const SizedBox(height: 14),

                // 5. Masukan Kelas Dropdown
                const Text(
                  'Masukan Kelas :',
                  style: TextStyle(
                    fontFamily: 'Plus Jakarta Sans',
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF4B5563),
                  ),
                ),
                const SizedBox(height: 6),
                _buildDropdownField(
                  hint: 'Pilih Kelas 1–6',
                  value: selectedKelas,
                  items: listKelas.map((k) => 'Kelas $k').toList(),
                  onChanged: (val) => setState(() => selectedKelas = val),
                ),
                const SizedBox(height: 14),

                // 6. Pilih Rombel Dropdown
                const Text(
                  'Pilih Rombel :',
                  style: TextStyle(
                    fontFamily: 'Plus Jakarta Sans',
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF4B5563),
                  ),
                ),
                const SizedBox(height: 6),
                _buildDropdownField(
                  hint: 'Tentukan Rombel A-F',
                  value: selectedRombel,
                  items: listRombel.map((r) => 'Rombel $r').toList(),
                  onChanged: (val) => setState(() => selectedRombel = val),
                ),
                const SizedBox(height: 14),

                // 7. Pilih Tahun Ajaran Dropdown
                const Text(
                  'Pilih Tahun Ajaran :',
                  style: TextStyle(
                    fontFamily: 'Plus Jakarta Sans',
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF4B5563),
                  ),
                ),
                const SizedBox(height: 6),
                _buildDropdownField(
                  hint: 'Tentukan Tahun Ajaran',
                  value: selectedTahunAjaran,
                  items: listTahunAjaran,
                  onChanged: (val) => setState(() => selectedTahunAjaran = val),
                ),
                const SizedBox(height: 16),

                // 8. Status : Nonaktif & Aktif
                const Text(
                  'Status :',
                  style: TextStyle(
                    fontFamily: 'Plus Jakarta Sans',
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF4B5563),
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    // Opsi Nonaktif
                    GestureDetector(
                      onTap: () => setState(() => statusMurid = 'Nonaktif'),
                      child: Row(
                        children: [
                          Container(
                            width: 22,
                            height: 22,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: statusMurid == 'Nonaktif'
                                  ? const Color(0xFFA6BA79)
                                  : const Color(0xFFD1D5DB),
                            ),
                          ),
                          const SizedBox(width: 8),
                          const Text(
                            'Nonaktif',
                            style: TextStyle(
                              fontFamily: 'Plus Jakarta Sans',
                              fontSize: 13,
                              color: Color(0xFF1F2937),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 28),
                    // Opsi Aktif
                    GestureDetector(
                      onTap: () => setState(() => statusMurid = 'Aktif'),
                      child: Row(
                        children: [
                          Container(
                            width: 22,
                            height: 22,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: statusMurid == 'Aktif'
                                  ? const Color(0xFFA6BA79)
                                  : const Color(0xFFD1D5DB),
                            ),
                          ),
                          const SizedBox(width: 8),
                          const Text(
                            'Aktif',
                            style: TextStyle(
                              fontFamily: 'Plus Jakarta Sans',
                              fontSize: 13,
                              color: Color(0xFF1F2937),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),

                // 9. Tombol Hijau "Tambahkan"
                SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: ElevatedButton(
                    onPressed: () {
                      final inputNama = _namaController.text.trim();
                      final nama = inputNama.isNotEmpty ? inputNama : 'Belinda Blanche';
                      final kelas = (selectedKelas != null && selectedRombel != null)
                          ? '${selectedKelas!.replaceAll('Kelas ', 'Kelas ')}${selectedRombel!.replaceAll('Rombel ', '')}'
                          : 'Kelas 6A';

                      widget.onMuridAdded(nama, kelas);
                      Navigator.pop(context);

                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Murid $nama berhasil ditambahkan!'),
                          backgroundColor: const Color(0xFF7A8B58),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFAAB881),
                      foregroundColor: Colors.white,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: const Text(
                      'Tambahkan',
                      style: TextStyle(
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
      ),
    );
  }

  Widget _buildInputField({
    required TextEditingController controller,
    required String hintText,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return Container(
      height: 48,
      padding: const EdgeInsets.symmetric(horizontal: 14),
      decoration: BoxDecoration(
        color: const Color(0xFFFAFBF8),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: const Color(0xFFDFE4D5), width: 1.2),
      ),
      alignment: Alignment.centerLeft,
      child: TextField(
        controller: controller,
        keyboardType: keyboardType,
        style: const TextStyle(
          fontFamily: 'Plus Jakarta Sans',
          fontSize: 14,
          color: Color(0xFF1F2937),
        ),
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: const TextStyle(
            fontFamily: 'Plus Jakarta Sans',
            fontSize: 14,
            color: Color(0xFFB0B7A6),
          ),
          border: InputBorder.none,
          isDense: true,
          contentPadding: EdgeInsets.zero,
        ),
      ),
    );
  }

  Widget _buildDropdownField({
    required String hint,
    required String? value,
    required List<String> items,
    required ValueChanged<String?> onChanged,
  }) {
    return Container(
      height: 48,
      padding: const EdgeInsets.symmetric(horizontal: 14),
      decoration: BoxDecoration(
        color: const Color(0xFFFAFBF8),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: const Color(0xFFDFE4D5), width: 1.2),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: value,
          isExpanded: true,
          hint: Text(
            hint,
            style: const TextStyle(
              fontFamily: 'Plus Jakarta Sans',
              fontSize: 13,
              color: Color(0xFFB0B7A6),
            ),
          ),
          icon: const Icon(Icons.keyboard_arrow_down, color: Color(0xFF6F824E)),
          items: items.map((item) {
            return DropdownMenuItem<String>(
              value: item,
              child: Text(
                item,
                style: const TextStyle(
                  fontFamily: 'Plus Jakarta Sans',
                  fontSize: 14,
                  color: Color(0xFF1F2937),
                ),
              ),
            );
          }).toList(),
          onChanged: onChanged,
        ),
      ),
    );
  }
}
