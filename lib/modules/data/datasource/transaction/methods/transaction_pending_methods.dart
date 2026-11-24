part of '../transaction_datasource_impl.dart';

extension TransactionPendingMethods on TransactionRemoteDataSourceImpl {
  // ============ POST PENDING PO/TRANSACTION DEFAULT ============
  @override
  Future<ResponseModelBasic> _postPendingTransaction(
    ParamsEndingOrder params,
  ) async {
    final isSatuan = params.jenisCancel == 'satuan';

    final date = !isSatuan && params.dateRit != null
        ? DateFormat('yyyy-MM-dd').format(DateTime.parse(params.dateRit!))
        : '';

    final role = _getPendingOrderRole(params.role!, params.statusChecker2);

    final formData = FormData.fromMap({
      'jenis_cancel': params.jenisCancel,
      if (isSatuan) 'invoice': params.invoice,
      if (!isSatuan) ...{'district': params.rit, 'date_rit': date},
      'desc': params.desc,
      ...await _buildImageFields(
        params.images ?? [],
        prefix: 'foto',
        required: true,
      ),
    });

    return _executePendingOrder(ApiEndpoints.pendingOrder(role), formData);
  }

  // ============ POST PENDING PO/TRANSACTION DRIVER ============
  @override
  Future<ResponseModelBasic> _postPendingTransactionDriver(
    ParamsTroubleRIT params,
  ) async {
    final jenisTrouble = params.troubleRIT == EnumTroubleRIT.tolak
        ? 'tolak'
        : 'satuan';

    final formData = FormData.fromMap({
      'no_rit': params.noRIT,
      'tanggal_rit': params.tanggalRIT,
      'invoice': params.invoicePO,
      'desc': params.desc,
      'jenis_trouble': jenisTrouble,
      'lat': params.lat,
      'long': params.long,
      ...await _buildImageFields(params.images, prefix: 'file'),
    });

    return _executePendingOrder(ApiEndpoints.trouble, formData);
  }

  // ============ DETERMINE ROLE ============
  String _getPendingOrderRole(String role, String? statusChecker2) {
    if (role == 'loader' && statusChecker2 != 'completed') {
      return 'check2';
    }

    if (role == 'deliver') {
      return 'delivery';
    }

    return role;
  }

  // ============ BUILD IMAGE FIELDS ============
  Future<Map<String, MultipartFile>> _buildImageFields(
    List<dynamic> images, {
    required String prefix,
    bool required = false,
  }) async {
    if (required && images.isEmpty) {
      throw ServerException(
        message: 'Minimal satu gambar harus dilampirkan',
        statusCode: 400,
      );
    }

    final files = <String, MultipartFile>{};

    for (var i = 0; i < images.length && i < 2; i++) {
      final index = i + 1;

      files['$prefix$index'] = await MultipartFile.fromFile(
        images[i].path,
        filename: '$prefix$index.jpg',
      );
    }

    return files;
  }

  // ============ EXECUTE REQUEST ============
  Future<ResponseModelBasic> _executePendingOrder(
    String endpoint,
    FormData formData,
  ) {
    return apiRequest.execute<ResponseModelBasic>(
      request: () {
        // debugPrint('========== POST PENDING ORDER ==========');
        // debugPrint('URL: $endpoint');
        // debugPrint('FIELDS: ${formData.fields}');
        // debugPrint('FILES: ${formData.files.map((e) => e.key).toList()}');

        return dioClient.post(endpoint, data: formData);
      },
      parser: (data) => ResponseModelBasic.fromMap(data),
    );
  }
}
