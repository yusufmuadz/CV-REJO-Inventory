class RouteListEntity {
  final String? city; // Harunya ID/nomor RIT
  final String? rute;
  final String? totalInv;
  final String? tanggalRit;
  final String? color;
  final String? invPendingPic;
  final String? invDonePic;
  final String? invPendingCheck1;
  final String? invDoneCheck1;
  final String? invPendingCheck2;
  final String? invDoneCheck2;
  final String? invPendingLoader;
  final String? invDoneLoader;
  final String? invPendingDelivery;
  final String? invDoneDelivery;
  final List<String>? route;

  RouteListEntity({
    this.city,
    this.rute,
    this.totalInv,
    this.tanggalRit,
    this.color,
    this.invPendingPic,
    this.invDonePic,
    this.invPendingCheck1,
    this.invDoneCheck1,
    this.invPendingCheck2,
    this.invDoneCheck2,
    this.invPendingLoader,
    this.invDoneLoader,
    this.invPendingDelivery,
    this.invDoneDelivery,
    this.route,
  });

  factory RouteListEntity.fromJson(Map<String, dynamic> json) {
    return RouteListEntity(
      city: json['city'] ?? '-',
      rute: json['rute'] ?? '-',
      totalInv: json['total_po'] ?? '-',
      tanggalRit: json['tanggal_rit'] ?? '-',
      color: json['color'] ?? '-',
      invPendingPic: json['po_pending_pic'] ?? '-',
      invDonePic: json['po_done_pic'] ?? '-',
      invPendingCheck1: json['po_pending_check1'] ?? '-',
      invDoneCheck1: json['po_done_check1'] ?? '-',
      invPendingCheck2: json['po_pending_check2'] ?? '-',
      invDoneCheck2: json['po_done_check2'] ?? '-',
      invPendingLoader: json['po_pending_loader'] ?? '-',
      invDoneLoader: json['po_done_loader'] ?? '-',
      invPendingDelivery: json['po_pending_delivery'] ?? '-',
      invDoneDelivery: json['po_done_delivery'] ?? '-',
      route: json['rute'] != null
          ? List<String>.from(json['rute'])
          : List<String>.from(['-']), // json['rute'],
    );
  }
}
