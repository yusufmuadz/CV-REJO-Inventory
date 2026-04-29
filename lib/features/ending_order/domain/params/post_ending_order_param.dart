import 'package:image_picker/image_picker.dart';

class ParamsEndingOrder {
  final String? role;
  final String? invoice;
  final String? desc;
  final List<XFile>? images;

  ParamsEndingOrder({this.role, this.invoice, this.desc, this.images});
}
