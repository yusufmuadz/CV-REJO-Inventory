import 'package:cv_rejo/core/result/result_custom.dart';
import 'package:cv_rejo/features/detail_order/domain/entities/transportation_entity.dart';
import 'package:cv_rejo/features/detail_order/domain/params/pending_so_param.dart';
import 'package:cv_rejo/features/login/domain/entities/user_entity.dart';
import '../../../../core/error/failures.dart';
import '../../../scan_product/domain/entities/post_item_product_entity.dart';
import '../../../scan_product/domain/params/post_product_param.dart';
import '../../domain/entities/basic_entity.dart';
import '../../domain/entities/detail_order_entity.dart';
import '../../domain/params/add_assistant_param.dart';
import '../../domain/repositories/detail_order_repository.dart';
import '../datasource/detail_order_remote_datasource.dart';

class DetailOrderRepositoryImpl implements DetailOrderRepository {
  DetailOrderRemoteDataSource dataSource;

  DetailOrderRepositoryImpl(this.dataSource);

  @override
  Future<ResultCustom<Failure, DetailOrderEntity>> getListOrders(
    String noInvoice,
  ) async {
    try {
      final response = await dataSource.fetchTransaction(noInvoice);

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

      return Success(
        BasicEntity(
          status: response.status ?? false,
          message: response.message ?? '-',
        ),
        '',
      );
    } catch (e) {
      return ErrorResult(message: e.toString());
    }
  }

  @override
  Future<ResultCustom<Failure, BasicEntity>> pendingSO(
    ParamsPendingSO params,
  ) async {
    try {
      final response = await dataSource.pendingSO(params);

      return Success(
        BasicEntity(
          status: response.status ?? false,
          message: response.message ?? '-',
        ),
        '',
      );
    } catch (e) {
      return ErrorResult(message: e.toString());
    }
  }

  @override
  Future<ResultCustom<Failure, PostItemProductEntity>> postItemProduct(
    ParamsPostProduct params,
  ) async {
    try {
      final response = await dataSource.postItemProduct(params);

      if (response.error?.details == null) {
        return Success(response.data!.toEntity()!, '');
      }

      return ErrorResult(
        message: response.error?.details ?? '',
        isMaxFailure: response.error?.isMaxFailure ?? false,
      );
    } catch (e) {
      return ErrorResult(message: e.toString());
    }
  }
}
