class ReviewModel {
  final String id;
  final String vendorId;
  final User user;
  final String comment;
  final int rating;
  final DateTime createdAt;

  ReviewModel({
    required this.id,
    required this.vendorId,
    required this.user,
    required this.comment,
    required this.rating,
    required this.createdAt,
  });

  factory ReviewModel.fromJson(Map<String, dynamic> json) {
    return ReviewModel(
      id: json["_id"],
      vendorId: json["vendorId"],
      user: User.fromJson(json["userId"]),
      comment: json["comment"],
      rating: json["rating"],
      createdAt: DateTime.parse(json["createdAt"]),
    );
  }
}

class User {
  final String id;
  final String email;

  User({
    required this.id,
    required this.email,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json["_id"],
      email: json["firstname"],
    );
  }
}
