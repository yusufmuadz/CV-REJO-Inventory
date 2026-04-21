
import 'package:image_picker/image_picker.dart';

class ParamsPostProduct {
  final String? barcode;
  final String? invoice;
  final String? qty;
  final List<XFile>? images;

  ParamsPostProduct({this.barcode, this.invoice, this.qty, this.images});
}
