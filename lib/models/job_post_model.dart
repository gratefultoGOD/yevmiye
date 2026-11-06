enum JobType {
  daily,
  weekly,
  permanent,
}

extension JobTypeExt on JobType {
  String get label {
    switch (this) {
      case JobType.daily:
        return 'Günlük';
      case JobType.weekly:
        return 'Haftalık';
      case JobType.permanent:
        return 'Sürekli';
    }
  }
}

class JobPostModel {
  final String id;
  final String employerId;
  final String employerName;
  final String employerPhone;
  final bool isEmployerVerified;

  final String title;
  final String description;
  final String categoryId;
  final String categoryTitle;
  final JobType jobType;

  final DateTime workDate;
  final String workHours; // örn: "09:00 - 18:00"
  final double wage; // Ücret miktarı (TL)
  final bool isDailyWage; // true ise Günlük, false ise Toplam
  final int workersNeeded;
  final int workersHired;

  final String city;
  final String district;
  final String addressDetails;
  final List<String> perks; // ["Öğle Yemeği", "Yol Desteği", "Gün Sonu Nakit"]

  final bool isActive;
  final DateTime createdAt;

  JobPostModel({
    required this.id,
    required this.employerId,
    required this.employerName,
    required this.employerPhone,
    this.isEmployerVerified = false,
    required this.title,
    required this.description,
    required this.categoryId,
    required this.categoryTitle,
    required this.jobType,
    required this.workDate,
    required this.workHours,
    required this.wage,
    this.isDailyWage = true,
    required this.workersNeeded,
    this.workersHired = 0,
    required this.city,
    required this.district,
    required this.addressDetails,
    this.perks = const [],
    this.isActive = true,
    required this.createdAt,
  });

  int get remainingSlots => (workersNeeded - workersHired).clamp(0, workersNeeded);
  bool get isFilled => remainingSlots <= 0;

  JobPostModel copyWith({
    String? title,
    String? description,
    String? categoryId,
    String? categoryTitle,
    JobType? jobType,
    DateTime? workDate,
    String? workHours,
    double? wage,
    bool? isDailyWage,
    int? workersNeeded,
    int? workersHired,
    String? city,
    String? district,
    String? addressDetails,
    List<String>? perks,
    bool? isActive,
  }) {
    return JobPostModel(
      id: id,
      employerId: employerId,
      employerName: employerName,
      employerPhone: employerPhone,
      isEmployerVerified: isEmployerVerified,
      title: title ?? this.title,
      description: description ?? this.description,
      categoryId: categoryId ?? this.categoryId,
      categoryTitle: categoryTitle ?? this.categoryTitle,
      jobType: jobType ?? this.jobType,
      workDate: workDate ?? this.workDate,
      workHours: workHours ?? this.workHours,
      wage: wage ?? this.wage,
      isDailyWage: isDailyWage ?? this.isDailyWage,
      workersNeeded: workersNeeded ?? this.workersNeeded,
      workersHired: workersHired ?? this.workersHired,
      city: city ?? this.city,
      district: district ?? this.district,
      addressDetails: addressDetails ?? this.addressDetails,
      perks: perks ?? this.perks,
      isActive: isActive ?? this.isActive,
      createdAt: createdAt,
    );
  }
}
