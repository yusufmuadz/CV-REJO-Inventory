import 'dart:io';

import 'package:camera/camera.dart';
import 'package:dio/dio.dart';
import 'package:path/path.dart' as p;

class MultipartHelper {
  MultipartHelper._();

  static Future<MultipartFile> fromXFile(XFile file) {
    return MultipartFile.fromFile(
      file.path,
      filename: p.basename(file.path),
    );
  }

  static Future<MultipartFile?> fromNullableXFile(XFile? file) async {
    if (file == null) return null;
    return fromXFile(file);
  }

  static Future<MultipartFile> fromFile(File file) {
    return MultipartFile.fromFile(
      file.path,
      filename: p.basename(file.path),
    );
  }

  static Future<MultipartFile?> fromNullableFile(File? file) async {
    if (file == null) return null;
    return fromFile(file);
  }
}