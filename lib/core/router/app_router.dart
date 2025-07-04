import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../features/home/screens/home_screen.dart';
import '../../features/auth/screens/login_screen.dart';
import '../../features/treatments/screens/treatment_detail_screen.dart';

class AppRouter {
  static final GoRouter router = GoRouter(
    initialLocation: '/',
    routes: [
      GoRoute(
        path: '/',
        name: 'home',
        builder: (context, state) => const HomeScreen(),
      ),
      GoRoute(
        path: '/login',
        name: 'login',
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: '/clinics',
        name: 'clinics',
        builder: (context, state) => const HomeScreen(), // Temporary - will be ClinicsScreen
      ),
      GoRoute(
        path: '/treatments',
        name: 'treatments',
        builder: (context, state) => const HomeScreen(), // Temporary - will be TreatmentsScreen
      ),
      GoRoute(
        path: '/treatments/:id',
        name: 'treatment-detail',
        builder: (context, state) {
          final treatmentId = state.pathParameters['id']!;
          // TODO: Fetch treatment data by ID
          return TreatmentDetailScreen(
            treatment: {'id': treatmentId, 'name': 'Treatment $treatmentId'},
          );
        },
      ),
      GoRoute(
        path: '/clinics/:id',
        name: 'clinic-detail',
        builder: (context, state) {
          final clinicId = state.pathParameters['id']!;
          // TODO: Create clinic detail screen and fetch data
          return const HomeScreen(); // Temporary - will be ClinicDetailScreen
        },
      ),
      GoRoute(
        path: '/profile',
        name: 'profile',
        builder: (context, state) => const HomeScreen(), // Temporary - will be ProfileScreen
      ),
      GoRoute(
        path: '/appointments',
        name: 'appointments',
        builder: (context, state) => const HomeScreen(), // Temporary - will be AppointmentsScreen
      ),
      GoRoute(
        path: '/search',
        name: 'search',
        builder: (context, state) {
          final query = state.uri.queryParameters['q'] ?? '';
          // TODO: Create search screen
          return const HomeScreen(); // Temporary - will be SearchScreen with query
        },
      ),
    ],
    errorBuilder: (context, state) => Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 64, color: Colors.red),
            const SizedBox(height: 16),
            Text('Sayfa bulunamadı: ${state.matchedLocation}'),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => context.go('/'),
              child: const Text('Ana Sayfaya Dön'),
            ),
          ],
        ),
      ),
    ),
  );
} 