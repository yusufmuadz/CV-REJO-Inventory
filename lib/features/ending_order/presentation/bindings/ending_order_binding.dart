import 'package:get/get.dart';

import '../controllers/ending_order_controller.dart';

class EndingOrderBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<EndingOrderController>(
      () => EndingOrderController(endingOrderUseCase: Get.find()),
    );
  }
}
