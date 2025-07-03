import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'core/config/firebase_config.dart';
import 'core/theme/app_theme.dart';
import 'features/home/screens/home_screen.dart';
import 'l10n/generated/app_localizations.dart';
import 'shared/services/auth_service.dart';

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
    return MaterialApp(
      title: 'ClinicAdvisor',
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
      home: const AuthWrapper(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    final authService = AuthService();
    
    return StreamBuilder(
      stream: authService.authStateChanges,
      builder: (context, snapshot) {
        // Always show HomeScreen
        // Authentication is handled on-demand when needed
        return const HomeScreen();
      },
    );
  }
}
