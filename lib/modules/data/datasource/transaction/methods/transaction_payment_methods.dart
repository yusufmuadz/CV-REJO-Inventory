part of '../transaction_datasource_impl.dart';

extension TransactionPaymentMethods on TransactionRemoteDataSourceImpl {
  Future<ResponseModelBasic> _postPaymentCollector(
    ParamsEndingOrder params,
  ) async {
    final paymentStatus = params.paymentStatus ?? false;
    final imagesPayment = params.imagesPayment ?? [];

    final formData = FormData.fromMap({
      'status_pembayaran': paymentStatus,
      'no_rute': params.noRoute,
      'nota_rute': params.notaRoute,
      'pdrp_id': params.idDetail,
      'id_transaksi': params.invoice,
      'id_piutang': params.idPiutang,
      'lat': params.lat,
      'long': params.long,

      if (paymentStatus) ...{
        'jenis_pembayaran': params.paymentMethod ?? '',
        'nominal': params.paymentNominal ?? '',
        ...await _buildMultipartImageFields(
          imagesPayment,
          prefix: 'file_bukti',
          maxImages: 1,
        ),
      } else ...{
        'catatan_khusus': params.desc ?? '',
        'catatan_kustomer': params.paymentNoteCustomer ?? '',
      },
    });

    return _executeEndingRequest(ApiEndpoints.paymentCollector, formData);
  }

  Future<ResponseModelBasic> _postImageAllItem(ParamsEndingOrder params) {
    return _submitCustomerArrival(
      params: params,
      endpoint: ApiEndpoints.arriveItemCustomer,
      images: params.imagesDriver?.imagesAllItem ?? [],
    );
  }

  Future<ResponseModelBasic> _postImageConfirmAllItem(
    ParamsEndingOrder params,
  ) {
    return _submitCustomerArrival(
      params: params,
      endpoint: ApiEndpoints.arriveHandoverCustomer,
      images: params.imagesDriver?.imagesHandover ?? [],
    );
  }

  Future<ResponseModelBasic> _postPaymentCustomerDriver(
    ParamsEndingOrder params,
  ) {
    return _submitCustomerArrival(
      params: params,
      endpoint: ApiEndpoints.arrivePaymentCustomer,
      images: params.imagesDriver?.imagesPayment ?? [],
      additionalFields: {
        'payment_type': params.paymentMethod,
        'payment_nominal': params.paymentNominal,
      },
    );
  }

  // Shared Customer Arrival
  Future<ResponseModelBasic> _submitCustomerArrival({
    required ParamsEndingOrder params,
    required String endpoint,
    required List<XFile> images,
    Map<String, dynamic> additionalFields = const {},
  }) async {
    final formData = FormData.fromMap({
      'invoice': params.invoice,
      'desc': params.desc,
      'lat': params.lat,
      'long': params.long,
      ...additionalFields,
      ...await _buildMultipartImageFields(images),
    });

    return _executeEndingRequest(endpoint, formData);
  }

  // Build Multipart Images
  Future<Map<String, MultipartFile>> _buildMultipartImageFields(
    List<XFile> images, {
    String prefix = 'file',
    int maxImages = 2,
  }) async {
    final files = <String, MultipartFile>{};

    final imageCount = images.length < maxImages ? images.length : maxImages;

    for (var i = 0; i < imageCount; i++) {
      final fieldName = '$prefix${i + 1}';

      files[fieldName] = await MultipartFile.fromFile(
        images[i].path,
        filename: '$fieldName.jpg',
      );
    }

    return files;
  }

  // Execute Ending Request
  Future<ResponseModelBasic> _executeEndingRequest(
    String endpoint,
    FormData formData,
  ) {
    return apiRequest.execute<ResponseModelBasic>(
      request: () {
        // debugPrint('========== POST ENDING REQUEST ==========');
        // debugPrint('URL: $endpoint');
        // debugPrint('FIELDS: ${formData.fields}');
        // debugPrint('FILES: ${formData.files.map((e) => e.key).toList()}');

        return dioClient.post(endpoint, data: formData);
      },
      parser: (data) => ResponseModelBasic.fromMap(data),
    );
  }
}
