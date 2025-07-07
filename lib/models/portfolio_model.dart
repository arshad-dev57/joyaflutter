class PortfolioModel {
  String id;
  String title;
  String description;
  List<String> images;
  List<String> services;
  String createdBy;
  DateTime createdAt;
  String? location;
  String? duration;
  String? priceRange;
  List<String>? tags;
  String? clientType;
  double? ratings;
  List<String>? testimonials;

  PortfolioModel({
    required this.id,
    required this.title,
    required this.description,
    required this.images,
    required this.services,
    required this.createdBy,
    required this.createdAt,
    this.location,
    this.duration,
    this.priceRange,
    this.tags,
    this.clientType,
    this.ratings,
    this.testimonials,
  });

  factory PortfolioModel.fromJson(Map<String, dynamic> json) {
    return PortfolioModel(
      id: json['_id'],
      title: json['title'],
      description: json['description'] ?? '',
      images: List<String>.from(json['images'] ?? []),
      services: List<String>.from(json['services'] ?? []),
      createdBy: json['createdBy'] ?? '',
      createdAt: DateTime.parse(json['createdAt']),
      location: json['location'],
      duration: json['duration'],
      priceRange: json['priceRange'],
      tags: (json['tags'] as List?)?.map((e) => e.toString()).toList(),
      clientType: json['clientType'],
      ratings: (json['ratings'] is int)
          ? (json['ratings'] as int).toDouble()
          : (json['ratings'] as double?),
      testimonials: (json['testimonials'] as List?)?.map((e) => e.toString()).toList(),
    );
  }
}
