class PortfolioModel {
  String id;
  String title;
  String description;
  List<String> images;
  String createdBy;
  DateTime createdAt;

  PortfolioModel({
    required this.id,
    required this.title,
    required this.description,
    required this.images,
    required this.createdBy,
    required this.createdAt,
  });

  factory PortfolioModel.fromJson(Map<String, dynamic> json) {
    return PortfolioModel(
      id: json['_id'],
      title: json['title'],
      description: json['description'] ?? '',
      images: List<String>.from(json['images'] ?? []),
      createdBy: json['createdBy'] ?? '',
      createdAt: DateTime.parse(json['createdAt']),
    );
  }
}
