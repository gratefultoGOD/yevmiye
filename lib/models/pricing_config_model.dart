class PricingConfigModel {
  final bool isMonetizationActive;
  final double jobPostFee; // İlan yayınlama ücreti (varsayılan: 100 TL)
  final double hiredWorkerFee; // İşe alınan çalışan başına komisyon (varsayılan: 20 TL)

  const PricingConfigModel({
    this.isMonetizationActive = false, // Başlangıçta pasif
    this.jobPostFee = 100.0,
    this.hiredWorkerFee = 20.0,
  });

  PricingConfigModel copyWith({
    bool? isMonetizationActive,
    double? jobPostFee,
    double? hiredWorkerFee,
  }) {
    return PricingConfigModel(
      isMonetizationActive: isMonetizationActive ?? this.isMonetizationActive,
      jobPostFee: jobPostFee ?? this.jobPostFee,
      hiredWorkerFee: hiredWorkerFee ?? this.hiredWorkerFee,
    );
  }
}

class ReportModel {
  final String id;
  final String reporterId;
  final String targetType; // 'job' veya 'user'
  final String targetId;
  final String targetTitle;
  final String reason;
  final DateTime createdAt;
  final bool isResolved;

  ReportModel({
    required this.id,
    required this.reporterId,
    required this.targetType,
    required this.targetId,
    required this.targetTitle,
    required this.reason,
    required this.createdAt,
    this.isResolved = false,
  });
}
