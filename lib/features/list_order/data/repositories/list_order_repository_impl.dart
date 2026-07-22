import 'package:cv_rejo/core/result/result_custom.dart';
import 'package:cv_rejo/features/list_order/data/datasource/list_order_remote_datasource.dart';
import 'package:cv_rejo/features/list_order/domain/entities/list_order_entity.dart';
import '../../../../core/error/failures.dart';
import '../../../detail_order/domain/entities/basic_entity.dart';
import '../../../detail_order/domain/entities/transportation_entity.dart';
import '../../../detail_order/domain/params/add_assistant_param.dart';
import '../../../login/domain/entities/user_entity.dart';
import '../../domain/entities/district_entity.dart';
import '../../domain/entities/rit_list_entity.dart';
import '../../domain/entities/take_it_order_entity.dart';
import '../../domain/params/get_rit_param.dart';
import '../../domain/params/get_transaction_param.dart';
import '../../domain/params/take_it_param.dart';
import '../../domain/repositories/list_order_repository.dart';

class ListOrderRepositoryImpl implements ListOrderRepository {
  ListOrderRemoteDataSource dataSource;

  ListOrderRepositoryImpl(this.dataSource);

  @override
  Future<ResultCustom<Failure, List<OrderEntity>>> getListOrders(
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
  Future<ResultCustom<Failure, List<DistrictEntity>>> getDistrict() async {
    try {
      final response = await dataSource.getDistrict();

      return Success(response.data!.toEntity(), '');
    } catch (e) {
      return ErrorResult(message: e.toString());
    }
  }

  @override
  Future<ResultCustom<Failure, List<RitListEntity>>> getRit(
    ParamGetRIT param,
  ) async {
    try {
      final response = await dataSource.getRit(param);

      return Success(response.data!.toEntity(), '');
    } catch (e) {
      return ErrorResult(message: e.toString());
    }
  }

  @override
  Future<ResultCustom<Failure, List<UserEntity>>> getUsers() async {
    try {
      final response = await dataSource.getUsers();

      return Success(response.data!.toEntity(), '');
    } catch (e) {
      return ErrorResult(message: e.toString());
    }
  }

  @override
  Future<ResultCustom<Failure, List<TransportationEntity>>>
  getTransportations() async {
    try {
      final response = await dataSource.getTransportations();

      return Success(response.data!.toEntity(), '');
    } catch (e) {
      return ErrorResult(message: e.toString());
    }
  }

  @override
  Future<ResultCustom<Failure, List<TransportationEntity>>>
  getLoaderTransportations() async {
    try {
      final response = await dataSource.getLoaderTransportations();

      return Success(response.data!.toEntity(), '');
    } catch (e) {
      return ErrorResult(message: e.toString());
    }
  }

  @override
  Future<ResultCustom<Failure, BasicEntity>> addAssistant(
    ParamsAddAssistant params,
  ) async {
    try {
      final response = await dataSource.addAssistant(params);
      String message = response.message;

      if (response.error != null) {
        message = response.error ?? '';
      }

      return Success(
        BasicEntity(status: response.status, message: message),
        '',
      );
    } catch (e) {
      return ErrorResult(message: e.toString());
    }
  }
}
