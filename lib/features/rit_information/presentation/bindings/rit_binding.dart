import 'package:get/get.dart';

import '../../data/datasource/rit_remote_datasource.dart';
import '../../data/datasource/rit_remote_datasource_impl.dart';
import '../../data/repositories/rit_repository_impl.dart';
import '../../domain/repositories/rit_repository.dart';
import '../../domain/usecases/rit_usecase.dart';
import '../controllers/rit_controller.dart';

class RitBinding extends Bindings {
  @override
  void dependencies() {
    /// UseCase
    Get.lazyPut<RitUseCase>(() => RitUseCase(Get.find()));

    /// DataSource
    Get.lazyPut<RitRemoteDataSource>(() => RitRemoteDataSourceImpl(Get.find()));

    /// Repository
    Get.lazyPut<RitRepository>(() => RitRepositoryImpl(Get.find()));

    Get.lazyPut<RitController>(() => RitController(ritUseCase: Get.find()));
  }
}
