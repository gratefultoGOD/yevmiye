import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/job_categories.dart';
import '../../models/user_model.dart';
import '../../state/app_state.dart';
import '../widgets/custom_button.dart';
import '../widgets/custom_text_field.dart';
import '../common/legal_disclaimer_sheet.dart';

class RegisterScreen extends StatefulWidget {
  final AppState appState;

  const RegisterScreen({super.key, required this.appState});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();

  UserRole _selectedRole = UserRole.jobSeeker;
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _ageController = TextEditingController();

  // İşveren
  final _businessNameController = TextEditingController();
  final _businessDescController = TextEditingController();

  String _selectedCity = 'İstanbul';
  String _selectedDistrict = 'Kadıköy';
  bool _termsAccepted = true;

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _ageController.dispose();
    _businessNameController.dispose();
    _businessDescController.dispose();
    super.dispose();
  }

  void _handleRegister() {
    if (!_termsAccepted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Lütfen kullanıcı ve güvenlik koşullarını onaylayınız.'),
          backgroundColor: AppColors.error,
        ),
      );
      return;
    }

    if (_formKey.currentState?.validate() ?? false) {
      final newUser = UserModel(
        id: 'user_${DateTime.now().millisecondsSinceEpoch}',
        name: _nameController.text.trim(),
        email: _emailController.text.trim(),
        phone: _phoneController.text.trim(),
        role: _selectedRole,
        city: _selectedCity,
        district: _selectedDistrict,
        age: int.tryParse(_ageController.text) ?? 22,
        businessName: _selectedRole == UserRole.employer ? _businessNameController.text.trim() : null,
        businessDescription: _selectedRole == UserRole.employer ? _businessDescController.text.trim() : null,
        isVerified: false,
        createdAt: DateTime.now(),
      );

      widget.appState.register(newUser);
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final districts = AppCategories.cityDistricts[_selectedCity] ?? ['Merkez', 'Diğer'];

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Yeni Hesap Oluştur'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Hesap Türünü Seçin',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800, color: AppColors.textPrimary),
                ),
                const SizedBox(height: 12),

                // Rol Seçim Kartları
                Row(
                  children: [
                    Expanded(
                      child: _buildRoleCard(
                        title: 'İş Arayan',
                        subtitle: 'Yevmiyeli iş bul',
                        icon: Icons.person_rounded,
                        role: UserRole.jobSeeker,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _buildRoleCard(
                        title: 'İşveren',
                        subtitle: 'Eleman ilanı ver',
                        icon: Icons.storefront_rounded,
                        role: UserRole.employer,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 24),

                // Temel Bilgiler
                CustomTextField(
                  label: _selectedRole == UserRole.employer ? 'Yetkili Adı Soyadı' : 'Ad Soyad',
                  hint: 'Örn: Caner Yılmaz',
                  controller: _nameController,
                  prefixIcon: Icons.badge_outlined,
                  validator: (v) => (v == null || v.isEmpty) ? 'Lütfen adınızı giriniz.' : null,
                ),

                if (_selectedRole == UserRole.employer) ...[
                  const SizedBox(height: 16),
                  CustomTextField(
                    label: 'İşletme / Firma Adı',
                    hint: 'Örn: Kadıköy Moda Bistro',
                    controller: _businessNameController,
                    prefixIcon: Icons.business_outlined,
                    validator: (v) => (v == null || v.isEmpty) ? 'İşletme adı zorunludur.' : null,
                  ),
                  const SizedBox(height: 16),
                  CustomTextField(
                    label: 'İşletme Faaliyet Açıklaması',
                    hint: 'Kafe, depo lojistik, restoran vb.',
                    controller: _businessDescController,
                    maxLines: 2,
                    prefixIcon: Icons.info_outline_rounded,
                  ),
                ],

                const SizedBox(height: 16),

                // Telefon & E-posta
                CustomTextField(
                  label: 'Telefon Numarası',
                  hint: '05XX XXX XX XX',
                  controller: _phoneController,
                  keyboardType: TextInputType.phone,
                  prefixIcon: Icons.phone_outlined,
                  validator: (v) => (v == null || v.isEmpty) ? 'Telefon numarası zorunludur.' : null,
                ),

                const SizedBox(height: 16),

                CustomTextField(
                  label: 'E-Posta Adresi',
                  hint: 'hesap@email.com',
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  prefixIcon: Icons.email_outlined,
                  validator: (v) {
                    if (v == null || !v.contains('@')) return 'Geçerli bir e-posta giriniz.';
                    return null;
                  },
                ),

                const SizedBox(height: 16),

                CustomTextField(
                  label: 'Şifre',
                  hint: 'En az 6 karakter',
                  controller: _passwordController,
                  obscureText: true,
                  prefixIcon: Icons.lock_outline_rounded,
                  validator: (v) => (v == null || v.length < 6) ? 'Şifre en az 6 karakter olmalıdır.' : null,
                ),

                if (_selectedRole == UserRole.jobSeeker) ...[
                  const SizedBox(height: 16),
                  CustomTextField(
                    label: 'Yaşınız',
                    hint: 'Örn: 24',
                    controller: _ageController,
                    keyboardType: TextInputType.number,
                    prefixIcon: Icons.cake_outlined,
                  ),
                ],

                const SizedBox(height: 20),

                // Şehir & İlçe Seçimi
                const Text(
                  'Konum (Şehir & İlçe)',
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: AppColors.textPrimary),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 14),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(color: AppColors.border),
                        ),
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton<String>(
                            value: _selectedCity,
                            isExpanded: true,
                            items: AppCategories.popularCities
                                .where((c) => c != 'Tüm Türkiye')
                                .map((c) => DropdownMenuItem(value: c, child: Text(c)))
                                .toList(),
                            onChanged: (val) {
                              if (val != null) {
                                setState(() {
                                  _selectedCity = val;
                                  _selectedDistrict =
                                      (AppCategories.cityDistricts[val]?.firstWhere((d) => d != 'Tümü') ?? 'Merkez');
                                });
                              }
                            },
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 14),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(color: AppColors.border),
                        ),
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton<String>(
                            value: districts.contains(_selectedDistrict) ? _selectedDistrict : districts.first,
                            isExpanded: true,
                            items: districts
                                .where((d) => d != 'Tümü')
                                .map((d) => DropdownMenuItem(value: d, child: Text(d)))
                                .toList(),
                            onChanged: (val) {
                              if (val != null) setState(() => _selectedDistrict = val);
                            },
                          ),
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 24),

                // Koşullar Onayı & Bilgilendirme
                Row(
                  children: [
                    Checkbox(
                      value: _termsAccepted,
                      activeColor: AppColors.primary,
                      onChanged: (val) => setState(() => _termsAccepted = val ?? false),
                    ),
                    Expanded(
                      child: GestureDetector(
                        onTap: () => LegalDisclaimerSheet.show(context),
                        child: const Text.rich(
                          TextSpan(
                            text: 'Kullanım şartlarını ve ',
                            style: TextStyle(fontSize: 12, color: AppColors.textSecondary),
                            children: [
                              TextSpan(
                                text: 'Yasal Sorumluluk Metnini',
                                style: TextStyle(
                                  color: AppColors.primary,
                                  fontWeight: FontWeight.w700,
                                  decoration: TextDecoration.underline,
                                ),
                              ),
                              TextSpan(text: ' okudum, kabul ediyorum.'),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 24),

                CustomButton(
                  text: 'Hesabı Oluştur',
                  backgroundColor: AppColors.primary,
                  onPressed: _handleRegister,
                ),

                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildRoleCard({
    required String title,
    required String subtitle,
    required IconData icon,
    required UserRole role,
  }) {
    final isSelected = _selectedRole == role;

    return InkWell(
      onTap: () => setState(() => _selectedRole = role),
      borderRadius: BorderRadius.circular(16),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.black : Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected ? AppColors.black : AppColors.border,
            width: 1.5,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.12),
                    blurRadius: 8,
                    offset: const Offset(0, 3),
                  ),
                ]
              : null,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(
              icon,
              size: 26,
              color: isSelected ? AppColors.primary : AppColors.textSecondary,
            ),
            const SizedBox(height: 10),
            Text(
              title,
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w800,
                color: isSelected ? Colors.white : AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              subtitle,
              style: TextStyle(
                fontSize: 11,
                color: isSelected ? Colors.white.withOpacity(0.7) : AppColors.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
