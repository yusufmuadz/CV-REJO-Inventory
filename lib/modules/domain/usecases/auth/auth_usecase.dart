import '../../../../core/error/failures.dart';
import '../../../../core/result/result_custom.dart';
import '../../../../features/login/domain/entities/user_entity.dart';
import '../../../data/repositories/auth/auth_repository_impl.dart';
import '../../params/auth/login_param.dart';

class AuthUseCase {
  final AuthRepository repository;

  AuthUseCase(this.repository);

  Future<ResultCustom<Failure, UserEntity>> callLogin({
    required LoginParam param,
  }) {
    return repository.login(param);
  }
}
