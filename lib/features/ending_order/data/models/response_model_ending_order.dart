// class ResponseModelEndingOrder {
//   final bool? status;
//   final String? message;
//   final String? error;

//   ResponseModelEndingOrder({this.status, this.message, this.error});

//   factory ResponseModelEndingOrder.fromMap(Map<String, dynamic> json) {
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

//     return ResponseModelEndingOrder(
//       status: getStatus,
//       message: getMessage,
//       error: errorMessage,
//     );
//   }
// }
