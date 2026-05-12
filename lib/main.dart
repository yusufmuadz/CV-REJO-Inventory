import 'package:cv_rejo/core/theme/app_theme.dart';
import 'package:cv_rejo/injection/initial_binding.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';

import 'core/initializer/app_initializer.dart';
import 'core/services/navigation_service.dart';
import 'routes/app_pages.dart';

void main() async {
  final init = await AppInitializer.init();
  final navigationService = NavigationService();

  runApp(MyApp(initialThemeMode: init, navigationService: navigationService));
}

class MyApp extends StatelessWidget {
  final ThemeMode initialThemeMode;
  final NavigationService navigationService;
  const MyApp({
    super.key,
    required this.initialThemeMode,
    required this.navigationService,
  });

  @override
  Widget build(BuildContext context) {
    return MediaQuery(
      data: MediaQuery.of(context).copyWith(textScaler: TextScaler.linear(1.0)),
      child: GetMaterialApp(
        title: 'CV Rejo Inventory',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.light,
        darkTheme: AppTheme.dark,
        themeMode: initialThemeMode,
        initialBinding: InitialBinding(),
        initialRoute: AppPages.INITIAL,
        getPages: AppPages.routes,
        builder: (context, child) =>
            SafeArea(top: false, bottom: true, child: child!),
        // navigatorKey: navigationService.navigatorKey,
        routingCallback: (routing) {
          debugPrint('➡️ Route: ${routing?.current}');
        },
        // builder: (context, child) {
        //   return AnimatedThemeWrapper(child: child ?? const SizedBox());
        // },
      ),
    );
  }
}
