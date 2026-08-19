import 'package:camera/camera.dart';

class RitConstraintEntity {
  final String? titleTrouble;
  final String? nominal;
  final String? solution;
  final DateTime date;
  final String status;
  final String desc;
  final String? rit;
  final String? routeRit;
  final List<XFile> mediaFileList;

  const RitConstraintEntity({
    this.titleTrouble,
    this.nominal,
    this.solution,
    this.rit,
    this.routeRit,
    required this.date,
    required this.status,
    required this.desc,
    required this.mediaFileList,
  });
}
