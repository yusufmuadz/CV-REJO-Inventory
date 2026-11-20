part of '../rit_datasource_impl.dart';

extension RitAmbilMethods on RitNewRemoteDataSourceImpl {
  // PUT: Take RIT
  Future<ResponseModelBasic> _takeItRIT(
    String urlRole,
    Map<String, dynamic> data,
  ) {
    return apiRequest.execute<ResponseModelBasic>(
      request: () => dioClient.put(ApiEndpoints.takeItRIT(urlRole), data: data),
      parser: (data) => ResponseModelBasic.fromMap(data),
    );
  }

  // POST: Add Assistant / Transportation
  Future<ResponseModelBasic> _submitAssistant(
    String endpoint,
    Map<String, dynamic> data,
  ) {
    return apiRequest.execute<ResponseModelBasic>(
      request: () => dioClient.post(
        endpoint,
        data: data,
        contentType: Headers.formUrlEncodedContentType,
      ),
      parser: (data) => ResponseModelBasic.fromMap(data),
    );
  }

  // Build request data
  Map<String, dynamic> _buildAssistantData(
    ParamsAddAssistant params, {
    required bool isChecker2,
    required bool isDetail,
  }) {
    return {
      'id_driver': params.idDriver,
      'id_kenek': params.idKenek,
      if (!isDetail) ...{
        'district': params.district,
        'date_rit': params.dateRIT,
      },
      if (!isChecker2)
        'id_loader': params.idKendaraan
      else
        'id_mobil': params.idKendaraan,
      if (isChecker2 && !isDetail) 'status_armada': params.statusTransportation,
      if (isChecker2 && isDetail) 'invoice': params.invoice,
      if (params.extNopol != null) 'driver_license': params.extNopol,
      if (params.extDriverName != null) 'driver_name': params.extDriverName,
    };
  }
}
