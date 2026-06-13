import 'package:flutter/material.dart';
import 'package:math_riddles/core/theme/app_colors.dart';
import 'package:math_riddles/core/theme/app_text_styles.dart';
import 'package:math_riddles/data/services/purchase_service.dart';

class PremiumInfoModal extends StatelessWidget {
  const PremiumInfoModal({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<String?>(
      future: PurchaseService().getPremiumPrice(),
      builder: (context, snapshot) {
        final price = snapshot.data ?? '₹299'; // Fallback price
        final colors = Theme.of(context).brightness == Brightness.light ? AppColors.light : AppColors.dark;

        return Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: colors.surface,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 12),
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.white24,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(height: 24),
              Text(
                'Get Premium',
                style: AppTextStyles.headline.copyWith(
                  color: colors.onSurface,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                'Enjoy 3 months of Ad-Free play!\n\n✓ No Ads\n✓ Free Hints\n✓ Free Solutions',
                textAlign: TextAlign.center,
                style: AppTextStyles.body.copyWith(
                  color: colors.onSurfaceMuted,
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 32),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () async {
                    final success = await PurchaseService().buyPremium();
                    if (context.mounted) {
                      Navigator.pop(context);
                      if (!success) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Purchase failed. Make sure you are logged into Play Store and the product is active in Play Console.')),
                        );
                      }
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF6B4EFF), // Match Be Premium button
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 20),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.stars, color: Colors.white, size: 24),
                      const SizedBox(width: 8),
                      Text(
                        'Get Premium at $price',
                        style: AppTextStyles.bodyEmphasis.copyWith(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),
            ],
          ),
        );
      },
    );
  }
}