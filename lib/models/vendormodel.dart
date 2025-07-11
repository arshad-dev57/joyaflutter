import 'package:joya_app/models/portfolio_model.dart';

class VendorModel {
  final String id;
  final String firstname;
  final String lastname;
  final String username;
  final String email;
  final String phoneNumber;
  final String code;
  final String country;
  final String? description;
  final String? image;
  final List<String> services;
  final List<SocialLink> urls;
  final String createdBy;
  final List<String> portfolios; // only IDs (optional)
  final List<PortfolioModel> linkedPortfolios; // embedded portfolios

  VendorModel({
    required this.id,
    required this.firstname,
    required this.lastname,
    required this.username,
    required this.email,
    required this.phoneNumber,
    required this.code,
    required this.country,
    required this.description,
    required this.image,
    required this.services,
    required this.urls,
    required this.createdBy,
    required this.portfolios,
    required this.linkedPortfolios,
  });

  factory VendorModel.fromJson(Map<String, dynamic> json) {
    return VendorModel(
      id: json["_id"] ?? "",
      firstname: json["firstname"] ?? "",
      lastname: json["lastname"] ?? "",
      username: json["username"] ?? "",
      email: json["email"] ?? "",
      phoneNumber: json["phone_number"] ?? "",
      code: json["code"] ?? "",
      country: json["country"] ?? "",
      description: json["description"],
      image: json["image"],
      services: List<String>.from(json["services"] ?? []),
      urls: (json["url"] as List<dynamic>?)
              ?.map((e) => SocialLink.fromJson(e))
              .toList() ??
          [],
      createdBy: json["createdBy"] ?? "",
      portfolios: List<String>.from(json["portfolios"] ?? []),
      linkedPortfolios: (json["linkedPortfolios"] as List<dynamic>?)
              ?.map((e) => PortfolioModel.fromJson(e))
              .toList() ??
          [],
    );
  }

  // ✅ NEW: copyWith for updating specific fields
  VendorModel copyWith({
    String? id,
    String? firstname,
    String? lastname,
    String? username,
    String? email,
    String? phoneNumber,
    String? code,
    String? country,
    String? description,
    String? image,
    List<String>? services,
    List<SocialLink>? urls,
    String? createdBy,
    List<String>? portfolios,
    List<PortfolioModel>? linkedPortfolios,
  }) {
    return VendorModel(
      id: id ?? this.id,
      firstname: firstname ?? this.firstname,
      lastname: lastname ?? this.lastname,
      username: username ?? this.username,
      email: email ?? this.email,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      code: code ?? this.code,
      country: country ?? this.country,
      description: description ?? this.description,
      image: image ?? this.image,
      services: services ?? this.services,
      urls: urls ?? this.urls,
      createdBy: createdBy ?? this.createdBy,
      portfolios: portfolios ?? this.portfolios,
      linkedPortfolios: linkedPortfolios ?? this.linkedPortfolios,
    );
  }
}

class SocialLink {
  final String name;
  final String url;
  final String image;
  final String? id;

  SocialLink({
    required this.name,
    required this.url,
    required this.image,
    this.id,
  });

  factory SocialLink.fromJson(Map<String, dynamic> json) {
    return SocialLink(
      name: json["name"] ?? "",
      url: json["url"] ?? "",
      image: json["image"] ?? "",
      id: json["_id"],
    );
  }
}
