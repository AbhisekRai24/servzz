class ApiEndpoints {
  ApiEndpoints._();

  // Timeouts
  static const connectionTimeout = Duration(seconds: 1000);
  static const receiveTimeout = Duration(seconds: 1000);

  // static const String serverAddress = "http://10.0.2.2:5050";
  static const String serverAddress = "http://192.168.1.108:5050";

  // For iPhone (uncomment if needed)
  static const String baseUrl = "$serverAddress/api/";
  static const String baseImgUrl = serverAddress;
  static const String imageUrl = "$baseImgUrl/uploads/";

  static const String login = "auth/login";
  static const String register = "auth/register";
  static const String getCurrentUser = "auth/register";

  static const String product = "admin/product";

  static const String createOrder = "orders";
  static const String getUserOrders = "orders";
  // static const String createOrder = "${baseUrl}orders";
}
