import 'package:cv_rejo/core/result/result_custom.dart';
import 'package:cv_rejo/features/home/data/datasource/home_remote_datasource.dart';
import 'package:cv_rejo/features/home/domain/entities/home_entity.dart';
import 'package:cv_rejo/features/list_order/data/datasource/list_order_remote_datasource.dart';
import 'package:cv_rejo/features/list_order/domain/params/get_transaction_param.dart';
import '../../../../core/error/failures.dart';
import '../../../list_order/domain/entities/list_order_entity.dart';
import '../../domain/entities/transaction_entity.dart';
import '../../domain/repositories/home_repository.dart';

class HomeRepositoryImpl extends HomeRepository {
  final HomeRemoteDataSource dataSource;
  // final ListOrderRemoteDataSource listOrderRemoteDataSource;

  HomeRepositoryImpl(this.dataSource);

  @override
  Future<ResultCustom<Failure, List<OrderEntity>>> getTransaction(
    ParamsGetTransaction params,
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

      if (response.status != false && response.message != '') {
        return Success(response.data!.toEntity(), '');
      }
      return ErrorResult(message: response.message ?? 'Error');
    } catch (e) {
      return ErrorResult(message: e.toString());
    }
  }

  // @override
  // Future<ResultCustom<Failure, List<OrderEntity>>> getListOrder(
  //   ParamsGetTransaction params,
  // ) async {
  //   try {
  //     final response = await listOrderRemoteDataSource.fetchTransaction(params);

  //     if (response.status != false && response.message != '') {
  //       return Success(response.data!.toEntity(), '');
  //     }
  //     return ErrorResult(message: response.message ?? 'Error');
  //   } catch (e) {
  //     return ErrorResult(message: e.toString());
  //   }
  // }
}
