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
  });

  /// fromJson
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
