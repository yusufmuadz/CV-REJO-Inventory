import 'package:cv_rejo/features/home/domain/entities/home_entity.dart';

class ResponseModelGetHome {
  final bool? status;
  final String? message;
  final Data? data;

  ResponseModelGetHome({this.status, this.message, this.data});

  factory ResponseModelGetHome.fromMap(Map<String, dynamic> json) =>
      ResponseModelGetHome(
        status: json["status"],
        message: json["message"],
        data: Data.fromMap(json),
      );
}

class Data {
  HomeEntity? home;

  Data({this.home});

  Data copyWith({HomeEntity? home}) => Data(home: home ?? this.home);

  factory Data.fromMap(Map<String, dynamic> json) => Data(
    home: json["data"] == null
        ? HomeEntity(totalRowTransaction: 0, totalRowTransactionHistory: 0)
        : HomeEntity(
            totalRowTransaction: json["data"]['total_row_trans'] ?? 0,
            totalRowTransactionHistory: json["data"]['total_row_history'] ?? 0,
          ),
  );

  HomeEntity toEntity() {
    if (home == null) {
      return HomeEntity(totalRowTransaction: 0, totalRowTransactionHistory: 0);
    }
    return home!;
  }
}