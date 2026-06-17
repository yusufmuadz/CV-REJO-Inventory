import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../core/error/dio_exceptions.dart';
import '../../../../core/error/exceptions.dart';
import '../../../../core/middlewares/app_role.dart';
import '../../../../core/network/api_endpoints.dart';
import '../../../../core/network/dio_client.dart';
import '../../../detail_order/data/models/response_model_basic.dart';
import '../../../detail_order/data/models/response_model_get_transporation.dart';
import '../../../detail_order/data/models/response_model_get_user.dart';
import '../../../detail_order/domain/params/add_assistant_param.dart';
import '../../domain/params/get_rit_param.dart';
import '../../domain/params/get_transaction_param.dart';
import '../../domain/params/take_it_param.dart';
import '../models/response_model_get_district.dart';
import '../models/response_model_get_rit.dart';
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
      String? date = params.dateRit;

      if (params.pastRit == true) {
        if (date != null) {
          date = DateFormat('yyyy-MM-dd').format(DateTime.parse(date));
        } else {
          date = DateFormat('yyyy-MM-dd').format(DateTime.now());
        }
      }

      Map<String, String> body = {
        if (params.limit != null) 'limit': '${params.limit}',
        if (params.page != null) 'page': '${params.page}',
        if (params.q != null) 'q': '${params.q}',
        if (params.sort != null) 'sort': '${params.sort}',
        if (params.district != null) 'district': '${params.district}',
        if (params.filter != null) 'filter': '${params.filter}',
        if (params.courier != null) 'courier': '${params.courier?.join(',')}',
        if (params.dateRit != null) 'date_rit': date ?? '',
      };

      String url = 'all';

      if (params.pastRit == true) {
        url = 'past';
      }

      String queryString = Uri(queryParameters: body).query;
      final response = await dioClient.get(
        '${ApiEndpoints.fetchTransactionAll(url)}?$queryString',
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
      throw ServerException(message: '$e');
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
      throw ServerException(message: '$e');
    }
  }

  @override
  Future<ResponseModelGetRit> getRit(ParamGetRIT params) async {
    try {
      String? date = DateFormat('yyyy-MM-dd').format(DateTime.now());

      if (params.isPastRit == true) {
        if (params.date != null) {
          date = DateFormat('yyyy-MM-dd').format(DateTime.parse(date));
        }
      }

      Map<String, String> body = {
        if (params.search != null) 'search': '${params.search}',
        if (params.isPastRit) 'date': date,
      };

      String url = 'getrit';

      String queryString = Uri(queryParameters: body).query;

      if (params.isPastRit) {
        url = 'pastrit';
      }

      final response = await dioClient.get(
        '${ApiEndpoints.getRit(url)}?$queryString',
      );

      // debugPrint('Data Get Rit Remote DataSource: ${response.data}');

      if (response.statusCode == 200 ||
          response.statusCode == 201 ||
          response.data != null) {
        return ResponseModelGetRit.fromMap(response.data);
      } else {
        throw ServerException(
          message: response.data['message'],
          statusCode: response.statusCode ?? 500,
        );
      }
    } on DioException catch (e) {
      throw HandleDioExceptions().handleDioError(e);
    } catch (e) {
      throw ServerException(message: '$e');
    }
  }

  @override
  Future<ResponseModelGetUser> getUsers() async {
    try {
      final response = await dioClient.get(ApiEndpoints.getUsers);

      // debugPrint('Data Get Users Remote DataSource: ${response.data}');

      if (response.statusCode == 200 ||
          response.statusCode == 201 ||
          response.data != null) {
        return ResponseModelGetUser.fromMap(response.data);
      } else {
        throw ServerException(
          message: response.data['message'],
          statusCode: response.statusCode ?? 500,
        );
      }
    } on DioException catch (e) {
      throw HandleDioExceptions().handleDioError(e);
    } catch (e) {
      throw ServerException(message: '$e');
    }
  }

  @override
  Future<ResponseModelGetTransportation> getTransportations() async {
    try {
      String apiEndpoint = ApiEndpoints.getTransportations('');

      if (AppRole.isChecker2) {
        apiEndpoint = ApiEndpoints.getLoaderTransportations('');
      }

      final response = await dioClient.get(apiEndpoint);

      // debugPrint('Data Get Users Remote DataSource: ${response.data}');

      if (response.statusCode == 200 ||
          response.statusCode == 201 ||
          response.data != null) {
        return ResponseModelGetTransportation.fromMap(response.data);
      } else {
        throw ServerException(
          message: response.data['message'],
          statusCode: response.statusCode ?? 500,
        );
      }
    } on DioException catch (e) {
      throw HandleDioExceptions().handleDioError(e);
    } catch (e) {
      throw ServerException(message: '$e');
    }
  }

  @override
  Future<ResponseModelGetTransportation> getLoaderTransportations() async {
    try {
      final response = await dioClient.get(
        ApiEndpoints.getLoaderTransportations(''),
      );

      // debugPrint('Data Get Loader Remote DataSource: ${response.data}');

      if (response.statusCode == 200 ||
          response.statusCode == 201 ||
          response.data != null) {
        return ResponseModelGetTransportation.fromMap(response.data);
      } else {
        throw ServerException(
          message: response.data['message'],
          statusCode: response.statusCode ?? 500,
        );
      }
    } on DioException catch (e) {
      throw HandleDioExceptions().handleDioError(e);
    } catch (e) {
      throw ServerException(message: '$e');
    }
  }

  @override
  Future<ResponseModelBasic> addAssistant(ParamsAddAssistant params) async {
    try {
      final response = await dioClient.put(
        ApiEndpoints.addAssistantRIT(
          AppRole.current?.name.toLowerCase() ?? 'picking',
        ),
        data: {
          "district": params.district,
          "id_driver": params.idDriver,
          "id_kenek": params.idKenek,
          "date_rit": params.dateRIT,
          if (!AppRole.isChecker2) "id_loader": params.idKendaraan,
          if (AppRole.isChecker2) "id_mobil": params.idKendaraan,
        },
      );

      // debugPrint('Data Add Assistant Remote DataSource: ${response.data}');

      if (response.statusCode == 200 ||
          response.statusCode == 201 ||
          response.data != null) {
        return ResponseModelBasic.fromMap(response.data);
      } else {
        throw ServerException(
          message: response.data['message'],
          statusCode: response.statusCode ?? 500,
        );
      }
    } on DioException catch (e) {
      throw HandleDioExceptions().handleDioError(e);
    } catch (e) {
      throw ServerException(message: '$e');
    }
  }
}
