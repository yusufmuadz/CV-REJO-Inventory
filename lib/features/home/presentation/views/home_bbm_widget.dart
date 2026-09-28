import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';

import '../controllers/home_controller.dart';
import '../widgets/home_app_bar/app_bar_widget.dart';

class HomeBbmWidget extends StatelessWidget {
  final HomeController controller;

  const HomeBbmWidget({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        AppBarWidget().content(
          title: 'Isi BBM',
          controller: controller,
          onTap: () {
            controller.dialogService.showComingSoonSnackbar();
          },
        ),
      ],
    );
  }
}
