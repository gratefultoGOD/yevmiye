import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../models/user_model.dart';
import '../../state/app_state.dart';
import '../widgets/custom_button.dart';
import '../common/admin_dashboard_screen.dart';
import '../common/legal_disclaimer_sheet.dart';

class EmployerProfileScreen extends StatelessWidget {
  final AppState appState;

  const EmployerProfileScreen({super.key, required this.appState});

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: appState,
      builder: (context, _) {
        final user = appState.currentUser;
        if (user == null) {
          return const Scaffold(body: Center(child: Text('Kullanıcı bulunamadı')));
        }

        return Scaffold(
          backgroundColor: AppColors.background,
          appBar: AppBar(
            title: const Text('İşletme Profili'),
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            child: Column(
              children: [
                // İşletme Kartı
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: AppColors.border),
                  ),
                  child: Column(
                    children: [
                      Container(
                        width: 72,
                        height: 72,
                        decoration: BoxDecoration(
                          color: AppColors.black,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        alignment: Alignment.center,
                        child: Text(
                          user.businessName?.isNotEmpty == true ? user.businessName![0].toUpperCase() : 'İ',
                          style: const TextStyle(fontSize: 32, fontWeight: FontWeight.w900, color: AppColors.primary),
                        ),
                      ),
                      const SizedBox(height: 14),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Flexible(
                            child: Text(
                              user.businessName ?? user.name,
                              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w800, color: AppColors.textPrimary),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          if (user.isVerified) ...[
                            const SizedBox(width: 6),
                            const Icon(Icons.verified_rounded, color: AppColors.info, size: 20),
                          ],
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        user.isVerified ? 'Doğrulanmış İşveren Hesabı' : 'Standart İşveren Hesabı',
                        style: TextStyle(
                          fontSize: 12,
                          color: user.isVerified ? AppColors.info : AppColors.textSecondary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        user.businessDescription ?? 'İşletme açıklaması belirtilmemiş.',
                        textAlign: TextAlign.center,
                        style: const TextStyle(fontSize: 13, color: AppColors.textSecondary, height: 1.4),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 16),

                // Bilgi Detayları
                Container(
                  padding: const EdgeInsets.all(18),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: AppColors.border),
                  ),
                  child: Column(
                    children: [
                      _buildInfoRow(Icons.person_outline_rounded, 'Yetkili Kişi', user.name),
                      const Divider(height: 20, color: AppColors.border),
                      _buildInfoRow(Icons.phone_outlined, 'İletişim Telefonu', user.phone),
                      const Divider(height: 20, color: AppColors.border),
                      _buildInfoRow(Icons.email_outlined, 'Kurumsal E-Posta', user.email),
                      const Divider(height: 20, color: AppColors.border),
                      _buildInfoRow(Icons.location_on_outlined, 'İşletme Adresi', user.address ?? '${user.district}, ${user.city}'),
                    ],
                  ),
                ),

                const SizedBox(height: 20),

                // Yönetici & Ücretlendirme Paneline Geçiş Butonu
                InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => AdminDashboardScreen(appState: appState),
                      ),
                    );
                  },
                  borderRadius: BorderRadius.circular(16),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                    decoration: BoxDecoration(
                      color: AppColors.black,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: const Row(
                      children: [
                        Icon(Icons.admin_panel_settings_rounded, color: AppColors.primary, size: 24),
                        SizedBox(width: 14),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Yönetici & Ücretlendirme Paneli',
                                style: TextStyle(color: Colors.white, fontWeight: FontWeight.w800, fontSize: 14),
                              ),
                              Text(
                                'İlan ve işe alım ücreti modelleri, şikayetler',
                                style: TextStyle(color: Colors.white70, fontSize: 11),
                              ),
                            ],
                          ),
                        ),
                        Icon(Icons.arrow_forward_ios_rounded, color: Colors.white54, size: 16),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 12),

                // İş Arayan Moduna Geç
                CustomButton(
                  text: 'İş Arayan Moduna Geçiş Yap',
                  isOutlined: true,
                  icon: Icons.person_search_rounded,
                  onPressed: () => appState.switchRole(UserRole.jobSeeker),
                ),

                const SizedBox(height: 12),

                ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: const Icon(Icons.shield_outlined, color: AppColors.primary),
                  title: const Text('Yasal Şartlar ve İş Güvenliği', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
                  trailing: const Icon(Icons.chevron_right_rounded),
                  onTap: () => LegalDisclaimerSheet.show(context),
                ),

                ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: const Icon(Icons.logout_rounded, color: AppColors.error),
                  title: const Text('Çıkış Yap', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: AppColors.error)),
                  onTap: () => appState.logout(),
                ),

                const SizedBox(height: 20),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Row(
      children: [
        Icon(icon, size: 20, color: AppColors.textSecondary),
        const SizedBox(width: 14),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label, style: const TextStyle(fontSize: 11, color: AppColors.textMuted, fontWeight: FontWeight.w600)),
            const SizedBox(height: 2),
            Text(value, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: AppColors.textPrimary)),
          ],
        ),
      ],
    );
  }
}
