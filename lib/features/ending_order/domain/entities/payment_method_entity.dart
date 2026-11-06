class PaymentMethodEntity {
  final String? bankName;
  final String? atasNama;
  final String? noRekening;
  final String? alamat;
  final String? idCompany;

  const PaymentMethodEntity({
    this.atasNama = '-',
    this.alamat = '-',
    this.bankName = '-',
    this.noRekening = '-',
    this.idCompany = '-',
  });

  factory PaymentMethodEntity.fromJson(Map<String, dynamic> json) {
    return PaymentMethodEntity(
      bankName: json['idcompany_bank'] ?? '-',
      atasNama: json['atas_nama'] ?? '-',
      noRekening: json['nomer_rekening'] ?? '-',
      alamat: json['alamat'] ?? '-',
      idCompany: json['idcompany'] ?? '-',
    );
  }
}
