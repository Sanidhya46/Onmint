class AppConstants {
  // API Configuration
  static const String baseUrl = 'http://localhost:5000/api/v1';
  
  // User Roles
  static const String rolePatient = 'patient';
  static const String roleDoctor = 'doctor';
  static const String roleNurse = 'nurse';
  static const String roleAmbulance = 'ambulance';
  static const String rolePharmacist = 'pharmacist';
  static const String rolePathology = 'pathology';
  static const String roleBloodbank = 'bloodbank';
  static const String roleAdmin = 'admin';
  
  // Service Types
  static const String serviceMedicine = 'medicine';
  static const String serviceDoctor = 'doctor';
  static const String serviceNurse = 'nurse';
  static const String serviceLabTest = 'pathology';
  static const String serviceAmbulance = 'ambulance';
  
  // Storage Keys
  static const String keyAccessToken = 'access_token';
  static const String keyRefreshToken = 'refresh_token';
  static const String keyUserData = 'user_data';
  static const String keyUserRole = 'user_role';
  
  // Validation
  static const int phoneLength = 10;
  static const int otpLength = 6;
  static const int passwordMinLength = 6;
}
