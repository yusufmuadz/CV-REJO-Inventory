import 'package:get/get.dart';

import '../controllers/rit_controller.dart';

class RitBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<RitController>(() => RitController(ritUseCase: Get.find()));
  }
}
