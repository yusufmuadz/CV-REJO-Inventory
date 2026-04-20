import '../../domain/entities/user_entity.dart';

class UserModel extends UserEntity {
  const UserModel({
    required super.userId,
    required super.nama,
    required super.username,
    required super.jabatan,
    required super.notelp,
    required super.alamat,
    super.token,
  });
  
  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
    userId: json['user_id'] ?? json['iduser'] ?? '-',
    nama: json['name'] ?? json['nama'] ?? '-',
    username: json['username'] ?? '-',
    jabatan: json['access'] ?? '-',  // Jangan lupa nanti diganti ke access
    notelp: json['notelp'] ?? '-',
    alamat: json['alamat'] ?? '-',
    token: json['token'],
  );

  @override
  String toString() {
    return 'UserModel(userId: $userId, username: $username, jabatan: $jabatan, token: $token)';
  }
}
