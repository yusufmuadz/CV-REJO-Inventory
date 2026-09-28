import 'package:camera/camera.dart';

class BbmEntitity {
  final String isiAwal;
  final String inputNopol;
  final DateTime date;
  final String? desc;
  final String rit;
  final String routeRit;

  final List<XFile> mediaFilesFront;
  final List<XFile> mediaFilesAwalSegel;
  final List<XFile> mediaFilesDispenserAwalPengisian;
  final List<XFile> mediaFilesPengisianTangkiFull;
  final List<XFile> mediaFilesDispenserAkhirPengisian;
  final List<XFile> mediaFilesSegelBaru;
  final List<XFile> mediaFilesNota;

  BbmEntitity({
    this.desc,
    required this.isiAwal,
    required this.inputNopol,
    required this.date,
    required this.rit,
    required this.routeRit,
    required this.mediaFilesFront,
    required this.mediaFilesAwalSegel,
    required this.mediaFilesDispenserAwalPengisian,
    required this.mediaFilesPengisianTangkiFull,
    required this.mediaFilesDispenserAkhirPengisian,
    required this.mediaFilesSegelBaru,
    required this.mediaFilesNota,
  });
}
