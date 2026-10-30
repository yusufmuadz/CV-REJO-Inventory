import 'package:cv_rejo/features/detail_order/data/models/customer_model.dart';
import 'package:cv_rejo/features/list_order/data/models/courier_model.dart';
import 'package:cv_rejo/features/list_order/data/models/date_model.dart';

import '../../data/models/assistant_model.dart';
import '../../data/models/driver_model.dart';
import '../../data/models/item_order_model.dart';

class DetailOrderEntity {
  final String invoice;
  final String orderNo;
  final String suratJalan;
  final String? route;
  final String? totalTonase;
  final String? jenisArmada;
  final String? driverExternal;
  final String? mobilExternal;
  final String? customerName;
  final String? dropAddress;
  final String? noTelp;
  final Courier? courier;
  final CustomerModel? customer;
  final DateModel? date;
  final AssistantModel? assistant;
  final DriverModel? driver;
  final String? idDetail;
  final String? idPiutang;
  final String? tanggalTransaksi;
  final String? totalPiutang;
  final String? sisaPiutang;
  final List<ItemOrderModel>? orderDetails;

  const DetailOrderEntity({
    required this.invoice,
    required this.orderNo,
    required this.suratJalan,
    this.courier,
    this.customer,
    this.customerName,
    this.dropAddress,
    this.noTelp,
    this.date,
    this.route,
    this.totalTonase,
    this.jenisArmada = '-',
    this.driverExternal,
    this.mobilExternal,
    this.assistant,
    this.driver,
    this.orderDetails,
    this.idDetail,
    this.idPiutang,
    this.tanggalTransaksi,
    this.totalPiutang,
    this.sisaPiutang,
  });

  factory DetailOrderEntity.fromJson(Map<String, dynamic> json) {
    String getData({required String value}) {
      String? data = json[value];

      if (json['content'] != null) {
        data ??= json['content'][value];
      }

      return data ?? '-';
    }

    return DetailOrderEntity(
      invoice: getData(value: 'invoice'),
      orderNo: getData(value: 'order_no'),
      suratJalan: getData(value: 'surat_jalan').replaceAll('SJ/', ''),
      courier: json['courier'] != null
          ? Courier.fromJson(json['courier'])
          : null,
      customer:
          json['customer'] != null && json['customer'].runtimeType != String
          ? CustomerModel.fromJson(json['customer'])
          : null,
      customerName: json['customer'].runtimeType == String
          ? getData(value: 'customer')
          : '-',
      dropAddress: getData(value: 'drop_address'),
      noTelp: getData(value: 'phone'),
      date: json['date'] != null ? DateModel.fromJson(json['date']) : null,
      route: getData(value: 'route'),
      totalTonase: getData(value: 'total_tonase'),
      jenisArmada: getData(value: 'jenis_armada'),
      driverExternal: getData(value: 'driver_external'),
      mobilExternal: getData(value: 'mobil_external'),
      idDetail: getData(value: 'id_detail'),
      idPiutang: getData(value: 'id_piutang'),
      tanggalTransaksi: getData(value: 'tanggal_transaksi'),
      totalPiutang: getData(value: 'total_piutang'),
      sisaPiutang: getData(value: 'sisa_piutang'),
      assistant: json['assistant'] != null
          ? AssistantModel.fromJson(json['assistant'])
          : null,
      driver: json['driver'] != null
          ? DriverModel.fromJson(json['driver'])
          : null,
      orderDetails: json['order_details'] != null
          ? List<ItemOrderModel>.from(
              json['order_details'].map((x) => ItemOrderModel.fromJson(x)),
            )
          : null,
    );
  }

  DetailOrderEntity copyWith({
    String? invoice,
    String? orderNo,
    String? suratJalan,
    Courier? courier,
    CustomerModel? customer,
    DateModel? date,
    AssistantModel? assistant,
    DriverModel? driver,
    List<ItemOrderModel>? orderDetails,
  }) {
    return DetailOrderEntity(
      invoice: invoice ?? this.invoice,
      orderNo: orderNo ?? this.orderNo,
      suratJalan: suratJalan ?? this.suratJalan,
      courier: courier ?? this.courier,
      customer: customer ?? this.customer,
      date: date ?? this.date,
      assistant: assistant ?? this.assistant,
      driver: driver ?? this.driver,
      orderDetails: orderDetails ?? this.orderDetails,
    );
  }
}
