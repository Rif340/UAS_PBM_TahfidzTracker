import 'package:flutter/material.dart';

// Model data surat
class SuratItem {
  final int no;
  final String nama;
  final int ayat;
  final int juz;
  bool sudahAda;
  bool isSelected;

  SuratItem({
    required this.no,
    required this.nama,
    required this.ayat,
    required this.juz,
    this.sudahAda = false,
    this.isSelected = false,
  });
}

class FormTargetHafalanScreen extends StatefulWidget {
  const FormTargetHafalanScreen({super.key});

  @override
  State<FormTargetHafalanScreen> createState() => _FormTargetHafalanScreenState();
}

class _FormTargetHafalanScreenState extends State<FormTargetHafalanScreen> {
  String? selectedKelas;
  String? selectedRombel;

  // Daftar surat yang saat ini ada di target hafalan (bisa di-drag)
  List<SuratItem> targetSuratList = [
    SuratItem(no: 78, nama: 'An-Naba', ayat: 40, juz: 30, sudahAda: true),
    SuratItem(no: 79, nama: 'An-Nazi\'at', ayat: 46, juz: 30, sudahAda: true),
    SuratItem(no: 80, nama: 'Abasa', ayat: 42, juz: 30, sudahAda: true),
  ];

  // Master daftar surat untuk modal bottom sheet
  List<SuratItem> masterSuratList = [
    SuratItem(no: 78, nama: 'An-Naba', ayat: 40, juz: 30, sudahAda: true),
    SuratItem(no: 79, nama: 'An-Nazi\'at', ayat: 46, juz: 30, sudahAda: true),
    SuratItem(no: 80, nama: 'Abasa', ayat: 42, juz: 30, sudahAda: true),
    SuratItem(no: 81, nama: 'At-Takwir', ayat: 29, juz: 30, sudahAda: false),
    SuratItem(no: 82, nama: 'Al-Infitar', ayat: 19, juz: 30, sudahAda: false),
    SuratItem(no: 83, nama: 'Al-Mutaffifin', ayat: 36, juz: 30, sudahAda: false),
    SuratItem(no: 84, nama: 'Al-Insyiqaq', ayat: 25, juz: 30, sudahAda: false),
    SuratItem(no: 85, nama: 'Al-Buruj', ayat: 22, juz: 30, sudahAda: false),
    SuratItem(no: 86, nama: 'At-Tariq', ayat: 17, juz: 30, sudahAda: false),
    SuratItem(no: 87, nama: 'Al-A\'la', ayat: 19, juz: 30, sudahAda: false),
  ];

  void _showPilihSuratBottomSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      barrierColor: Colors.black.withOpacity(0.5),
      builder: (context) {
        return _PilihSuratModal(
          masterSurat: masterSuratList,
          onSuratAdded: (List<SuratItem> newlyAdded) {
            setState(() {
              for (var s in newlyAdded) {
                if (!targetSuratList.any((existing) => existing.no == s.no)) {
                  targetSuratList.add(
                    SuratItem(no: s.no, nama: s.nama, ayat: s.ayat, juz: s.juz, sudahAda: true),
                  );
                }
                // Update status di master
                final idx = masterSuratList.indexWhere((m) => m.no == s.no);
                if (idx != -1) masterSuratList[idx].sudahAda = true;
              }
            });
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFAFBF8),
      body: Stack(
        children: [
          // KONTEN UTAMA DENGAN DRAG LIST
          SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 1. HEADER ATAS (GAMBAR 2)
                _buildHeader(context),

                const SizedBox(height: 24),

                // 2. FORM UTAMA (GAMBAR 1)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // Judul Form: Poppins, 28, Bold, Rata Tengah
                      const Text(
                        'Form Target Hafalan',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF5B6E3F),
                        ),
                      ),
                      const SizedBox(height: 6),

                      // Subjudul: Poppins, 16, Regular, Rata Tengah
                      const Text(
                        'buat target hafalan pada kelas',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 16,
                          fontWeight: FontWeight.w400,
                          color: Color(0xFF6B7280),
                        ),
                      ),

                      const SizedBox(height: 24),

                      // Dropdown Pilih Kelas & Pilih Rombel Bersebelahan
                      Row(
                        children: [
                          Expanded(
                            child: _buildFieldGroup(
                              label: 'Pilih Kelas :',
                              child: _buildDropdown(
                                hint: 'Pilih kelas',
                                value: selectedKelas,
                                items: ['Kelas 1', 'Kelas 2', 'Kelas 3', 'Kelas 4', 'Kelas 5', 'Kelas 6'],
                                onChanged: (val) => setState(() => selectedKelas = val),
                              ),
                            ),
                          ),
                          const SizedBox(width: 14),
                          Expanded(
                            child: _buildFieldGroup(
                              label: 'Pilih Rombel :',
                              child: _buildDropdown(
                                hint: 'Pilih rombel',
                                value: selectedRombel,
                                items: ['Rombel A', 'Rombel B', 'Rombel C', 'Rombel D', 'Rombel E', 'Rombel F'],
                                onChanged: (val) => setState(() => selectedRombel = val),
                              ),
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 24),

                      // Header Daftar Surat
                      Align(
                        alignment: Alignment.centerLeft,
                        child: const Text(
                          'Daftar Surat',
                          style: TextStyle(
                            fontFamily: 'Plus Jakarta Sans',
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF4B5563),
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),

                      // 3. DAFTAR SURAT YANG BISA DI-DRAG (ReorderableListView)
                      ReorderableListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: targetSuratList.length,
                        onReorder: (int oldIndex, int newIndex) {
                          setState(() {
                            if (oldIndex < newIndex) {
                              newIndex -= 1;
                            }
                            final SuratItem item = targetSuratList.removeAt(oldIndex);
                            targetSuratList.insert(newIndex, item);
                          });
                        },
                        itemBuilder: (context, index) {
                          final item = targetSuratList[index];
                          return Container(
                            key: ValueKey(item.no),
                            margin: const EdgeInsets.only(bottom: 12),
                            height: 66,
                            decoration: BoxDecoration(
                              color: const Color(0xFFFAFBF8),
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: const Color(0xFFA0B175), width: 1.2),
                            ),
                            padding: const EdgeInsets.symmetric(horizontal: 14),
                            child: Row(
                              children: [
                                // Ikon titik-titik untuk drag di sisi kiri
                                ReorderableDragStartListener(
                                  index: index,
                                  child: Image.asset(
                                    'assets/icons/Icon_titik_titik_untuk_field_yang_drag.png',
                                    width: 22,
                                    height: 22,
                                    errorBuilder: (context, error, stackTrace) =>
                                        const Icon(Icons.drag_indicator, color: Color(0xFF6B7280)),
                                  ),
                                ),
                                const SizedBox(width: 14),

                                // Nama Surat & Jumlah Ayat
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        item.nama,
                                        style: const TextStyle(
                                          fontFamily: 'Plus Jakarta Sans',
                                          fontSize: 14,
                                          fontWeight: FontWeight.w500,
                                          color: Color(0xFF2C3E2D),
                                        ),
                                      ),
                                      const SizedBox(height: 2),
                                      Text(
                                        '${item.ayat} Ayat',
                                        style: const TextStyle(
                                          fontFamily: 'Plus Jakarta Sans',
                                          fontSize: 13,
                                          fontWeight: FontWeight.w400,
                                          color: Color(0xFF666666),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),

                                // Ikon Sampah di pojok kanan
                                InkWell(
                                  onTap: () {
                                    setState(() {
                                      final removed = targetSuratList.removeAt(index);
                                      final mIdx = masterSuratList.indexWhere((m) => m.no == removed.no);
                                      if (mIdx != -1) masterSuratList[mIdx].sudahAda = false;
                                    });
                                  },
                                  borderRadius: BorderRadius.circular(8),
                                  child: Padding(
                                    padding: const EdgeInsets.all(6.0),
                                    child: Image.asset(
                                      'assets/icons/icon_sampah_untuk_field_drag.png',
                                      width: 20,
                                      height: 20,
                                      errorBuilder: (context, error, stackTrace) =>
                                          const Icon(Icons.delete_outline, color: Color(0xFF8B9E68), size: 22),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),

                      const SizedBox(height: 10),

                      // Tombol "+ Tambah Surat"
                      Align(
                        alignment: Alignment.center,
                        child: ElevatedButton.icon(
                          onPressed: _showPilihSuratBottomSheet,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFFAAB881),
                            foregroundColor: Colors.white,
                            elevation: 0,
                            padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 12),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          icon: const Icon(Icons.add, color: Colors.white, size: 20),
                          label: const Text(
                            'Tambah Surat',
                            style: TextStyle(
                              fontFamily: 'Plus Jakarta Sans',
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 140), // Ruang agar tidak tertutup sticky footer
                    ],
                  ),
                ),
              ],
            ),
          ),

          // 4. BAGIAN BAWAH: FOOTER STICKY DI DEPAN (GAMBAR 3)
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: Container(
              padding: const EdgeInsets.only(left: 24, right: 24, top: 14, bottom: 24),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.06),
                    blurRadius: 10,
                    offset: const Offset(0, -4),
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    'Pastikan kelas, rombel, hari, dan jam sudah sesuai',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontFamily: 'Plus Jakarta Sans',
                      fontSize: 12,
                      color: Color(0xFF6B7280),
                    ),
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text(
                              'Target Hafalan Berhasil Disimpan!',
                              style: TextStyle(fontFamily: 'Plus Jakarta Sans'),
                            ),
                            backgroundColor: Color(0xFF5B6E3F),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFAAB881),
                        foregroundColor: Colors.white,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text(
                        'Simpan Target',
                        style: TextStyle(
                          fontFamily: 'Plus Jakarta Sans',
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
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

  // Header Hijau Melengkung
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
            Row(
            children: [
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
                  alignment: Alignment.center,
                  child: Image.asset(
                    'assets/icons/icon_back_untuk_header.png',
                    width: 38,
                    height: 38,
                    fit: BoxFit.contain,
                    errorBuilder: (context, error, stackTrace) =>
                        const Icon(Icons.arrow_back_ios_new, color: Colors.white, size: 18),
                  ),
                ),
              ),
              const SizedBox(width: 14),
              const Expanded(
                child: Text(
                  'Membuat Target\nHafalan',
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
              const SizedBox(width: 38),
            ],
          ),
        ],
      ),
    ),
    );
  }

  Widget _buildFieldGroup({required String label, required Widget child}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontFamily: 'Plus Jakarta Sans',
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Color(0xFF6B7280),
          ),
        ),
        const SizedBox(height: 8),
        child,
      ],
    );
  }

  Widget _buildDropdown({
    required String hint,
    required String? value,
    required List<String> items,
    required ValueChanged<String?> onChanged,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
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
              fontSize: 14,
              fontWeight: FontWeight.w400,
              color: Color(0xFF9E9E9E),
            ),
          ),
          icon: const Icon(Icons.keyboard_arrow_down, color: Color(0xFF6F824E)),
          items: items.map<DropdownMenuItem<String>>((String val) {
            return DropdownMenuItem<String>(
              value: val,
              child: Text(
                val,
                style: const TextStyle(
                  fontFamily: 'Plus Jakarta Sans',
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  color: Color(0xFF333333),
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

// ============================================================================
// MODAL BOTTOM SHEET: PILIH SURAT (GAMBAR 4 & 5)
// ============================================================================
class _PilihSuratModal extends StatefulWidget {
  final List<SuratItem> masterSurat;
  final ValueChanged<List<SuratItem>> onSuratAdded;

  const _PilihSuratModal({
    required this.masterSurat,
    required this.onSuratAdded,
  });

  @override
  State<_PilihSuratModal> createState() => _PilihSuratModalState();
}

class _PilihSuratModalState extends State<_PilihSuratModal> {
  String selectedFilter = 'Semua';
  String searchQuery = '';
  late List<SuratItem> localList;
  bool isJuzChecked = false;

  final List<String> filterList = [
    'Semua',
    'Juz 30',
    'Juz 29',
    'Juz 28',
    'Juz 27',
    'Juz 26',
  ];

  @override
  void initState() {
    super.initState();
    localList = widget.masterSurat
        .map((s) => SuratItem(
              no: s.no,
              nama: s.nama,
              ayat: s.ayat,
              juz: s.juz,
              sudahAda: s.sudahAda,
              isSelected: false,
            ))
        .toList();
  }

  int get selectedCount => localList.where((s) => s.isSelected && !s.sudahAda).length;

  void _toggleAllJuz(bool check) {
    setState(() {
      isJuzChecked = check;
      for (var s in localList) {
        if (!s.sudahAda) {
          s.isSelected = check;
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final filtered = localList.where((s) {
      if (searchQuery.isNotEmpty && !s.nama.toLowerCase().contains(searchQuery.toLowerCase())) {
        return false;
      }
      return true;
    }).toList();

    return Container(
      height: MediaQuery.of(context).size.height * 0.88,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(24),
          topRight: Radius.circular(24),
        ),
      ),
      child: Column(
        children: [
          const SizedBox(height: 10),
          // Garis Handle D1D5DB, Lebar 48, Tinggi 4, Rata Tengah
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

          // Header: Judul "Pilih Surat" Sejajar Icon Close
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Pilih Surat',
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1F2937),
                  ),
                ),
                InkWell(
                  onTap: () => Navigator.pop(context),
                  borderRadius: BorderRadius.circular(8),
                  child: Image.asset(
                    'assets/icons/icon_sampah_untuk_pilih_surat.png',
                    width: 24,
                    height: 24,
                    errorBuilder: (context, error, stackTrace) =>
                        const Icon(Icons.close, color: Colors.black54),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 4),

          // Subjudul
          Align(
            alignment: Alignment.centerLeft,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: const Text(
                'Tambahkan surat untuk target hafalan',
                style: TextStyle(
                  fontFamily: 'Plus Jakarta Sans',
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  color: Color(0xFF6B7280),
                ),
              ),
            ),
          ),

          const SizedBox(height: 16),

          // Field Search (Padding 16, Font Poppins 16, Border DFE4D5, Fill FAFBF8)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Container(
              height: 48,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                color: const Color(0xFFFAFBF8),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: const Color(0xFFDFE4D5), width: 1.2),
              ),
              child: TextField(
                onChanged: (val) => setState(() => searchQuery = val),
                style: const TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 15,
                  fontWeight: FontWeight.w400,
                ),
                decoration: const InputDecoration(
                  hintText: 'Cari nama surat...',
                  hintStyle: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 14,
                    color: Color(0xFF9E9E9E),
                  ),
                  border: InputBorder.none,
                  isDense: true,
                  contentPadding: EdgeInsets.symmetric(vertical: 13),
                ),
              ),
            ),
          ),

          const SizedBox(height: 14),

          // Filter Horizontal Juz (Tinggi 31, Radius 50, Font Plus Jakarta Sans 12 Bold)
          SizedBox(
            height: 34,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 24),
              itemCount: filterList.length,
              itemBuilder: (context, idx) {
                final f = filterList[idx];
                final bool isActive = selectedFilter == f;
                return Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: InkWell(
                    onTap: () => setState(() => selectedFilter = f),
                    borderRadius: BorderRadius.circular(50),
                    child: Container(
                      height: 31,
                      padding: const EdgeInsets.symmetric(horizontal: 14),
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: isActive ? const Color(0xFFB0BF7C) : Colors.white,
                        borderRadius: BorderRadius.circular(50),
                        border: Border.all(color: const Color(0xFFB0BF7C), width: 1.2),
                      ),
                      child: Text(
                        f,
                        style: TextStyle(
                          fontFamily: 'Plus Jakarta Sans',
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: isActive ? Colors.white : const Color(0xFFB0BF7C),
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),

          const SizedBox(height: 16),

          // Header Juz 30 & Checkbox Pilih Semua
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Juz 30',
                  style: TextStyle(
                    fontFamily: 'Plus Jakarta Sans',
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF2C3E2D),
                  ),
                ),
                InkWell(
                  onTap: () => _toggleAllJuz(!isJuzChecked),
                  child: Image.asset(
                    isJuzChecked
                        ? 'assets/icons/icon_checkbox_untuk_nambah_surat_kalo_sedang_di_klik.png'
                        : 'assets/icons/icon_checkbox_untuk_nambah_surat.png',
                    width: 22,
                    height: 22,
                    errorBuilder: (context, error, stackTrace) => Icon(
                      isJuzChecked ? Icons.check_box : Icons.check_box_outline_blank,
                      color: const Color(0xFFAAB881),
                      size: 22,
                    ),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 10),

          // DAFTAR SURAT
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              itemCount: filtered.length,
              itemBuilder: (context, index) {
                final s = filtered[index];
                final bool isSelected = s.isSelected;

                return InkWell(
                  onTap: s.sudahAda
                      ? null
                      : () {
                          setState(() {
                            s.isSelected = !s.isSelected;
                          });
                        },
                  child: Container(
                    height: 56,
                    margin: const EdgeInsets.only(bottom: 6),
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    decoration: BoxDecoration(
                      color: isSelected ? const Color(0xFFE8EDD0) : Colors.transparent,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Row(
                      children: [
                        // Angka Urutan Surat (Font Plus Jakarta Sans 12 Regular)
                        SizedBox(
                          width: 26,
                          child: Text(
                            '${s.no}',
                            style: const TextStyle(
                              fontFamily: 'Plus Jakarta Sans',
                              fontSize: 12,
                              fontWeight: FontWeight.w400,
                              color: Color(0xFF9CA3AF),
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),

                        // Nama Surat & Jumlah Ayat (Font Plus Jakarta Sans 14 Bold)
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                s.nama,
                                style: const TextStyle(
                                  fontFamily: 'Plus Jakarta Sans',
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF1F2937),
                                ),
                              ),
                              Text(
                                '${s.ayat} ayat',
                                style: const TextStyle(
                                  fontFamily: 'Plus Jakarta Sans',
                                  fontSize: 12,
                                  fontWeight: FontWeight.w400,
                                  color: Color(0xFF9CA3AF),
                                ),
                              ),
                            ],
                          ),
                        ),

                        // Status Badge "Sudah ada" ATAU Checkbox
                        if (s.sudahAda) ...[
                          Container(
                            height: 22,
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                            decoration: BoxDecoration(
                              color: const Color(0xFFF3F4F6),
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(color: const Color(0xFFE5E7EB)),
                            ),
                            child: const Text(
                              'Sudah ada',
                              style: TextStyle(
                                fontFamily: 'Plus Jakarta Sans',
                                fontSize: 11,
                                fontWeight: FontWeight.w500,
                                color: Color(0xFF9CA3AF),
                              ),
                            ),
                          ),
                        ] else ...[
                          Image.asset(
                            isSelected
                                ? 'assets/icons/icon_checkbox_untuk_nambah_surat_kalo_sedang_di_klik.png'
                                : 'assets/icons/icon_checkbox_untuk_nambah_surat.png',
                            width: 22,
                            height: 22,
                            errorBuilder: (context, error, stackTrace) => Icon(
                              isSelected ? Icons.check_box : Icons.check_box_outline_blank,
                              color: const Color(0xFFAAB881),
                              size: 22,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                );
              },
            ),
          ),

          // Tombol Bawah "Tambahkan X Surat"
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
            child: SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton(
                onPressed: selectedCount == 0
                    ? null
                    : () {
                        final selected = localList.where((s) => s.isSelected && !s.sudahAda).toList();
                        widget.onSuratAdded(selected);
                        Navigator.pop(context);
                      },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFAAB881),
                  disabledBackgroundColor: const Color(0xFFD6DEC9),
                  foregroundColor: Colors.white,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Text(
                  selectedCount > 0 ? 'Tambahkan $selectedCount Surat' : 'Pilih Surat',
                  style: const TextStyle(
                    fontFamily: 'Plus Jakarta Sans',
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
