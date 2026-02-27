class UserModel {
  final String id;
  final String email;
  final String role;
  final String firstName;
  final String lastName;
  final String phone;
  final String? profilePicture;
  final LocationModel location;
  final String city;
  final String state;
  final String pincode;
  final String status;
  final RatingModel? rating;

  UserModel({
    required this.id,
    required this.email,
    required this.role,
    required this.firstName,
    required this.lastName,
    required this.phone,
    this.profilePicture,
    required this.location,
    required this.city,
    required this.state,
    required this.pincode,
    required this.status,
    this.rating,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['_id'] ?? '',
      email: json['email'] ?? '',
      role: json['role'] ?? '',
      firstName: json['firstName'] ?? '',
      lastName: json['lastName'] ?? '',
      phone: json['phone'] ?? '',
      profilePicture: json['profilePicture'],
      location: LocationModel.fromJson(json['location'] ?? {}),
      city: json['city'] ?? '',
      state: json['state'] ?? '',
      pincode: json['pincode'] ?? '',
      status: json['status'] ?? 'pending',
      rating: json['rating'] != null ? RatingModel.fromJson(json['rating']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'email': email,
      'role': role,
      'firstName': firstName,
      'lastName': lastName,
      'phone': phone,
      'profilePicture': profilePicture,
      'location': location.toJson(),
      'city': city,
      'state': state,
      'pincode': pincode,
      'status': status,
      'rating': rating?.toJson(),
    };
  }

  String get fullName => '$firstName $lastName';
}

class LocationModel {
  final String type;
  final List<double> coordinates;

  LocationModel({
    this.type = 'Point',
    required this.coordinates,
  });

  factory LocationModel.fromJson(Map<String, dynamic> json) {
    return LocationModel(
      type: json['type'] ?? 'Point',
      coordinates: json['coordinates'] != null
          ? List<double>.from(json['coordinates'].map((x) => x.toDouble()))
          : [0.0, 0.0],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'type': type,
      'coordinates': coordinates,
    };
  }

  double get longitude => coordinates.isNotEmpty ? coordinates[0] : 0.0;
  double get latitude => coordinates.length > 1 ? coordinates[1] : 0.0;
}

class RatingModel {
  final double average;
  final int count;

  RatingModel({
    required this.average,
    required this.count,
  });

  factory RatingModel.fromJson(Map<String, dynamic> json) {
    return RatingModel(
      average: (json['average'] ?? 0).toDouble(),
      count: json['count'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'average': average,
      'count': count,
    };
  }
}
