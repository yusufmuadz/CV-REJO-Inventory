import 'package:get/get.dart';

import '../../data/datasource/scan_product_remote_datasource.dart';
import '../../data/datasource/scan_product_remote_datasource_impl.dart';
import '../../data/repositories/scan_product_repository_impl.dart';
import '../../domain/repositories/scan_product_repository.dart';
import '../../domain/usecases/scan_product_usecase.dart';
import '../controllers/scan_product_controller.dart';

class ScanProductBinding extends Bindings {
  @override
  void dependencies() {
    /// UseCase
    Get.lazyPut<ScanProductUseCase>(() => ScanProductUseCase(Get.find()));

    /// DataSource
    Get.lazyPut<ScanProductRemoteDataSource>(
      () => ScanProductRemoteDataSourceImpl(Get.find()),
    );

    /// Repository
    Get.lazyPut<ScanProductRepository>(
      () => ScanProductRepositoryImpl(Get.find()),
    );

    Get.lazyPut<ScanProductController>(
      () => ScanProductController(scanProductUseCase: Get.find()),
    );
  }
}
