class LoginEntity {
  final String id;
  final String refreshToken;
  final String email;

  const LoginEntity({
    required this.id,
    required this.refreshToken,
    required this.email,
  });
}
