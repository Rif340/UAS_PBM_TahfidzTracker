import 'package:flutter/material.dart';
import 'package:tahfizd_tracker/widgets/class_card.dart';
import 'detail_kelas_screen.dart';
import 'form_tambah_tahfidz_screen.dart';

class JadwalTahfidzScreen extends StatefulWidget {
  const JadwalTahfidzScreen({super.key});

  @override
  State<JadwalTahfidzScreen> createState() => _JadwalTahfidzScreenState();
}

class _JadwalTahfidzScreenState extends State<JadwalTahfidzScreen> {
  String selectedDay = 'Semua hari';

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header Jadwal
          _buildJadwalHeader(),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Hari',
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Color(0xFF333333)),
                ),
                const SizedBox(height: 8),
                _buildDropdownHari(),
                const SizedBox(height: 20),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: const [
                    Text(
                      'Daftar jadwal',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF2C3E2D)),
                    ),
                    Text(
                      '7 jadwal',
                      style: TextStyle(fontSize: 13, color: Colors.black45),
                    ),
                  ],
                ),
                const SizedBox(height: 12),

                // Kartu Jadwal 1
                ClassCard(
                  kelas: 'Tahfizd',
                  subKelas: 'Kelas 6A',
                  waktu: 'Selasa, 07.00 – 10.00',
                  guru: 'Belinda Blanche, S.Kom',
                  buttonLabel: 'Pergi',
                  secondaryActionLabel: 'Ubah',
                  onSecondaryAction: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const FormTambahTahfidzScreen(
                          isUbah: true,
                          initialKelas: 'Kelas 6',
                          initialRombel: 'Rombel A',
                          initialHari: 'Selasa',
                        ),
                      ),
                    );
                  },
                  onButtonPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const DetailKelasScreen()),
                    );
                  },
                ),
                const SizedBox(height: 16),

                // Kartu Jadwal 2
                ClassCard(
                  kelas: 'Tahfizd',
                  subKelas: 'Kelas 6A',
                  waktu: 'Selasa, 07.00 – 10.00',
                  guru: 'Belinda Blanche, S.Kom',
                  buttonLabel: 'Pergi',
                  secondaryActionLabel: 'Ubah',
                  onSecondaryAction: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const FormTambahTahfidzScreen(
                          isUbah: true,
                          initialKelas: 'Kelas 6',
                          initialRombel: 'Rombel A',
                          initialHari: 'Selasa',
                        ),
                      ),
                    );
                  },
                  onButtonPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const DetailKelasScreen()),
                    );
                  },
                ),
                const SizedBox(height: 80),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildJadwalHeader() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.only(top: 16, left: 24, right: 24, bottom: 24),
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
              ClipOval(
                child: Image.asset(
                  'assets/images/Foto_Belinda_Blanche_Di_Card_Kelas.png',
                  width: 52,
                  height: 52,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) =>
                      const CircleAvatar(radius: 26, backgroundColor: Colors.white30),
                ),
              ),
              const SizedBox(width: 14),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text(
                    'Hai, Belinda Blanche, S.Kom',
                    style: TextStyle(
                      fontFamily: 'Plus Jakarta Sans',
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 2),
                  Text(
                    'Selasa, 6 Oktober 2026',
                    style: TextStyle(
                      fontFamily: 'Plus Jakarta Sans',
                      color: Colors.white70,
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 20),
          const Text(
            'Jadwal Tahfizd',
            style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold, letterSpacing: 0.5),
          ),
        ],
      ),
    ),
    );
  }

  Widget _buildDropdownHari() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE2E7D8)),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: selectedDay,
          isExpanded: true,
          icon: const Icon(Icons.keyboard_arrow_down, color: Color(0xFF6F824E)),
          items: <String>['Semua hari', 'Senin', 'Selasa', 'Rabu', 'Kamis', 'Jumat']
              .map<DropdownMenuItem<String>>((String val) {
            return DropdownMenuItem<String>(
              value: val,
              child: Text(val, style: const TextStyle(fontSize: 14, color: Color(0xFF333333))),
            );
          }).toList(),
          onChanged: (String? val) {
            if (val != null) setState(() => selectedDay = val);
          },
        ),
      ),
    );
  }
}