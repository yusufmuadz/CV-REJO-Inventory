import 'package:camera/camera.dart';
import 'package:cv_rejo/features/rit_information/presentation/controllers/enums/enum_trouble.dart';

class ParamsTroubleRIT {
  final String? invoicePO;
  final String noRIT;
  final String tanggalRIT;
  final EnumTroubleRIT troubleRIT;
  final String desc;
  final String lat;
  final String long;
  final List<XFile> images;

  ParamsTroubleRIT({
    this.invoicePO,
    required this.noRIT,
    required this.tanggalRIT,
    required this.troubleRIT,
    required this.desc,
    required this.lat,
    required this.long,
    required this.images,
  });
}
