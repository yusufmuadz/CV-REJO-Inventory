import 'package:get/get.dart';

import '../features/detail_order/data/datasource/detail_order_remote_datasource.dart';
import '../features/detail_order/data/datasource/detail_order_remote_datasource_impl.dart';
import '../features/ending_order/data/datasource/ending_order_remote_datasource.dart';
import '../features/ending_order/data/datasource/ending_order_remote_datasource_impl.dart';
import '../features/home/data/datasource/home_remote_datasource.dart';
import '../features/home/data/datasource/home_remote_datasource_impl.dart';
import '../features/list_order/data/datasource/list_order_remote_datasource.dart';
import '../features/list_order/data/datasource/list_order_remote_datasource_impl.dart';
import '../features/list_order_history/data/datasource/list_history_order_remote_datasource.dart';
import '../features/list_order_history/data/datasource/list_history_order_remote_datasource_impl.dart';
import '../features/login/data/datasource/login_remote_datasource.dart';
import '../features/login/data/datasource/login_remote_datasource_impl.dart';
import '../features/rit_information/data/datasource/rit_remote_datasource.dart';
import '../features/rit_information/data/datasource/rit_remote_datasource_impl.dart';
import '../features/scan_product/data/datasource/scan_product_remote_datasource.dart';
import '../features/scan_product/data/datasource/scan_product_remote_datasource_impl.dart';

void injectionDataSource() {
  // ---------------------------------------------------------
  // LOGIN DATASOURCE
  // ---------------------------------------------------------
  Get.lazyPut<LoginRemoteDataSource>(
    () => LoginRemoteDataSourceImpl(Get.find()),
    fenix: true,
  );

  // ---------------------------------------------------------
  // HOME DATASOURCE
  // ---------------------------------------------------------
  Get.lazyPut<HomeRemoteDataSource>(
    () => HomeRemoteDataSourceImpl(Get.find()),
    fenix: true,
  );

  // ---------------------------------------------------------
  // LIST ORDER DATASOURCE
  // ---------------------------------------------------------
  Get.lazyPut<ListOrderRemoteDataSource>(
    () => ListOrderRemoteDataSourceImpl(Get.find()),
    fenix: true,
  );

  // ---------------------------------------------------------
  // LIST ORDER HISTORY DATASOURCE
  // ---------------------------------------------------------
  Get.lazyPut<ListHistoryOrderRemoteDataSource>(
    () => ListHistoryOrderRemoteDataSourceImpl(Get.find()),
    fenix: true,
  );

  // ---------------------------------------------------------
  // DETAIL ORDER DATASOURCE
  // ---------------------------------------------------------
  Get.lazyPut<DetailOrderRemoteDataSource>(
    () => DetailOrderRemoteDataSourceImpl(Get.find()),
    fenix: true,
  );

  // ---------------------------------------------------------
  // ENDING ORDER DATASOURCE
  // ---------------------------------------------------------
  Get.lazyPut<EndingOrderRemoteDataSource>(
    () => EndingOrderRemoteDataSourceImpl(Get.find()),
    fenix: true,
  );

  // ---------------------------------------------------------
  // RIT DATASOURCE
  // ---------------------------------------------------------
  Get.lazyPut<RitRemoteDataSource>(
    () => RitRemoteDataSourceImpl(Get.find()),
    fenix: true,
  );

  // ---------------------------------------------------------
  // SCAN PRODUCT DATASOURCE
  // ---------------------------------------------------------
  Get.lazyPut<ScanProductRemoteDataSource>(
    () => ScanProductRemoteDataSourceImpl(Get.find()),
    fenix: true,
  );
}
