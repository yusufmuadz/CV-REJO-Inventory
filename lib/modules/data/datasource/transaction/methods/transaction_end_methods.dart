part of '../transaction_datasource_impl.dart';

extension TransactionEndMethods on TransactionRemoteDataSourceImpl {
  // ============ POST ENDING PO/TRANSACTION ============
  Future<ResponseModelBasic> _postEndTransaction(ParamsEndingOrder param) {
    return apiRequest.execute<ResponseModelBasic>(
      request: () async {
        final endpoint = _getEndingOrderEndpoint(param);
        final formData = await _buildEndingOrderFormData(param);

        return dioClient.post(endpoint, data: formData);
      },
      parser: (data) => ResponseModelBasic.fromMap(data),
    );
  }

  // ============ DETERMINE ENDPOINT ============
  String _getEndingOrderEndpoint(ParamsEndingOrder params) {
    if (params.role == 'deliver') {
      return ApiEndpoints.finishScanOrder;
    }

    final role = params.role == 'loader' && params.statusChecker2 != 'completed'
        ? 'check2'
        : params.role!;

    return ApiEndpoints.completeOrder(role);
  }

  // ============ BUILD FORM DATA ============
  Future<FormData> _buildEndingOrderFormData(ParamsEndingOrder params) {
    if (AppRole.isCollector) {
      return _buildCollectorFormData(params);
    }

    return _buildDefaultFormData(params);
  }

  // ============ COLLECTOR FORM DATA ============
  Future<FormData> _buildCollectorFormData(ParamsEndingOrder params) async {
    return FormData.fromMap({
      'invoice': params.invoice,
      'desc': params.desc,
      'lat': params.lat,
      'long': params.long,
      'file_toko': await MultipartHelper.fromNullableXFile(
        params.imagesDriver?.imagesMerchant?.isNotEmpty == true
            ? params.imagesDriver!.imagesMerchant![0]
            : null,
      ),
      'file_tagihan': await MultipartHelper.fromNullableXFile(
        params.images?.isNotEmpty == true ? params.images![0] : null,
      ),
    });
  }

  // ============ DEFAULT FORM DATA (NON-COLLECTOR) ============
  Future<FormData> _buildDefaultFormData(ParamsEndingOrder params) async {
    final isChecker2 = AppRole.isChecker2;

    final isExternalCompleted =
        isChecker2 &&
        params.statusTransportation == 'EXTERNAL' &&
        params.statusChecker2 == 'completed';

    const nameFile = 'file';

    return FormData.fromMap({
      'invoice': params.invoice,
      'desc': params.desc,
      'status_armada': params.statusTransportation,
      'driver_external': params.driverExternal,
      'mobil_external': params.mobilExternal,
      'lat': params.lat,
      'long': params.long,

      if (params.role == 'deliver') 'gudang': 'BARANG JADI',

      '${nameFile}1': await MultipartHelper.fromNullableXFile(
        params.images?.isNotEmpty == true ? params.images![0] : null,
      ),

      if (params.images?.length case final length? when length > 1)
        '${nameFile}2': await MultipartHelper.fromNullableXFile(
          params.images![1],
        ),

      if (isExternalCompleted &&
          params.imagesTransportation?.isNotEmpty == true)
        '${nameFile}3': await MultipartHelper.fromNullableXFile(
          params.imagesTransportation![0],
        ),

      if (isExternalCompleted && params.imagesInvoice?.isNotEmpty == true)
        '${nameFile}4': await MultipartHelper.fromNullableXFile(
          params.imagesInvoice![0],
        ),
    });
  }
}
