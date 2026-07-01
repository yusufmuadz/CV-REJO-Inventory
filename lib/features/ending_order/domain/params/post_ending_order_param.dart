import 'package:camera/camera.dart';

class ParamsEndingOrder {
  final String? role;
  final String? invoice;
  final String? desc;
  final String statusChecker2;
  final List<XFile>? images;

  ParamsEndingOrder({
    this.role,
    this.invoice,
    this.desc,
    required this.statusChecker2,
    this.images,
  });
}
