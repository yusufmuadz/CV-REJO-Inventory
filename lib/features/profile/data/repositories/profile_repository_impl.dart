import 'package:cv_rejo/core/result/result_custom.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/network/dio_client.dart';

class ProfileRepositoryImpl {
  final DioClient client;

  ProfileRepositoryImpl(this.client);

  Future<ResultCustom<Failure, String>> login(
    String email,
    String password,
  ) async {
    try {
      final response = await client.post(
        "/auth/login",
        data: {
          "email": email,
          "password": password,
        },
      );

      return Success(response.data["token"], response.data["message"]);
    } catch (e) {
      return ErrorResult(message: e.toString());
    }
  }
}