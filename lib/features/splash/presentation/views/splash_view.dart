import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../../../../gen/assets.gen.dart';
import '../../../../shared/custom/custom_button.dart';
import '../../../../shared/enum/load_state_enum.dart';
import '../../../../utils/loading_custom.dart';
import '../controllers/splash_controller.dart';

class SplashView extends GetView<SplashController> {
  const SplashView({super.key});
  @override
  Widget build(BuildContext context) {
    controller.onReady(); // call onReady
    return Scaffold(
      body: SizedBox(
        width: Get.width,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              height: 250,
              width: 250,
              child: Image.asset(Assets.logo.logo.path),
            ),
            Obx(() {
              switch (controller.loadStateEnum.value) {
                case LoadStateEnum.initial:
                case LoadStateEnum.loading:
                case LoadStateEnum.refreshing:
                  return const LoadingView();

                case LoadStateEnum.success:
                case LoadStateEnum.error:
                  return SizedBox(
                    height: 45,
                    width: 100,
                    child: CustomButton.basicButton(
                      title: 'Ulangi',
                      color: Colors.red,
                      onPressed: () =>
                          controller.checkVersion(isRefreshing: true),
                    ),
                  );

                default:
                  return Container();
              }
            }),
          ],
        ),
      ),
    );
  }
}
