import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../l10n/generated/app_localizations.dart';
import '../../../shared/widgets/clinic_card.dart';
import '../../../shared/widgets/treatment_card.dart';
import '../../../shared/services/firestore_service.dart';
import '../../../shared/services/auth_service.dart';
import '../../auth/screens/login_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final FirestoreService _firestoreService = FirestoreService();
  final AuthService _authService = AuthService();
  List<Map<String, dynamic>> popularClinics = [];
  List<Map<String, dynamic>> popularTreatments = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    try {
      final clinics = await _firestoreService.getPopularClinics();
      final treatments = await _firestoreService.getPopularTreatments();
      
      setState(() {
        popularClinics = clinics;
        popularTreatments = treatments;
        isLoading = false;
      });
    } catch (e) {
      debugPrint('Error loading data: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth < 768;
    
    return Scaffold(
      backgroundColor: AppColors.white,
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: _loadData,
              child: CustomScrollView(
                slivers: [
                  // Custom App Bar
                  SliverAppBar(
                    floating: true,
                    snap: true,
                    backgroundColor: AppColors.white,
                    foregroundColor: AppColors.primary,
                    elevation: 0,
                    pinned: true,
                    expandedHeight: 0,
                    flexibleSpace: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      child: Row(
                        children: [
                          // Logo
                          Row(
                            children: [
                              Container(
                                width: 32,
                                height: 32,
                                decoration: BoxDecoration(
                                  color: AppColors.primary,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: const Icon(
                                  Icons.local_hospital,
                                  color: AppColors.white,
                                  size: 20,
                                ),
                              ),
                              const SizedBox(width: 8),
                              Text(
                                'ClinicAdvisor',
                                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.primary,
                                ),
                              ),
                            ],
                          ),
                          const Spacer(),
                          // Top actions
                          Row(
                            children: [
                              IconButton(
                                icon: const Icon(Icons.notifications_outlined),
                                onPressed: () {},
                              ),
                              if (_authService.isLoggedIn)
                                IconButton(
                                  icon: const Icon(Icons.account_circle),
                                  onPressed: () {},
                                )
                              else
                                TextButton(
                                  onPressed: () {
                                    Navigator.of(context).push(
                                      MaterialPageRoute(
                                        builder: (context) => const LoginScreen(),
                                      ),
                                    );
                                  },
                                  child: const Text('Giriş Yap'),
                                ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  
                  // Hero Section
                  SliverToBoxAdapter(
                    child: Container(
                      width: double.infinity,
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
                          SizedBox(height: isMobile ? 40 : 60),
                          // Hero Content
                          Center(
                            child: Container(
                              constraints: BoxConstraints(
                                maxWidth: isMobile ? double.infinity : 1200,
                              ),
                              padding: EdgeInsets.symmetric(
                                horizontal: isMobile ? 24 : 48,
                              ),
                              child: Column(
                                children: [
                                  Text(
                                    'Türkiye\'nin En Büyük\nSağlık Pazaryeri',
                                    textAlign: TextAlign.center,
                                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                                      color: AppColors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: isMobile ? 28 : 42,
                                    ),
                                  ),
                                  const SizedBox(height: 16),
                                  Text(
                                    'Binlerce klinik arasından en uygun olanı bul,\nfiyatları karşılaştır ve hemen randevu al!',
                                    textAlign: TextAlign.center,
                                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                                      color: AppColors.white.withOpacity(0.9),
                                      fontSize: isMobile ? 16 : 18,
                                    ),
                                  ),
                                  SizedBox(height: isMobile ? 32 : 48),
                                  
                                  // Search Bar
                                  Container(
                                    constraints: BoxConstraints(
                                      maxWidth: isMobile ? double.infinity : 600,
                                    ),
                                    padding: const EdgeInsets.all(4),
                                    decoration: BoxDecoration(
                                      color: AppColors.white,
                                      borderRadius: BorderRadius.circular(12),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black.withOpacity(0.1),
                                          blurRadius: 10,
                                          offset: const Offset(0, 4),
                                        ),
                                      ],
                                    ),
                                    child: Row(
                                      children: [
                                        Expanded(
                                          child: TextField(
                                            decoration: InputDecoration(
                                              hintText: 'Klinik, tedavi veya doktor ara...',
                                              border: InputBorder.none,
                                              prefixIcon: const Icon(Icons.search),
                                              contentPadding: const EdgeInsets.symmetric(
                                                horizontal: 16,
                                                vertical: 12,
                                              ),
                                            ),
                                          ),
                                        ),
                                        Container(
                                          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                                          decoration: BoxDecoration(
                                            color: AppColors.primary,
                                            borderRadius: BorderRadius.circular(8),
                                          ),
                                          child: Text(
                                            'Ara',
                                            style: TextStyle(
                                              color: AppColors.white,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  
                                  SizedBox(height: isMobile ? 32 : 48),
                                  
                                  // Quick Stats
                                  Container(
                                    constraints: BoxConstraints(
                                      maxWidth: isMobile ? double.infinity : 800,
                                    ),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                      children: [
                                        _buildStatCard('500+', 'Klinik'),
                                        _buildStatCard('1000+', 'Doktor'),
                                        _buildStatCard('50K+', 'Hasta'),
                                        _buildStatCard('4.8', 'Puan'),
                                      ],
                                    ),
                                  ),
                                  
                                  SizedBox(height: isMobile ? 40 : 60),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  
                  // Categories Section
                  SliverToBoxAdapter(
                    child: Container(
                      padding: EdgeInsets.all(isMobile ? 24 : 32),
                      child: Center(
                        child: Container(
                          constraints: BoxConstraints(
                            maxWidth: isMobile ? double.infinity : 1200,
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Popüler Kategoriler',
                                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(height: isMobile ? 16 : 24),
                              GridView.count(
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                crossAxisCount: isMobile ? 2 : (screenWidth > 1200 ? 4 : 3),
                                mainAxisSpacing: isMobile ? 16 : 24,
                                crossAxisSpacing: isMobile ? 16 : 24,
                                childAspectRatio: isMobile ? 1.2 : 1.1,
                                children: [
                                  _buildCategoryCard(
                                    'Diş Hekimliği',
                                    Icons.local_hospital,
                                    AppColors.primary,
                                    '150+ Klinik',
                                  ),
                                  _buildCategoryCard(
                                    'Estetik',
                                    Icons.face_retouching_natural,
                                    AppColors.accent,
                                    '89+ Klinik',
                                  ),
                                  _buildCategoryCard(
                                    'Göz Hastalıkları',
                                    Icons.remove_red_eye,
                                    AppColors.success,
                                    '65+ Klinik',
                                  ),
                                  _buildCategoryCard(
                                    'Dermatoloji',
                                    Icons.healing,
                                    AppColors.warning,
                                    '78+ Klinik',
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  
                  // Featured Clinics Section
                  SliverToBoxAdapter(
                    child: Container(
                      padding: EdgeInsets.symmetric(vertical: isMobile ? 24 : 32),
                      color: AppColors.grey.withOpacity(0.03),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Center(
                            child: Container(
                              constraints: BoxConstraints(
                                maxWidth: isMobile ? double.infinity : 1200,
                              ),
                              padding: EdgeInsets.symmetric(horizontal: isMobile ? 24 : 32),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Öne Çıkan Klinikler',
                                        style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        'En çok tercih edilen ve güvenilir klinikler',
                                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                          color: AppColors.grey,
                                        ),
                                      ),
                                    ],
                                  ),
                                  TextButton(
                                    onPressed: () {},
                                    child: Text('Tümünü Gör'),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          SizedBox(height: isMobile ? 16 : 24),
                          popularClinics.isEmpty
                              ? SizedBox(
                                  height: 200,
                                  child: Center(
                                    child: Text(l10n.noResultsFound),
                                  ),
                                )
                              : isMobile
                                  ? SizedBox(
                                      height: 320,
                                      child: ListView.builder(
                                        scrollDirection: Axis.horizontal,
                                        padding: EdgeInsets.symmetric(horizontal: 16),
                                        itemCount: popularClinics.length,
                                        itemBuilder: (context, index) {
                                          return Padding(
                                            padding: EdgeInsets.only(left: 8, right: 8),
                                            child: SizedBox(
                                              width: 280,
                                              child: ClinicCard(clinic: popularClinics[index]),
                                            ),
                                          );
                                        },
                                      ),
                                    )
                                  : GridView.builder(
                                      shrinkWrap: true,
                                      physics: const NeverScrollableScrollPhysics(),
                                      padding: EdgeInsets.symmetric(horizontal: 24),
                                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                        crossAxisCount: screenWidth > 1400 ? 4 : 3,
                                        childAspectRatio: 0.75,
                                        mainAxisSpacing: 24,
                                        crossAxisSpacing: 24,
                                      ),
                                      itemCount: popularClinics.length > (screenWidth > 1400 ? 8 : 6) 
                                          ? (screenWidth > 1400 ? 8 : 6) 
                                          : popularClinics.length,
                                      itemBuilder: (context, index) {
                                        return ClinicCard(clinic: popularClinics[index]);
                                      },
                                    ),
                        ],
                      ),
                    ),
                  ),
                  
                  // How It Works Section
                  SliverToBoxAdapter(
                    child: Container(
                      padding: EdgeInsets.all(isMobile ? 24 : 32),
                      child: Center(
                        child: Container(
                          constraints: BoxConstraints(
                            maxWidth: isMobile ? double.infinity : 1000,
                          ),
                          child: Column(
                            children: [
                              Text(
                                'Nasıl Çalışır?',
                                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(height: isMobile ? 32 : 48),
                              isMobile 
                                ? Column(
                                    children: [
                                      _buildStepCard(
                                        '1',
                                        'Ara',
                                        'İhtiyacınız olan tedavi\nveya kliniği arayın',
                                        Icons.search,
                                      ),
                                      SizedBox(height: 24),
                                      _buildStepCard(
                                        '2',
                                        'Karşılaştır',
                                        'Fiyatları ve yorumları\nkarşılaştırın',
                                        Icons.compare_arrows,
                                      ),
                                      SizedBox(height: 24),
                                      _buildStepCard(
                                        '3',
                                        'Randevu Al',
                                        'En uygun kliniği seçin\nve randevu alın',
                                        Icons.calendar_today,
                                      ),
                                    ],
                                  )
                                : Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                    children: [
                                      _buildStepCard(
                                        '1',
                                        'Ara',
                                        'İhtiyacınız olan tedavi\nveya kliniği arayın',
                                        Icons.search,
                                      ),
                                      _buildStepCard(
                                        '2',
                                        'Karşılaştır',
                                        'Fiyatları ve yorumları\nkarşılaştırın',
                                        Icons.compare_arrows,
                                      ),
                                      _buildStepCard(
                                        '3',
                                        'Randevu Al',
                                        'En uygun kliniği seçin\nve randevu alın',
                                        Icons.calendar_today,
                                      ),
                                    ],
                                  ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  
                  // Popular Treatments Section
                  SliverToBoxAdapter(
                    child: Container(
                      padding: EdgeInsets.all(isMobile ? 24 : 32),
                      child: Center(
                        child: Container(
                          constraints: BoxConstraints(
                            maxWidth: isMobile ? double.infinity : 1200,
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Popüler Tedaviler',
                                        style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        'En çok aranan tedavi seçenekleri',
                                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                          color: AppColors.grey,
                                        ),
                                      ),
                                    ],
                                  ),
                                  TextButton(
                                    onPressed: () {},
                                    child: Text('Tümünü Gör'),
                                  ),
                                ],
                              ),
                              SizedBox(height: isMobile ? 16 : 24),
                              popularTreatments.isEmpty
                                  ? SizedBox(
                                      height: 200,
                                      child: Center(
                                        child: Text(l10n.noResultsFound),
                                      ),
                                    )
                                  : isMobile
                                      ? SizedBox(
                                          height: 240,
                                          child: ListView.builder(
                                            scrollDirection: Axis.horizontal,
                                            padding: EdgeInsets.symmetric(horizontal: 0),
                                            itemCount: popularTreatments.length,
                                                                                          itemBuilder: (context, index) {
                                                return Padding(
                                                  padding: EdgeInsets.only(right: 16),
                                                  child: SizedBox(
                                                    width: 250,
                                                    child: TreatmentCard(treatment: popularTreatments[index]),
                                                  ),
                                                );
                                              },
                                          ),
                                        )
                                      : GridView.builder(
                                          shrinkWrap: true,
                                          physics: const NeverScrollableScrollPhysics(),
                                          padding: EdgeInsets.symmetric(horizontal: 0),
                                          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                            crossAxisCount: screenWidth > 1400 ? 5 : 4,
                                            childAspectRatio: 0.85,
                                            mainAxisSpacing: 20,
                                            crossAxisSpacing: 20,
                                          ),
                                          itemCount: popularTreatments.length > (screenWidth > 1400 ? 10 : 8) 
                                              ? (screenWidth > 1400 ? 10 : 8) 
                                              : popularTreatments.length,
                                          itemBuilder: (context, index) {
                                            return TreatmentCard(treatment: popularTreatments[index]);
                                          },
                                        ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  
                  // Testimonials Section
                  SliverToBoxAdapter(
                    child: Container(
                      padding: EdgeInsets.all(isMobile ? 24 : 32),
                      decoration: BoxDecoration(
                        color: AppColors.grey.withOpacity(0.03),
                      ),
                      child: Center(
                        child: Container(
                          constraints: BoxConstraints(
                            maxWidth: isMobile ? double.infinity : 1200,
                          ),
                          child: Column(
                            children: [
                              Text(
                                'Hasta Yorumları',
                                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(height: isMobile ? 16 : 20),
                              Text(
                                'Binlerce hasta deneyimlerini paylaşıyor',
                                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                  color: AppColors.grey,
                                ),
                              ),
                              SizedBox(height: isMobile ? 24 : 32),
                              SizedBox(
                                height: isMobile ? 200 : 240,
                                child: ListView.builder(
                                  scrollDirection: Axis.horizontal,
                                  padding: EdgeInsets.symmetric(horizontal: isMobile ? 0 : 8),
                                  itemCount: 3,
                                  itemBuilder: (context, index) {
                                    return Container(
                                      width: isMobile ? 300 : (screenWidth > 1200 ? 380 : 340),
                                      margin: EdgeInsets.only(right: isMobile ? 16 : 20),
                                      padding: EdgeInsets.all(isMobile ? 20 : 24),
                                      decoration: BoxDecoration(
                                        color: AppColors.white,
                                        borderRadius: BorderRadius.circular(12),
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.black.withOpacity(0.05),
                                            blurRadius: 10,
                                            offset: const Offset(0, 4),
                                          ),
                                        ],
                                      ),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            children: [
                                              CircleAvatar(
                                                radius: isMobile ? 20 : 24,
                                                backgroundColor: AppColors.primary,
                                                child: Text(
                                                  'A${index + 1}',
                                                  style: TextStyle(
                                                    color: AppColors.white,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                              ),
                                              const SizedBox(width: 12),
                                              Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    'Ahmet ${index + 1}',
                                                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                                      fontWeight: FontWeight.bold,
                                                    ),
                                                  ),
                                                  Row(
                                                    children: List.generate(5, (i) => Icon(
                                                      Icons.star,
                                                      color: AppColors.warning,
                                                      size: 16,
                                                    )),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                          const SizedBox(height: 16),
                                          Text(
                                            'Harika bir deneyim yaşadım. Klinik bulma sürecim çok kolay oldu ve randevu alma işlemi sorunsuzdu.',
                                            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                              color: AppColors.grey,
                                              height: 1.5,
                                            ),
                                          ),
                                        ],
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  
                  // CTA Section
                  SliverToBoxAdapter(
                    child: Container(
                      margin: EdgeInsets.all(isMobile ? 24 : 32),
                      child: Center(
                        child: Container(
                          constraints: BoxConstraints(
                            maxWidth: isMobile ? double.infinity : 800,
                          ),
                          padding: EdgeInsets.all(isMobile ? 32 : 48),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [AppColors.primary, AppColors.secondary],
                            ),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Column(
                            children: [
                              Text(
                                'Hemen Başlayın!',
                                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                                  color: AppColors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: isMobile ? 24 : 28,
                                ),
                              ),
                              SizedBox(height: isMobile ? 8 : 12),
                              Text(
                                'Binlerce klinik arasından size en uygun olanı bulun',
                                textAlign: TextAlign.center,
                                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                                  color: AppColors.white.withOpacity(0.9),
                                  fontSize: isMobile ? 16 : 18,
                                ),
                              ),
                              SizedBox(height: isMobile ? 24 : 32),
                              Wrap(
                                spacing: 16,
                                runSpacing: 12,
                                alignment: WrapAlignment.center,
                                children: [
                                  ElevatedButton(
                                    onPressed: () {},
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: AppColors.white,
                                      foregroundColor: AppColors.primary,
                                      padding: EdgeInsets.symmetric(
                                        horizontal: isMobile ? 32 : 40,
                                        vertical: isMobile ? 16 : 20,
                                      ),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                    ),
                                    child: Text(
                                      'Klinik Ara',
                                      style: TextStyle(
                                        fontSize: isMobile ? 16 : 18,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                  OutlinedButton(
                                    onPressed: () {},
                                    style: OutlinedButton.styleFrom(
                                      foregroundColor: AppColors.white,
                                      side: BorderSide(color: AppColors.white, width: 2),
                                      padding: EdgeInsets.symmetric(
                                        horizontal: isMobile ? 32 : 40,
                                        vertical: isMobile ? 16 : 20,
                                      ),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                    ),
                                    child: Text(
                                      'Tedavi Ara',
                                      style: TextStyle(
                                        fontSize: isMobile ? 16 : 18,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  
                  // Footer
                  SliverToBoxAdapter(
                    child: Container(
                      padding: EdgeInsets.all(isMobile ? 24 : 32),
                      color: AppColors.grey.withOpacity(0.05),
                      child: Center(
                        child: Container(
                          constraints: BoxConstraints(
                            maxWidth: isMobile ? double.infinity : 1000,
                          ),
                          child: Column(
                            children: [
                              isMobile 
                                ? Wrap(
                                    spacing: 32,
                                    runSpacing: 16,
                                    alignment: WrapAlignment.center,
                                    children: [
                                      _buildFooterStat('500+', 'Klinik'),
                                      _buildFooterStat('1000+', 'Doktor'),
                                      _buildFooterStat('50K+', 'Hasta'),
                                      _buildFooterStat('4.8', 'Ortalama Puan'),
                                    ],
                                  )
                                : Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                    children: [
                                      _buildFooterStat('500+', 'Klinik'),
                                      _buildFooterStat('1000+', 'Doktor'),
                                      _buildFooterStat('50K+', 'Hasta'),
                                      _buildFooterStat('4.8', 'Ortalama Puan'),
                                    ],
                                  ),
                              SizedBox(height: isMobile ? 24 : 32),
                              Text(
                                '© 2024 ClinicAdvisor. Tüm hakları saklıdır.',
                                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                  color: AppColors.grey,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        selectedItemColor: AppColors.primary,
        unselectedItemColor: AppColors.grey,
        items: [
          BottomNavigationBarItem(
            icon: const Icon(Icons.home),
            label: l10n.home,
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.search),
            label: l10n.search,
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.calendar_today),
            label: l10n.appointments,
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.person),
            label: l10n.profile,
          ),
        ],
        currentIndex: 0,
        onTap: (index) {
          // TODO: Handle navigation
        },
      ),
    );
  }
  
  Widget _buildStatCard(String number, String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: AppColors.white.withOpacity(0.2),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        children: [
          Text(
            number,
            style: TextStyle(
              color: AppColors.white,
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
          Text(
            label,
            style: TextStyle(
              color: AppColors.white.withOpacity(0.8),
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildCategoryCard(String title, IconData icon, Color color, String subtitle) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.2)),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            color: color,
            size: 32,
          ),
          const SizedBox(height: 8),
          Text(
            title,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            subtitle,
            style: TextStyle(
              color: AppColors.grey,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildStepCard(String number, String title, String description, IconData icon) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                color: AppColors.primary,
                borderRadius: BorderRadius.circular(30),
              ),
              child: Icon(
                icon,
                color: AppColors.white,
                size: 24,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              title,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              description,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: AppColors.grey,
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }
  
  Widget _buildFooterStat(String number, String label) {
    return Column(
      children: [
        Text(
          number,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 24,
            color: AppColors.primary,
          ),
        ),
        Text(
          label,
          style: TextStyle(
            color: AppColors.grey,
            fontSize: 12,
          ),
        ),
      ],
    );
  }
} 