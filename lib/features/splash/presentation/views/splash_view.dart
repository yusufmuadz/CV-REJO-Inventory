import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../../../../gen/assets.gen.dart';
import '../controllers/splash_controller.dart';

class SplashView extends GetView<SplashController> {
  const SplashView({super.key});
  @override
  Widget build(BuildContext context) {
    controller.onReady(); // call onReady
    return Scaffold(
      body: Center(
        child: Container(
          height: Get.height,
          width: 216,
          decoration: BoxDecoration(
            image: DecorationImage(image: AssetImage(Assets.logo.logo.path)),
          ),
        ),
      ),
    );
  }
}
