
import '../../domain/entities/home_entity.dart';

class HomeModel extends HomeEntity {
  const HomeModel({
    required super.totalRowTransaction,
    required super.totalRowTransactionHistory,
  });

  factory HomeModel.fromJson(Map<String, dynamic> json) {
    return HomeModel(
      totalRowTransaction: json['total_row_trans'] ?? 0,
      totalRowTransactionHistory: json['total_row_history'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "total_row_trans": totalRowTransaction,
      "total_row_history": totalRowTransactionHistory,
    };
  }
}