import 'package:get/get.dart';

import '../features/detail_order/presentation/bindings/detail_order_binding.dart';
import '../features/detail_order/presentation/views/detail_order_view.dart';
import '../features/ending_order/presentation/bindings/ending_order_binding.dart';
import '../features/ending_order/presentation/views/ending_order_view.dart';
import '../features/home/presentation/bindings/home_binding.dart';
import '../features/home/presentation/pages/home_page.dart';
import '../features/list_order/presentation/bindings/list_order_binding.dart';
import '../features/list_order/presentation/pages/list_order_page.dart';
import '../features/list_order_history/presentation/bindings/list_history_order_binding.dart';
import '../features/list_order_history/presentation/views/list_history_order_view.dart';
import '../features/login/presentation/bindings/login_binding.dart';
import '../features/login/presentation/views/login_view.dart';
import '../features/rit_information/presentation/bindings/rit_binding.dart';
import '../features/rit_information/presentation/pages/rit_page.dart';
import '../features/scan_product/presentation/bindings/scan_product_binding.dart';
import '../features/scan_product/presentation/views/scan_product_view.dart';
import '../features/splash/presentation/bindings/splash_binding.dart';
import '../features/splash/presentation/views/splash_view.dart';

part 'app_routes.dart';

class AppPages {
  AppPages._();

  static const INITIAL = Routes.SPLASH;

  static final routes = [
    GetPage(
      name: _Paths.HOME,
      page: () => const HomePage(),
      binding: HomeBinding(),
    ),
    GetPage(
      name: _Paths.LOGIN,
      page: () => const LoginView(),
      binding: LoginBinding(),
    ),
    GetPage(
      name: _Paths.SPLASH,
      page: () => const SplashView(),
      binding: SplashBinding(),
    ),
    GetPage(
      name: _Paths.LIST_ORDER,
      page: () => const ListOrderPage(),
      binding: ListOrderBinding(),
    ),
    GetPage(
      name: _Paths.DETAIL_ORDER,
      page: () => const DetailOrderView(),
      binding: DetailOrderBinding(),
    ),
    GetPage(
      name: _Paths.SCAN_PRODUCT,
      page: () => const ScanProductView(),
      binding: ScanProductBinding(),
    ),
    GetPage(
      name: _Paths.ENDING_ORDER,
      page: () => const EndingOrderView(),
      binding: EndingOrderBinding(),
    ),
    GetPage(
      name: _Paths.LIST_HISTORY_ORDER,
      page: () => const ListHistoryOrderView(),
      binding: ListHistoryOrderBinding(),
    ),
    GetPage(
      name: _Paths.RIT_INFORMATION,
      page: () => const RitPage(),
      binding: RitBinding(),
    ),
  ];
}
