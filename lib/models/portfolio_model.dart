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
  List<String>? tags;
  String? clientType;
  List<String>? testimonials;
  int? numberOfProjects;
  TimeEstimates? timeEstimates;
  CostRange? estimatedCostRange;
  String? selfNote;
  bool? isPracticeProject;
  bool? contactEnabled;
  List<String>? skillsUsed;
  String? highlights;
  String? challengesFaced;
  DateTime? date;
  List<String>? videoLinks;
  List<String>? equipmentUsed;

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
    this.tags,
    this.clientType,
    this.testimonials,
    this.numberOfProjects,
    this.timeEstimates,
    this.estimatedCostRange,
    this.selfNote,
    this.isPracticeProject,
    this.contactEnabled,
    this.skillsUsed,
    this.highlights,
    this.challengesFaced,
    this.date,
    this.videoLinks,
    this.equipmentUsed,
  });

  factory PortfolioModel.fromJson(Map<String, dynamic> json) {
    return PortfolioModel(
      id: json['_id'] ?? '',
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      images: List<String>.from(json['images'] ?? []),
      services: List<String>.from(json['serviceType'] ?? []),
      createdBy: json['createdBy'] ?? '',
      createdAt: DateTime.tryParse(json['createdAt'] ?? '') ?? DateTime.now(),
      location: json['location'],
      duration: json['duration'],
      tags: (json['tags'] as List?)?.map((e) => e.toString()).toList(),
      clientType: json['clientType'],
      testimonials: (json['testimonials'] as List?)
          ?.map((e) => e.toString())
          .toList(),
      numberOfProjects: json['numberOfProjects'],
      timeEstimates: json['timeEstimates'] != null
          ? TimeEstimates.fromJson(json['timeEstimates'])
          : null,
      estimatedCostRange: json['estimatedCostRange'] != null
          ? CostRange.fromJson(json['estimatedCostRange'])
          : null,
      selfNote: json['selfNote'],
      isPracticeProject: json['isPracticeProject'],
      contactEnabled: json['contactEnabled'],
      skillsUsed: (json['skillsUsed'] as List?)?.map((e) => e.toString()).toList(),
      highlights: json['highlights'],
      challengesFaced: json['challengesFaced'],
      date: json['date'] != null
          ? DateTime.tryParse(json['date'])
          : null,
      videoLinks: (json['videoLinks'] as List?)
          ?.map((e) => e.toString())
          .toList(),
      equipmentUsed:
          (json['equipmentUsed'] as List?)?.map((e) => e.toString()).toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'title': title,
      'description': description,
      'images': images,
      'serviceType': services,
      'createdBy': createdBy,
      'createdAt': createdAt.toIso8601String(),
      'location': location,
      'duration': duration,
      'tags': tags,
      'clientType': clientType,
      'testimonials': testimonials,
      'numberOfProjects': numberOfProjects,
      'timeEstimates': timeEstimates?.toJson(),
      'estimatedCostRange': estimatedCostRange?.toJson(),
      'selfNote': selfNote,
      'isPracticeProject': isPracticeProject,
      'contactEnabled': contactEnabled,
      'skillsUsed': skillsUsed,
      'highlights': highlights,
      'challengesFaced': challengesFaced,
      'date': date?.toIso8601String(),
      'videoLinks': videoLinks,
      'equipmentUsed': equipmentUsed,
    };
  }
}

class TimeEstimates {
  int minHours;
  int maxHours;

  TimeEstimates({
    required this.minHours,
    required this.maxHours,
  });

  factory TimeEstimates.fromJson(Map<String, dynamic> json) {
    return TimeEstimates(
      minHours: json['minHours'] ?? 0,
      maxHours: json['maxHours'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'minHours': minHours,
      'maxHours': maxHours,
    };
  }
}

class CostRange {
  double min;
  double max;
  String currency;

  CostRange({
    required this.min,
    required this.max,
    required this.currency,
  });

  factory CostRange.fromJson(Map<String, dynamic> json) {
    return CostRange(
      min: (json['min'] is int
              ? (json['min'] as int).toDouble()
              : (json['min'] as double?)) ??
          0.0,
      max: (json['max'] is int
              ? (json['max'] as int).toDouble()
              : (json['max'] as double?)) ??
          0.0,
      currency: json['currency'] ?? 'USD',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'min': min,
      'max': max,
      'currency': currency,
    };
  }
}
