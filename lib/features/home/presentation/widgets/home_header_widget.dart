import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../gen/assets.gen.dart';
import '../controllers/home_controller.dart';

class HomeHeaderWidget extends StatelessWidget {
  final HomeController controller;

  const HomeHeaderWidget({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [_buildHi(), _buildAvatar()],
    );
  }

  Widget _buildHi() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Hi! ${controller.user.nama.capitalize}",
          style: const TextStyle(fontSize: 21, fontWeight: FontWeight.bold, color: Colors.black),
        ),
        const SizedBox(height: 3),
        Text(
          "Mari ${controller.user.jabatan.capitalizeFirst} Orderanmu",
          style: const TextStyle(fontSize: 15, fontWeight: FontWeight.normal),
        ),
      ],
    );
  }

  Widget _buildAvatar() {
    return InkWell(
      onTap: () => controller.changePage(1),
      child: SizedBox(
        height: 50,
        width: 50,
        child: Stack(
          children: [
            Container(
              width: 46,
              height: 46,
              padding: const EdgeInsets.all(2),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(width: 1, color: const Color(0xFFd4993b)),
              ),
              child: ClipOval(child: Image.asset(Assets.logo.logo.path)),
            ),
            Positioned(
              bottom: 0,
              left: 5,
              child: Container(
                height: 15,
                width: 15,
                decoration: const BoxDecoration(
                  color: Color(0xFFd4993b),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.account_circle,
                  color: Colors.white,
                  size: 15,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
