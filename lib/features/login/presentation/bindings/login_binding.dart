import 'package:get/get.dart';

import '../../domain/usecases/login_usecase.dart';
import '../controllers/login_controller.dart';

class LoginBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<LoginController>(
      () => LoginController(loginUseCase: Get.find<PostLoginUseCase>()),
    );
  }
}
