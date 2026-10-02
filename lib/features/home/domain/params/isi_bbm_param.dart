import 'package:camera/camera.dart';

class ParamsIsiBbm {
  final String noRit;
  final String dateRit;
  final String? fieldKm;
  final String? fieldNopol;
  final String? paymentMethod;
  final String? paymentNominal;
  final String? fieldDesc;
  final String? lat;
  final String? long;
  final String? statusTransportation;
  final List<XFile>? imagesSealBefore;
  final List<XFile>? imagesSealAfter;
  final List<XFile>? imagesBuktiPembayaran;
  final List<XFile>? imagesFrontTransportation;
  final List<XFile>? imagesDispenserAwal;
  final List<XFile>? imagesDispenserAkhir;
  final List<XFile>? imagesPengisianFull;

  ParamsIsiBbm({
    required this.noRit,
    required this.dateRit,
    this.fieldKm,
    this.fieldNopol,
    this.paymentMethod,
    this.paymentNominal,
    this.fieldDesc,
    this.lat,
    this.long,
    this.statusTransportation,
    this.imagesSealBefore,
    this.imagesSealAfter,
    this.imagesBuktiPembayaran,
    this.imagesFrontTransportation,
    this.imagesDispenserAwal,
    this.imagesDispenserAkhir,
    this.imagesPengisianFull,
  });
}
