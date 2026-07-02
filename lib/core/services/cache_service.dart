import 'dart:io';
import 'dart:math';
import 'package:path_provider/path_provider.dart';
import 'package:flutter/foundation.dart';

class CacheService {
  // Singleton pattern agar mudah dipanggil di mana saja
  static final CacheService instance = CacheService._internal();
  factory CacheService() => instance;
  CacheService._internal();

  /// 1. Menghapus file spesifik setelah proses upload selesai
  Future<void> deleteFile(String path) async {
    try {
      final file = File(path);
      if (await file.exists()) {
        await file.delete();
        debugPrint("Cache file dihapus: $path");
      }
    } catch (e) {
      debugPrint("Gagal menghapus file: $e");
    }
  }

  /// 2. Mendapatkan total ukuran folder cache
  Future<int> getCacheSize() async {
    final cacheDir = await getTemporaryDirectory();
    if (!cacheDir.existsSync()) return 0;
    
    int size = 0;
    cacheDir.listSync(recursive: true).forEach((file) {
      if (file is File) size += file.lengthSync();
    });
    return size;
  }

  /// 3. Menghapus seluruh file di folder cache (Manual Action)
  Future<void> clearAllCache() async {
    final cacheDir = await getTemporaryDirectory();
    if (cacheDir.existsSync()) {
      cacheDir.listSync().forEach((file) {
        try {
          file.deleteSync(recursive: true);
        } catch (e) {
          debugPrint("Gagal hapus item: $e");
        }
      });
    }
  }

  /// Helper untuk mengubah bytes ke String yang terbaca user
  String formatSize(int bytes) {
    if (bytes <= 0) return "0 B";
    final i = (log(bytes) / log(1024)).floor();
    return '${(bytes / pow(1024, i)).toStringAsFixed(2)} ${['B', 'KB', 'MB', 'GB'][i]}';
  }
}