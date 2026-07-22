class ResponseModelBasic {
  final bool status;
  final String message;
  final String? error;

  ResponseModelBasic({required this.status, required this.message, this.error});

  factory ResponseModelBasic.fromMap(Map<String, dynamic> json) {
    final bool status = json['status'] == true;
    final String message = (json['message'] ?? 'Terjadi kesalahan').toString();
    final dynamic errorData = json['error'];

    String? resolvedError;

    if (!status || errorData != null) {
      if (errorData is Map) {
        // Prioritas 1: Ambil dari error.details (Sesuai contoh 1 Anda)
        if (errorData['details'] != null) {
          resolvedError = errorData['details'].toString();
        }
        // Prioritas 2: Ambil dari error.message (Sesuai contoh 2 Anda)
        else if (errorData['message'] != null) {
          resolvedError = errorData['message'].toString();
        }
      }
      // Prioritas 3: Jika error langsung berupa String (Misal: "Token expired")
      else if (errorData is String && errorData.isNotEmpty) {
        resolvedError = errorData;
      }

      // Prioritas 4: Fallback ke "message biasa" (root message)
      // jika semua format error di atas tidak ada/null.
      resolvedError ??= message;
    }

    return ResponseModelBasic(
      status: status,
      message: message,
      error: resolvedError, // Sudah pasti String siap pakai
    );
  }
}

// class ResponseModelBasic {
//   // 💡 Saran: Ganti nama dari ResponseModelBasic menjadi BaseResponse agar lebih universal
//   final bool status;
//   final String message;
//   final Map<String, dynamic>? errors;

//   ResponseModelBasic({
//     required this.status,
//     required this.message,
//     this.errors,
//   });

//   factory ResponseModelBasic.fromMap(Map<String, dynamic> json) {
//     return ResponseModelBasic(
//       // 1. AMAN: Menghasilkan bool murni. Jika API kirim 1, 0, atau "true", ini tetap aman (tidak crash).
//       status: json['status'] == true,

//       // 2. AMAN: Memastikan nilai akhir selalu String, meskipun API mengirim angka atau null.
//       message: (json['message'] ?? 'Terjadi kesalahan').toString(),

//       // 3. AMAN: Mencegah crash jika ternyata API mengirim 'errors' sebagai List, bukan Map.
//       errors: json['errors'] is Map
//           ? Map<String, dynamic>.from(json['errors'])
//           : null,
//     );
//   }

//   /// ✅ Method untuk mendapatkan error message yang paling relevan
//   String get errorMessage {
//     if (errors != null) {
//       // Prioritas 1: Ambil dari errors.details jika ada
//       if (errors!['details'] != null) {
//         return errors!['details'].toString();
//       }

//       // Prioritas 2: Ambil dari field error pertama yang tersedia
//       if (errors!.isNotEmpty) {
//         final firstError = errors!.values.first;
//         if (firstError is String) return firstError;
//         if (firstError is List && firstError.isNotEmpty) {
//           return firstError.first.toString();
//         }
//       }
//     }

//     // Prioritas 3: Fallback ke message umum
//     return message;
//   }

//   Map<String, dynamic> toJson() {
//     return {"status": status, "message": message, "errors": errors};
//   }
// }

// class ResponseModelBasic {
//   final bool? status;
//   final String? message;
//   final String? error;

//   ResponseModelBasic({this.status, this.message, this.error});

//   factory ResponseModelBasic.fromMap(Map<String, dynamic> json) {
//     bool? getStatus = json["status"] ?? false;
//     String? getMessage = json["message"];
//     String? errorMessage = 'Terjadi Kesalahan';
//     Map<String, dynamic>? getError = json["error"];

//     if (getStatus == false && getError == null) {
//       errorMessage = getMessage;
//     }

//     if (getError != null) {
//       if (getError['details'] != null) {
//         errorMessage = getError['details'];
//       } else {
//         errorMessage = getMessage;
//       }
//     }

//     return ResponseModelBasic(
//       status: getStatus,
//       message: getMessage,
//       error: errorMessage,
//     );
//   }
// }
