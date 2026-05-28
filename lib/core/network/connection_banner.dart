// widgets/global_connection_banner.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'koneksi_check.dart';

class ConnectionBanner extends StatelessWidget {
  const ConnectionBanner({super.key});

  @override
  Widget build(BuildContext context) {
    final network = Get.find<KoneksiCheck>();

    return Obx(() {
      final status = network.statusStream.value;
      if (status == ConnectionStatus.online) return const SizedBox.shrink();

      debugPrint('Connection status from banner: $status');

      final isOffline = status == ConnectionStatus.offline;
      return _AnimatedBanner(
        isVisible: true,
        color: isOffline ? Colors.red.shade700 : Colors.orange.shade600,
        icon: isOffline
            ? Icons.wifi_off_rounded
            : Icons.signal_wifi_statusbar_connected_no_internet_4_rounded,
        message: isOffline
            ? 'Tidak ada koneksi internet'
            : 'Koneksi lemah / tidak stabil',
        showSpinner: false, // isOffline,
      );
    });
  }
}

class _AnimatedBanner extends StatelessWidget {
  final bool isVisible;
  final Color color;
  final IconData icon;
  final String message;
  final bool showSpinner;

  const _AnimatedBanner({
    required this.isVisible,
    required this.color,
    required this.icon,
    required this.message,
    required this.showSpinner,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      height: isVisible ? 50 : 0,
      child: isVisible
          ? Material(
              color: color,
              elevation: 6,
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 0,
                ),
                child: Row(
                  children: [
                    Icon(icon, color: Colors.white, size: 20),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        message,
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                        ),
                      ),
                    ),
                    if (showSpinner)
                      const SizedBox(
                        width: 16,
                        height: 16,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation<Color>(
                            Colors.white,
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            )
          : const SizedBox.shrink(),
    );
  }
}
