import 'package:camera/camera.dart';
import 'package:cv_rejo/features/rit_information/presentation/controllers/enums/enum_trouble.dart';

class ParamsTroubleRIT {
  final String? invoicePO;
  final String noRIT;
  final String tanggalRIT;
  final DateTime? date;
  final String? titleTrouble;
  final String? solution;
  final String? nominal;
  final String desc;
  final String lat;
  final String long;
  final String? status;
  final EnumTroubleRIT troubleRIT;
  final List<XFile> images;

  ParamsTroubleRIT({
    this.invoicePO,
    this.date,
    this.titleTrouble,
    this.solution,
    this.nominal,
    this.status,
    required this.noRIT,
    required this.tanggalRIT,
    required this.troubleRIT,
    required this.desc,
    required this.lat,
    required this.long,
    required this.images,
  });
}
