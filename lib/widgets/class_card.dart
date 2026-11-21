import 'package:flutter/material.dart';

class ClassCard extends StatelessWidget {
  final String kelas;
  final String subKelas;
  final String waktu;
  final String guru;
  final String buttonLabel;
  final VoidCallback onButtonPressed;
  final String? secondaryActionLabel;
  final VoidCallback? onSecondaryAction;

  const ClassCard({
    super.key,
    required this.kelas,
    required this.subKelas,
    required this.waktu,
    required this.guru,
    required this.buttonLabel,
    required this.onButtonPressed,
    this.secondaryActionLabel,
    this.onSecondaryAction,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          // Banner Atas Hijau
          Container(
            padding: const EdgeInsets.all(16),
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFFABC07E), Color(0xFF6F824E)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      kelas,
                      style: const TextStyle(
                        fontFamily: 'Plus Jakarta Sans',
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      subKelas,
                      style: const TextStyle(
                        fontFamily: 'Plus Jakarta Sans',
                        color: Colors.white,
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      waktu,
                      style: const TextStyle(
                        fontFamily: 'Plus Jakarta Sans',
                        color: Colors.white70,
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
                // Vektor Topi Wisuda Asli dari Asset Anda
                Image.asset(
                  'assets/images/Topi_Wisuda_Vector_Buat_Di_Card_Kelas.png',
                  width: 58,
                  height: 58,
                  errorBuilder: (context, error, stackTrace) =>
                      const Icon(Icons.school, size: 54, color: Colors.white70),
                ),
              ],
            ),
          ),

          // Detail Bawah
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            child: Row(
              children: [
                // Info Guru (Avatar + Nama) dengan Expanded agar fleksibel menyesuaikan lebar HP
                Expanded(
                  child: Row(
                    children: [
                      ClipOval(
                        child: Image.asset(
                          'assets/images/Foto_Belinda_Blanche_Di_Card_Kelas.png',
                          width: 34,
                          height: 34,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) =>
                              const CircleAvatar(radius: 17, backgroundColor: Colors.grey),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          guru,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontFamily: 'Plus Jakarta Sans',
                            fontWeight: FontWeight.w600,
                            fontSize: 12.5,
                            color: Color(0xFF333333),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),

                // Tombol Aksi (Ubah & Pergi)
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (secondaryActionLabel != null) ...[
                      TextButton(
                        onPressed: onSecondaryAction,
                        style: TextButton.styleFrom(
                          foregroundColor: const Color(0xFF6F824E),
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 0),
                          minimumSize: Size.zero,
                          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        ),
                        child: Text(
                          secondaryActionLabel!,
                          style: const TextStyle(
                            fontFamily: 'Plus Jakarta Sans',
                            fontSize: 12.5,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      const SizedBox(width: 6),
                    ],
                    ElevatedButton(
                      onPressed: onButtonPressed,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF657E47),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                        minimumSize: Size.zero,
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        elevation: 0,
                      ),
                      child: Text(
                        buttonLabel,
                        style: const TextStyle(
                          fontFamily: 'Plus Jakarta Sans',
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}