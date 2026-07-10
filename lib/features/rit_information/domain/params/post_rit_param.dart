import 'package:camera/camera.dart';

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
  final XFile? pocketImage;
  final XFile? travelDocImage;
  final List<XFile>? invoiceImages;

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
    this.pocketImage,
    this.travelDocImage,
    this.invoiceImages,
  });
}
