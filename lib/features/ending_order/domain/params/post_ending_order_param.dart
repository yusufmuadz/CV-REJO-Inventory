import 'package:camera/camera.dart';

class ParamsEndingOrder {
  final bool? paymentStatus;
  final String? role;
  final String? invoice;
  final String? noRoute;
  final String? notaRoute;
  final String? idDetail;
  final String? idPiutang;
  final String? desc;
  final String? lat;
  final String? long;
  final String? paymentMethod;
  final String? paymentNominal;
  final String? paymentNoteCustomer;
  final String? statusTransportation;
  final String? driverExternal;
  final String? mobilExternal;
  final String statusChecker2;
  final List<XFile>? images;
  final List<XFile>? imagesAllItem;
  final List<XFile>? imagesTransportation;
  final List<XFile>? imagesInvoice;
  final List<XFile>? imagesPayment;
  final ImagesDriverModel? imagesDriver;

  ParamsEndingOrder({
    this.role,
    this.invoice,
    this.noRoute,
    this.notaRoute,
    this.idDetail,
    this.idPiutang,
    this.desc,
    this.lat,
    this.long,
    this.paymentStatus,
    this.paymentMethod,
    this.paymentNominal,
    this.paymentNoteCustomer,
    this.statusTransportation,
    this.driverExternal,
    this.mobilExternal,
    this.images,
    this.imagesAllItem,
    this.imagesTransportation,
    this.imagesInvoice,
    this.imagesDriver,
    this.imagesPayment,
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
