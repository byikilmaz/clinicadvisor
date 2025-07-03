import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../l10n/generated/app_localizations.dart';
import '../../../shared/services/auth_service.dart';
import '../../auth/screens/login_screen.dart';

class TreatmentDetailScreen extends StatefulWidget {
  final Map<String, dynamic> treatment;

  const TreatmentDetailScreen({
    super.key,
    required this.treatment,
  });

  @override
  State<TreatmentDetailScreen> createState() => _TreatmentDetailScreenState();
}

class _TreatmentDetailScreenState extends State<TreatmentDetailScreen> {
  final AuthService _authService = AuthService();
  
  Future<void> _requireAuthentication(String action) async {
    if (!_authService.isLoggedIn) {
      // Show login required dialog
      final shouldLogin = await showDialog<bool>(
        context: context,
        builder: (context) => AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: const Text('Giriş Gerekli'),
          content: Text(
            '$action için giriş yapmanız gerekiyor. Hesabınız yoksa hemen kaydolabilirsiniz.',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text('İptal'),
            ),
            ElevatedButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: const Text('Giriş Yap'),
            ),
          ],
        ),
      );

      if (shouldLogin == true) {
        // Navigate to login screen
        final result = await Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => const LoginScreen(),
          ),
        );
        
        if (result == true) {
          // User logged in successfully, proceed with the action
          _performAction(action);
        }
      }
    } else {
      // User is already logged in
      _performAction(action);
    }
  }

  void _performAction(String action) {
    switch (action) {
      case 'Randevu Al':
        _bookAppointment();
        break;
      case 'Teklif Al':
        _getQuote();
        break;
      default:
        break;
    }
  }

  void _bookAppointment() {
    // TODO: Implement appointment booking
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Randevu alma sayfasına yönlendiriliyorsunuz...'),
        backgroundColor: AppColors.success,
      ),
    );
  }

  void _getQuote() {
    // TODO: Implement quote request
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Teklif alma sayfasına yönlendiriliyorsunuz...'),
        backgroundColor: AppColors.success,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    
    return Scaffold(
      backgroundColor: AppColors.white,
      body: CustomScrollView(
        slivers: [
          // App Bar with image
          SliverAppBar(
            expandedHeight: 250,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      AppColors.primary.withOpacity(0.8),
                      AppColors.accent.withOpacity(0.8),
                    ],
                  ),
                ),
                child: Stack(
                  children: [
                    // Background image
                    Container(
                      decoration: const BoxDecoration(
                        image: DecorationImage(
                          image: NetworkImage('https://via.placeholder.com/400x300'),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    // Overlay
                    Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Colors.transparent,
                            AppColors.primary.withOpacity(0.7),
                          ],
                        ),
                      ),
                    ),
                    // Content
                    Positioned(
                      bottom: 20,
                      left: 20,
                      right: 20,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                            decoration: BoxDecoration(
                              color: AppColors.white.withOpacity(0.9),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              widget.treatment['category'] ?? 'Genel',
                              style: const TextStyle(
                                color: AppColors.primary,
                                fontWeight: FontWeight.bold,
                                fontSize: 12,
                              ),
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            widget.treatment['name'] ?? 'Tedavi',
                            style: const TextStyle(
                              color: AppColors.white,
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
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
          
          // Content
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Quick info cards
                  Row(
                    children: [
                      Expanded(
                        child: _buildInfoCard(
                          icon: Icons.attach_money,
                          title: 'Ortalama Fiyat',
                          value: '${widget.treatment['averagePrice'] ?? 0} ₺',
                          color: AppColors.success,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _buildInfoCard(
                          icon: Icons.schedule,
                          title: 'Süre',
                          value: widget.treatment['duration'] ?? 'Belirtilmemiş',
                          color: AppColors.warning,
                        ),
                      ),
                    ],
                  ),
                  
                  const SizedBox(height: 12),
                  
                  Row(
                    children: [
                      Expanded(
                        child: _buildInfoCard(
                          icon: Icons.trending_up,
                          title: 'Popülerlik',
                          value: '${widget.treatment['popularity'] ?? 0}%',
                          color: AppColors.primary,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _buildInfoCard(
                          icon: Icons.local_hospital,
                          title: 'Klinik Sayısı',
                          value: '${widget.treatment['clinicCount'] ?? 0}',
                          color: AppColors.accent,
                        ),
                      ),
                    ],
                  ),
                  
                  const SizedBox(height: 24),
                  
                  // Description section
                  Text(
                    'Tedavi Hakkında',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    widget.treatment['description'] ?? 
                    'Bu tedavi hakkında detaylı bilgi için lütfen uzman doktorlarımızla iletişime geçin. '
                    'Kişiselleştirilmiş tedavi planı ve fiyat bilgisi almak için randevu alabilirsiniz.',
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: AppColors.grey,
                      height: 1.5,
                    ),
                  ),
                  
                  const SizedBox(height: 24),
                  
                  // Features section
                  Text(
                    'Tedavi Özellikleri',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 12),
                  
                  ..._buildFeaturesList(),
                  
                  const SizedBox(height: 24),
                  
                  // Process section
                  Text(
                    'Tedavi Süreci',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 12),
                  
                  ..._buildProcessSteps(),
                  
                  const SizedBox(height: 32),
                  
                  // Action buttons
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: () => _requireAuthentication('Teklif Al'),
                          icon: const Icon(Icons.request_quote),
                          label: const Text('Teklif Al'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.accent,
                            foregroundColor: AppColors.white,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: () => _requireAuthentication('Randevu Al'),
                          icon: const Icon(Icons.calendar_today),
                          label: const Text('Randevu Al'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primary,
                            foregroundColor: AppColors.white,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoCard({
    required IconData icon,
    required String title,
    required String value,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: color.withOpacity(0.3),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: color, size: 24),
          const SizedBox(height: 8),
          Text(
            title,
            style: TextStyle(
              color: AppColors.grey,
              fontSize: 12,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: TextStyle(
              color: color,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> _buildFeaturesList() {
    final features = [
      'Uzman doktor kontrolü',
      'Modern ekipman kullanımı',
      'Kişiselleştirilmiş tedavi planı',
      'Takip ve kontrol hizmetleri',
      'Güvenli ve hijyenik ortam',
    ];

    return features.map((feature) => Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Icon(
            Icons.check_circle,
            color: AppColors.success,
            size: 20,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              feature,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ),
        ],
      ),
    )).toList();
  }

  List<Widget> _buildProcessSteps() {
    final steps = [
      {'title': 'Konsültasyon', 'description': 'Uzman doktor ile ilk görüşme'},
      {'title': 'Değerlendirme', 'description': 'Kapsamlı muayene ve tetkikler'},
      {'title': 'Tedavi Planı', 'description': 'Kişiselleştirilmiş tedavi programı'},
      {'title': 'Uygulama', 'description': 'Tedavi sürecinin başlatılması'},
      {'title': 'Takip', 'description': 'Düzenli kontrol ve takip'},
    ];

    return steps.asMap().entries.map((entry) {
      final index = entry.key;
      final step = entry.value;
      
      return Padding(
        padding: const EdgeInsets.only(bottom: 16),
        child: Row(
          children: [
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: AppColors.primary,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Center(
                child: Text(
                  '${index + 1}',
                  style: const TextStyle(
                    color: AppColors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    step['title']!,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    step['description']!,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: AppColors.grey,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    }).toList();
  }
} 