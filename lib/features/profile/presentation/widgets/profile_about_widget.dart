import 'package:flutter/material.dart';

import '../../../home/presentation/controllers/home_controller.dart';

class ProfileAboutWidget extends StatelessWidget {
  final HomeController controller;

  const ProfileAboutWidget({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    final profileController = controller.homeProfileController;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      margin: const EdgeInsets.only(top: 10, bottom: 20),
      decoration: const BoxDecoration(
        color: Colors.white,
        boxShadow: [BoxShadow(color: Color(0xFF545454), blurRadius: 1)],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'App Version',
                style: TextStyle(fontSize: 12, color: Colors.black),
              ),
              Text(
                profileController.versionApp.value,
                style: const TextStyle(fontSize: 12, color: Colors.black),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Tanggal Update Version',
                style: TextStyle(fontSize: 12, color: Colors.black),
              ),
              Text(
                profileController.updateVersionApp.value,
                style: const TextStyle(fontSize: 12, color: Colors.black),
              ),
            ],
          ),
          const SizedBox(height: 10),
          GestureDetector(
            onTap: () => profileController.onTapTermsAndCondition(),
            child: const Text(
              'Syarat & Ketentuan',
              style: TextStyle(
                fontSize: 12,
                color: Colors.black,
                fontWeight: FontWeight.normal,
              ),
            ),
          ),
          const SizedBox(height: 10),
          GestureDetector(
            onTap: () => profileController.onTapPrivacyPolicy(),
            child: const Text(
              'Kebijakan Privasi',
              style: TextStyle(
                fontSize: 12,
                color: Colors.black,
                fontWeight: FontWeight.normal,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
