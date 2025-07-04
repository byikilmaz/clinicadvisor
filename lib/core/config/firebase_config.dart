import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

class FirebaseConfig {
  static Future<void> initialize() async {
    try {
      print('🔥 Initializing Firebase...');
      
      await Firebase.initializeApp(
        options: const FirebaseOptions(
          apiKey: "AIzaSyAx1GcocZ4LYlYfjhGuoU7AlmuM9Mk0mc",
          authDomain: "clinicadvisor-f4fe9.firebaseapp.com",
          projectId: "clinicadvisor-f4fe9",
          storageBucket: "clinicadvisor-f4fe9.firebasestorage.app",
          messagingSenderId: "532900169989",
          appId: "1:532900169989:web:b07cdd020197dec3878234",
        ),
      );
      
      print('✅ Firebase initialized successfully');
      print('🔥 Auth instance: ${FirebaseAuth.instance}');
      print('🔥 Firestore instance: ${FirebaseFirestore.instance}');
      
    } catch (e) {
      print('🚨 Firebase initialization failed: $e');
      rethrow;
    }
  }

  static FirebaseAuth get auth => FirebaseAuth.instance;
  static FirebaseFirestore get firestore => FirebaseFirestore.instance;
  static FirebaseStorage get storage => FirebaseStorage.instance;
} 