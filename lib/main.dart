import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'core/config/firebase_config.dart';
import 'core/theme/app_theme.dart';
import 'core/router/app_router.dart';
import 'l10n/generated/app_localizations.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  try {
    await FirebaseConfig.initialize();
  } catch (e) {
    debugPrint('Firebase initialization error: $e');
  }
  
  runApp(const ClinicAdvisorApp());
}

class ClinicAdvisorApp extends StatelessWidget {
  const ClinicAdvisorApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'ClinicAdvisor - Türkiye\'nin En Büyük Sağlık Pazaryeri',
      theme: AppTheme.lightTheme,
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('tr', ''), // Turkish
        Locale('en', ''), // English
      ],
      locale: const Locale('tr', ''), // Default to Turkish
      routerConfig: AppRouter.router,
      debugShowCheckedModeBanner: false,
    );
  }
}
