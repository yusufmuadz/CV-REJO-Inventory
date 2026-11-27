part of '../transaction_datasource_impl.dart';

extension TransactionSortingMethods on TransactionRemoteDataSourceImpl {
  // ============ POST URUTKAN PO/TRANSACTION ============
  Future<ResponseModelBasic> _postSimpanUrutanTransaction(
    ParamsPostSortingSisipan param,
  ) {
    final date = param.dateRit.isEmpty
        ? ''
        : DateFormat('yyyy-MM-dd').format(DateTime.parse(param.dateRit));

    final formattedArrayString =
        "[${param.noInvoices.map((e) => "'$e'").join(', ')}]";

    return apiRequest.execute<ResponseModelBasic>(
      request: () async {
        return dioClient.post(
          ApiEndpoints.saveSortingSisipan,
          contentType: Headers.formUrlEncodedContentType,
          data: {
            'district': param.noRit,
            'date_rit': date,
            'array_urutan': formattedArrayString,
          },
        );
      },
      parser: (data) => ResponseModelBasic.fromMap(data),
    );
  }
}
