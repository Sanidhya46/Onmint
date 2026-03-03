import 'user_model.dart';

class BookingModel {
  final String id;
  final String patientId;
  final String providerId;
  final String serviceType;
  final String status;
  final DateTime? scheduledTime;
  final DateTime? completedTime;
  final String? symptoms;
  final String? notes;
  final double? amount;
  final String paymentStatus;
  final int? rating;
  final String? review;
  final bool isEmergency;
  final UserModel? provider;
  final DateTime createdAt;
  final DateTime updatedAt;

  BookingModel({
    required this.id,
    required this.patientId,
    required this.providerId,
    required this.serviceType,
    required this.status,
    this.scheduledTime,
    this.completedTime,
    this.symptoms,
    this.notes,
    this.amount,
    required this.paymentStatus,
    this.rating,
    this.review,
    required this.isEmergency,
    this.provider,
    required this.createdAt,
    required this.updatedAt,
  });

  factory BookingModel.fromJson(Map<String, dynamic> json) {
    return BookingModel(
      id: json['id'] ?? '',
      patientId: json['patientId'] ?? '',
      providerId: json['providerId'] ?? '',
      serviceType: json['serviceType'] ?? '',
      status: json['status'] ?? 'pending',
      scheduledTime: json['scheduledTime'] != null
          ? DateTime.parse(json['scheduledTime'])
          : null,
      completedTime: json['completedTime'] != null
          ? DateTime.parse(json['completedTime'])
          : null,
      symptoms: json['symptoms'],
      notes: json['notes'],
      amount: json['amount']?.toDouble(),
      paymentStatus: json['paymentStatus'] ?? 'pending',
      rating: json['rating'],
      review: json['review'],
      isEmergency: json['isEmergency'] ?? false,
      provider: json['provider'] != null
          ? UserModel.fromJson(json['provider'])
          : null,
      createdAt: DateTime.parse(json['createdAt'] ?? DateTime.now().toIso8601String()),
      updatedAt: DateTime.parse(json['updatedAt'] ?? DateTime.now().toIso8601String()),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'patientId': patientId,
      'providerId': providerId,
      'serviceType': serviceType,
      'status': status,
      'scheduledTime': scheduledTime?.toIso8601String(),
      'completedTime': completedTime?.toIso8601String(),
      'symptoms': symptoms,
      'notes': notes,
      'amount': amount,
      'paymentStatus': paymentStatus,
      'rating': rating,
      'review': review,
      'isEmergency': isEmergency,
    };
  }

  String get statusDisplay {
    switch (status) {
      case 'pending':
        return 'Pending Approval';
      case 'accepted':
        return 'Accepted';
      case 'rejected':
        return 'Rejected';
      case 'in_progress':
        return 'In Progress';
      case 'completed':
        return 'Completed';
      case 'cancelled':
        return 'Cancelled';
      default:
        return status;
    }
  }

  String get serviceTypeDisplay {
    switch (serviceType) {
      case 'doctor':
        return 'Doctor Consultation';
      case 'nurse':
        return 'Nurse Service';
      case 'ambulance':
        return 'Ambulance';
      case 'pharmacy':
        return 'Medicine Order';
      case 'pathology':
        return 'Lab Test';
      default:
        return serviceType;
    }
  }
}
