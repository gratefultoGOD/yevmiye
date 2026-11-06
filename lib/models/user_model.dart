enum UserRole {
  jobSeeker,
  employer,
  admin,
}

class UserModel {
  final String id;
  final String name;
  final String email;
  final String phone;
  final UserRole role;
  final String? profilePhoto;
  final String city;
  final String district;
  final DateTime createdAt;

  // İş Arayan Alanları
  final int? age;
  final List<String> skills;
  final int experienceYears;
  final String? bio;

  // İşveren Alanları
  final String? businessName;
  final String? businessDescription;
  final bool isVerified;
  final String? address;

  UserModel({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    required this.role,
    this.profilePhoto,
    required this.city,
    required this.district,
    required this.createdAt,
    this.age,
    this.skills = const [],
    this.experienceYears = 0,
    this.bio,
    this.businessName,
    this.businessDescription,
    this.isVerified = false,
    this.address,
  });

  bool get isEmployer => role == UserRole.employer;
  bool get isJobSeeker => role == UserRole.jobSeeker;
  bool get isAdmin => role == UserRole.admin;

  UserModel copyWith({
    String? name,
    String? email,
    String? phone,
    UserRole? role,
    String? profilePhoto,
    String? city,
    String? district,
    int? age,
    List<String>? skills,
    int? experienceYears,
    String? bio,
    String? businessName,
    String? businessDescription,
    bool? isVerified,
    String? address,
  }) {
    return UserModel(
      id: id,
      name: name ?? this.name,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      role: role ?? this.role,
      profilePhoto: profilePhoto ?? this.profilePhoto,
      city: city ?? this.city,
      district: district ?? this.district,
      createdAt: createdAt,
      age: age ?? this.age,
      skills: skills ?? this.skills,
      experienceYears: experienceYears ?? this.experienceYears,
      bio: bio ?? this.bio,
      businessName: businessName ?? this.businessName,
      businessDescription: businessDescription ?? this.businessDescription,
      isVerified: isVerified ?? this.isVerified,
      address: address ?? this.address,
    );
  }
}
