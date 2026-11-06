import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../models/user_model.dart';
import '../../state/app_state.dart';
import '../widgets/custom_button.dart';
import '../widgets/custom_text_field.dart';
import 'register_screen.dart';

class LoginScreen extends StatefulWidget {
  final AppState appState;

  const LoginScreen({super.key, required this.appState});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _identifierController = TextEditingController(text: 'ahmet@yevmiye.app');
  final _passwordController = TextEditingController(text: '123456');

  bool _isPhoneMode = false;
  bool _obscurePassword = true;

  @override
  void dispose() {
    _identifierController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _handleLogin(UserRole role) {
    if (_formKey.currentState?.validate() ?? false) {
      widget.appState.loginWithEmail(
        _identifierController.text.trim(),
        _passwordController.text,
        role,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Logo & Başlık
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: AppColors.black,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: const Icon(
                          Icons.handshake_rounded,
                          color: AppColors.primary,
                          size: 32,
                        ),
                      ),
                      const SizedBox(width: 14),
                      const Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Yevmiye',
                            style: TextStyle(
                              fontSize: 26,
                              fontWeight: FontWeight.w900,
                              color: AppColors.black,
                              letterSpacing: -0.5,
                            ),
                          ),
                          Text(
                            'Günlük İş & İşçi Bulma Platformu',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: AppColors.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),

                  const SizedBox(height: 36),

                  const Text(
                    'Hoş Geldiniz 👋',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w800,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 6),
                  const Text(
                    'Hesabınıza giriş yaparak hemen iş veya çalışan bulun.',
                    style: TextStyle(
                      fontSize: 14,
                      color: AppColors.textSecondary,
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Telefon / E-posta Toggle
                  Container(
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: AppColors.background,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: AppColors.border),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: InkWell(
                            onTap: () {
                              setState(() {
                                _isPhoneMode = false;
                                _identifierController.text = 'ahmet@yevmiye.app';
                              });
                            },
                            borderRadius: BorderRadius.circular(9),
                            child: Container(
                              padding: const EdgeInsets.symmetric(vertical: 10),
                              decoration: BoxDecoration(
                                color: !_isPhoneMode ? Colors.white : Colors.transparent,
                                borderRadius: BorderRadius.circular(9),
                                boxShadow: !_isPhoneMode
                                    ? [
                                        BoxShadow(
                                          color: Colors.black.withOpacity(0.06),
                                          blurRadius: 4,
                                        )
                                      ]
                                    : null,
                              ),
                              alignment: Alignment.center,
                              child: Text(
                                'E-Posta ile Giriş',
                                style: TextStyle(
                                  fontSize: 13,
                                  fontWeight: !_isPhoneMode ? FontWeight.w700 : FontWeight.w500,
                                  color: !_isPhoneMode ? AppColors.black : AppColors.textSecondary,
                                ),
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          child: InkWell(
                            onTap: () {
                              setState(() {
                                _isPhoneMode = true;
                                _identifierController.text = '0532 111 2233';
                              });
                            },
                            borderRadius: BorderRadius.circular(9),
                            child: Container(
                              padding: const EdgeInsets.symmetric(vertical: 10),
                              decoration: BoxDecoration(
                                color: _isPhoneMode ? Colors.white : Colors.transparent,
                                borderRadius: BorderRadius.circular(9),
                                boxShadow: _isPhoneMode
                                    ? [
                                        BoxShadow(
                                          color: Colors.black.withOpacity(0.06),
                                          blurRadius: 4,
                                        )
                                      ]
                                    : null,
                              ),
                              alignment: Alignment.center,
                              child: Text(
                                'Telefon No ile Giriş',
                                style: TextStyle(
                                  fontSize: 13,
                                  fontWeight: _isPhoneMode ? FontWeight.w700 : FontWeight.w500,
                                  color: _isPhoneMode ? AppColors.black : AppColors.textSecondary,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 20),

                  // Kimlik Girdisi
                  CustomTextField(
                    label: _isPhoneMode ? 'Telefon Numarası' : 'E-Posta Adresi',
                    hint: _isPhoneMode ? '05XX XXX XX XX' : 'ornek@email.com',
                    controller: _identifierController,
                    keyboardType: _isPhoneMode ? TextInputType.phone : TextInputType.emailAddress,
                    prefixIcon: _isPhoneMode ? Icons.phone_outlined : Icons.email_outlined,
                    validator: (v) {
                      if (v == null || v.trim().isEmpty) return 'Bu alan zorunludur.';
                      return null;
                    },
                  ),

                  const SizedBox(height: 16),

                  // Şifre
                  CustomTextField(
                    label: 'Şifre',
                    hint: '••••••••',
                    controller: _passwordController,
                    obscureText: _obscurePassword,
                    prefixIcon: Icons.lock_outline_rounded,
                    suffixIcon: IconButton(
                      icon: Icon(
                        _obscurePassword ? Icons.visibility_off_outlined : Icons.visibility_outlined,
                        color: AppColors.textSecondary,
                        size: 20,
                      ),
                      onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
                    ),
                    validator: (v) {
                      if (v == null || v.length < 6) return 'Şifre en az 6 karakter olmalıdır.';
                      return null;
                    },
                  ),

                  const SizedBox(height: 24),

                  // Giriş Butonu
                  CustomButton(
                    text: 'İş Arayan Olarak Giriş Yap',
                    icon: Icons.person_search_rounded,
                    backgroundColor: AppColors.primary,
                    onPressed: () => _handleLogin(UserRole.jobSeeker),
                  ),

                  const SizedBox(height: 12),

                  CustomButton(
                    text: 'İşveren Olarak Giriş Yap',
                    isOutlined: true,
                    icon: Icons.business_center_rounded,
                    onPressed: () => _handleLogin(UserRole.employer),
                  ),

                  const SizedBox(height: 28),

                  // Kayıt Ol
                  Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          'Henüz hesabın yok mu? ',
                          style: TextStyle(color: AppColors.textSecondary, fontSize: 14),
                        ),
                        InkWell(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => RegisterScreen(appState: widget.appState),
                              ),
                            );
                          },
                          child: const Text(
                            'Kayıt Ol',
                            style: TextStyle(
                              color: AppColors.primary,
                              fontWeight: FontWeight.w800,
                              fontSize: 14,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
