import '../../../../core/error/failures.dart';
import '../../../../core/result/result_custom.dart';
import '../entities/profile_entity.dart';
import '../repositories/profile_repository.dart';

class GetProfileUseCase {
  final ProfileRepository repository;

  GetProfileUseCase(this.repository);

  Future<ResultCustom<Failure, ProfileEntity>> call() {
    return repository.getProfile();
  }
}
