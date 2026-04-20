import 'package:cv_rejo/features/login/domain/entities/user_entity.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/result/result_custom.dart';
import '../repositories/login_repository.dart';

class PostLoginUseCase {
  final LoginRepository repository;

  PostLoginUseCase(this.repository);

  Future<ResultCustom<Failure, UserEntity>> call({required String email, required String password}) async {
    return await repository.login(email, password);
  }
}