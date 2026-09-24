import 'package:flutter/material.dart';
import '../controllers/home_controller.dart';
import '../widgets/home_app_bar/app_bar_widget.dart';
import '../widgets/retur/retur_input_sheet.dart';

class HomeReturDriverView extends StatelessWidget {
  final HomeController homeController;

  const HomeReturDriverView({super.key, required this.homeController});

  @override
  Widget build(BuildContext context) {
    final controller = homeController.homeReturController;

    return Column(
      children: [
        AppBarWidget().content(
          title: 'Retur Tidak Terkait',
          onTap: () {
            ReturInputSheet.show(controller: controller);
          },
        ),
      ],
    );
  }
}
