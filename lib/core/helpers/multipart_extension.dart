import 'package:camera/camera.dart';
import 'package:dio/dio.dart';
import 'package:path/path.dart' as p;

extension XFileMultipartExtension on XFile {
  Future<MultipartFile> get multipart async {
    return MultipartFile.fromFile(
      path,
      filename: p.basename(path),
    );
  }
}