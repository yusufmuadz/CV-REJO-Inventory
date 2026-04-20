class ProfileEntity {
  final String token;
  final String refreshToken;
  final String email;

  const ProfileEntity({
    required this.token,
    required this.refreshToken,
    required this.email,
  });
}
