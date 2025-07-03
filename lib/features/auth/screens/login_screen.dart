import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../l10n/generated/app_localizations.dart';
import '../../../shared/services/auth_service.dart';
import 'register_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _authService = AuthService();
  
  bool _isLoading = false;
  bool _obscurePassword = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _login() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      await _authService.signInWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text,
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

  Future<void> _forgotPassword() async {
    final email = _emailController.text.trim();
    if (email.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Lütfen email adresinizi girin'),
          backgroundColor: AppColors.warning,
        ),
      );
      return;
    }

    try {
      await _authService.resetPassword(email);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Şifre sıfırlama emaili gönderildi'),
            backgroundColor: AppColors.success,
          ),
        );
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
    if (_isTablet(width)) return 400;
    if (_isDesktop(width)) return 450;
    return 500; // Large desktop
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    
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
                  AppColors.primary,
                  AppColors.secondary,
                ],
              ),
            ),
            child: Column(
              children: [
                Icon(
                  Icons.local_hospital,
                  size: _getResponsiveFontSize(screenWidth, 60),
                  color: AppColors.white,
                ),
                SizedBox(height: padding),
                Text(
                  'Hoş Geldiniz!',
                  style: TextStyle(
                    fontSize: _getResponsiveFontSize(screenWidth, 28),
                    fontWeight: FontWeight.bold,
                    color: AppColors.white,
                  ),
                ),
                SizedBox(height: padding / 2),
                Text(
                  'Binlerce klinik arasından size en uygun olanı bulmaya devam edin',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: _getResponsiveFontSize(screenWidth, 16),
                    color: AppColors.white.withOpacity(0.9),
                  ),
                ),
                SizedBox(height: padding),
                
                // Trust indicators
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _buildTrustBadge('500+', 'Klinik', screenWidth),
                    _buildTrustBadge('50K+', 'Hasta', screenWidth),
                    _buildTrustBadge('4.8★', 'Puan', screenWidth),
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
            child: _buildLoginForm(screenWidth),
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
                      AppColors.primary,
                      AppColors.secondary,
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
                        Icons.local_hospital,
                        size: _getResponsiveFontSize(screenWidth, 80),
                        color: AppColors.white,
                      ),
                      SizedBox(height: padding),
                      Text(
                        'Türkiye\'nin En Büyük\nSağlık Pazaryeri',
                        style: TextStyle(
                          fontSize: _getResponsiveFontSize(screenWidth, 42),
                          fontWeight: FontWeight.bold,
                          color: AppColors.white,
                          height: 1.2,
                        ),
                      ),
                      SizedBox(height: padding / 1.5),
                      Text(
                        'Binlerce klinik arasından size en uygun olanı bulun, fiyatları karşılaştırın ve güvenle randevu alın.',
                        style: TextStyle(
                          fontSize: _getResponsiveFontSize(screenWidth, 18),
                          color: AppColors.white.withOpacity(0.9),
                          height: 1.6,
                        ),
                      ),
                      SizedBox(height: padding * 1.5),
                      
                      // Benefits - Hide on tablet for space
                      if (!_isTablet(screenWidth)) ...[
                        Column(
                          children: [
                            _buildBenefit('Güvenilir klinikler ve doktorlar', screenWidth),
                            _buildBenefit('Şeffaf fiyat karşılaştırması', screenWidth),
                            _buildBenefit('Kolay randevu alma sistemi', screenWidth),
                            _buildBenefit('Gerçek hasta yorumları', screenWidth),
                          ],
                        ),
                        SizedBox(height: padding * 1.5),
                      ],
                      
                      // Stats
                      Wrap(
                        spacing: padding,
                        runSpacing: padding / 2,
                        children: [
                          _buildStatItem('500+', 'Klinik', screenWidth),
                          _buildStatItem('1000+', 'Doktor', screenWidth),
                          _buildStatItem('50K+', 'Hasta', screenWidth),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
            
            // Right side - Login form
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
                            'Giriş Yapın',
                            style: TextStyle(
                              fontSize: _getResponsiveFontSize(screenWidth, 32),
                              fontWeight: FontWeight.bold,
                              color: AppColors.primary,
                            ),
                          ),
                          SizedBox(height: padding / 4),
                          Text(
                            'Hesabınıza giriş yaparak devam edin',
                            style: TextStyle(
                              fontSize: _getResponsiveFontSize(screenWidth, 16),
                              color: AppColors.grey,
                            ),
                          ),
                          SizedBox(height: padding * 1.5),
                          _buildLoginForm(screenWidth),
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

  Widget _buildLoginForm(double screenWidth) {
    final padding = _getResponsivePadding(screenWidth);
    final fontSize = _getResponsiveFontSize(screenWidth, 16);
    
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
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
                    color: AppColors.primary.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    Icons.email_outlined,
                    color: AppColors.primary,
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
              textInputAction: TextInputAction.done,
              style: TextStyle(fontSize: fontSize),
              decoration: InputDecoration(
                labelText: 'Şifre',
                hintText: 'En az 6 karakter',
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
              onFieldSubmitted: (_) => _login(),
            ),
          ),
          
          SizedBox(height: padding / 2),
          
          // Forgot password
          Align(
            alignment: Alignment.centerRight,
            child: TextButton(
              onPressed: _forgotPassword,
              child: Text(
                'Şifremi Unuttum',
                style: TextStyle(
                  color: AppColors.primary,
                  fontWeight: FontWeight.w600,
                  fontSize: fontSize - 2,
                ),
              ),
            ),
          ),
          
          SizedBox(height: padding),
          
          // Login button
          Container(
            height: _isMobile(screenWidth) ? 56 : 64,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [AppColors.primary, AppColors.secondary],
              ),
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: AppColors.primary.withOpacity(0.3),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: ElevatedButton(
              onPressed: _isLoading ? null : _login,
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
                      'Giriş Yap',
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
          
          // Register link
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
                  'Hesabınız yok mu? ',
                  style: TextStyle(
                    color: AppColors.grey,
                    fontSize: fontSize,
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.of(context).pushReplacement(
                      MaterialPageRoute(
                        builder: (context) => const RegisterScreen(),
                      ),
                    );
                  },
                  child: Text(
                    'Hemen Kaydolun',
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
          
          // Trust indicators at bottom
          Text(
            '500+ klinik • 50K+ hasta • 4.8★ ortalama puan',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: AppColors.grey,
              fontSize: fontSize - 4,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTrustBadge(String number, String label, double screenWidth) {
    final fontSize = _getResponsiveFontSize(screenWidth, 16);
    
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: _isMobile(screenWidth) ? 12 : 16, 
        vertical: 8,
      ),
      decoration: BoxDecoration(
        color: AppColors.white.withOpacity(0.2),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        children: [
          Text(
            number,
            style: TextStyle(
              color: AppColors.white,
              fontWeight: FontWeight.bold,
              fontSize: fontSize,
            ),
          ),
          Text(
            label,
            style: TextStyle(
              color: AppColors.white.withOpacity(0.8),
              fontSize: fontSize - 6,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBenefit(String text, double screenWidth) {
    final fontSize = _getResponsiveFontSize(screenWidth, 16);
    
    return Padding(
      padding: EdgeInsets.only(bottom: _getResponsivePadding(screenWidth)),
      child: Row(
        children: [
          Container(
            width: 24,
            height: 24,
            decoration: BoxDecoration(
              color: AppColors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              Icons.check,
              color: AppColors.white,
              size: 16,
            ),
          ),
          SizedBox(width: _getResponsivePadding(screenWidth)),
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                color: AppColors.white,
                fontSize: fontSize,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem(String number, String label, double screenWidth) {
    final fontSize = _getResponsiveFontSize(screenWidth, 24);
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
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
            fontSize: fontSize - 10,
          ),
        ),
      ],
    );
  }
} 