class UserModel {
  final int id;
  final String name;
  final String email;
  final String phoneNumber;
  // final String organization;
  // final int userType;
  // final String emailVerifiedAt;
  // final String createdAt;
  // final String updatedAt;

  UserModel({
    required this.id,
    required this.name,
    required this.email,
    required this.phoneNumber,
    // required this.organization,
    // required this.userType,
    // required this.emailVerifiedAt,
    // required this.createdAt,
    // required this.updatedAt,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      phoneNumber: json['phone'] ?? '',
      // organization: json['organization'] ?? [],
      // userType: json['user_type_id'] ?? 0,
      // emailVerifiedAt: json['email_verified_at'] ?? '',
      // createdAt: json['created_at'] ?? '',
      // updatedAt: json['updated_at'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'phone_number': phoneNumber,
      // 'organization': organization,
      // 'user_type_id': userType,
      // 'email_verified_at': emailVerifiedAt,
      // 'created_at': createdAt,
      // 'updated_at': updatedAt,
    };
  }
}
