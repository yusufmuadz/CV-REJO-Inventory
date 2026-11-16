// controllers/connectivity_network.dart
import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:http/http.dart' as http; // ✅ Import http
import 'package:flutter/material.dart';
import 'package:get/get.dart';

enum ConnectionStatus { online, weak, offline }

class KoneksiCheck extends GetxController {
  final Connectivity _connectivity = Connectivity();
  final Rx<ConnectionStatus> _status = ConnectionStatus.offline.obs;

  // ❌ HAPUS _pingDio (tidak dipakai lagi)
  // late final Dio _pingDio;

  bool _isChecking = false;
  bool _isDisposed = false;

  Timer? _pingTimer;
  StreamSubscription<List<ConnectivityResult>>? _connectivitySub;

  // ✅ Return Rx object untuk Obx
  Rx<ConnectionStatus> get statusStream => _status;

  @override
  void onInit() {
    super.onInit();
    // ❌ Jangan inisialisasi _pingDio lagi
    _startMonitoring();
  }

  @override
  void onClose() {
    _isDisposed = true;

    _pingTimer?.cancel();
    _connectivitySub?.cancel();
    // ❌ Jangan close _pingDio
    super.onClose();
  }

  void _startMonitoring() {
    _checkQuality();

    _connectivitySub = _connectivity.onConnectivityChanged.listen((
      results,
    ) async {
      final hasConnection = results.any((r) => r != ConnectivityResult.none);
      debugPrint('🌐 Connectivity: $results | Has: $hasConnection');

      if (!hasConnection) {
        _updateStatus(ConnectionStatus.offline);
      } else {
        // ✅ Delay agar network stack siap
        await Future.delayed(const Duration(seconds: 8));
        _checkQuality();
      }
    });

    // ✅ Timer tetap jalan untuk auto-recovery
    _pingTimer = Timer.periodic(
      const Duration(seconds: 15),
      (_) => _checkQuality(),
    );
  }

  Future<void> _checkQuality() async {
    // debugPrint('📡 [Ping] Starting check...');

    if (_isChecking || _isDisposed) return;

    _isChecking = true;

    try {
      // Endpoint utama: Cloudflare
      final cloudflare = await _checkEndpoint(
        'https://cloudflare.com/cdn-cgi/trace',
        expectedStatus: 200,
      );

      if (_isDisposed) return;

      // Jika Cloudflare berhasil, gunakan hasilnya.
      if (cloudflare != null) {
        _updateStatus(
          cloudflare < 800 ? ConnectionStatus.online : ConnectionStatus.weak,
        );
        return;
      }

      // Fallback: Google
      final google = await _checkEndpoint(
        'https://www.google.com/generate_204',
        expectedStatus: 204,
      );

      if (_isDisposed) return;

      // Jika Google berhasil, gunakan hasilnya.
      if (google != null) {
        _updateStatus(
          google < 800 ? ConnectionStatus.online : ConnectionStatus.weak,
        );
        return;
      }

      // debugPrint('✅ [Ping] Success: ${response.statusCode} in ${latency}ms');

      _updateStatus(ConnectionStatus.offline);
      // }
      // }
      // on TimeoutException {
      //   stopwatch.stop();
      //   debugPrint('❌ [Ping] Timeout after 5s');
      //   _updateStatus(ConnectionStatus.offline);
      // } catch (e, stack) {
      //   stopwatch.stop();
      //   debugPrint('❌ [Ping] Error: $e\nStack: $stack');
      //   _updateStatus(ConnectionStatus.offline);
    } finally {
      _isChecking = false;
    }
  }

  void _updateStatus(ConnectionStatus newStatus) {
    if (_isDisposed) return;

    if (_status.value != newStatus) {
      debugPrint('🔄 Status: ${_status.value} → $newStatus');
      _status.value = newStatus;
    }
  }

  bool get canMakeRequest => _status.value != ConnectionStatus.offline;

  // ... waitForConnection tetap sama

  Future<int?> _checkEndpoint(String url, {required int expectedStatus}) async {
    final stopwatch = Stopwatch()..start();

    try {
      // ✅ PAKAI http.get - tanpa interceptor, lebih reliable
      final response = await http
          .get(Uri.parse(url))
          .timeout(const Duration(seconds: 5)); // ✅ Explicit timeout

      stopwatch.stop();

      if (response.statusCode == expectedStatus) {
        debugPrint('✅ $url | ${stopwatch.elapsedMilliseconds}ms');

        return stopwatch.elapsedMilliseconds;
      }

      debugPrint('⚠️ $url | HTTP ${response.statusCode}');

      return null;
    } catch (e) {
      stopwatch.stop();
      debugPrint('❌ $url | $e');
      return null;
    }
  }
}
