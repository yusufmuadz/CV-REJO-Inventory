class FormValidator {
  // Regex pattern
  static const _emailRegex = r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$';
  static const _phoneRegex = r'^\+?[0-9]{10,15}$';
  static const _usernameRegex = r'^[a-zA-Z0-9_]{3,20}$';

  /// Validasi wajib isi
  static String? validateRequired(String? value, [String fieldName = 'Field ini']) {
    if (value == null || value.trim().isEmpty) {
      return '$fieldName wajib diisi';
    }
    return null;
  }

  /// Validasi format email
  static String? validateEmail(String? value) {
    final error = validateRequired(value, 'Email');
    if (error != null) return error;
    if (!RegExp(_emailRegex).hasMatch(value!.trim())) {
      return 'Format email tidak valid';
    }
    return null;
  }

  /// Validasi username (huruf, angka, underscore, 3-20 karakter)
  static String? validateUsername(String? value) {
    final error = validateRequired(value, 'Username');
    if (error != null) return error;
    if (!RegExp(_usernameRegex).hasMatch(value!.trim())) {
      return 'Username hanya boleh berisi huruf, angka, atau underscore (3-20 karakter)';
    }
    return null;
  }

  /// Validasi password (min 8 karakter, huruf besar, huruf kecil, angka, karakter spesial)
  static String? validatePassword(String? value, {int minLength = 8}) {
    final error = validateRequired(value, 'Password');
    if (error != null) return error;
    if (value!.length < minLength) return 'Password minimal $minLength karakter';
    if (!RegExp(r'[A-Z]').hasMatch(value)) return 'Password harus mengandung minimal 1 huruf besar';
    if (!RegExp(r'[a-z]').hasMatch(value)) return 'Password harus mengandung minimal 1 huruf kecil';
    if (!RegExp(r'[0-9]').hasMatch(value)) return 'Password harus mengandung minimal 1 angka';
    if (!RegExp(r'[!@#$%^&*(),.?":{}|<>]').hasMatch(value)) return 'Password harus mengandung minimal 1 karakter spesial';
    return null;
  }

  /// Validasi konfirmasi password
  static String? validateConfirmPassword(String? value, String originalPassword) {
    final error = validateRequired(value, 'Konfirmasi password');
    if (error != null) return error;
    if (value != originalPassword) return 'Password tidak cocok';
    return null;
  }

  /// Validasi nomor telepon
  static String? validatePhoneNumber(String? value) {
    final error = validateRequired(value, 'Nomor telepon');
    if (error != null) return error;
    final cleaned = value!.trim().replaceAll(RegExp(r'\s+|-'), '');
    if (!RegExp(_phoneRegex).hasMatch(cleaned)) {
      return 'Format nomor telepon tidak valid (10-15 digit, boleh diawali +)';
    }
    return null;
  }

  /// Validasi panjang minimum
  static String? validateMinLength(String? value, int minLength, [String fieldName = 'Field ini']) {
    final error = validateRequired(value, fieldName);
    if (error != null) return error;
    if (value!.length < minLength) return '$fieldName minimal $minLength karakter';
    return null;
  }

  /// Validasi panjang maksimum
  static String? validateMaxLength(String? value, int maxLength, [String fieldName = 'Field ini']) {
    if (value == null || value.isEmpty) return null;
    if (value.length > maxLength) return '$fieldName maksimal $maxLength karakter';
    return null;
  }
}