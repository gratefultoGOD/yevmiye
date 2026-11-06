import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../models/pricing_config_model.dart';
import '../../state/app_state.dart';
import '../widgets/custom_button.dart';

class AdminDashboardScreen extends StatefulWidget {
  final AppState appState;

  const AdminDashboardScreen({super.key, required this.appState});

  @override
  State<AdminDashboardScreen> createState() => _AdminDashboardScreenState();
}

class _AdminDashboardScreenState extends State<AdminDashboardScreen> {
  late bool _isMonetizationActive;
  late TextEditingController _jobFeeController;
  late TextEditingController _hireFeeController;

  @override
  void initState() {
    super.initState();
    final config = widget.appState.pricingConfig;
    _isMonetizationActive = config.isMonetizationActive;
    _jobFeeController = TextEditingController(text: config.jobPostFee.toStringAsFixed(0));
    _hireFeeController = TextEditingController(text: config.hiredWorkerFee.toStringAsFixed(0));
  }

  @override
  void dispose() {
    _jobFeeController.dispose();
    _hireFeeController.dispose();
    super.dispose();
  }

  void _savePricing() {
    final updated = PricingConfigModel(
      isMonetizationActive: _isMonetizationActive,
      jobPostFee: double.tryParse(_jobFeeController.text) ?? 100.0,
      hiredWorkerFee: double.tryParse(_hireFeeController.text) ?? 20.0,
    );
    widget.appState.updatePricingConfig(updated);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Ücretlendirme ve moderasyon ayarları güncellendi!'),
        backgroundColor: AppColors.black,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: widget.appState,
      builder: (context, _) {
        final reports = widget.appState.reports;
        final jobs = widget.appState.jobs;

        return Scaffold(
          backgroundColor: AppColors.background,
          appBar: AppBar(
            title: const Text('Yönetici & Moderasyon Paneli'),
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 1. Ücretlendirme Modülü (Bölüm 9)
                Container(
                  padding: const EdgeInsets.all(18),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(18),
                    border: Border.all(color: AppColors.border),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Row(
                            children: [
                              Icon(Icons.payments_rounded, color: AppColors.primary, size: 22),
                              SizedBox(width: 10),
                              Text(
                                'Ücretlendirme Altyapısı',
                                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800),
                              ),
                            ],
                          ),
                          Switch(
                            value: _isMonetizationActive,
                            activeColor: AppColors.primary,
                            onChanged: (val) => setState(() => _isMonetizationActive = val),
                          ),
                        ],
                      ),
                      const SizedBox(height: 6),
                      Text(
                        _isMonetizationActive
                            ? 'Ücretlendirme sistemi şu an AKTİF. İşverenlerden komisyon ve ilan bedeli tahsil edilir.'
                            : 'Ücretlendirme şu an PASİF (Uygulama tamamen ücretsiz). İleride tek tıkla aktif edilebilir.',
                        style: TextStyle(
                          fontSize: 12,
                          color: _isMonetizationActive ? AppColors.success : AppColors.textSecondary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          Expanded(
                            child: TextField(
                              controller: _jobFeeController,
                              keyboardType: TextInputType.number,
                              decoration: const InputDecoration(
                                labelText: 'İlan Başına (TL)',
                                prefixText: '₺ ',
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: TextField(
                              controller: _hireFeeController,
                              keyboardType: TextInputType.number,
                              decoration: const InputDecoration(
                                labelText: 'İşe Alım Başına (TL)',
                                prefixText: '₺ ',
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 14),
                      CustomButton(
                        text: 'Ücretlendirme Ayarlarını Kaydet',
                        backgroundColor: AppColors.black,
                        onPressed: _savePricing,
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 20),

                // 2. Güvenlik ve Şikayetler (Bölüm 10)
                Container(
                  padding: const EdgeInsets.all(18),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(18),
                    border: Border.all(color: AppColors.border),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const Icon(Icons.shield_rounded, color: AppColors.error, size: 22),
                          const SizedBox(width: 10),
                          const Text(
                            'Gelen Şikâyetler ve Bildirimler',
                            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800),
                          ),
                          const Spacer(),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                            decoration: BoxDecoration(
                              color: AppColors.error.withOpacity(0.12),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              '${reports.length} Bildirim',
                              style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: AppColors.error),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      if (reports.isEmpty)
                        const Padding(
                          padding: EdgeInsets.symmetric(vertical: 12),
                          child: Center(
                            child: Text(
                              'Bekleyen şüpheli ilan veya kullanıcı bildirimi yok.',
                              style: TextStyle(fontSize: 13, color: AppColors.textSecondary),
                            ),
                          ),
                        )
                      else
                        ...reports.map((rep) {
                          return Container(
                            margin: const EdgeInsets.only(bottom: 10),
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: AppColors.background,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: AppColors.border),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  rep.targetTitle,
                                  style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  'Neden: ${rep.reason}',
                                  style: const TextStyle(fontSize: 12, color: AppColors.error, fontWeight: FontWeight.w600),
                                ),
                              ],
                            ),
                          );
                        }),
                    ],
                  ),
                ),

                const SizedBox(height: 20),

                // 3. İşletme Doğrulama & Genel Metrikler
                Container(
                  padding: const EdgeInsets.all(18),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(18),
                    border: Border.all(color: AppColors.border),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Row(
                        children: [
                          Icon(Icons.verified_rounded, color: AppColors.info, size: 22),
                          SizedBox(width: 10),
                          Text(
                            'Platform Genel Durumu',
                            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800),
                          ),
                        ],
                      ),
                      const SizedBox(height: 14),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text('Sistemdeki Toplam İlan:', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
                          Text('${jobs.length}', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w800)),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text('Toplam Başvuru Sayısı:', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
                          Text('${widget.appState.applications.length}', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w800)),
                        ],
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 30),
              ],
            ),
          ),
        );
      },
    );
  }
}
