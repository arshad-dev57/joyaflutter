class PaymentLinkModel {
  final String id;
  final String link;
  final String imageUrl;
  final DateTime createdAt;

  PaymentLinkModel({
    required this.id,
    required this.link,
    required this.imageUrl,
    required this.createdAt,
  });

  factory PaymentLinkModel.fromJson(Map<String, dynamic> json) {
    return PaymentLinkModel(
      id: json['_id'],
      link: json['link'],
      imageUrl: json['imageUrl'],
      createdAt: DateTime.parse(json['createdAt']),
    );
  }
}
