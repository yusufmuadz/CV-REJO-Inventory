class GetUserEntity {
  final String iduser;
  final String nama;
  final String username;
  final String jabatan;

  const GetUserEntity({
    required this.iduser,
    required this.nama,
    required this.username,
    required this.jabatan,
  });

  factory GetUserEntity.fromJson(Map<String, dynamic> json) {
    return GetUserEntity(
      iduser: json['iduser'] ?? '-',
      nama: json['nama'] ?? '-',
      username: json['username'] ?? '-',
      jabatan: json['jabatan'] ?? '-',
    );
  }
}