import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../gen/assets.gen.dart';
import '../../../home/presentation/controllers/home_controller.dart';

class ProfileHeaderView extends StatelessWidget {
  final HomeController controller;

  const ProfileHeaderView({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 300,
      child: Stack(
        children: [
          Container(
            height: 160,
            padding: const EdgeInsets.only(left: 16, right: 16, top: 15),
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                  begin: Alignment(-0.00, 1.00),
                  end: Alignment(0, -1),
                  colors: [Color(0xFFE0048C), Color(0xFF750149)]),
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(0),
                bottomRight: Radius.circular(0),
              ),
            ),
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  'Profile',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontFamily: 'Inter',
                    fontWeight: FontWeight.w700,
                    height: 0,
                    letterSpacing: 0.51,
                  ),
                )
              ],
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Container(
                  height: 146,
                  width: 146,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border:
                        Border.all(width: 2, color: const Color(0xFFE0048C)),
                    color: Colors.white,
                  ),
                  child: ClipOval(
                      child: Image.asset(Assets.logo.logo.path)
                      ),
                ),
                const SizedBox(height: 1),
                Text(
                  controller.user.nama.capitalize ?? '-',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 1),
                Text(
                  controller.user.jabatan.capitalizeFirst ?? '-',
                  style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}