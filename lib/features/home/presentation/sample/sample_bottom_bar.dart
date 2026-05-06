import 'package:flutter/material.dart';

class CustomBottomBarScreen extends StatefulWidget {
  const CustomBottomBarScreen({super.key});

  @override
  State<CustomBottomBarScreen> createState() => _CustomBottomBarScreenState();
}

class _CustomBottomBarScreenState extends State<CustomBottomBarScreen> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      body: Stack(
        children: [
          Center(
            child: Text(
              "Halaman ${_selectedIndex == 0
                  ? 'Home'
                  : _selectedIndex == 1
                  ? 'Pesanan'
                  : 'History/Profil'}",
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Stack(
              clipBehavior: Clip.none,
              alignment: Alignment.bottomCenter,
              children: [
                // 1. White Bar dengan Bentuk Custom Smooth
                ClipPath(
                  clipper: BottomBarClipper(notchRadius: 35, cornerRadius: 24),
                  clipBehavior:
                      Clip.antiAlias, // Penting: agar kurva tidak bergerigi
                  child: Container(
                    // margin: const EdgeInsets.symmetric(horizontal: 16),
                    height: 60,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.08),
                          blurRadius: 12,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        _buildNavItem(0, Icons.home_rounded, 'Home'),
                        _buildNavItem(1, Icons.receipt_long_rounded, 'Pesanan'),
                        const SizedBox(
                          width: 70,
                        ), // Ruang kosong untuk tombol hijau
                        _buildNavItem(2, Icons.history_rounded, 'History'),
                        _buildNavItem(3, Icons.person_rounded, 'Profil'),
                      ],
                    ),
                  ),
                ),

                // 2. Tombol Hijau Melayang
                Positioned(
                  top: -65, // Center tombol sejajar dengan garis atas bar
                  child: GestureDetector(
                    onTap: () => debugPrint('Scan tapped'),
                    child: Container(
                      width: 70,
                      height: 70,
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [Color(0xFF1B5E20), Color(0xFF4CAF50)],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.green.withOpacity(0.4),
                            blurRadius: 15,
                            spreadRadius: 2,
                          ),
                        ],
                      ),
                      child: const Icon(
                        Icons.center_focus_strong,
                        color: Colors.white,
                        size: 32,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNavItem(int index, IconData icon, String label) {
    bool isSelected = _selectedIndex == index;
    return GestureDetector(
      onTap: () => setState(() => _selectedIndex = index),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            color: isSelected ? const Color(0xFF2E7D32) : Colors.grey,
            size: 24,
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              color: isSelected ? const Color(0xFF2E7D32) : Colors.grey,
              fontSize: 11,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }
}

// Custom Clipper dengan kurva Bézier untuk transisi yang 100% smooth
class BottomBarClipper extends CustomClipper<Path> {
  final double notchRadius;
  final double cornerRadius;

  BottomBarClipper({required this.notchRadius, required this.cornerRadius});

  @override
  Path getClip(Size size) {
    final path = Path();
    final double notchCenterX = size.width / 2;
    final double notchLeft = notchCenterX - notchRadius;
    final double notchRight = notchCenterX + notchRadius;

    // Kedalaman lekukan (0.85 memberikan kurva natural yang tidak terlalu dalam)
    final double notchDepth = notchRadius * 0.85;

    // 1. Mulai dari pojok kiri bawah
    path.moveTo(0, size.height);

    // 2. Naik lurus ke sudut kiri atas
    path.lineTo(0, cornerRadius);

    // 3. Lengkungan sudut kiri atas
    path.arcToPoint(
      Offset(cornerRadius, 0),
      radius: Radius.circular(cornerRadius),
    );

    // 4. Garis atas kiri menuju awal notch
    path.lineTo(notchLeft, 0);

    // 5. Lengkungan smooth ke dalam (QUADRATIC BEZIER)
    // Titik kontrol di tengah secara horizontal, menarik kurva ke bawah
    path.quadraticBezierTo(
      notchCenterX,
      notchDepth, // Control Point
      notchRight,
      0, // End Point
    );

    // 6. Garis atas kanan menuju sudut kanan atas
    path.lineTo(size.width - cornerRadius, 0);

    // 7. Lengkungan sudut kanan atas
    path.arcToPoint(
      Offset(size.width, cornerRadius),
      radius: Radius.circular(cornerRadius),
    );

    // 8. Turun LURUS ke kanan bawah (TIDAK MELENGKUNG)
    path.lineTo(size.width, size.height);

    // 9. Garis bawah LURUS kembali ke kiri
    path.lineTo(0, size.height);

    path.close();
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => false;
}
