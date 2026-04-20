class BaseResponseSuccess<T> {
  final bool status;
  final String message;
  final T? data;

  BaseResponseSuccess({required this.status, required this.message, this.data});

  factory BaseResponseSuccess.fromJson(
    Map<String, dynamic> json,
    T Function(Object? json) fromJsonT,
  ) {
    return BaseResponseSuccess<T>(
      status: json['status'] ?? false,
      message: json['message'] ?? '',
      data: json['data'] != null ? fromJsonT(json['data']) : null,
    );
  }

  Map<String, dynamic> toJson(Object? Function(T value) toJsonT) {
    return {
      "status": status,
      "message": message,
      "data": data != null ? toJsonT(data as T) : null,
    };
  }
}

class BaseResponseFailed {
  final bool status;
  final String message;
  final Map<String, dynamic>? errors;

  BaseResponseFailed({
    required this.status,
    required this.message,
    this.errors,
  });

  factory BaseResponseFailed.fromJson(Map<String, dynamic> json) {
    return BaseResponseFailed(
      status: json['status'] ?? false,
      message: json['message'] ?? 'Terjadi kesalahan',
      errors: json['errors'] != null 
          ? Map<String, dynamic>.from(json['errors']) 
          : null,
    );
  }

  /// ✅ Method untuk mendapatkan error message yang paling relevan
  String get errorMessage {
    // Prioritas 1: Ambil dari errors.details jika ada
    if (errors != null) {
      if (errors!['details'] != null) {
        return errors!['details'].toString();
      }
      // Prioritas 2: Ambil dari field error pertama yang tersedia
      if (errors!.isNotEmpty) {
        final firstError = errors!.values.first;
        if (firstError is String) return firstError;
        if (firstError is List) return firstError.first.toString();
      }
    }
    // Prioritas 3: Fallback ke message umum
    return message;
  }

  Map<String, dynamic> toJson() {
    return {
      "status": status,
      "message": message,
      "errors": errors,
    };
  }
}