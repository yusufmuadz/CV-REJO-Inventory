import 'package:get/get.dart';

import '../features/detail_order/data/repositories/detail_order_repository_impl.dart';
import '../features/detail_order/domain/repositories/detail_order_repository.dart';
import '../features/ending_order/data/repositories/ending_order_repository_impl.dart';
import '../features/ending_order/domain/repositories/ending_order_repository.dart';
import '../features/home/data/repositories/home_repository_impl.dart';
import '../features/home/domain/repositories/home_repository.dart';
import '../features/list_order/data/repositories/list_order_repository_impl.dart';
import '../features/list_order/domain/repositories/list_order_repository.dart';
import '../features/list_order_history/data/repositories/list_order_repository_impl.dart';
import '../features/list_order_history/domain/repositories/list_history_order_repository.dart';
import '../features/login/data/repositories/login_repository_impl.dart';
import '../features/login/domain/repositories/login_repository.dart';
import '../features/rit_information/data/repositories/rit_repository_impl.dart';
import '../features/rit_information/domain/repositories/rit_repository.dart';
import '../features/scan_product/data/repositories/scan_product_repository_impl.dart';
import '../features/scan_product/domain/repositories/scan_product_repository.dart';

void injectionRepository() {
  // ---------------------------------------------------------
  // LOGIN REPOSITORY
  // ---------------------------------------------------------
  Get.lazyPut<LoginRepository>(
    () => LoginRepositoryImpl(Get.find()),
    fenix: true,
  );

  // ---------------------------------------------------------
  // HOME REPOSITORY
  // ---------------------------------------------------------
  Get.lazyPut<HomeRepository>(
    () => HomeRepositoryImpl(Get.find()),
    fenix: true,
  );

  // ---------------------------------------------------------
  // LIST ORDER REPOSITORY
  // ---------------------------------------------------------
  Get.lazyPut<ListOrderRepository>(
    () => ListOrderRepositoryImpl(Get.find()),
    fenix: true,
  );

  // ---------------------------------------------------------
  // LIST ORDER HISTORY REPOSITORY
  // ---------------------------------------------------------
  Get.lazyPut<ListHistoryOrderRepository>(
    () => ListHistoryOrderRepositoryImpl(Get.find()),
    fenix: true,
  );

  // ---------------------------------------------------------
  // DETAIL ORDER REPOSITORY
  // ---------------------------------------------------------
  Get.lazyPut<DetailOrderRepository>(
    () => DetailOrderRepositoryImpl(Get.find()),
    fenix: true,
  );

  // ---------------------------------------------------------
  // ENDING ORDER REPOSITORY
  // ---------------------------------------------------------
  Get.lazyPut<EndingOrderRepository>(
    () => EndingOrderRepositoryImpl(Get.find(), Get.find()),
    fenix: true,
  );

  // ---------------------------------------------------------
  // RIT REPOSITORY
  // ---------------------------------------------------------
  Get.lazyPut<RitRepository>(() => RitRepositoryImpl(Get.find()), fenix: true);

  // ---------------------------------------------------------
  // SCAN PRODUCT REPOSITORY
  // ---------------------------------------------------------
  Get.lazyPut<ScanProductRepository>(
    () => ScanProductRepositoryImpl(Get.find()),
    fenix: true,
  );
}
