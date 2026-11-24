part of '../transaction_datasource_impl.dart';

extension TransactionArmadaMethods on TransactionRemoteDataSourceImpl {
  // ============ POST FIRST ARRIVE ARMADA DRIVER IN CUSTOMER ============
  Future<ResponseModelBasic> _postFirstArriveDriver(
    ParamsEndingOrder params,
  ) async {
    final imagesTransportation =
        params.imagesDriver?.imagesTransportation ?? [];
    final imagesMerchant = params.imagesDriver?.imagesMerchant ?? [];

    final formData = FormData.fromMap({
      'invoice': params.invoice,
      'desc': params.desc,
      'lat': params.lat,
      'long': params.long,
      ...await _buildArrivalImageFields(
        images: [
          if (imagesTransportation.isNotEmpty)
            (imagesTransportation[0], 'file1'),
          if (imagesMerchant.isNotEmpty) (imagesMerchant[0], 'file2'),
        ],
      ),
    });

    return _executeArrival(ApiEndpoints.arriveFirstCustomer, formData);
  }

  // ============ POST FIRST ARRIVE ARMADA COLLECTOR IN CUSTOMER ============
  Future<ResponseModelBasic> _postFirstArriveCollector(
    ParamsEndingOrder params,
  ) async {
    final imagesTransportation = params.images ?? [];
    final imagesMerchant = params.imagesDriver?.imagesMerchant ?? [];

    final formData = FormData.fromMap({
      'no_rute': params.noRoute,
      'nota_rute': params.notaRoute,
      'pdrp_id': params.idDetail,
      'id_transaksi': params.invoice,
      'id_piutang': params.idPiutang,
      'lat': params.lat,
      'long': params.long,
      ...await _buildArrivalImageFields(
        images: [
          if (imagesTransportation.isNotEmpty)
            (imagesTransportation[0], 'file_toko'),
          if (imagesMerchant.isNotEmpty) (imagesMerchant[0], 'file_tagihan'),
        ],
      ),
    });

    return _executeArrival(ApiEndpoints.arriveCollector, formData);
  }

  // ============ BUILD ARRIVAL IMAGE FIELDS ============
  Future<Map<String, MultipartFile>> _buildArrivalImageFields({
    required List<(XFile, String)> images,
  }) async {
    final files = <String, MultipartFile>{};

    for (final (image, fieldName) in images) {
      files[fieldName] = await MultipartFile.fromFile(
        image.path,
        filename: '$fieldName.jpg',
      );
    }

    return files;
  }

  // ============ EXECUTE ARRIVAL REQUEST ============
  Future<ResponseModelBasic> _executeArrival(
    String endpoint,
    FormData formData,
  ) {
    return apiRequest.execute<ResponseModelBasic>(
      request: () {
        // debugPrint('========== POST FIRST ARRIVAL ==========');
        // debugPrint('URL: $endpoint');
        // debugPrint('FIELDS: ${formData.fields}');
        // debugPrint('FILES: ${formData.files.map((e) => e.key).toList()}');

        return dioClient.post(endpoint, data: formData);
      },
      parser: (data) => ResponseModelBasic.fromMap(data),
    );
  }
}
