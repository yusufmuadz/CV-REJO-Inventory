import 'package:flutter/material.dart';

import '../controllers/home_controller.dart';
import '../widgets/app_bar_widget.dart';

class TakeItOrderView extends StatelessWidget {
  final HomeController controller;
  
  const TakeItOrderView({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        AppBarWidget().content(title: 'Ambil Pesanan', onTap: () {}),

      ],
    );
  }
}