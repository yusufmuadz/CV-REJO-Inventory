import '../middlewares/app_role.dart';

class MockupLogin {
  void mockLoginAsPIC() {
    AppRole.loginFromApi(
      role: 'picking',
      name: 'PIC Test',
      email: 'picking@test.com',
      token: 'mock_token_123',
    );
  }

  void mockLoginAsChecker1() {
    AppRole.loginFromApi(
      role: 'packing',
      name: 'Checker1 Test',
      email: 'checker1@test.com',
      token: 'mock_token_123',
    );
  }

  void mockLoginAsChecker2() {
    AppRole.loginFromApi(
      role: 'sealing',
      name: 'Checker2 Test',
      email: 'checker2@test.com',
      token: 'mock_token_123',
    );
  }

  void mockLoginAsDriver() {
    AppRole.loginFromApi(
      role: 'deliver',
      name: 'Driver Test',
      email: 'driver@test.com',
      token: 'mock_token_123',
    );
  }
}
