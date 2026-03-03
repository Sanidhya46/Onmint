class ApiConfig {
  static const String baseUrl = 'http://localhost:5000/api/v1';
  static const String socketUrl = 'http://localhost:5000';
  static const int appPort = 8082;
  
  // API Endpoints
  static const String login = '$baseUrl/auth/login';
  static const String me = '$baseUrl/auth/me';
  static const String dashboard = '$baseUrl/admin/dashboard';
  static const String users = '$baseUrl/admin/users';
  static const String pendingApprovals = '$baseUrl/admin/approvals/pending';
  static const String bookings = '$baseUrl/admin/bookings';
}
