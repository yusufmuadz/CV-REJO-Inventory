import '../../../../core/error/failures.dart';
import '../../../../core/result/result_custom.dart';
import '../entities/profile_entity.dart';

abstract class ProfileRepository {
  Future<ResultCustom<Failure, ProfileEntity>> login(
    String email,
    String password,
  );

  Future<ResultCustom<Failure, ProfileEntity>> getProfile();

  Future<ResultCustom<Failure, void>> logout();
}
