import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';

class LegalDisclaimerSheet extends StatelessWidget {
  const LegalDisclaimerSheet({super.key});

  static void show(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => const LegalDisclaimerSheet(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: AppColors.border,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(Icons.gavel_rounded, color: AppColors.primary, size: 24),
              ),
              const SizedBox(width: 14),
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Yasal Bilgilendirme & Güvenlik',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800, color: AppColors.textPrimary),
                    ),
                    Text(
                      'İş sözleşmesi, sigorta ve hakediş sorumluluğu',
                      style: TextStyle(fontSize: 12, color: AppColors.textSecondary),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          _buildInfoItem(
            icon: Icons.shield_outlined,
            title: 'SGK ve Günlük Sigorta Yükümlülüğü',
            description:
                '5510 Sayılı Kanun gereğince, günlük çalışan işçilerin SGK günlük sigorta girişleri (EK-9 vb.) işveren tarafından yasal olarak bildirilmelidir.',
          ),
          const SizedBox(height: 14),
          _buildInfoItem(
            icon: Icons.payments_outlined,
            title: 'Ödeme ve Hakediş Güvencesi',
            description:
                'Yevmiye uygulaması iş arayan ile işvereni buluşturan bir platformdur. Belirtilen hakedişin gün sonunda veya anlaşılan tarihte eksiksiz ödenmesi işverenin doğrudan taahhüdüdür.',
          ),
          const SizedBox(height: 14),
          _buildInfoItem(
            icon: Icons.health_and_safety_outlined,
            title: 'İş Sağlığı ve Güvenliği',
            description:
                'Çalışma alanında gerekli tüm iş güvenliği önlemlerinin ve koruyucu ekipmanların sağlanması ilgili işletmenin kanuni sorumluluğundadır.',
          ),
          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            height: 50,
            child: ElevatedButton(
              onPressed: () => Navigator.pop(context),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.black,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
              ),
              child: const Text('Anladım ve Kabul Ediyorum', style: TextStyle(fontWeight: FontWeight.w700)),
            ),
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  Widget _buildInfoItem({
    required IconData icon,
    required String title,
    required String description,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 20, color: AppColors.primary),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: AppColors.textPrimary),
              ),
              const SizedBox(height: 4),
              Text(
                description,
                style: const TextStyle(fontSize: 12, color: AppColors.textSecondary, height: 1.4),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
