import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../models/user_model.dart';
import '../../state/app_state.dart';
import '../widgets/custom_button.dart';
import '../widgets/custom_text_field.dart';
import '../common/legal_disclaimer_sheet.dart';

class SeekerProfileScreen extends StatelessWidget {
  final AppState appState;

  const SeekerProfileScreen({super.key, required this.appState});

  void _showEditProfileDialog(BuildContext context) {
    final user = appState.currentUser;
    if (user == null) return;

    final nameController = TextEditingController(text: user.name);
    final phoneController = TextEditingController(text: user.phone);
    final ageController = TextEditingController(text: user.age?.toString() ?? '');
    final expController = TextEditingController(text: user.experienceYears.toString());
    final bioController = TextEditingController(text: user.bio ?? '');

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
      builder: (ctx) => Padding(
        padding: EdgeInsets.only(
          left: 24,
          right: 24,
          top: 20,
          bottom: MediaQuery.of(ctx).viewInsets.bottom + 20,
        ),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Profili Düzenle', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800)),
                  IconButton(icon: const Icon(Icons.close), onPressed: () => Navigator.pop(ctx)),
                ],
              ),
              const SizedBox(height: 16),
              CustomTextField(label: 'Ad Soyad', controller: nameController),
              const SizedBox(height: 14),
              CustomTextField(label: 'Telefon Numarası', controller: phoneController, keyboardType: TextInputType.phone),
              const SizedBox(height: 14),
              Row(
                children: [
                  Expanded(child: CustomTextField(label: 'Yaş', controller: ageController, keyboardType: TextInputType.number)),
                  const SizedBox(width: 12),
                  Expanded(
                    child: CustomTextField(
                      label: 'Deneyim (Yıl)',
                      controller: expController,
                      keyboardType: TextInputType.number,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 14),
              CustomTextField(label: 'Hakkımda / Biyografi', controller: bioController, maxLines: 3),
              const SizedBox(height: 20),
              CustomButton(
                text: 'Değişiklikleri Kaydet',
                backgroundColor: AppColors.primary,
                onPressed: () {
                  final updated = user.copyWith(
                    name: nameController.text.trim(),
                    phone: phoneController.text.trim(),
                    age: int.tryParse(ageController.text) ?? user.age,
                    experienceYears: int.tryParse(expController.text) ?? user.experienceYears,
                    bio: bioController.text.trim(),
                  );
                  appState.updateProfile(updated);
                  Navigator.pop(ctx);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

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
            title: const Text('Profilim'),
            actions: [
              IconButton(
                icon: const Icon(Icons.edit_outlined),
                onPressed: () => _showEditProfileDialog(context),
              ),
            ],
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            child: Column(
              children: [
                // Profil Üst Kartı
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
                      CircleAvatar(
                        radius: 40,
                        backgroundColor: AppColors.black,
                        child: Text(
                          user.name.isNotEmpty ? user.name[0].toUpperCase() : 'A',
                          style: const TextStyle(fontSize: 32, fontWeight: FontWeight.w900, color: AppColors.primary),
                        ),
                      ),
                      const SizedBox(height: 14),
                      Text(
                        user.name,
                        style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w800, color: AppColors.textPrimary),
                      ),
                      const SizedBox(height: 4),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: AppColors.primary.withOpacity(0.12),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Text(
                          'İş Arayan',
                          style: TextStyle(color: AppColors.primary, fontWeight: FontWeight.w700, fontSize: 12),
                        ),
                      ),
                      const SizedBox(height: 14),
                      Text(
                        user.bio ?? 'Kısa biyografi eklenmemiş.',
                        textAlign: TextAlign.center,
                        style: const TextStyle(fontSize: 13, color: AppColors.textSecondary, height: 1.4),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 16),

                // Bilgi Listesi Kartı
                Container(
                  padding: const EdgeInsets.all(18),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: AppColors.border),
                  ),
                  child: Column(
                    children: [
                      _buildProfileRow(Icons.phone_outlined, 'Telefon', user.phone),
                      const Divider(height: 20, color: AppColors.border),
                      _buildProfileRow(Icons.email_outlined, 'E-Posta', user.email),
                      const Divider(height: 20, color: AppColors.border),
                      _buildProfileRow(Icons.location_on_outlined, 'Konum', '${user.district}, ${user.city}'),
                      const Divider(height: 20, color: AppColors.border),
                      _buildProfileRow(Icons.cake_outlined, 'Yaş', '${user.age ?? 24} yaşında'),
                      const Divider(height: 20, color: AppColors.border),
                      _buildProfileRow(Icons.work_outline_rounded, 'İş Deneyimi', '${user.experienceYears} yıl deneyim'),
                    ],
                  ),
                ),

                const SizedBox(height: 16),

                // Yetenekler
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(18),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: AppColors.border),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Meslek & Yetenekler',
                        style: TextStyle(fontSize: 15, fontWeight: FontWeight.w800, color: AppColors.textPrimary),
                      ),
                      const SizedBox(height: 12),
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: user.skills.map((skill) {
                          return Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                            decoration: BoxDecoration(
                              color: AppColors.background,
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(color: AppColors.border),
                            ),
                            child: Text(
                              skill,
                              style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: AppColors.textPrimary),
                            ),
                          );
                        }).toList(),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 20),

                // İşletme Moduna Geçiş Butonu
                CustomButton(
                  text: 'İşveren Hesabına Geçiş Yap',
                  isOutlined: true,
                  icon: Icons.storefront_rounded,
                  onPressed: () {
                    appState.switchRole(UserRole.employer);
                  },
                ),

                const SizedBox(height: 12),

                // Güvenlik & Yasal Bilgilendirme
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: const Icon(Icons.shield_outlined, color: AppColors.primary),
                  title: const Text('Yasal Sorumluluk & Güvenlik', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
                  trailing: const Icon(Icons.chevron_right_rounded),
                  onTap: () => LegalDisclaimerSheet.show(context),
                ),

                const SizedBox(height: 8),

                // Çıkış Yap
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

  Widget _buildProfileRow(IconData icon, String label, String value) {
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
