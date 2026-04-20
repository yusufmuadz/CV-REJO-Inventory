import 'dart:convert';

import 'package:cv_rejo/core/error/dio_exceptions.dart';
import 'package:cv_rejo/features/login/data/models/response_model.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

import '../../../../core/error/exceptions.dart';
import '../../../../core/network/api_endpoints.dart';
import '../../../../core/network/base_response.dart';
import '../../../../core/network/dio_client.dart';
import '../models/user_model.dart';
import 'login_remote_datasource.dart';

class LoginRemoteDataSourceImpl implements LoginRemoteDataSource {
  final DioClient dioClient;

  LoginRemoteDataSourceImpl(this.dioClient);

  @override
  Future<ResponseModelLoginSuccess> login(String email, String password) async {
    try {
      final response = await dioClient.post(
        ApiEndpoints.login,
        data: {"username": email, "password": password},
      );

      debugPrint('Data Login Remote DataSource: ${response.data}');

      if (response.statusCode == 200 || response.statusCode == 201) {
        return ResponseModelLoginSuccess.fromMap(response.data);
      } else {
        throw ServerException(message: response.data['message'], statusCode: response.statusCode ?? 500);
      }
    } on DioException catch (e) {
      throw HandleDioExceptions().handleDioError(e);
    } catch (e) {
      throw ServerException(message: 'error login: $e');
    }
  }

  @override
  Future<UserModel> getProfile() async {
    final response = await dioClient.get(ApiEndpoints.users);

    final result = BaseResponseSuccess<UserModel>.fromJson(
      jsonDecode(response.data),
      (json) => UserModel.fromJson(json as Map<String, dynamic>),
    );

    if (!result.status || result.data == null) {
      throw Exception(result.message);
    }

    return result.data!;
  }

  @override
  Future<void> logout() async {
    await dioClient.post("/Login/logout");
  }
}
