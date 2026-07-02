import 'package:get/get.dart';

import '../features/detail_order/domain/usecases/detail_order_usecase.dart';
import '../features/ending_order/domain/usecases/ending_order_usecase.dart';
import '../features/home/domain/usecases/get_home_usecase.dart';
import '../features/list_order/domain/usecases/list_order_usecase.dart';
import '../features/list_order_history/domain/usecases/list_history_order_usecase.dart';
import '../features/login/domain/usecases/login_usecase.dart';
import '../features/rit_information/domain/usecases/rit_usecase.dart';
import '../features/scan_product/domain/usecases/scan_product_usecase.dart';

void injectionUsecase() {
  // ---------------------------------------------------------
  // LOGIN USECASE
  // ---------------------------------------------------------
  Get.lazyPut<PostLoginUseCase>(
    () => PostLoginUseCase(Get.find()),
    fenix: true,
  );

  // ---------------------------------------------------------
  // HOME USECASE
  // ---------------------------------------------------------
  Get.lazyPut<GetHomeUseCase>(() => GetHomeUseCase(Get.find()), fenix: true);

  // ---------------------------------------------------------
  // LIST ORDER USECASE
  // ---------------------------------------------------------
  Get.lazyPut<ListOrderUseCase>(
    () => ListOrderUseCase(Get.find()),
    fenix: true,
  );

  // ---------------------------------------------------------
  // LIST ORDER HISTORY USECASE
  // ---------------------------------------------------------
  Get.lazyPut<ListHistoryOrderUseCase>(
    () => ListHistoryOrderUseCase(Get.find()),
    fenix: true,
  );

  // ---------------------------------------------------------
  // DETAIL ORDER USECASE
  // ---------------------------------------------------------
  Get.lazyPut<DetailOrderUseCase>(
    () => DetailOrderUseCase(Get.find()),
    fenix: true,
  );

  // ---------------------------------------------------------
  // ENDING ORDER USECASE
  // ---------------------------------------------------------
  Get.lazyPut<EndingOrderUseCase>(
    () => EndingOrderUseCase(Get.find()),
    fenix: true,
  );

  // ---------------------------------------------------------
  // RIT USECASE
  // ---------------------------------------------------------
  Get.lazyPut<RitUseCase>(() => RitUseCase(Get.find()), fenix: true);

  // ---------------------------------------------------------
  // SCAN PRODUCT USECASE
  // ---------------------------------------------------------
  Get.lazyPut<ScanProductUseCase>(() => ScanProductUseCase(Get.find()), fenix: true);
}
