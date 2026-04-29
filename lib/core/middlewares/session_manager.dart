// session_manager.dart
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

enum UserRole { picking, packing, loader, deliver }

class SessionManager extends GetxController {
  // 🔑 Keys
  static const String _keyRole = 'user_role';
  static const String _keyName = 'user_name';

  final _box = GetStorage();

  // 💡 Reactive state
  final _role = Rx<UserRole?>(null);
  final _name = RxnString();

  // 🎯 Getters
  UserRole? get role => _role.value;
  String? get name => _name.value;

  // ✅ Boolean getters untuk UI
  bool get isPIC   => _role.value == UserRole.picking;
  bool get isChecker1    => _role.value == UserRole.packing;
  bool get isChecker2   => _role.value == UserRole.loader;
  bool get isDriver   => _role.value == UserRole.deliver;
  bool get isLoggedIn => _role.value != null;

  @override
  void onInit() {
    super.onInit();
    _loadFromStorage(); // Load sekali saat app start
  }

  // 📥 Load dari GetStorage (dipanggil 1x di onInit)
  void _loadFromStorage() {
    // Load role (String → Enum)
    final roleStr = _box.read<String>(_keyRole);
    if (roleStr != null) {
      _role.value = _parseRole(roleStr);
    }
    // Load data user lainnya
    _name.value = _box.read<String>(_keyName);
  }

  // 🔄 Helper: Parse String dari API → UserRole enum
  UserRole _parseRole(String roleStr) {
    return UserRole.values.firstWhere(
      (e) => e.name.toLowerCase() == roleStr.toLowerCase(),
      orElse: () => UserRole.picking, // Default jika tidak cocok
    );
  }

  // 🎯 MAIN METHOD: Handle response API langsung
  // Panggil ini setelah login/register sukses
  Future<void> handleApiResponse({
    required String role,       // dari API: "admin", "user", dll
    required String name,       // dari API: "John Doe"
    String? email,              // optional
    String? token,              // optional: bearer token
  }) async {
    // 1. Convert & update reactive state (UI auto refresh)
    final parsedRole = _parseRole(role);
    _role.value = parsedRole;
    _name.value = name;

    // 2. Simpan ke GetStorage (persisten)
    await Future.wait([
      _box.write(_keyRole, parsedRole.name),
      _box.write(_keyName, name),
    ]);
  }

  // 🚪 Logout
  Future<void> logout() async {
    // Clear state
    _role.value = null;
    _name.value = null;

    // Clear storage
    await Future.wait([
      _box.remove(_keyRole),
      _box.remove(_keyName),
    ]);
  }

  // 🔄 Update partial data (misal: ganti nama profile)
  Future<void> updateProfile({String? name, String? role}) async {
    if (name != null) {
      _name.value = name;
      await _box.write(_keyName, name);
    }
  }
}