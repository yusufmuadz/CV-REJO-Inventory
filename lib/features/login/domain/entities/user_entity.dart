class UserEntity {
  final String userId;
  final String nama;
  final String username;
  final String jabatan;
  final String notelp;
  final String alamat;
  final String? token;

  const UserEntity({
    required this.userId,
    required this.nama,
    required this.username,
    required this.jabatan,
    required this.notelp,
    required this.alamat,
    this.token,
  });

  @override
  String toString() {
    return 'UserEntity(userId: $userId, username: $username, jabatan: $jabatan)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is UserEntity &&
        other.userId == userId &&
        other.username == username &&
        other.jabatan == jabatan;
  }

  @override
  int get hashCode => userId.hashCode ^ username.hashCode ^ jabatan.hashCode;

  Map<String, dynamic> toJson() => {
    'name': nama,
    'username': username,
    'access': jabatan,
    'notelp': notelp,
    'alamat': alamat,
  };

  factory UserEntity.fromJson(Map<String, dynamic> json) => UserEntity(
    userId: json['user_id'] ?? json['iduser'] ?? '-',
    nama: json['name'] ?? json['nama'] ?? '-',
    username: json['username'] ?? '-',
    jabatan: json['access'] ?? '-', // Jangan lupa nanti diganti ke access
    notelp: json['notelp'] ?? '-',
    alamat: json['alamat'] ?? '-',
    token: json['token'],
  );
}
