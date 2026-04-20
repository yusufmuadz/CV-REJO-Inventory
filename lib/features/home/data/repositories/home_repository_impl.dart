import 'package:cv_rejo/core/result/result_custom.dart';
import 'package:cv_rejo/features/home/data/datasource/home_remote_datasource.dart';
import 'package:cv_rejo/features/home/domain/entities/home_entity.dart';
import 'package:cv_rejo/features/list_order/domain/params/get_transaction_param.dart';
import '../../../../core/error/failures.dart';
import '../../domain/entities/transaction_entity.dart';
import '../../domain/repositories/home_repository.dart';

class HomeRepositoryImpl extends HomeRepository {
  final HomeRemoteDataSource dataSource;

  HomeRepositoryImpl(this.dataSource);

  @override
  Future<ResultCustom<Failure, TransactionEntity>> getTransaction(
    ParamsGetTransaction params
  ) async {
    try {
      final response = await dataSource.fetchTransaction(params);

      return Success(response.data!.toEntity(), '');
    } catch (e) {
      return ErrorResult(message: e.toString());
    }
  }

  @override
  Future<ResultCustom<Failure, HomeEntity>> getHomeData() async {
    try {
      final response = await dataSource.getHomeData();

      return Success(response.data!.toEntity(), '');
    } catch (e) {
      return ErrorResult(message: e.toString());
    }
  }
}