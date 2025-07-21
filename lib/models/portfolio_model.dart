class PortfolioModel {
  final String id;
  final String title;
  final String description;
  final List<String> images;
  final List<String> services;
  final String createdBy;
  final DateTime createdAt;

  final String? location;
  final String? duration;
  final List<String>? tags;
  final String? clientType;
  final List<String>? testimonials;
  final int? numberOfProjects;
  final TimeEstimates? timeEstimates;
  final CostRange? estimatedCostRange;
  final String? selfNote;
  final bool? isPracticeProject;
  final bool? contactEnabled;
  final List<String>? skillsUsed;
  final String? highlights;
  final String? challengesFaced;
  final DateTime? date;
  final List<String>? videoLinks;
  final List<String>? equipmentUsed;

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
      id: json['_id'] as String? ?? '',
      title: json['title'] as String? ?? '',
      description: json['description'] as String? ?? '',
      images: List<String>.from(json['images'] ?? []),
      services: List<String>.from(json['serviceType'] ?? []),
      createdBy: json['createdBy'] as String? ?? '',
      createdAt: DateTime.tryParse(json['createdAt'] ?? '') ?? DateTime.now(),
      location: json['location'] as String?,
      duration: json['duration'] as String?,
      tags: (json['tags'] as List?)?.map((e) => e.toString()).toList(),
      clientType: json['clientType'] as String?,
      testimonials: (json['testimonials'] as List?)?.map((e) => e.toString()).toList(),
      numberOfProjects: json['numberOfProjects'] as int?,
      timeEstimates: json['timeEstimates'] != null
          ? TimeEstimates.fromJson(json['timeEstimates'] as Map<String, dynamic>)
          : null,
      estimatedCostRange: json['estimatedCostRange'] != null
          ? CostRange.fromJson(json['estimatedCostRange'] as Map<String, dynamic>)
          : null,
      selfNote: json['selfNote'] as String?,
      isPracticeProject: json['isPracticeProject'] as bool?,
      contactEnabled: json['contactEnabled'] as bool?,
      skillsUsed: (json['skillsUsed'] as List?)?.map((e) => e.toString()).toList(),
      highlights: json['highlights'] as String?,
      challengesFaced: json['challengesFaced'] as String?,
      date: json['date'] != null ? DateTime.tryParse(json['date']) : null,
      videoLinks: (json['videoLinks'] as List?)?.map((e) => e.toString()).toList(),
      equipmentUsed: (json['equipmentUsed'] as List?)?.map((e) => e.toString()).toList(),
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
  final int minHours;
  final int maxHours;

  TimeEstimates({
    required this.minHours,
    required this.maxHours,
  });

  factory TimeEstimates.fromJson(Map<String, dynamic> json) {
    return TimeEstimates(
      minHours: json['minHours'] as int? ?? 0,
      maxHours: json['maxHours'] as int? ?? 0,
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
  final double min;
  final double max;
  final String currency;

  CostRange({
    required this.min,
    required this.max,
    required this.currency,
  });

  factory CostRange.fromJson(Map<String, dynamic> json) {
    return CostRange(
      min: (json['min'] is int
              ? (json['min'] as int).toDouble()
              : json['min'] as double?) ??
          0.0,
      max: (json['max'] is int
              ? (json['max'] as int).toDouble()
              : json['max'] as double?) ??
          0.0,
      currency: json['currency'] as String? ?? 'USD',
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
