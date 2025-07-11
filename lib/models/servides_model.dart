class ServiceModel {
  final String id;
  final String title;
  final String imageUrl;
  final DateTime createdAt;
  final int vendorCount;

  ServiceModel({
    required this.id,
    required this.title,
    required this.imageUrl,
    required this.createdAt,
    required this.vendorCount,
  });

  factory ServiceModel.fromJson(Map<String, dynamic> json) {
    return ServiceModel(
      id: json['_id'] ?? '',
      title: json['title'] ?? '',
      imageUrl: json['imageUrl'] ?? '',
      createdAt: DateTime.tryParse(json['createdAt'] ?? '') ?? DateTime.now(),
      vendorCount: json['vendorCount'] ?? 0,
    );
  }
}
