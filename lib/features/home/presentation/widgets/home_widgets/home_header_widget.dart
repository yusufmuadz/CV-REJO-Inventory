import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../core/middlewares/app_role.dart';
import '../../../../../gen/assets.gen.dart';
import '../../controllers/home_controller.dart';
import '../../../../../core/theme/app_colors.dart';

class HomeHeaderWidget extends StatelessWidget {
  final HomeController controller;

  const HomeHeaderWidget({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    String imagePath = Assets.images.bgPickingMan.path;

    if (AppRole.isDriver) {
      imagePath = Assets.images.bgDriver.path;
    } else if (AppRole.isChecker1) {
      imagePath = Assets.images.bgPackingMan.path;
    }

    return Stack(
      children: [
        Image.asset(
          imagePath,
          width: double.infinity,
          fit: BoxFit.fitWidth,
          // color: Colors.black,
        ),
        Positioned(
          top: 0.0,
          bottom: 0.0,
          left: 20.0,
          child: Row(
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Hi, ${AppRole.name!.capitalize} 👋',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                      height: 1.3,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Semangat ${AppRole.current!.name.capitalizeFirst} hari ini!',
                    style: TextStyle(
                      fontSize: 14,
                      color: AppColors.textSecondary,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}
