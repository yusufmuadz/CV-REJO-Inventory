import '../../../../core/error/failures.dart';
import '../../../../core/result/result_custom.dart';
import '../../../../features/scan_product/domain/entities/post_item_product_entity.dart';
import '../../../../features/scan_product/domain/entities/scan_product_entity.dart';
import '../../../../features/scan_product/domain/params/post_product_param.dart';
import '../../../../features/scan_product/domain/params/scan_product_param.dart';
import '../../../helpers/repository_request_handler.dart';
import '../../datasource/scan/scan_datasource_impl.dart';

// ============ INDUK REPOSITORY ============
abstract class ScanRepository {
  Future<ResultCustom<Failure, ProductEntity>> getProduct(
    ParamsGetProduct param,
  );
  Future<ResultCustom<Failure, PostItemProductEntity>> simpanProduct(
    ParamsPostProduct param,
  );
}

// ============ CHILD REPOSITORY ============
class ScanRepositoryImpl implements ScanRepository {
  ScanRemoteDataSource dataSource;
  RepositoryRequestHandler request;

  ScanRepositoryImpl(this.dataSource, this.request);

  // ============ GET PRODUCT BY INVOICE AND BARCODE ============
  @override
  Future<ResultCustom<Failure, ProductEntity>> getProduct(
    ParamsGetProduct param,
  ) async {
    return request.execute(
      request: () => dataSource.getProduct(param),
      mapper: (response) => response.data!.toEntity(),
    );
  }

  // ============ POST SIMPAN IMAGE AND QTY PRODUCT ============
  @override
  Future<ResultCustom<Failure, PostItemProductEntity>> simpanProduct(
    ParamsPostProduct param,
  ) async {
    return request.execute(
      request: () => dataSource.simpanProduct(param),
      mapper: (response) => response.data!.toEntity(),
    );
  }
}
