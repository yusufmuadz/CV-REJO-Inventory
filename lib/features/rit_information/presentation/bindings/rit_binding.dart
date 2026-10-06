import 'package:get/get.dart';

import '../controllers/inv_controller.dart';
import '../controllers/rit_controller.dart';

class RitBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<RitController>(() => RitController(ritUseCase: Get.find()));
    Get.lazyPut<InvController>(() => InvController());
  }
}
