import 'package:image_picker/image_picker.dart';

class ParamsRit {
  final String rit;
  final String km;
  final XFile kmImage;
  final XFile? frontTruckImage;
  final XFile? backTruckImage;
  final XFile? rightTruckImage;
  final XFile? leftTruckImage;
  final XFile? overAllTruckImage;
  final XFile tankTruckImage;
  final List<XFile>? inoviceImages;
  final List<XFile>? pocketImages;
  final List<XFile>? travelDocImages;

  ParamsRit({
    required this.rit,
    required this.km,
    required this.kmImage,
    this.frontTruckImage,
    this.backTruckImage,
    this.rightTruckImage,
    this.leftTruckImage,
    this.overAllTruckImage,
    required this.tankTruckImage,
    this.inoviceImages,
    this.pocketImages,
    this.travelDocImages,
  });
}
