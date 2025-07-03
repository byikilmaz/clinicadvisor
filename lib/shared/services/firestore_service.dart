import 'package:cloud_firestore/cloud_firestore.dart';
import '../../core/config/firebase_config.dart';

class FirestoreService {
  final FirebaseFirestore _firestore = FirebaseConfig.firestore;

  // Popüler klinikleri getir
  Future<List<Map<String, dynamic>>> getPopularClinics() async {
    try {
      final snapshot = await _firestore
          .collection('clinics')
          .where('isActive', isEqualTo: true)
          .orderBy('rating', descending: true)
          .limit(10)
          .get();
      
      return snapshot.docs.map((doc) {
        final data = doc.data();
        data['id'] = doc.id;
        return data;
      }).toList();
    } catch (e) {
      print('Error fetching popular clinics: $e');
      return _getMockClinics();
    }
  }

  // Popüler tedavileri getir
  Future<List<Map<String, dynamic>>> getPopularTreatments() async {
    try {
      final snapshot = await _firestore
          .collection('treatments')
          .where('isActive', isEqualTo: true)
          .orderBy('popularity', descending: true)
          .limit(10)
          .get();
      
      return snapshot.docs.map((doc) {
        final data = doc.data();
        data['id'] = doc.id;
        return data;
      }).toList();
    } catch (e) {
      print('Error fetching popular treatments: $e');
      return _getMockTreatments();
    }
  }

  // Mock veri - Firebase bağlantısı yoksa veya hata durumunda
  List<Map<String, dynamic>> _getMockClinics() {
    return [
      {
        'id': '1',
        'name': 'Acıbadem Maslak Hastanesi',
        'specialty': 'Genel Hastane',
        'rating': 4.8,
        'reviewCount': 254,
        'location': 'Maslak, İstanbul',
        'imageUrl': 'https://via.placeholder.com/300x200',
        'priceRange': '₺₺₺',
        'distance': '2.5 km',
        'isVerified': true,
      },
      {
        'id': '2',
        'name': 'Memorial Şişli Hastanesi',
        'specialty': 'Özel Hastane',
        'rating': 4.7,
        'reviewCount': 189,
        'location': 'Şişli, İstanbul',
        'imageUrl': 'https://via.placeholder.com/300x200',
        'priceRange': '₺₺₺',
        'distance': '3.2 km',
        'isVerified': true,
      },
      {
        'id': '3',
        'name': 'Liv Hospital Ulus',
        'specialty': 'Özel Hastane',
        'rating': 4.6,
        'reviewCount': 142,
        'location': 'Beşiktaş, İstanbul',
        'imageUrl': 'https://via.placeholder.com/300x200',
        'priceRange': '₺₺₺',
        'distance': '4.1 km',
        'isVerified': true,
      },
      {
        'id': '4',
        'name': 'Koç Üniversitesi Hastanesi',
        'specialty': 'Üniversite Hastanesi',
        'rating': 4.9,
        'reviewCount': 312,
        'location': 'Davutpaşa, İstanbul',
        'imageUrl': 'https://via.placeholder.com/300x200',
        'priceRange': '₺₺₺₺',
        'distance': '12.3 km',
        'isVerified': true,
      },
    ];
  }

  List<Map<String, dynamic>> _getMockTreatments() {
    return [
      {
        'id': '1',
        'name': 'Saç Ekimi',
        'category': 'Estetik',
        'averagePrice': 8500,
        'minPrice': 5000,
        'maxPrice': 15000,
        'duration': '6-8 saat',
        'imageUrl': 'https://via.placeholder.com/300x200',
        'popularity': 95,
        'clinicCount': 45,
      },
      {
        'id': '2',
        'name': 'Lazer Göz Ameliyatı',
        'category': 'Göz Sağlığı',
        'averagePrice': 12000,
        'minPrice': 8000,
        'maxPrice': 20000,
        'duration': '30 dakika',
        'imageUrl': 'https://via.placeholder.com/300x200',
        'popularity': 89,
        'clinicCount': 32,
      },
      {
        'id': '3',
        'name': 'Diş İmplantı',
        'category': 'Diş Sağlığı',
        'averagePrice': 3500,
        'minPrice': 2000,
        'maxPrice': 6000,
        'duration': '2-3 saat',
        'imageUrl': 'https://via.placeholder.com/300x200',
        'popularity': 87,
        'clinicCount': 78,
      },
      {
        'id': '4',
        'name': 'Botox',
        'category': 'Estetik',
        'averagePrice': 1200,
        'minPrice': 800,
        'maxPrice': 2500,
        'duration': '30 dakika',
        'imageUrl': 'https://via.placeholder.com/300x200',
        'popularity': 84,
        'clinicCount': 156,
      },
      {
        'id': '5',
        'name': 'Kalp Bypass',
        'category': 'Kardiyoloji',
        'averagePrice': 85000,
        'minPrice': 60000,
        'maxPrice': 120000,
        'duration': '4-6 saat',
        'imageUrl': 'https://via.placeholder.com/300x200',
        'popularity': 76,
        'clinicCount': 12,
      },
    ];
  }

  // Test verileri ekle
  Future<void> addSampleData() async {
    try {
      // Klinik verilerini ekle
      final clinics = _getMockClinics();
      for (final clinic in clinics) {
        await _firestore.collection('clinics').add(clinic);
      }

      // Tedavi verilerini ekle
      final treatments = _getMockTreatments();
      for (final treatment in treatments) {
        await _firestore.collection('treatments').add(treatment);
      }

      print('Sample data added successfully');
    } catch (e) {
      print('Error adding sample data: $e');
    }
  }
} 