// app_role.dart
import 'package:get/get.dart';
import 'session_manager.dart';

class AppRole {
  static SessionManager get _inst => Get.find<SessionManager>();

  // 🎯 Role checkers (boolean)
  static bool get isPIC => _inst.isPIC;
  static bool get isChecker1 => _inst.isChecker1;
  static bool get isChecker2 => _inst.isChecker2;
  static bool get isDriver => _inst.isDriver;
  static bool get isLoggedIn => _inst.isLoggedIn;

  // 🎯 User data accessors (langsung pakai di UI)
  static String? get name => _inst.name;
  static UserRole? get current => _inst.role;

  // 🎯 Actions (async, karena involve storage)
  static Future<void> loginFromApi({
    required String role,
    required String name,
    String? email,
    String? token,
  }) => _inst.handleApiResponse(
    role: role,
    name: name,
    email: email,
    token: token,
  );

  static Future<void> logout() => _inst.logout();
  static Future<void> updateProfile({String? name, String? role}) =>
      _inst.updateProfile(name: name, role: role);
}
