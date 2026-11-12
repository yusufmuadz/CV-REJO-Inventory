import '../../../../core/error/failures.dart';
import '../../../../core/result/result_custom.dart';
import '../../../../features/home/domain/entities/home_entity.dart';
import '../../../data/repositories/app/app_repository_impl.dart';
import '../../entities/app/version_entity.dart';

class AppUsecase {
  final AppRepository repository;

  AppUsecase(this.repository);

  Future<ResultCustom<Failure, HomeEntity>> callHomeData() {
    return repository.getHomeData();
  }

  Future<ResultCustom<Failure, VersionEntity>> callVersionApp() {
    return repository.checkVersionApp();
  }
}
