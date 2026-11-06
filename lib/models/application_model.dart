enum ApplicationStatus {
  pending,
  accepted,
  rejected,
}

extension ApplicationStatusExt on ApplicationStatus {
  String get label {
    switch (this) {
      case ApplicationStatus.pending:
        return 'Beklemede';
      case ApplicationStatus.accepted:
        return 'Kabul Edildi';
      case ApplicationStatus.rejected:
        return 'Reddedildi';
    }
  }
}

class ApplicationModel {
  final String id;
  final String jobId;
  final String jobTitle;
  final String employerId;
  final String seekerId;
  final String seekerName;
  final String seekerPhone;
  final int seekerAge;
  final int seekerExperience;
  final String? note;
  final ApplicationStatus status;
  final DateTime appliedAt;
  final DateTime? updatedAt;

  ApplicationModel({
    required this.id,
    required this.jobId,
    required this.jobTitle,
    required this.employerId,
    required this.seekerId,
    required this.seekerName,
    required this.seekerPhone,
    required this.seekerAge,
    required this.seekerExperience,
    this.note,
    this.status = ApplicationStatus.pending,
    required this.appliedAt,
    this.updatedAt,
  });

  ApplicationModel copyWith({
    ApplicationStatus? status,
    DateTime? updatedAt,
  }) {
    return ApplicationModel(
      id: id,
      jobId: jobId,
      jobTitle: jobTitle,
      employerId: employerId,
      seekerId: seekerId,
      seekerName: seekerName,
      seekerPhone: seekerPhone,
      seekerAge: seekerAge,
      seekerExperience: seekerExperience,
      note: note,
      status: status ?? this.status,
      appliedAt: appliedAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
