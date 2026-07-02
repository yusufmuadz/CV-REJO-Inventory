import 'package:get/get.dart';

import '../controllers/scan_product_controller.dart';

class ScanProductBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ScanProductController>(
      () => ScanProductController(scanProductUseCase: Get.find()),
    );
  }
}
