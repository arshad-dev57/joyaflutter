
class UserProfileModel {
  final String name;
  final String email;
  final String role;
  final String? phone;

  UserProfileModel({
    required this.name,
    required this.email,
    required this.role,
    this.phone,
  });

  factory UserProfileModel.fromJson(Map<String, dynamic> json) {
    return UserProfileModel(
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      role: json['role'] ?? '',
      phone: json['phone'],
    );
  }
}
