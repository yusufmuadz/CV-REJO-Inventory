import 'package:image_picker/image_picker.dart';

class ParamsPostProduct {
  final String? role;
  final String? barcode;
  final String? invoice;
  final String? qty;
  final String? statusChecker2;
  final List<XFile>? images;

  ParamsPostProduct({
    this.role,
    this.barcode,
    this.invoice,
    this.qty,
    this.statusChecker2,
    this.images,
  });
}
