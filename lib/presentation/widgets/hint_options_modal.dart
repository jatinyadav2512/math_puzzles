import 'package:flutter/material.dart';
import 'package:math_riddles/core/theme/app_colors.dart';
import 'package:math_riddles/core/theme/app_text_styles.dart';
import 'package:math_riddles/providers/app_state.dart';
import 'package:math_riddles/presentation/widgets/premium_info_modal.dart';
import 'package:provider/provider.dart';

class HintOptionsModal extends StatelessWidget {
  const HintOptionsModal({super.key});

  @override
  Widget build(BuildContext context) {
    final appState = context.read<AppState>();
    final isPremium = appState.settings.isPremium;
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
            'Need Help?',
            style: AppTextStyles.headline.copyWith(
              color: colors.onSurface,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 24),
          if (isPremium) ...[
            _buildAdButton(
              context,
              prefix: 'Show',
              boldWord: 'Hint',
              onTap: () => Navigator.pop(context, 'hint'),
            ),
            const SizedBox(height: 12),
            _buildAdButton(
              context,
              prefix: 'Show',
              boldWord: 'Solution',
              onTap: () => Navigator.pop(context, 'solution'),
            ),
          ] else ...[
            _buildAdButton(
              context,
              prefix: 'Watch Ad for',
              boldWord: 'Hint',
              onTap: () => Navigator.pop(context, 'hint_ad'),
            ),
            const SizedBox(height: 12),
            _buildAdButton(
              context,
              prefix: 'Watch Ad for',
              boldWord: 'Solution',
              onTap: () => Navigator.pop(context, 'solution_ad'),
            ),
            const SizedBox(height: 24),
            Row(
              children: [
                Expanded(child: Divider(color: colors.onSurfaceMuted.withOpacity(0.2))),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Text('OR', style: TextStyle(color: colors.onSurfaceMuted)),
                ),
                Expanded(child: Divider(color: colors.onSurfaceMuted.withOpacity(0.2))),
              ],
            ),
            const SizedBox(height: 24),
            _buildPremiumButton(
              context,
              onTap: () {
                Navigator.pop(context);
                showModalBottomSheet(
                  context: context,
                  isScrollControlled: true,
                  builder: (context) => const PremiumInfoModal(),
                );
              },
            ),
          ],
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  Widget _buildAdButton(
    BuildContext context, {
    required String prefix,
    required String boldWord,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 24),
        decoration: BoxDecoration(
          color: const Color(0xFF1C1C24),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          children: [
            const Icon(Icons.play_circle_outline, color: Color(0xFFFF9800), size: 28),
            const SizedBox(width: 16),
            RichText(
              text: TextSpan(
                style: AppTextStyles.body.copyWith(color: Colors.white, fontSize: 18),
                children: [
                  TextSpan(text: '$prefix '),
                  TextSpan(
                    text: boldWord,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPremiumButton(BuildContext context, {required VoidCallback onTap}) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 20),
        decoration: BoxDecoration(
          color: const Color(0xFF6B4EFF), // Bright purple
          borderRadius: BorderRadius.circular(16),
        ),
        child: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.stars, color: Colors.white, size: 24),
            SizedBox(width: 8),
            Text(
              'Be Premium',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}