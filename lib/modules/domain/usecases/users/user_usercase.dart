import '../../../../core/error/failures.dart';
import '../../../../core/result/result_custom.dart';
import '../../../../features/login/domain/entities/user_entity.dart';
import '../../../data/repositories/users/user_repository_impl.dart';

class UserUseCase {
  final UserRepository repository;

  UserUseCase(this.repository);

  Future<ResultCustom<Failure, List<UserEntity>>> callListUser() {
    return repository.listUser();
  }

  Future<ResultCustom<Failure, UserEntity>> callUser() {
    return repository.user();
  }
}
