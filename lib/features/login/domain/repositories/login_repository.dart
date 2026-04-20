import 'package:cv_rejo/core/result/result_custom.dart';
import 'package:cv_rejo/features/login/domain/entities/user_entity.dart';

import '../../../../core/error/failures.dart';

abstract class LoginRepository {
  Future<ResultCustom<Failure, UserEntity>> login(
    String email,
    String password,
  );

  Future<ResultCustom<Failure, UserEntity>> getProfile();

  Future<ResultCustom<Failure, void>> logout();
}