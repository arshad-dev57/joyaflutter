class UserProfileModel {
  final String name;
  final String email;
  final String role;
  final String? phone;
  final String? image;
  final String paymentstatus;

  UserProfileModel({
    required this.name,
    required this.paymentstatus,
    required this.email,
    required this.role,
    this.phone,
    this.image,
  });

  factory UserProfileModel.fromJson(Map<String, dynamic> json) {
    return UserProfileModel(
      paymentstatus: json['paymentStatus'] ?? '',
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      role: json['role'] ?? '',
      phone: json['phone'],
      image: json['image'],
    );
  }
}
