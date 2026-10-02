class ParamsAddAssistant {
  final String? invoice;
  final String? district; // ATAU RIT
  final String? idKendaraan;
  final String? idLoader;
  final String? idDriver;
  final String? idKenek;
  final String? dateRIT;
  final String? statusTransportation;
  final bool? isChecker2;
  final bool isDetail;

  ParamsAddAssistant({
    this.invoice,
    this.district, // ATAU RIT
    this.idKendaraan,
    this.idLoader,
    this.idDriver,
    this.idKenek,
    this.dateRIT,
    this.statusTransportation,
    this.isChecker2,
    this.isDetail = false,
  });
}
