import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../l10n/generated/app_localizations.dart';
import '../../../shared/services/auth_service.dart';
import 'login_screen.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _fullNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _authService = AuthService();
  
  bool _isLoading = false;
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  bool _acceptTerms = false;

  @override
  void dispose() {
    _fullNameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _register() async {
    if (!_formKey.currentState!.validate()) return;
    
    if (!_acceptTerms) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Kullanım koşullarını kabul etmelisiniz'),
          backgroundColor: AppColors.warning,
        ),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      await _authService.registerWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text,
        fullName: _fullNameController.text.trim(),
        phone: _phoneController.text.trim(),
      );
      
      if (mounted) {
        Navigator.of(context).pop(true);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(e.toString()),
            backgroundColor: AppColors.error,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  // Responsive breakpoints
  bool _isMobile(double width) => width < 768;
  bool _isTablet(double width) => width >= 768 && width < 1024;
  bool _isDesktop(double width) => width >= 1024 && width < 1440;
  bool _isLargeDesktop(double width) => width >= 1440;

  // Responsive values
  double _getResponsivePadding(double width) {
    if (_isMobile(width)) return 16;
    if (_isTablet(width)) return 24;
    if (_isDesktop(width)) return 32;
    return 48; // Large desktop
  }

  double _getResponsiveFontSize(double width, double baseFontSize) {
    if (_isMobile(width)) return baseFontSize;
    if (_isTablet(width)) return baseFontSize * 1.1;
    if (_isDesktop(width)) return baseFontSize * 1.2;
    return baseFontSize * 1.3; // Large desktop
  }

  double _getFormMaxWidth(double width) {
    if (_isMobile(width)) return double.infinity;
    if (_isTablet(width)) return 450;
    if (_isDesktop(width)) return 500;
    return 550; // Large desktop
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final screenWidth = MediaQuery.of(context).size.width;
    
    return Scaffold(
      backgroundColor: AppColors.white,
      body: SafeArea(
        child: _isMobile(screenWidth) 
            ? _buildMobileLayout(screenWidth) 
            : _buildDesktopLayout(screenWidth),
      ),
    );
  }

  Widget _buildMobileLayout(double screenWidth) {
    final padding = _getResponsivePadding(screenWidth);
    
    return SingleChildScrollView(
      child: Column(
        children: [
          // Header with close button
          Container(
            padding: EdgeInsets.all(padding),
            child: Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () => Navigator.of(context).pop(),
                ),
                const Spacer(),
                Text(
                  'ClinicAdvisor',
                  style: TextStyle(
                    fontSize: _getResponsiveFontSize(screenWidth, 18),
                    fontWeight: FontWeight.bold,
                    color: AppColors.primary,
                  ),
                ),
                const Spacer(),
                const SizedBox(width: 48),
              ],
            ),
          ),
          
          // Hero Section
          Container(
            padding: EdgeInsets.symmetric(
              horizontal: padding, 
              vertical: padding * 1.5,
            ),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  AppColors.secondary,
                  AppColors.accent,
                ],
              ),
            ),
            child: Column(
              children: [
                Icon(
                  Icons.person_add,
                  size: _getResponsiveFontSize(screenWidth, 60),
                  color: AppColors.white,
                ),
                SizedBox(height: padding),
                Text(
                  'Hemen Başlayın!',
                  style: TextStyle(
                    fontSize: _getResponsiveFontSize(screenWidth, 28),
                    fontWeight: FontWeight.bold,
                    color: AppColors.white,
                  ),
                ),
                SizedBox(height: padding / 2),
                Text(
                  'Ücretsiz hesap oluşturun ve en iyi sağlık hizmetlerine ulaşın',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: _getResponsiveFontSize(screenWidth, 16),
                    color: AppColors.white.withOpacity(0.9),
                  ),
                ),
                SizedBox(height: padding),
                
                // Benefits
                Wrap(
                  spacing: padding / 2,
                  runSpacing: padding / 2,
                  children: [
                    _buildFeatureBadge(Icons.search, 'Kolay Arama', screenWidth),
                    _buildFeatureBadge(Icons.compare, 'Fiyat Karşılaştır', screenWidth),
                    _buildFeatureBadge(Icons.star, 'Güvenilir', screenWidth),
                  ],
                ),
              ],
            ),
          ),
          
          // Form Section
          Container(
            padding: EdgeInsets.all(padding),
            constraints: BoxConstraints(
              maxWidth: _getFormMaxWidth(screenWidth),
            ),
            child: _buildRegisterForm(screenWidth),
          ),
        ],
      ),
    );
  }

  Widget _buildDesktopLayout(double screenWidth) {
    final padding = _getResponsivePadding(screenWidth);
    final isUltraWide = _isLargeDesktop(screenWidth);
    
    return Center(
      child: Container(
        constraints: BoxConstraints(
          maxWidth: isUltraWide ? 1600 : 1200,
          maxHeight: 900,
        ),
        margin: EdgeInsets.symmetric(
          horizontal: padding,
          vertical: padding / 2,
        ),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 20,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        clipBehavior: Clip.antiAlias,
        child: Row(
          children: [
            // Left side - Visual content
            Expanded(
              flex: _isTablet(screenWidth) ? 1 : 3,
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      AppColors.secondary,
                      AppColors.accent,
                    ],
                  ),
                ),
                child: Padding(
                  padding: EdgeInsets.all(padding),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(
                        Icons.person_add,
                        size: _getResponsiveFontSize(screenWidth, 80),
                        color: AppColors.white,
                      ),
                      SizedBox(height: padding),
                      Text(
                        'Sağlık Yolculuğunuza\nBaşlayın',
                        style: TextStyle(
                          fontSize: _getResponsiveFontSize(screenWidth, 42),
                          fontWeight: FontWeight.bold,
                          color: AppColors.white,
                          height: 1.2,
                        ),
                      ),
                      SizedBox(height: padding / 1.5),
                      Text(
                        'Ücretsiz hesabınızı oluşturun ve binlerce klinik arasından size en uygun olanı bulun. Fiyatları karşılaştırın, yorumları okuyun ve güvenle randevu alın.',
                        style: TextStyle(
                          fontSize: _getResponsiveFontSize(screenWidth, 18),
                          color: AppColors.white.withOpacity(0.9),
                          height: 1.6,
                        ),
                      ),
                      SizedBox(height: padding * 1.5),
                      
                      // Why choose us - Hide on tablet for space
                      if (!_isTablet(screenWidth)) ...[
                        Column(
                          children: [
                            _buildFeature(Icons.shield_outlined, 'Güvenli ve Hızlı', 'SSL şifrelemesi ile korunan hesap bilgileriniz', screenWidth),
                            _buildFeature(Icons.verified_user, 'Doğrulanmış Klinikler', 'Sadece lisanslı ve güvenilir sağlık kuruluşları', screenWidth),
                            _buildFeature(Icons.price_check, 'Şeffaf Fiyatlar', 'Gizli maliyet yok, net fiyat bilgileri', screenWidth),
                            _buildFeature(Icons.support_agent, '7/24 Destek', 'Her zaman yanınızdayız, yardım için buradayız', screenWidth),
                          ],
                        ),
                        SizedBox(height: padding * 1.5),
                      ],
                      
                      // Success stats
                      Container(
                        padding: EdgeInsets.all(padding / 1.5),
                        decoration: BoxDecoration(
                          color: AppColors.white.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Wrap(
                          spacing: padding,
                          runSpacing: padding / 2,
                          children: [
                            _buildSuccessStat('98%', 'Memnuniyet', screenWidth),
                            _buildSuccessStat('24sa', 'Ortalama Yanıt', screenWidth),
                            _buildSuccessStat('50K+', 'Mutlu Hasta', screenWidth),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            
            // Right side - Register form
            Expanded(
              flex: _isTablet(screenWidth) ? 1 : 2,
              child: Container(
                color: AppColors.white,
                child: Center(
                  child: SingleChildScrollView(
                    padding: EdgeInsets.all(padding),
                    child: Container(
                      constraints: BoxConstraints(
                        maxWidth: _getFormMaxWidth(screenWidth),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Hesap Oluşturun',
                            style: TextStyle(
                              fontSize: _getResponsiveFontSize(screenWidth, 32),
                              fontWeight: FontWeight.bold,
                              color: AppColors.primary,
                            ),
                          ),
                          SizedBox(height: padding / 4),
                          Text(
                            'Birkaç dakikada ücretsiz hesabınızı oluşturun',
                            style: TextStyle(
                              fontSize: _getResponsiveFontSize(screenWidth, 16),
                              color: AppColors.grey,
                            ),
                          ),
                          SizedBox(height: padding * 1.5),
                          _buildRegisterForm(screenWidth),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRegisterForm(double screenWidth) {
    final padding = _getResponsivePadding(screenWidth);
    final fontSize = _getResponsiveFontSize(screenWidth, 16);
    
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Full name field
          Container(
            decoration: BoxDecoration(
              color: AppColors.grey.withOpacity(0.05),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: AppColors.grey.withOpacity(0.1),
              ),
            ),
            child: TextFormField(
              controller: _fullNameController,
              textInputAction: TextInputAction.next,
              textCapitalization: TextCapitalization.words,
              style: TextStyle(fontSize: fontSize),
              decoration: InputDecoration(
                labelText: 'Ad Soyad',
                hintText: 'Ahmet Yılmaz',
                prefixIcon: Container(
                  margin: const EdgeInsets.all(12),
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: AppColors.secondary.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    Icons.person_outline,
                    color: AppColors.secondary,
                    size: 20,
                  ),
                ),
                border: InputBorder.none,
                contentPadding: EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: _isMobile(screenWidth) ? 20 : 24,
                ),
                labelStyle: TextStyle(
                  color: AppColors.grey,
                  fontSize: fontSize,
                ),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Ad soyad gerekli';
                }
                if (value.trim().length < 2) {
                  return 'Ad soyad en az 2 karakter olmalı';
                }
                return null;
              },
            ),
          ),
          
          SizedBox(height: padding),
          
          // Email field
          Container(
            decoration: BoxDecoration(
              color: AppColors.grey.withOpacity(0.05),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: AppColors.grey.withOpacity(0.1),
              ),
            ),
            child: TextFormField(
              controller: _emailController,
              keyboardType: TextInputType.emailAddress,
              textInputAction: TextInputAction.next,
              style: TextStyle(fontSize: fontSize),
              decoration: InputDecoration(
                labelText: 'Email Adresi',
                hintText: 'ornek@email.com',
                prefixIcon: Container(
                  margin: const EdgeInsets.all(12),
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: AppColors.accent.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    Icons.email_outlined,
                    color: AppColors.accent,
                    size: 20,
                  ),
                ),
                border: InputBorder.none,
                contentPadding: EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: _isMobile(screenWidth) ? 20 : 24,
                ),
                labelStyle: TextStyle(
                  color: AppColors.grey,
                  fontSize: fontSize,
                ),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Email adresi gerekli';
                }
                if (!value.contains('@')) {
                  return 'Geçerli bir email adresi girin';
                }
                return null;
              },
            ),
          ),
          
          SizedBox(height: padding),
          
          // Phone field
          Container(
            decoration: BoxDecoration(
              color: AppColors.grey.withOpacity(0.05),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: AppColors.grey.withOpacity(0.1),
              ),
            ),
            child: TextFormField(
              controller: _phoneController,
              keyboardType: TextInputType.phone,
              textInputAction: TextInputAction.next,
              style: TextStyle(fontSize: fontSize),
              decoration: InputDecoration(
                labelText: 'Telefon Numarası',
                hintText: '0555 123 45 67',
                prefixIcon: Container(
                  margin: const EdgeInsets.all(12),
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: AppColors.success.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    Icons.phone_outlined,
                    color: AppColors.success,
                    size: 20,
                  ),
                ),
                border: InputBorder.none,
                contentPadding: EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: _isMobile(screenWidth) ? 20 : 24,
                ),
                labelStyle: TextStyle(
                  color: AppColors.grey,
                  fontSize: fontSize,
                ),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Telefon numarası gerekli';
                }
                if (value.length < 10) {
                  return 'Geçerli bir telefon numarası girin';
                }
                return null;
              },
            ),
          ),
          
          SizedBox(height: padding),
          
          // Password field
          Container(
            decoration: BoxDecoration(
              color: AppColors.grey.withOpacity(0.05),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: AppColors.grey.withOpacity(0.1),
              ),
            ),
            child: TextFormField(
              controller: _passwordController,
              obscureText: _obscurePassword,
              textInputAction: TextInputAction.next,
              style: TextStyle(fontSize: fontSize),
              decoration: InputDecoration(
                labelText: 'Şifre',
                hintText: 'En az 6 karakter',
                prefixIcon: Container(
                  margin: const EdgeInsets.all(12),
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: AppColors.warning.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    Icons.lock_outline,
                    color: AppColors.warning,
                    size: 20,
                  ),
                ),
                suffixIcon: IconButton(
                  icon: Icon(
                    _obscurePassword ? Icons.visibility_off : Icons.visibility,
                    color: AppColors.grey,
                  ),
                  onPressed: () {
                    setState(() => _obscurePassword = !_obscurePassword);
                  },
                ),
                border: InputBorder.none,
                contentPadding: EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: _isMobile(screenWidth) ? 20 : 24,
                ),
                labelStyle: TextStyle(
                  color: AppColors.grey,
                  fontSize: fontSize,
                ),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Şifre gerekli';
                }
                if (value.length < 6) {
                  return 'Şifre en az 6 karakter olmalı';
                }
                return null;
              },
            ),
          ),
          
          SizedBox(height: padding),
          
          // Confirm password field
          Container(
            decoration: BoxDecoration(
              color: AppColors.grey.withOpacity(0.05),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: AppColors.grey.withOpacity(0.1),
              ),
            ),
            child: TextFormField(
              controller: _confirmPasswordController,
              obscureText: _obscureConfirmPassword,
              textInputAction: TextInputAction.done,
              style: TextStyle(fontSize: fontSize),
              decoration: InputDecoration(
                labelText: 'Şifre Tekrar',
                hintText: 'Şifrenizi tekrar girin',
                prefixIcon: Container(
                  margin: const EdgeInsets.all(12),
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    Icons.lock_outline,
                    color: AppColors.primary,
                    size: 20,
                  ),
                ),
                suffixIcon: IconButton(
                  icon: Icon(
                    _obscureConfirmPassword ? Icons.visibility_off : Icons.visibility,
                    color: AppColors.grey,
                  ),
                  onPressed: () {
                    setState(() => _obscureConfirmPassword = !_obscureConfirmPassword);
                  },
                ),
                border: InputBorder.none,
                contentPadding: EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: _isMobile(screenWidth) ? 20 : 24,
                ),
                labelStyle: TextStyle(
                  color: AppColors.grey,
                  fontSize: fontSize,
                ),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Şifre tekrarı gerekli';
                }
                if (value != _passwordController.text) {
                  return 'Şifreler eşleşmiyor';
                }
                return null;
              },
              onFieldSubmitted: (_) => _register(),
            ),
          ),
          
          SizedBox(height: padding),
          
          // Terms checkbox
          Container(
            padding: EdgeInsets.all(padding),
            decoration: BoxDecoration(
              color: AppColors.grey.withOpacity(0.05),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                Checkbox(
                  value: _acceptTerms,
                  onChanged: (value) {
                    setState(() => _acceptTerms = value ?? false);
                  },
                  activeColor: AppColors.primary,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      setState(() => _acceptTerms = !_acceptTerms);
                    },
                    child: RichText(
                      text: TextSpan(
                        style: TextStyle(
                          color: AppColors.grey,
                          fontSize: fontSize - 2,
                        ),
                        children: [
                          TextSpan(text: 'Hesap oluşturarak '),
                          TextSpan(
                            text: 'Kullanım Koşulları',
                            style: TextStyle(
                              color: AppColors.primary,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          TextSpan(text: ' ve '),
                          TextSpan(
                            text: 'Gizlilik Politikası',
                            style: TextStyle(
                              color: AppColors.primary,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          TextSpan(text: '\'nı kabul etmiş olursunuz.'),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          
          SizedBox(height: padding * 1.5),
          
          // Register button
          Container(
            height: _isMobile(screenWidth) ? 56 : 64,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [AppColors.secondary, AppColors.accent],
              ),
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: AppColors.secondary.withOpacity(0.3),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: ElevatedButton(
              onPressed: _isLoading ? null : _register,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.transparent,
                shadowColor: Colors.transparent,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
              child: _isLoading
                  ? const SizedBox(
                      width: 24,
                      height: 24,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(AppColors.white),
                      ),
                    )
                  : Text(
                      'Hesap Oluştur',
                      style: TextStyle(
                        color: AppColors.white,
                        fontSize: _getResponsiveFontSize(screenWidth, 18),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
            ),
          ),
          
          SizedBox(height: padding),
          
          // Divider
          Row(
            children: [
              Expanded(
                child: Divider(
                  color: AppColors.grey.withOpacity(0.3),
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: padding),
                child: Text(
                  'veya',
                  style: TextStyle(
                    color: AppColors.grey,
                    fontSize: fontSize - 2,
                  ),
                ),
              ),
              Expanded(
                child: Divider(
                  color: AppColors.grey.withOpacity(0.3),
                ),
              ),
            ],
          ),
          
          SizedBox(height: padding),
          
          // Login link
          Container(
            padding: EdgeInsets.all(padding),
            decoration: BoxDecoration(
              color: AppColors.grey.withOpacity(0.05),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: AppColors.grey.withOpacity(0.1),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Zaten hesabınız var mı? ',
                  style: TextStyle(
                    color: AppColors.grey,
                    fontSize: fontSize,
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.of(context).pushReplacement(
                      MaterialPageRoute(
                        builder: (context) => const LoginScreen(),
                      ),
                    );
                  },
                  child: Text(
                    'Giriş Yapın',
                    style: TextStyle(
                      color: AppColors.primary,
                      fontSize: fontSize,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
          
          SizedBox(height: padding),
          
          // Security note
          Container(
            padding: EdgeInsets.all(padding),
            decoration: BoxDecoration(
              color: AppColors.success.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.security,
                  color: AppColors.success,
                  size: 20,
                ),
                SizedBox(width: padding / 2),
                Expanded(
                  child: Text(
                    'Bilgileriniz SSL şifrelemesi ile korunmaktadır',
                    style: TextStyle(
                      color: AppColors.success,
                      fontSize: fontSize - 4,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFeatureBadge(IconData icon, String label, double screenWidth) {
    final fontSize = _getResponsiveFontSize(screenWidth, 10);
    
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: _isMobile(screenWidth) ? 12 : 16, 
        vertical: 8,
      ),
      decoration: BoxDecoration(
        color: AppColors.white.withOpacity(0.2),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          Icon(
            icon,
            color: AppColors.white,
            size: 20,
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              color: AppColors.white,
              fontSize: fontSize,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFeature(IconData icon, String title, String description, double screenWidth) {
    final padding = _getResponsivePadding(screenWidth);
    final fontSize = _getResponsiveFontSize(screenWidth, 16);
    
    return Padding(
      padding: EdgeInsets.only(bottom: padding),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: AppColors.white.withOpacity(0.15),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              icon,
              color: AppColors.white,
              size: 24,
            ),
          ),
          SizedBox(width: padding),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    color: AppColors.white,
                    fontSize: fontSize,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  description,
                  style: TextStyle(
                    color: AppColors.white.withOpacity(0.8),
                    fontSize: fontSize - 2,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSuccessStat(String number, String label, double screenWidth) {
    final fontSize = _getResponsiveFontSize(screenWidth, 20);
    
    return Column(
      children: [
        Text(
          number,
          style: TextStyle(
            color: AppColors.white,
            fontSize: fontSize,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          label,
          style: TextStyle(
            color: AppColors.white.withOpacity(0.8),
            fontSize: fontSize - 8,
          ),
        ),
      ],
    );
  }
} 