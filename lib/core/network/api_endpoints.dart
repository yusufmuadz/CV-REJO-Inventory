class ApiEndpoints {
  ApiEndpoints._();

  static const String baseUrl =
      "https://server3.andiglobalsoft.com/cvrejo/api/";

  // Auth
  static const String login = "auth/login";
  static const String refreshToken = "auth/refresh";

  // User
  static const String users = "users";
  static const String logout = "auth/logout";
  static const String getUsers = "user/getpicking";

  // Home
  static const String home = "main/getinfo";

  // Transaction
  static const String fetchTransactionAll = "transaction/all";
  static const String fetchHistoryTransaction = "transaction/history/get";
  static const String getItemProduct = "items/get";
  static const String getDistrict = "city/getcity";
  static String takeItTransaction(String role) => "$role/claim";
  static String saveQty(String role) => "$role/scan/multiple";
  static String completeOrder(String role) => "$role/complete";
  static String pendingOrder(String role) => "$role/cancel";
  static String addAssistant(String role) => "$role/claimcoba";
  static String getRit(String search) => "rit/getrit?search=$search";

  // PICKING TRANSACTION
  static const String pendingSO = "picking/cancel";
  
  static String getDetailTransaction(String invoice) => "transaction/get?invoice=$invoice";
  static String getScanProduct(String role) => "$role/scan";
  static String getTransportations(String search) => "vehicle/getloader?q=$search";
  static String getLoaderTransportations(String search) => "vehicle/gettruck?q=$search";

  static const String hubungiAdmin = "https://wa.me/628112936865";
  static const String privacyPolicy = "http://lite2.indopustakaplus.com/admin/privacy_policy.html";
  static const String termsAndCondition = "https://lite2.indopustakaplus.com/admin/terms_and_condition.html";

  static String maps(String latitude, String longitude) => "https://www.google.com/maps/search/?api=1&query=$latitude,$longitude";
}
