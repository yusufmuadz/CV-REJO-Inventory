import '../../../../core/error/failures.dart';
import '../../../../core/result/result_custom.dart';
import '../../../../features/login/domain/entities/user_entity.dart';
import '../../../domain/params/auth/login_param.dart';
import '../../../helpers/repository_request_handler.dart';
import '../../datasource/auth/auth_datasource_impl.dart';

// ============ INDUK REPOSITORY ============
abstract class AuthRepository {
  Future<ResultCustom<Failure, UserEntity>> login(LoginParam param);
}

// ============ CHILD REPOSITORY ============
class AuthRepositoryImpl implements AuthRepository {
  AuthRemoteDataSource dataSource;
  RepositoryRequestHandler request;

  AuthRepositoryImpl(this.dataSource, this.request);

  // ============ POST LOGIN ============
  @override
  Future<ResultCustom<Failure, UserEntity>> login(LoginParam param) async {
    return request.execute(
      request: () => dataSource.login(param),
      mapper: (response) => response.data!.toEntity(),
      errorMapper: (response) => response.error ?? '',
    );
  }
}
