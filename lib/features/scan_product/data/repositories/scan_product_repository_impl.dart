
import '../../../../core/error/failures.dart';
import '../../../../core/result/result_custom.dart';
import '../../domain/entities/item_product_entity.dart';
import '../../domain/entities/post_item_product_entity.dart';
import '../../domain/entities/scan_product_entity.dart';
import '../../domain/params/post_product_param.dart';
import '../../domain/params/scan_product_param.dart';
import '../../domain/repositories/scan_product_repository.dart';
import '../datasource/scan_product_remote_datasource.dart';

class ScanProductRepositoryImpl implements ScanProductRepository {
  ScanProductRemoteDataSource dataSource;

  ScanProductRepositoryImpl(this.dataSource);

  @override
  Future<ResultCustom<Failure, ProductEntity>> getProduct(
    ParamsGetProduct params,
  ) async {
    try {
      final response = await dataSource.getProduct(params);

      if (response.error == null) {
        return Success(response.data!.toEntity()!, '');
      }

      return ErrorResult(message: response.error ?? '');
    } catch (e) {
      return ErrorResult(message: e.toString());
    }
  }

  @override
  Future<ResultCustom<Failure, List<ItemProductEntity>>> getItemProduct(
    String search,
  ) async {
    try {
      final response = await dataSource.getItemProduct(search);

      if (response.error == null) {
        return Success(response.data!.toEntity(), '');
      }
      return ErrorResult(message: response.error ?? '');
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
      
      return ErrorResult(message: response.error?.details ?? '', isMaxFailure: response.error?.isMaxFailure ?? false);
    } catch (e) {
      return ErrorResult(message: e.toString());
    }
  }
}
