import 'package:cv_rejo/features/home/domain/usecases/get_home_usecase.dart';
import 'package:get/get.dart';

import '../../../../core/services/cache_service.dart';
import '../../../list_order/domain/usecases/list_order_usecase.dart';
import '../controllers/home_controller.dart';
import '../controllers/home_page_controller.dart';
import '../controllers/home_profile_controller.dart';
import '../controllers/home_rit_controller.dart';
import '../controllers/home_tracking_driver_controller.dart';
import '../controllers/home_transactions_controller.dart';

class HomeBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<CacheService>(() => CacheService());

    Get.lazyPut<HomeController>(
      () => HomeController(homeUseCase: Get.find<GetHomeUseCase>()),
    );

    Get.lazyPut<HomePageController>(() => HomePageController());

    Get.lazyPut<HomeProfileController>(() => HomeProfileController());

    Get.lazyPut<HomeTransactionsController>(
      () => HomeTransactionsController(homeUseCase: Get.find<GetHomeUseCase>()),
    );

    Get.lazyPut<HomeRITController>(
      () => HomeRITController(homeUseCase: Get.find<GetHomeUseCase>()),
    );

    Get.lazyPut<HomeTrackingDriverController>(
      () => HomeTrackingDriverController(
        homeUseCase: Get.find<GetHomeUseCase>(),
        listOrderUseCase: Get.find<ListOrderUseCase>(),
      ),
    );
  }
}
