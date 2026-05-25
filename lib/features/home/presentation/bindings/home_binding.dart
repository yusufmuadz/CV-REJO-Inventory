import 'package:cv_rejo/features/home/domain/usecases/get_home_usecase.dart';
import 'package:get/get.dart';

import '../../../list_order/presentation/bindings/list_order_binding.dart';
import '../../data/datasource/home_remote_datasource.dart';
import '../../data/datasource/home_remote_datasource_impl.dart';
import '../../data/repositories/home_repository_impl.dart';
import '../../domain/repositories/home_repository.dart';
import '../controllers/home_controller.dart';

class HomeBinding extends Bindings {
  @override
  void dependencies() {
    /// UseCase
    Get.lazyPut<GetHomeUseCase>(() => GetHomeUseCase(Get.find()));

    /// DataSource
    Get.lazyPut<HomeRemoteDataSource>(
      () => HomeRemoteDataSourceImpl(Get.find()),
    );

    /// Repository
    Get.lazyPut<HomeRepository>(() => HomeRepositoryImpl(Get.find()));

    Get.lazyPut<HomeController>(
      () => HomeController(homeUseCase: Get.find<GetHomeUseCase>()),
    );

    ListOrderBinding().dependencies();
  }
}
