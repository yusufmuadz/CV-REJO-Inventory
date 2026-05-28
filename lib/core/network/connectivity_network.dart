// // controllers/network_controller.dart
// import 'dart:async';
// import 'package:connectivity_plus/connectivity_plus.dart';
// import 'package:dio/dio.dart'; // ✅ Pakai Dio yang sudah ada
// import 'package:flutter/material.dart';
// // import 'package:flutter/material.dart';
// import 'package:get/get.dart';

// enum ConnectionStatus { online, weak, offline }

// class ConnectivityNetwork extends GetxController {
//   final Connectivity _connectivity = Connectivity();
//   final Rx<ConnectionStatus> _status = ConnectionStatus.offline.obs;

//   // ✅ Dio khusus ping: tanpa interceptor, timeout ketat
//   late final Dio _pingDio;

//   Timer? _pingTimer;
//   // bool _isSnackbarShowing = false;

//   ConnectionStatus get status => _status.value;
//   Rx<ConnectionStatus> get statusStream => _status;

//   StreamSubscription<List<ConnectivityResult>>? _connectivitySub;

//   @override
//   void onInit() {
//     super.onInit();

//     // ✅ Inisialisasi Dio khusus ping (minimal config)
//     _pingDio = Dio(
//       BaseOptions(
//         baseUrl: 'https://1.1.1.1', // Cloudflare DNS - stabil & gratis
//         connectTimeout: const Duration(seconds: 3),
//         receiveTimeout: const Duration(seconds: 3),
//         validateStatus: (status) => true, // Terima semua status code untuk ping
//       ),
//     );

//     _startMonitoring();
//   }

//   @override
//   void onClose() {
//     _pingTimer?.cancel();
//     _connectivitySub?.cancel();
//     _pingDio.close(force: true); // ✅ Cleanup resource
//     super.onClose();
//   }

//   void _startMonitoring() {
//     // ✅ Cek awal
//     _checkQuality();

//     // ✅ Listen perubahan jaringan
//     _connectivity.onConnectivityChanged.listen((results) {
//       final hasConnection = results.any((r) => r != ConnectivityResult.none);
//       debugPrint('🌐 Connectivity changed: $results');

//       if (hasConnection) {
//         _checkQuality();
//       } else {
//         _updateStatus(ConnectionStatus.offline);
//         // _pingTimer?.cancel();
//       }
//     });

//     // ✅ Periodic check (fallback jika stream tidak emit)
//     _pingTimer = Timer.periodic(
//       const Duration(seconds: 3),
//       (_) => _checkQuality(),
//     );
//   }

//   Future<void> _checkQuality() async {
//     final stopwatch = Stopwatch()..start();

//     try {
//       debugPrint('📡 Pinging https://1.1.1.1/cdn-cgi/trace...');

//       // ✅ Ping pakai Dio (GET /cdn-cgi/trace endpoint ringan dari Cloudflare)
//       final response = await _pingDio.get('/cdn-cgi/trace');
//       stopwatch.stop();

//       final latency = stopwatch.elapsedMilliseconds;

//       debugPrint(
//         '✅ Ping success! Status: ${response.statusCode}, Latency: ${latency}ms',
//       );

//       if (response.statusCode == 200) {
//         if (latency < 800) {
//           _updateStatus(ConnectionStatus.online);
//         } else {
//           _updateStatus(ConnectionStatus.weak);
//         }
//       } else {
//         _updateStatus(ConnectionStatus.weak);
//       }
//     } on DioException catch (e) {
//       stopwatch.stop();
//       // ✅ Timeout / connection error = offline
//       final isConnectionError = [
//         DioExceptionType.connectionTimeout,
//         DioExceptionType.receiveTimeout,
//         DioExceptionType.connectionError,
//         DioExceptionType.unknown,
//       ].contains(e.type);

//       if (isConnectionError) {
//         _updateStatus(ConnectionStatus.offline);
//       } else {
//         _updateStatus(ConnectionStatus.weak);
//       }
//     } catch (_) {
//       stopwatch.stop();
//       _updateStatus(ConnectionStatus.offline);
//     }
//   }

//   void _updateStatus(ConnectionStatus newStatus) {
//     // final oldStatus = _status.value;
//     if (_status.value != newStatus) {
//       debugPrint('🔄 Status changed: ${_status.value} → $newStatus');
//       _status.value = newStatus;
//     }

//     // if (newStatus != oldStatus && !_isSnackbarShowing) {
//     //   _showConnectionSnackbar(newStatus);
//     // }
//   }

//   // void _showConnectionSnackbar(ConnectionStatus status) {
//   //   if (_isSnackbarShowing) return;

//   //   String message;
//   //   Color backgroundColor;
//   //   Duration duration;

//   //   switch (status) {
//   //     case ConnectionStatus.offline:
//   //       message = '🔴 Tidak ada koneksi internet';
//   //       backgroundColor = Colors.red.shade700;
//   //       duration = const Duration(days: 1);
//   //       break;
//   //     case ConnectionStatus.weak:
//   //       message = '🟡 Sinyal lemah, koneksi tidak stabil';
//   //       backgroundColor = Colors.orange.shade700;
//   //       duration = const Duration(seconds: 5);
//   //       break;
//   //     default:
//   //       return;
//   //   }

//   //   _isSnackbarShowing = true;

//   //   Get.snackbar(
//   //     'Koneksi',
//   //     message,
//   //     backgroundColor: backgroundColor,
//   //     colorText: Colors.white,
//   //     snackPosition: SnackPosition.TOP,
//   //     duration: duration,
//   //     isDismissible: status == ConnectionStatus.weak,
//   //     dismissDirection: DismissDirection.horizontal,
//   //     // onClose: () => _isSnackbarShowing = false,
//   //     icon: const Icon(Icons.wifi_off, color: Colors.white),
//   //     margin: const EdgeInsets.all(8),
//   //     borderRadius: 8,
//   //   );

//   //   if (status == ConnectionStatus.offline) {
//   //     Timer.periodic(const Duration(seconds: 3), (timer) {
//   //       if (_status.value == ConnectionStatus.online) {
//   //         timer.cancel();
//   //         _isSnackbarShowing = false;
//   //       } else {
//   //         _checkQuality();
//   //       }
//   //     });
//   //   }
//   // }

//   bool get canMakeRequest => _status.value != ConnectionStatus.offline;

//   Future<bool> waitForConnection({int maxWaitSeconds = 30}) async {
//     if (_status.value == ConnectionStatus.online) return true;

//     final completer = Completer<bool>();
//     StreamSubscription<ConnectionStatus>? subscription; // ✅ Deklarasi dulu

//     subscription = _status.listen((status) {
//       if (status == ConnectionStatus.online) {
//         subscription?.cancel(); // ✅ Aman diakses setelah assignment
//         if (!completer.isCompleted) completer.complete(true);
//       }
//     });

//     Future.delayed(Duration(seconds: maxWaitSeconds), () {
//       if (!completer.isCompleted) {
//         subscription?.cancel();
//         completer.complete(false);
//       }
//     });

//     return completer.future;
//   }
// }
