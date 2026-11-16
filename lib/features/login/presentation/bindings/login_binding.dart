import 'package:get/get.dart';

import '../../../../modules/domain/usecases/auth/auth_usecase.dart';
import '../controllers/login_controller.dart';

class LoginBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<LoginController>(
      () => LoginController(authUseCase: Get.find<AuthUseCase>()),
    );
  }
}
