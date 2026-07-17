import 'package:camera/camera.dart';

class ParamsEndingOrder {
  final String? role;
  final String? invoice;
  final String? desc;
  final String? lat;
  final String? long;
  final String? paymentMethod;
  final String? paymentNominal;
  final String statusChecker2;
  final List<XFile>? images;
  final ImagesDriverModel? imagesDriver;

  ParamsEndingOrder({
    this.role,
    this.invoice,
    this.desc,
    this.lat,
    this.long,
    this.paymentMethod,
    this.paymentNominal,
    this.images,
    this.imagesDriver,
    required this.statusChecker2,
  });
}

class ImagesDriverModel {
  final List<XFile>? imagesTransportation;
  final List<XFile>? imagesMerchant;
  final List<XFile>? imagesAllItem;
  final List<XFile>? imagesHandover; // Gambar Invoice atau Surat Jalan
  final List<XFile>? imagesPayment;

  ImagesDriverModel({
    this.imagesTransportation,
    this.imagesMerchant,
    this.imagesAllItem,
    this.imagesHandover,
    this.imagesPayment,
  });
}
