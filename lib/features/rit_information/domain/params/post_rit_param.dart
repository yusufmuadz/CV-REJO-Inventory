import 'package:camera/camera.dart';

class ParamsRit {
  final bool isArriveOffice;
  final String? recipient;
  final String rit;
  final String? routeRit;
  final String dateRit;
  final String? notaRoute;
  final String km;
  final String? lat;
  final String? long;
  final XFile kmImage;
  final XFile? frontTruckImage;
  final XFile? backTruckImage;
  final XFile? rightTruckImage;
  final XFile? leftTruckImage;
  final XFile? overAllTruckImage;
  final XFile? tankTruckImage;
  final XFile? pocketImage;
  final XFile? travelDocImage;
  final XFile? receiptMoneyImage;
  final XFile? fileBoxImage;
  final XFile? fileBuktiBayar;
  final List<XFile>? invoiceImages;

  ParamsRit({
    required this.isArriveOffice,
    this.recipient,
    required this.rit,
    required this.dateRit,
    this.routeRit,
    this.notaRoute,
    this.lat,
    this.long,
    required this.km,
    required this.kmImage,
    this.frontTruckImage,
    this.backTruckImage,
    this.rightTruckImage,
    this.leftTruckImage,
    this.overAllTruckImage,
    this.tankTruckImage,
    this.pocketImage,
    this.travelDocImage,
    this.invoiceImages,
    this.receiptMoneyImage,
    this.fileBoxImage,
    this.fileBuktiBayar,
  });
}
