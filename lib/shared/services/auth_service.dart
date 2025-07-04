import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Current user
  User? get currentUser => _auth.currentUser;
  
  // Auth state stream
  Stream<User?> get authStateChanges => _auth.authStateChanges();

  // Check if user is logged in
  bool get isLoggedIn => currentUser != null;

  // Register with email and password
  Future<User?> registerWithEmailAndPassword({
    required String email,
    required String password,
    required String firstName,
    required String lastName,
    required String phone,
  }) async {
    try {
      print('🔥 Firebase Auth: Registering user with email: $email');
      
      final credential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      print('🔥 Firebase Auth: User created successfully, UID: ${credential.user?.uid}');

      if (credential.user != null) {
        print('🔥 Firestore: Saving user data...');
        
        // Save user data to Firestore
        await _firestore.collection('users').doc(credential.user!.uid).set({
          'firstName': firstName,
          'lastName': lastName,
          'fullName': '$firstName $lastName', // Combined for display
          'email': email,
          'phone': phone,
          'createdAt': FieldValue.serverTimestamp(),
          'isActive': true,
        });

        print('🔥 Firestore: User data saved successfully');

        // Update display name
        await credential.user!.updateDisplayName('$firstName $lastName');
        print('🔥 Firebase Auth: Display name updated');
      }

      return credential.user;
    } on FirebaseAuthException catch (e) {
      print('🚨 Firebase Auth Error: ${e.code} - ${e.message}');
      throw _handleAuthException(e);
    } catch (e) {
      print('🚨 General Error: $e');
      throw 'Kayıt işlemi sırasında beklenmeyen bir hata oluştu: $e';
    }
  }

  // Sign in with email and password
  Future<User?> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    try {
      final credential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return credential.user;
    } on FirebaseAuthException catch (e) {
      throw _handleAuthException(e);
    }
  }

  // Sign out
  Future<void> signOut() async {
    await _auth.signOut();
  }

  // Reset password
  Future<void> resetPassword(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
    } on FirebaseAuthException catch (e) {
      throw _handleAuthException(e);
    }
  }

  // Get user profile data
  Future<Map<String, dynamic>?> getUserProfile() async {
    if (currentUser == null) return null;
    
    try {
      final doc = await _firestore.collection('users').doc(currentUser!.uid).get();
      return doc.data();
    } catch (e) {
      return null;
    }
  }

  // Update user profile
  Future<void> updateUserProfile(Map<String, dynamic> data) async {
    if (currentUser == null) return;
    
    await _firestore.collection('users').doc(currentUser!.uid).update(data);
  }

  // Handle auth exceptions
  String _handleAuthException(FirebaseAuthException e) {
    switch (e.code) {
      case 'user-not-found':
        return 'Bu email ile kayıtlı kullanıcı bulunamadı.';
      case 'wrong-password':
        return 'Hatalı şifre girdiniz.';
      case 'email-already-in-use':
        return 'Bu email adresi zaten kullanılıyor.';
      case 'weak-password':
        return 'Şifre çok zayıf. En az 6 karakter olmalı.';
      case 'invalid-email':
        return 'Geçersiz email adresi.';
      case 'user-disabled':
        return 'Bu kullanıcı hesabı devre dışı bırakılmış.';
      case 'too-many-requests':
        return 'Çok fazla giriş denemesi. Lütfen daha sonra tekrar deneyin.';
      default:
        return 'Bir hata oluştu: ${e.message}';
    }
  }
} 