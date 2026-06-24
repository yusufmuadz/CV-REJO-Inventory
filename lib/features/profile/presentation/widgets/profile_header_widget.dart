import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../core/middlewares/app_role.dart';
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
          // Container(
          //   height: 160,
          //   padding: const EdgeInsets.only(left: 16, right: 16, top: 15),
          //   child: const Row(
          //     mainAxisAlignment: MainAxisAlignment.center,
          //     crossAxisAlignment: CrossAxisAlignment.center,
          //     children: [
          //       Text(
          //         'Profile',
          //         style: TextStyle(
          //           color: Colors.white,
          //           fontSize: 18,
          //           fontFamily: 'Inter',
          //           fontWeight: FontWeight.w700,
          //           height: 0,
          //           letterSpacing: 0.51,
          //         ),
          //       ),
          //     ],
          //   ),
          // ),
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
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.3),
                        blurRadius: 5,
                        offset: const Offset(0, 1),
                      ),
                    ],
                  ),
                  child: ClipOval(child: Image.asset(Assets.logo.logo.path)),
                ),
                // const SizedBox(height: 1),
                // Text(
                //   AppRole.name?.capitalize ?? '-',
                //   style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                // ),
                // const SizedBox(height: 1),
                // Text(
                //   AppRole.current?.name.capitalizeFirst ?? '-',
                //   style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
                // ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
