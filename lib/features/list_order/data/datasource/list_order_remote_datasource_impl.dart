import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

import '../../../../core/error/dio_exceptions.dart';
import '../../../../core/error/exceptions.dart';
import '../../../../core/network/api_endpoints.dart';
import '../../../../core/network/dio_client.dart';
import '../../domain/params/get_transaction_param.dart';
import '../../domain/params/take_it_param.dart';
import '../models/response_model_get_district.dart';
import '../models/response_model_get_transaction_all.dart';
import '../models/response_model_take_it_transaction.dart';
import 'list_order_remote_datasource.dart';

class ListOrderRemoteDataSourceImpl implements ListOrderRemoteDataSource {
  final DioClient dioClient;

  ListOrderRemoteDataSourceImpl(this.dioClient);

  @override
  Future<ResponseModelGetTransactionAll> fetchTransaction(
    ParamsGetTransaction params,
  ) async {
    try {
      Map<String, String> body = {
        if (params.limit != null) 'limit': '${params.limit}',
        if (params.page != null) 'page': '${params.page}',
        if (params.q != null) 'q': '${params.q}',
        if (params.sort != null) 'sort': '${params.sort}',
        if (params.district != null) 'district': '${params.district}',
        if (params.filter != null) 'filter': '${params.filter}',
        if (params.courier != null) 'courier': '${params.courier?.join(',')}',
      };

      String queryString = Uri(queryParameters: body).query;
      final response = await dioClient.get(
        '${ApiEndpoints.fetchTransactionAll}?$queryString',
      );

      // debugPrint('Data Home Transaction Remote DataSource: ${response.data}');

      if (response.statusCode == 200 ||
          response.statusCode == 201 ||
          response.data != null) {
        return ResponseModelGetTransactionAll.fromMap(response.data);
      } else {
        throw ServerException(
          message: response.data['message'],
          statusCode: response.statusCode ?? 500,
        );
      }
    } on DioException catch (e) {
      throw HandleDioExceptions().handleDioError(e);
    } catch (e) {
      throw ServerException(message: 'error Home Transaction: $e');
    }
  }

  @override
  Future<ResponseModelTakeItTransaction> takeItTransaction(
    ParamsTakeIt params,
  ) async {
    try {
      String role = params.role;

      if (params.role == 'loader' && params.statusChecker2 != 'completed') {
        role = 'check2';
      }
      
      final response = await dioClient.put(
        ApiEndpoints.takeItTransaction(role),
        data: {"invoice": params.invoice},
      );

      // debugPrint('Data Take It Transaction Remote DataSource: ${response.data}');

      if (response.statusCode == 200 ||
          response.statusCode == 201 ||
          response.data != null) {
        return ResponseModelTakeItTransaction.fromMap(response.data);
      } else {
        throw ServerException(
          message: response.data['message'],
          statusCode: response.statusCode ?? 500,
        );
      }
    } on DioException catch (e) {
      throw HandleDioExceptions().handleDioError(e);
    } catch (e) {
      throw ServerException(message: 'error Take It Transaction: $e');
    }
  }

  @override
  Future<ResponseModelGetDistrict> getDistrict() async {
    try {
      final response = await dioClient.get(ApiEndpoints.getDistrict);

      // debugPrint('Data Get District Remote DataSource: ${response.data}');

      if (response.statusCode == 200 ||
          response.statusCode == 201 ||
          response.data != null) {
        return ResponseModelGetDistrict.fromMap(response.data);
      } else {
        throw ServerException(
          message: response.data['message'],
          statusCode: response.statusCode ?? 500,
        );
      }
    } on DioException catch (e) {
      throw HandleDioExceptions().handleDioError(e);
    } catch (e) {
      throw ServerException(message: 'error Get District: $e');
    }
  }
}
