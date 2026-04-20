import 'package:cv_rejo/features/login/data/datasource/login_remote_datasource_impl.dart';
import 'package:cv_rejo/features/login/data/repositories/login_repository_impl.dart';
import 'package:cv_rejo/features/login/domain/repositories/login_repository.dart';
import 'package:cv_rejo/features/login/domain/usecases/login_usecase.dart';
import 'package:get/get.dart';

import '../../data/datasource/login_remote_datasource.dart';
import '../controllers/login_controller.dart';

class LoginBinding extends Bindings {
  @override
  void dependencies() {
    /// UseCase
    Get.lazyPut<PostLoginUseCase>(() => PostLoginUseCase(Get.find()));

    /// DataSource
    Get.lazyPut<LoginRemoteDataSource>(() => LoginRemoteDataSourceImpl(Get.find()));

    /// Repository
    Get.lazyPut<LoginRepository>(() => LoginRepositoryImpl(Get.find()));

    /// Controller
    Get.lazyPut<LoginController>(
      () => LoginController(loginUseCase: Get.find<PostLoginUseCase>()),
    );
  }
}
