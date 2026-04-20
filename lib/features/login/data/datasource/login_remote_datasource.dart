
import '../models/response_model.dart';
import '../models/user_model.dart';

abstract class LoginRemoteDataSource {
  Future<ResponseModelLoginSuccess> login(String email, String password);

  Future<UserModel> getProfile();

  Future<void> logout();
}