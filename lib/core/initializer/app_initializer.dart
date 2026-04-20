import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get_storage/get_storage.dart';

class AppInitializer {
  static Future<ThemeMode> init() async {
    final initialTheme = await loadInitialTheme();

    // Set status bar menjadi transparan
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent, // Untuk Android
        statusBarIconBrightness:
            Brightness.dark, // Ikon hitam (untuk background terang)
        statusBarBrightness: Brightness.light, // Untuk iOS
      ),
    );

    return initialTheme;
  }
}

Future<ThemeMode> loadInitialTheme() async {
  await GetStorage.init();
  final box = GetStorage();
  // final value = box.read<String>('theme_mode');

  // switch (value) {
  //   case 'light':
      return ThemeMode.light;
    // case 'dark':
    //   return ThemeMode.dark;
    // default:
    //   return ThemeMode.system;
  // }
}
