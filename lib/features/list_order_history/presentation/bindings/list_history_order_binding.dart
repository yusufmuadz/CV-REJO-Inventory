import 'package:get/get.dart';

import '../controllers/list_history_order_controller.dart';

class ListHistoryOrderBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ListHistoryOrderController>(
      () => ListHistoryOrderController(listHistoryOrderUseCase: Get.find()),
    );
  }
}
