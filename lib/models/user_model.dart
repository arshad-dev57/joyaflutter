class UserModel {
  final String id;
  final String username;
  final String email;
  final List<String> country;
  final String language;
  final String role;
  final String firstname;
  final String lastname;
  final String phone;
  final String createdAt;

  UserModel({
    required this.id,
    required this.username,
    required this.email,
    required this.country,
    required this.language,
    required this.role,
    required this.firstname,
    required this.lastname,
    required this.phone,
    required this.createdAt,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
  return UserModel(
    id: json['_id'] ?? '',
    username: json['username'] ?? '',
    email: json['email'] ?? '',
    country: List<String>.from(json['country'] ?? []),
    language: json['language'] ?? '',
    role: json['role'] ?? '',
    firstname: json['firstname'] ?? '',
    lastname: json['lastname'] ?? '',
    phone: json['phone'] ?? '',
    createdAt: json['createdAt'] ?? '',
  );
}
}
