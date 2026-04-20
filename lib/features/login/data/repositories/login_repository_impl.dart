import 'package:cv_rejo/core/error/failures.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';

import '../../../../core/result/result_custom.dart';
import '../../domain/entities/user_entity.dart';
import '../../domain/repositories/login_repository.dart';
import '../datasource/login_remote_datasource.dart';

// JIKA PAKAI DIO

class LoginRepositoryImpl implements LoginRepository {
  final LoginRemoteDataSource remoteDatasource;

  LoginRepositoryImpl(this.remoteDatasource);

  @override
  Future<ResultCustom<Failure, UserEntity>> login(String email, String password) async {
    try {
      final response = await remoteDatasource.login(email, password);
      // debugPrint('Data Login Repository: ${response.errors}');
      
      return Success(response.toEntity(), response.errors);
    } on DioException catch (e) {
      return ErrorResult(
        message: 'Failed to login Dio Repository: ${e.message}',
        statusCode: e.response?.statusCode,
      );
    } catch (e) {
      return ErrorResult(message: 'Failed to login Result Repository: $e');
    }
  }

  @override
  Future<ResultCustom<Failure, UserEntity>> getProfile() {
    throw UnimplementedError();
  }

  @override
  Future<ResultCustom<Failure, void>> logout() {
    throw UnimplementedError();
  }
}
