import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../l10n/generated/app_localizations.dart';

class ClinicCard extends StatelessWidget {
  final Map<String, dynamic> clinic;

  const ClinicCard({
    super.key,
    required this.clinic,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    
    return SizedBox(
      width: 280,
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Klinik resmi
            ClipRRect(
              borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
              child: Container(
                height: 120,
                width: double.infinity,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      AppColors.primary.withOpacity(0.8),
                      AppColors.secondary.withOpacity(0.8),
                    ],
                  ),
                ),
                child: Stack(
                  children: [
                    // Placeholder image
                    Container(
                      decoration: const BoxDecoration(
                        image: DecorationImage(
                          image: NetworkImage('https://via.placeholder.com/300x200'),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    // Verified badge
                    if (clinic['isVerified'] == true)
                      Positioned(
                        top: 12,
                        right: 12,
                        child: Container(
                          padding: const EdgeInsets.all(6),
                          decoration: BoxDecoration(
                            color: AppColors.success,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: const Icon(
                            Icons.verified,
                            color: AppColors.white,
                            size: 16,
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),
            
            // Klinik bilgileri
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Klinik adı
                  Text(
                    clinic['name'] ?? 'Bilinmeyen Klinik',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  
                  const SizedBox(height: 8),
                  
                  // Uzmanlık alanı
                  Text(
                    clinic['specialty'] ?? 'Genel',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: AppColors.grey,
                    ),
                  ),
                  
                  const SizedBox(height: 8),
                  
                  // Konum
                  Row(
                    children: [
                      const Icon(
                        Icons.location_on,
                        size: 14,
                        color: AppColors.grey,
                      ),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          clinic['location'] ?? 'Konum belirtilmemiş',
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: AppColors.grey,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  
                  const SizedBox(height: 8),
                  
                  // Rating ve fiyat
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          const Icon(
                            Icons.star,
                            color: AppColors.warning,
                            size: 16,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            '${clinic['rating'] ?? 0.0}',
                            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(width: 4),
                          Text(
                            '(${clinic['reviewCount'] ?? 0})',
                            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: AppColors.grey,
                            ),
                          ),
                        ],
                      ),
                      Text(
                        clinic['priceRange'] ?? '₺₺₺',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: AppColors.primary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  
                  const SizedBox(height: 12),
                  
                  // Butonlar
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () {
                            // TODO: View details
                          },
                          style: OutlinedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 8),
                          ),
                          child: Text(
                            l10n.viewDetails,
                            style: const TextStyle(fontSize: 12),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {
                            // TODO: Book appointment
                          },
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 8),
                          ),
                          child: Text(
                            l10n.bookAppointment,
                            style: const TextStyle(fontSize: 12),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
} 