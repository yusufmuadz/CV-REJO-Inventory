import 'package:get/get.dart';

import '../../data/datasource/list_history_order_remote_datasource.dart';
import '../../data/datasource/list_history_order_remote_datasource_impl.dart';
import '../../data/repositories/list_order_repository_impl.dart';
import '../../domain/repositories/list_history_order_repository.dart';
import '../../domain/usecases/list_history_order_usecase.dart';
import '../controllers/list_history_order_controller.dart';

class ListHistoryOrderBinding extends Bindings {
  @override
  void dependencies() {

    /// UseCase
    Get.lazyPut<ListHistoryOrderUseCase>(() => ListHistoryOrderUseCase(Get.find()));

    /// DataSource
    Get.lazyPut<ListHistoryOrderRemoteDataSource>(
      () => ListHistoryOrderRemoteDataSourceImpl(Get.find()),
    );

    /// Repository
    Get.lazyPut<ListHistoryOrderRepository>(() => ListHistoryOrderRepositoryImpl(Get.find()));

    Get.lazyPut<ListHistoryOrderController>(
      () => ListHistoryOrderController(listHistoryOrderUseCase: Get.find()),
    );
  }
}
