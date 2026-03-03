class ApiConfig {
  static const String baseUrl = 'http://localhost:5000/api/v1';
  static const String socketUrl = 'http://localhost:5000';
  static const int appPort = 8080;
  
  // API Endpoints
  static const String login = '$baseUrl/auth/login';
  static const String register = '$baseUrl/auth/register';
  static const String me = '$baseUrl/auth/me';
  static const String nearbyServices = '$baseUrl/patient/services/nearby';
  static const String bookings = '$baseUrl/patient/bookings';
  static const String notifications = '$baseUrl/patient/notifications';
}
