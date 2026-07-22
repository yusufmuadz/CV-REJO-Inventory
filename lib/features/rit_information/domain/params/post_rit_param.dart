import 'package:camera/camera.dart';

class ParamsRit {
  final bool isArriveOffice;
  final String? recipient;
  final String rit;
  final String dateRit;
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
  final XFile? receiptMoneyImage;
  final XFile? fileBoxImage;
  final List<XFile>? invoiceImages;

  ParamsRit({
    required this.isArriveOffice,
    this.recipient,
    required this.rit,
    required this.dateRit,
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
    this.receiptMoneyImage,
    this.fileBoxImage,
  });
}
