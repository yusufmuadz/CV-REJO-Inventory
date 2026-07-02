import 'package:get/get.dart';

import '../controllers/get_data_list_controller.dart';
import '../controllers/list_order_controller.dart';
import '../controllers/post_data_list_controller.dart';

class ListOrderBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ListOrderController>(
      () => ListOrderController(listOrderUseCase: Get.find()),
    );

    Get.lazyPut<GetDataListController>(
      () => GetDataListController(listOrderUseCase: Get.find()),
    );

    Get.lazyPut<PostDataListController>(
      () => PostDataListController(listOrderUseCase: Get.find()),
    );
  }
}
