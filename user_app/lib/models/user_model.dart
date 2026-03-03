class UserModel {
  final String id;
  final String email;
  final String role;
  final String firstName;
  final String lastName;
  final String phone;
  final String? city;
  final String? state;
  final String? pincode;
  final Location? location;
  final String status;
  final bool isActive;
  final double? rating;
  final int? totalRatings;

  UserModel({
    required this.id,
    required this.email,
    required this.role,
    required this.firstName,
    required this.lastName,
    required this.phone,
    this.city,
    this.state,
    this.pincode,
    this.location,
    required this.status,
    required this.isActive,
    this.rating,
    this.totalRatings,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] ?? '',
      email: json['email'] ?? '',
      role: json['role'] ?? 'patient',
      firstName: json['firstName'] ?? '',
      lastName: json['lastName'] ?? '',
      phone: json['phone'] ?? '',
      city: json['city'],
      state: json['state'],
      pincode: json['pincode'],
      location: json['location'] != null 
          ? Location.fromJson(json['location']) 
          : null,
      status: json['status'] ?? 'approved',
      isActive: json['isActive'] ?? true,
      rating: json['rating']?.toDouble(),
      totalRatings: json['totalRatings'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'role': role,
      'firstName': firstName,
      'lastName': lastName,
      'phone': phone,
      'city': city,
      'state': state,
      'pincode': pincode,
      'location': location?.toJson(),
      'status': status,
      'isActive': isActive,
      'rating': rating,
      'totalRatings': totalRatings,
    };
  }

  String get fullName => '$firstName $lastName';
}

class Location {
  final double latitude;
  final double longitude;

  Location({required this.latitude, required this.longitude});

  factory Location.fromJson(Map<String, dynamic> json) {
    final coordinates = json['coordinates'] as List;
    return Location(
      longitude: coordinates[0].toDouble(),
      latitude: coordinates[1].toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'type': 'Point',
      'coordinates': [longitude, latitude],
    };
  }
}
