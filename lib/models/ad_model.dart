class AdModel {
  final String id;
  final String imageUrl;
  final String uploadedByUsername;
  final String uploadedByEmail;
  final DateTime createdAt;

  AdModel({
    required this.id,
    required this.imageUrl,
    required this.uploadedByUsername,
    required this.uploadedByEmail,
    required this.createdAt,
  });

  factory AdModel.fromJson(Map<String, dynamic> json) {
    return AdModel(
      id: json['_id'] ?? '',
      imageUrl: json['imageUrl'] ?? '',
      uploadedByUsername: json['uploadedBy']?['username'] ?? '',
      uploadedByEmail: json['uploadedBy']?['email'] ?? '',
      createdAt: DateTime.tryParse(json['createdAt'] ?? '') ?? DateTime.now(),
    );
  }
}
