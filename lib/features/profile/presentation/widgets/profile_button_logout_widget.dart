import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../home/presentation/controllers/home_controller.dart';

class ProfileButtonLogoutWidget extends StatelessWidget {
  final HomeController controller;

  const ProfileButtonLogoutWidget({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    final profileController = controller.homeProfileController;

    return Padding(
      padding: EdgeInsets.only(left: 16, right: Get.size.width / 1.62),
      child: SizedBox(
        height: 42,
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFFFF51BD),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          onPressed: () => profileController.onTapLogout(),
          child: const Row(
            children: [
              Icon(Icons.logout, size: 24.0, color: Colors.white),
              SizedBox(width: 8), // Tambahkan jarak antara ikon dan teks
              Text("Keluar", style: TextStyle(color: Colors.white)),
            ],
          ),
        ),
      ),
    );
  }
}
