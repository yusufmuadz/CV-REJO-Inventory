import 'package:get/get.dart';

import '../../data/datasource/list_order_remote_datasource.dart';
import '../../data/datasource/list_order_remote_datasource_impl.dart';
import '../../data/repositories/list_order_repository_impl.dart';
import '../../domain/repositories/list_order_repository.dart';
import '../../domain/usecases/list_order_usecase.dart';
import '../controllers/list_order_controller.dart';

class ListOrderBinding extends Bindings {
  @override
  void dependencies() {

    /// UseCase
    Get.lazyPut<ListOrderUseCase>(() => ListOrderUseCase(Get.find()));

    /// DataSource
    Get.lazyPut<ListOrderRemoteDataSource>(
      () => ListOrderRemoteDataSourceImpl(Get.find()),
    );

    /// Repository
    Get.lazyPut<ListOrderRepository>(() => ListOrderRepositoryImpl(Get.find()));

    Get.lazyPut<ListOrderController>(
      () => ListOrderController(listOrderUseCase: Get.find()),
    );
  }
}
