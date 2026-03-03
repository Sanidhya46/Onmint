class AppConstants {
  // App Info
  static const String appName = 'ONMINT';
  static const String appTagline = 'Your Complete Healthcare Partner';
  
  // Service Types
  static const String serviceMedicine = 'pharmacy';
  static const String serviceDoctor = 'doctor';
  static const String serviceNurse = 'nurse';
  static const String serviceLab = 'pathology';
  static const String serviceAmbulance = 'ambulance';
  
  // Booking Status
  static const String statusPending = 'pending';
  static const String statusAccepted = 'accepted';
  static const String statusRejected = 'rejected';
  static const String statusInProgress = 'in_progress';
  static const String statusCompleted = 'completed';
  static const String statusCancelled = 'cancelled';
  
  // Payment Status
  static const String paymentPending = 'pending';
  static const String paymentPaid = 'paid';
  static const String paymentRefunded = 'refunded';
  
  // User Roles
  static const String rolePatient = 'patient';
  static const String roleDoctor = 'doctor';
  static const String roleNurse = 'nurse';
  static const String roleAmbulance = 'ambulance';
  static const String rolePharmacist = 'pharmacist';
  static const String rolePathology = 'pathology';
  static const String roleAdmin = 'admin';
  
  // API Timeouts
  static const Duration apiTimeout = Duration(seconds: 30);
  static const Duration socketTimeout = Duration(seconds: 10);
  
  // Pagination
  static const int defaultPageSize = 20;
  static const int maxPageSize = 100;
  
  // Map Settings
  static const double defaultZoom = 14.0;
  static const double defaultRadius = 10.0; // km
}
