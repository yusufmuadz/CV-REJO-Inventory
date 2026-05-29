// controllers/connectivity_network.dart
import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:http/http.dart' as http;  // ✅ Import http
import 'package:flutter/material.dart';
import 'package:get/get.dart';

enum ConnectionStatus { online, weak, offline }

class KoneksiCheck extends GetxController {
  final Connectivity _connectivity = Connectivity();
  final Rx<ConnectionStatus> _status = ConnectionStatus.offline.obs;
  
  // ❌ HAPUS _pingDio (tidak dipakai lagi)
  // late final Dio _pingDio;
  
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
    _pingTimer?.cancel();
    _connectivitySub?.cancel();
    // ❌ Jangan close _pingDio
    super.onClose();
  }

  void _startMonitoring() {
    _checkQuality();

    _connectivitySub = _connectivity.onConnectivityChanged.listen((results) async {
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
    _pingTimer = Timer.periodic(const Duration(seconds: 8), (_) => _checkQuality());
  }

  Future<void> _checkQuality() async {
    debugPrint('📡 [Ping] Starting check...');
    final stopwatch = Stopwatch()..start();
    
    try {
      // ✅ PAKAI http.get - tanpa interceptor, lebih reliable
      final response = await http
          .get(Uri.parse('https://1.1.1.1/cdn-cgi/trace'))
          .timeout(const Duration(seconds: 5)); // ✅ Explicit timeout
      
      stopwatch.stop();
      final latency = stopwatch.elapsedMilliseconds;
      
      debugPrint('✅ [Ping] Success: ${response.statusCode} in ${latency}ms');

      if (response.statusCode == 200) {
        _updateStatus(latency < 800 ? ConnectionStatus.online : ConnectionStatus.weak);
      } else {
        _updateStatus(ConnectionStatus.weak);
      }
      
    } on TimeoutException {
      stopwatch.stop();
      debugPrint('❌ [Ping] Timeout after 5s');
      _updateStatus(ConnectionStatus.offline);
      
    } catch (e, stack) {
      stopwatch.stop();
      debugPrint('❌ [Ping] Error: $e\nStack: $stack');
      _updateStatus(ConnectionStatus.offline);
    }
  }

  void _updateStatus(ConnectionStatus newStatus) {
    if (_status.value != newStatus) {
      debugPrint('🔄 Status: ${_status.value} → $newStatus');
      _status.value = newStatus;
    }
  }

  bool get canMakeRequest => _status.value != ConnectionStatus.offline;
  
  // ... waitForConnection tetap sama
}