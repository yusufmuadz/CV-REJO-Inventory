import 'package:get/get.dart';

import '../../data/datasource/detail_order_remote_datasource.dart';
import '../../data/datasource/detail_order_remote_datasource_impl.dart';
import '../../data/repositories/detail_order_repository_impl.dart';
import '../../domain/repositories/detail_order_repository.dart';
import '../../domain/usecases/detail_order_usecase.dart';
import '../controllers/detail_order_controller.dart';

class DetailOrderBinding extends Bindings {
  @override
  void dependencies() {

    /// UseCase
    Get.lazyPut<DetailOrderUseCase>(() => DetailOrderUseCase(Get.find()));

    /// DataSource
    Get.lazyPut<DetailOrderRemoteDataSource>(
      () => DetailOrderRemoteDataSourceImpl(Get.find()),
    );

    /// Repository
    Get.lazyPut<DetailOrderRepository>(() => DetailOrderRepositoryImpl(Get.find()));

    Get.lazyPut<DetailOrderController>(
      () => DetailOrderController(detailOrderUseCase: Get.find()),
    );
  }
}
