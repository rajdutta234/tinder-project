class UserModel {
  final String id;
  final String name;
  final int age;
  final String bio;
  final List<String> photos;
  final String location;
  final double distance;
  final List<String> interests;
  final String occupation;
  final String education;
  final int height; // in cm
  final String gender;
  final String lookingFor;
  final bool isVerified;
  final bool isOnline;
  final DateTime lastActive;
  final List<String> languages;
  final String relationshipGoal;
  final bool hasChildren;
  final String smoking;
  final String drinking;
  final String religion;
  final String politics;
  final String zodiacSign;
  final String instagram;
  final String spotify;

  UserModel({
    required this.id,
    required this.name,
    required this.age,
    required this.bio,
    required this.photos,
    required this.location,
    required this.distance,
    required this.interests,
    required this.occupation,
    required this.education,
    required this.height,
    required this.gender,
    required this.lookingFor,
    required this.isVerified,
    required this.isOnline,
    required this.lastActive,
    required this.languages,
    required this.relationshipGoal,
    required this.hasChildren,
    required this.smoking,
    required this.drinking,
    required this.religion,
    required this.politics,
    required this.zodiacSign,
    required this.instagram,
    required this.spotify,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      age: json['age'] ?? 0,
      bio: json['bio'] ?? '',
      photos: List<String>.from(json['photos'] ?? []),
      location: json['location'] ?? '',
      distance: (json['distance'] ?? 0).toDouble(),
      interests: List<String>.from(json['interests'] ?? []),
      occupation: json['occupation'] ?? '',
      education: json['education'] ?? '',
      height: json['height'] ?? 0,
      gender: json['gender'] ?? '',
      lookingFor: json['lookingFor'] ?? '',
      isVerified: json['isVerified'] ?? false,
      isOnline: json['isOnline'] ?? false,
      lastActive: DateTime.parse(json['lastActive'] ?? DateTime.now().toIso8601String()),
      languages: List<String>.from(json['languages'] ?? []),
      relationshipGoal: json['relationshipGoal'] ?? '',
      hasChildren: json['hasChildren'] ?? false,
      smoking: json['smoking'] ?? '',
      drinking: json['drinking'] ?? '',
      religion: json['religion'] ?? '',
      politics: json['politics'] ?? '',
      zodiacSign: json['zodiacSign'] ?? '',
      instagram: json['instagram'] ?? '',
      spotify: json['spotify'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'age': age,
      'bio': bio,
      'photos': photos,
      'location': location,
      'distance': distance,
      'interests': interests,
      'occupation': occupation,
      'education': education,
      'height': height,
      'gender': gender,
      'lookingFor': lookingFor,
      'isVerified': isVerified,
      'isOnline': isOnline,
      'lastActive': lastActive.toIso8601String(),
      'languages': languages,
      'relationshipGoal': relationshipGoal,
      'hasChildren': hasChildren,
      'smoking': smoking,
      'drinking': drinking,
      'religion': religion,
      'politics': politics,
      'zodiacSign': zodiacSign,
      'instagram': instagram,
      'spotify': spotify,
    };
  }

  UserModel copyWith({
    String? id,
    String? name,
    int? age,
    String? bio,
    List<String>? photos,
    String? location,
    double? distance,
    List<String>? interests,
    String? occupation,
    String? education,
    int? height,
    String? gender,
    String? lookingFor,
    bool? isVerified,
    bool? isOnline,
    DateTime? lastActive,
    List<String>? languages,
    String? relationshipGoal,
    bool? hasChildren,
    String? smoking,
    String? drinking,
    String? religion,
    String? politics,
    String? zodiacSign,
    String? instagram,
    String? spotify,
  }) {
    return UserModel(
      id: id ?? this.id,
      name: name ?? this.name,
      age: age ?? this.age,
      bio: bio ?? this.bio,
      photos: photos ?? this.photos,
      location: location ?? this.location,
      distance: distance ?? this.distance,
      interests: interests ?? this.interests,
      occupation: occupation ?? this.occupation,
      education: education ?? this.education,
      height: height ?? this.height,
      gender: gender ?? this.gender,
      lookingFor: lookingFor ?? this.lookingFor,
      isVerified: isVerified ?? this.isVerified,
      isOnline: isOnline ?? this.isOnline,
      lastActive: lastActive ?? this.lastActive,
      languages: languages ?? this.languages,
      relationshipGoal: relationshipGoal ?? this.relationshipGoal,
      hasChildren: hasChildren ?? this.hasChildren,
      smoking: smoking ?? this.smoking,
      drinking: drinking ?? this.drinking,
      religion: religion ?? this.religion,
      politics: politics ?? this.politics,
      zodiacSign: zodiacSign ?? this.zodiacSign,
      instagram: instagram ?? this.instagram,
      spotify: spotify ?? this.spotify,
    );
  }
} 