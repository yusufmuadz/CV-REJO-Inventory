import 'package:camera/camera.dart';
import 'package:dio/dio.dart';

import '../../../../core/middlewares/app_role.dart';
import '../../../../core/network/api_endpoints.dart';
import '../../../../core/network/dio_client.dart';
import '../../../../features/scan_product/data/models/response_model_post_item_product.dart';
import '../../../../features/scan_product/data/models/response_model_scan_product.dart';
import '../../../../features/scan_product/domain/params/post_product_param.dart';
import '../../../../features/scan_product/domain/params/scan_product_param.dart';
import '../../../helpers/api_request_handler.dart';

// ======== INDUK DATASOURCE ========
abstract class ScanRemoteDataSource {
  Future<ResponseModelScanProduct> getProduct(ParamsGetProduct param);
  Future<ResponseModelPostItemProduct> simpanProduct(ParamsPostProduct param);
}

// ======== CHILD DATASOURCE ========
class ScanRemoteDataSourceImpl implements ScanRemoteDataSource {
  final DioClient dioClient;
  final ApiRequestHandler apiRequest;

  ScanRemoteDataSourceImpl(this.dioClient, this.apiRequest);

  // ============ GET PRODUCT BY INVOICE AND BARCODE  ============
  // ====================== CHECK PRODUCT   ======================
  @override
  Future<ResponseModelScanProduct> getProduct(ParamsGetProduct param) {
    return apiRequest.execute<ResponseModelScanProduct>(
      request: () {
        return dioClient.put(
          ApiEndpoints.getScanProduct(param.role?.toLowerCase() ?? 'picking'),
          data: {'barcode': param.barcode, 'invoice': param.invoice},
        );
      },
      parser: (data) => ResponseModelScanProduct.fromMap(data),
    );
  }

  // ============ POST SIMPAN IMAGE AND QTY PRODUCT  ============
  @override
  Future<ResponseModelPostItemProduct> simpanProduct(
    ParamsPostProduct param,
  ) async {
    final images = param.images ?? [];

    final formData = FormData.fromMap({
      'barcode': param.barcode,
      'invoice': param.invoice,
      'qty': param.qty,
      ...await _buildPhotoFields(images, maxImages: AppRole.isDriver ? 5 : 2),
    });

    final role = _getSaveQtyRole(param);

    return apiRequest.execute<ResponseModelPostItemProduct>(
      request: () {
        return dioClient.post(ApiEndpoints.saveQty(role), data: formData);
      },
      parser: (data) => ResponseModelPostItemProduct.fromMap(data),
    );
  }

  // ============ PARAM ROLE SAVE QTY  ============
  String _getSaveQtyRole(ParamsPostProduct params) {
    if (params.role == 'loader' && params.statusChecker2 != 'completed') {
      return 'check2';
    }

    if (params.role == 'deliver') {
      return 'deliverynew';
    }

    return params.role!;
  }

  // ============ BUILD PHOTO FIELDS  ============
  Future<Map<String, MultipartFile>> _buildPhotoFields(
    List<XFile> images, {
    int maxImages = 2,
  }) async {
    final photoFields = <String, MultipartFile>{};
    final count = images.length < maxImages ? images.length : maxImages;

    for (var i = 0; i < count; i++) {
      final fieldName = 'foto${i + 1}';

      photoFields[fieldName] = await MultipartFile.fromFile(
        images[i].path,
        filename: '$fieldName.jpg',
      );
    }

    return photoFields;
  }
}
