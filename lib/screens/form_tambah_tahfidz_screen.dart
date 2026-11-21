import 'package:flutter/material.dart';

class FormTambahTahfidzScreen extends StatefulWidget {
  final bool? isUbah;
  final String? initialKelas;
  final String? initialRombel;
  final String? initialHari;
  final TimeOfDay? initialJamMasuk;
  final TimeOfDay? initialJamKeluar;

  const FormTambahTahfidzScreen({
    super.key,
    this.isUbah = false,
    this.initialKelas,
    this.initialRombel,
    this.initialHari,
    this.initialJamMasuk,
    this.initialJamKeluar,
  });

  @override
  State<FormTambahTahfidzScreen> createState() => _FormTambahTahfidzScreenState();
}

class _FormTambahTahfidzScreenState extends State<FormTambahTahfidzScreen> {
  bool get _isUbah => widget.isUbah == true;

  String? selectedKelas;
  String? selectedRombel;
  String? selectedHari;

  TimeOfDay jamMasuk = const TimeOfDay(hour: 7, minute: 0);
  TimeOfDay jamKeluar = const TimeOfDay(hour: 10, minute: 0);

  @override
  void initState() {
    super.initState();
    selectedKelas = widget.initialKelas;
    selectedRombel = widget.initialRombel;
    selectedHari = widget.initialHari;
    if (widget.initialJamMasuk != null) jamMasuk = widget.initialJamMasuk!;
    if (widget.initialJamKeluar != null) jamKeluar = widget.initialJamKeluar!;
  }

  Future<void> _selectTime(BuildContext context, bool isMasuk) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: isMasuk ? jamMasuk : jamKeluar,
    );
    if (picked != null) {
      setState(() {
        if (isMasuk) {
          jamMasuk = picked;
        } else {
          jamKeluar = picked;
        }
      });
    }
  }

  String _formatTime(TimeOfDay time) {
    final String hour = time.hour.toString().padLeft(2, '0');
    final String minute = time.minute.toString().padLeft(2, '0');
    return '$hour:$minute';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFAFBF8),
      body: Stack(
        children: [
          // KONTEN UTAMA YANG BISA DI-SCROLL
          SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ==========================================
                // 1. BAGIAN ATAS: HEADER HIJAU GRADASI (GAMBAR 3)
                // ==========================================
                _buildHeader(context),

                const SizedBox(height: 24),

                // ==========================================
                // 2. BAGIAN ISI: FORM INPUT DETAIL (GAMBAR 2)
                // ==========================================
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // Judul Form: Poppins, 28, Bold, Rata Tengah
                      Text(
                        _isUbah ? 'Form Perubahan Tahfizd' : 'Form Tambah Tahfizd',
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF5B6E3F),
                        ),
                      ),
                      const SizedBox(height: 6),

                      // Subjudul: Poppins, 16, Regular, Rata Tengah
                      const Text(
                        'Isi detail kelas yang akan anda ajar',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 16,
                          fontWeight: FontWeight.w400,
                          color: Color(0xFF6B7280),
                        ),
                      ),

                      const SizedBox(height: 28),

                      // Grup Field 1: Masukan Kelas :
                      _buildFieldGroup(
                        label: 'Masukan Kelas :',
                        child: _buildDropdown(
                          hint: 'Pilih Kelas 1–6',
                          value: selectedKelas,
                          items: ['Kelas 1', 'Kelas 2', 'Kelas 3', 'Kelas 4', 'Kelas 5', 'Kelas 6'],
                          onChanged: (val) => setState(() => selectedKelas = val),
                        ),
                      ),

                      const SizedBox(height: 20),

                      // Grup Field 2: Pilih Rombel :
                      _buildFieldGroup(
                        label: 'Pilih Rombel :',
                        child: _buildDropdown(
                          hint: 'Tentukan Rombel A–F',
                          value: selectedRombel,
                          items: ['Rombel A', 'Rombel B', 'Rombel C', 'Rombel D', 'Rombel E', 'Rombel F'],
                          onChanged: (val) => setState(() => selectedRombel = val),
                        ),
                      ),

                      const SizedBox(height: 20),

                      // Grup Field 3: Tentukan Hari :
                      _buildFieldGroup(
                        label: 'Tentukan Hari :',
                        child: _buildDropdown(
                          hint: 'Semua hari',
                          value: selectedHari,
                          items: ['Semua hari', 'Senin', 'Selasa', 'Rabu', 'Kamis', 'Jumat', 'Sabtu'],
                          onChanged: (val) => setState(() => selectedHari = val),
                        ),
                      ),

                      const SizedBox(height: 20),

                      // Grup Field 4: Tentukan Jam Pelajaran :
                      _buildFieldGroup(
                        label: 'Tentukan Jam Pelajaran :',
                        child: Row(
                          children: [
                            // Jam Masuk
                            Expanded(
                              child: Column(
                                children: [
                                  _buildTimePickerBox(
                                    time: _formatTime(jamMasuk),
                                    onTap: () => _selectTime(context, true),
                                  ),
                                  const SizedBox(height: 6),
                                  const Text(
                                    'Jam Masuk',
                                    style: TextStyle(
                                      fontFamily: 'Plus Jakarta Sans',
                                      fontSize: 12,
                                      color: Color(0xFF6B7280),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(width: 16),
                            // Jam Keluar
                            Expanded(
                              child: Column(
                                children: [
                                  _buildTimePickerBox(
                                    time: _formatTime(jamKeluar),
                                    onTap: () => _selectTime(context, false),
                                  ),
                                  const SizedBox(height: 6),
                                  const Text(
                                    'Jam Keluar',
                                    style: TextStyle(
                                      fontFamily: 'Plus Jakarta Sans',
                                      fontSize: 12,
                                      color: Color(0xFF6B7280),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 140), // Ruang agar konten bawah tidak tertutup tombol sticky
                    ],
                  ),
                ),
              ],
            ),
          ),

          // ==========================================
          // 3. BAGIAN BAWAH: FOOTER STICKY DI DEPAN (GAMBAR 2)
          // ==========================================
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
                        // Kembali ke halaman jadwal dengan notifikasi sukses
                        Navigator.pop(context);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              _isUbah
                                  ? 'Perubahan Jadwal Tahfizd Berhasil Disimpan!'
                                  : 'Jadwal Tahfizd Berhasil Disimpan!',
                              style: const TextStyle(fontFamily: 'Plus Jakarta Sans'),
                            ),
                            backgroundColor: const Color(0xFF5B6E3F),
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
                        'Simpan Kelas',
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

  // Header Hijau Melengkung dengan Icon Back Sejajar Teks Judul
  Widget _buildHeader(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.only(top: 16, left: 24, right: 24, bottom: 28),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Color(0xFFB5C384),
            Color(0xFF7A8B58),
          ],
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
            // Baris Tombol Back (38x38) Sejajar dengan Teks Judul "Tambah Jadwal Tahfizd" (Ukuran 20, SemiBold)
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
                  'Tambah Jadwal\nTahfizd',
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
              const SizedBox(width: 38), // Pengimbang agar teks benar-benar berada di tengah
            ],
          ),
        ],
      ),
    ),
    );
  }

  // Grup Label & Input
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

  // Dropdown dengan Border Radius 10, Border DFE4D5, Fill FAFBF8, Padding 16, Font Plus Jakarta Sans 14 Regular
  Widget _buildDropdown({
    required String hint,
    required String? value,
    required List<String> items,
    required ValueChanged<String?> onChanged,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
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

  // Kotak Pemilih Jam dengan Icon Jam
  Widget _buildTimePickerBox({
    required String time,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(10),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: const Color(0xFFFAFBF8),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: const Color(0xFFDFE4D5), width: 1.2),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              time,
              style: const TextStyle(
                fontFamily: 'Plus Jakarta Sans',
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: Color(0xFF333333),
              ),
            ),
            const Icon(Icons.access_time_rounded, color: Color(0xFF6F824E), size: 20),
          ],
        ),
      ),
    );
  }
}
