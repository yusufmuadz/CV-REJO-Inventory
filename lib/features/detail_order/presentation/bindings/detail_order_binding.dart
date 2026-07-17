import 'package:get/get.dart';

import '../controllers/add_product_order_controller.dart';
import '../controllers/detail_order_controller.dart';
import '../controllers/get_detail_order_controller.dart';

class DetailOrderBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<DetailOrderController>(
      () => DetailOrderController(detailOrderUseCase: Get.find()),
    );

    Get.lazyPut<GetDetailOrderController>(
      () => GetDetailOrderController(detailOrderUseCase: Get.find()),
    );

    Get.lazyPut<AddProductOrderController>(
      () => AddProductOrderController(detailOrderUseCase: Get.find()),
    );
  }
}
