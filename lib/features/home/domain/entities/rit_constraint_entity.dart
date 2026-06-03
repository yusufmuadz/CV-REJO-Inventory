import 'package:image_picker/image_picker.dart';

class RitConstraintEntity {
  final String title;
  final String nominal;
  final DateTime date;
  final String status;
  final String desc;
  final List<XFile> mediaFileList;

  const RitConstraintEntity({
    required this.title,
    required this.nominal,
    required this.date,
    required this.status,
    required this.desc,
    required this.mediaFileList,
  });
}
