import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:math_riddles/core/theme/app_colors.dart';
import 'package:math_riddles/core/theme/app_spacing.dart';
import 'package:math_riddles/core/theme/app_text_styles.dart';
import 'package:math_riddles/data/models/riddle.dart';
import 'package:math_riddles/providers/app_state.dart';
import 'package:provider/provider.dart';

class StatsScreen extends StatelessWidget {
  const StatsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final appState = context.watch<AppState>();
    final stats = appState.stats;
    final brightness = Theme.of(context).brightness;
    final colors =
        brightness == Brightness.light ? AppColors.light : AppColors.dark;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          tooltip: 'Back',
          onPressed: () => context.pop(),
        ),
        title: Text(
          'Statistics',
          style: AppTextStyles.title.copyWith(color: colors.onSurface),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.s5),
        child: Column(
          children: [
            // Top Card: Progress Ring
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: AppSpacing.s6),
              decoration: BoxDecoration(
                color: colors.surface,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                children: [
                  SizedBox(
                    width: 140,
                    height: 140,
                    child: Stack(
                      children: [
                        Positioned.fill(
                          child: CircularProgressIndicator(
                            value: stats.totalRiddles > 0
                                ? stats.totalSolved / stats.totalRiddles
                                : 0,
                            strokeWidth: 8,
                            backgroundColor: colors.surfaceMuted,
                            color: AppColors.brandPrimary,
                          ),
                        ),
                        Center(
                          child: Text(
                            '${stats.totalSolved} / ${stats.totalRiddles}',
                            style: AppTextStyles.displayLarge.copyWith(
                              color: colors.onSurface,
                              fontSize: 28,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: AppSpacing.s4),
                  Text(
                    'Puzzles solved',
                    style: AppTextStyles.caption.copyWith(
                      color: colors.onSurfaceMuted,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.s5),
            // Bucket Rows
            Container(
              padding: const EdgeInsets.all(AppSpacing.s5),
              decoration: BoxDecoration(
                color: colors.surface,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                children: List.generate(5, (index) {
                  final difficulty = Difficulty.values[index];
                  final bucketName =
                      difficulty.name[0].toUpperCase() + difficulty.name.substring(1);
                  final solved = stats.solvedPerBucket[index] ?? 0;
                  final total = stats.riddlesPerBucket[index] ?? 0;
                  final accent = colors.bucketAccent(index);

                  return Padding(
                    padding: EdgeInsets.only(
                      bottom: index < 4 ? AppSpacing.s4 : 0,
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 12,
                          height: 12,
                          decoration: BoxDecoration(
                            color: accent,
                            shape: BoxShape.circle,
                          ),
                        ),
                        const SizedBox(width: AppSpacing.s3),
                        Text(
                          bucketName,
                          style: AppTextStyles.bodyEmphasis.copyWith(
                            color: colors.onSurface,
                          ),
                        ),
                        const Spacer(),
                        Text(
                          '$solved / $total',
                          style: AppTextStyles.caption.copyWith(
                            color: colors.onSurfaceMuted,
                          ),
                        ),
                      ],
                    ),
                  );
                }),
              ),
            ),
            const SizedBox(height: AppSpacing.s5),
            // Footer two-up grid
            Row(
              children: [
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.all(AppSpacing.s4),
                    decoration: BoxDecoration(
                      color: colors.surface,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Hints used',
                          style: AppTextStyles.caption.copyWith(
                            color: colors.onSurfaceMuted,
                          ),
                        ),
                        const SizedBox(height: AppSpacing.s2),
                        Text(
                          '${stats.hintsUsed}',
                          style: AppTextStyles.title.copyWith(
                            color: colors.onSurface,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: AppSpacing.s4),
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.all(AppSpacing.s4),
                    decoration: BoxDecoration(
                      color: colors.surface,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Streak',
                          style: AppTextStyles.caption.copyWith(
                            color: colors.onSurfaceMuted,
                          ),
                        ),
                        const SizedBox(height: AppSpacing.s2),
                        Text(
                          '0 days', // Hardcoded for v0 as per spec
                          style: AppTextStyles.title.copyWith(
                            color: colors.onSurface,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
