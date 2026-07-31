import 'package:flutter/cupertino.dart';

import '../widgets/home_app_bar/app_bar_widget.dart';

class TrackingDriverView extends StatelessWidget {
  const TrackingDriverView({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        AppBarWidget().content(
          title: 'Tracking Driver',
          isIcon: false,
        ),
        const SizedBox(height: 10),
      ],
    );
  }
}
