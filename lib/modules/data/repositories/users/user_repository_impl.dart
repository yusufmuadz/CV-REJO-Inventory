import '../../../../core/error/failures.dart';
import '../../../../core/result/result_custom.dart';
import '../../../../features/login/domain/entities/user_entity.dart';
import '../../../helpers/repository_request_handler.dart';
import '../../datasource/user/user_datasource_impl.dart';

// ============ INDUK REPOSITORY ============
abstract class UserRepository {
  Future<ResultCustom<Failure, List<UserEntity>>> listUser();
  Future<ResultCustom<Failure, UserEntity>> user();
}

// ============ CHILD REPOSITORY ============
class UserRepositoryImpl implements UserRepository {
  UserRemoteDataSource dataSource;
  RepositoryRequestHandler request;

  UserRepositoryImpl(this.dataSource, this.request);

  // ============ GET LIST USER ============
  @override
  Future<ResultCustom<Failure, List<UserEntity>>> listUser() async {
    return request.execute(
      request: () => dataSource.listUser(),
      mapper: (response) => response.data!.toEntity(),
    );
  }

  // ============ GET USER LOGIN ============
  @override
  Future<ResultCustom<Failure, UserEntity>> user() async {
    return request.execute(
      request: () => dataSource.user(),
      mapper: (response) => response.data!.toEntity(),
    );
  }
}
