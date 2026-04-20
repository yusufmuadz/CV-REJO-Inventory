import 'package:get/get.dart';

import '../../data/datasource/ending_order_remote_datasource.dart';
import '../../data/datasource/ending_order_remote_datasource_impl.dart';
import '../../data/repositories/ending_order_repository_impl.dart';
import '../../domain/repositories/ending_order_repository.dart';
import '../../domain/usecases/ending_order_usecase.dart';
import '../controllers/ending_order_controller.dart';

class EndingOrderBinding extends Bindings {
  @override
  void dependencies() {

    /// UseCase
    Get.lazyPut<EndingOrderUseCase>(() => EndingOrderUseCase(Get.find()));

    /// DataSource
    Get.lazyPut<EndingOrderRemoteDataSource>(
      () => EndingOrderRemoteDataSourceImpl(Get.find()),
    );

    /// Repository
    Get.lazyPut<EndingOrderRepository>(() => EndingOrderRepositoryImpl(Get.find()));

    Get.lazyPut<EndingOrderController>(
      () => EndingOrderController(endingOrderUseCase: Get.find()),
    );
  }
}
