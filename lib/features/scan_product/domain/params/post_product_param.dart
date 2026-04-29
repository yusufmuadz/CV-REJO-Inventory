import 'package:image_picker/image_picker.dart';

class ParamsPostProduct {
  final String? role;
  final String? barcode;
  final String? invoice;
  final String? qty;
  final List<XFile>? images;

  ParamsPostProduct({
    this.role,
    this.barcode,
    this.invoice,
    this.qty,
    this.images,
  });
}
