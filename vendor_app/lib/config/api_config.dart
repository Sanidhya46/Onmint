class ApiConfig {
  static const String baseUrl = 'http://localhost:5000/api/v1';
  static const String socketUrl = 'http://localhost:5000';
  static const int appPort = 8081;
  
  // API Endpoints
  static const String login = '$baseUrl/auth/login';
  static const String register = '$baseUrl/auth/register';
  static const String me = '$baseUrl/auth/me';
  
  // Doctor endpoints
  static const String appointments = '$baseUrl/doctor/appointments';
  static const String dashboard = '$baseUrl/doctor/dashboard';
  
  // Nurse endpoints
  static const String nurseRequests = '$baseUrl/nurse/requests';
  
  // Ambulance endpoints
  static const String ambulanceRequests = '$baseUrl/ambulance/requests';
  static const String updateLocation = '$baseUrl/ambulance/location';
  
  // Pharmacist endpoints
  static const String medicines = '$baseUrl/pharmacist/medicines';
  static const String orders = '$baseUrl/pharmacist/orders';
  
  // Pathology endpoints
  static const String labBookings = '$baseUrl/pathology/bookings';
}
