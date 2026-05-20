import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:math_riddles/core/theme/app_colors.dart';
import 'package:math_riddles/core/theme/app_spacing.dart';
import 'package:math_riddles/core/theme/app_text_styles.dart';
import 'package:math_riddles/providers/app_state.dart';
import 'package:provider/provider.dart';

/// Home screen — centered branding and direct play button.
/// See design.md §7.3.
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final appState = context.watch<AppState>();
    final brightness = Theme.of(context).brightness;
    final colors =
        brightness == Brightness.light ? AppColors.light : AppColors.dark;

    // Error state — riddles failed to load.
    if (appState.initError != null) {
      return Scaffold(
        body: Center(
          child: Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: AppSpacing.screenHorizontal),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.error_outline,
                  size: 48,
                  color: colors.error,
                ),
                const SizedBox(height: AppSpacing.s4),
                Text(
                  "Couldn't load riddles",
                  style: AppTextStyles.title.copyWith(
                    color: colors.onBackground,
                  ),
                ),
                const SizedBox(height: AppSpacing.s3),
                FilledButton(
                  onPressed: appState.init,
                  child: const Text('Retry'),
                ),
              ],
            ),
          ),
        ),
      );
    }

    // Loading state.
    if (!appState.initialized || appState.riddles == null) {
      return Scaffold(
        body: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const CircularProgressIndicator(),
              const SizedBox(height: AppSpacing.s4),
              Text(
                'Loading riddles…',
                style: AppTextStyles.caption.copyWith(
                  color: colors.onSurfaceMuted,
                ),
              ),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: colors.background,
      body: Stack(
        children: [
          // Main Content: Math title + Progress + Play button
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Math Puzzles',
                  style: AppTextStyles.displayLarge.copyWith(
                    color: colors.onBackground,
                    fontSize: 72,
                    letterSpacing: -2,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: AppSpacing.s4),
                Text(
                  'Level ${appState.stats.totalSolved + 1} / ${appState.stats.totalRiddles}',
                  style: AppTextStyles.title.copyWith(
                    color: colors.onSurfaceMuted,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: AppSpacing.s6),
                _PlayButton(
                  onPressed: () {
                    final next = appState.nextUnsolvedRiddle;
                    if (next != null) {
                      context.push('/riddle/${next.id}');
                    } else if (appState.riddles?.isNotEmpty ?? false) {
                      // If all solved, just go to the first one or show a "Congrats"
                      context.push('/riddle/${appState.riddles!.first.id}');
                    }
                  },
                  colors: colors,
                ),
              ],
            ),
          ),

          // Top right: Settings
          Positioned(
            top: 0,
            right: 0,
            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(AppSpacing.s2),
                child: IconButton(
                  icon: const Icon(Icons.settings_rounded),
                  iconSize: 28,
                  color: colors.onSurfaceMuted,
                  tooltip: 'Settings',
                  onPressed: () => context.push('/settings'),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _PlayButton extends StatelessWidget {
  const _PlayButton({required this.onPressed, required this.colors});

  final VoidCallback onPressed;
  final AppColors colors;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 180,
      height: 180,
      child: Stack(
        children: [
          // Outer pulse ring (static for now, can be animated later)
          Center(
            child: Container(
              width: 180,
              height: 180,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.brandPrimary.withOpacity(0.1),
              ),
            ),
          ),
          Center(
            child: Container(
              width: 140,
              height: 140,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.brandPrimary.withOpacity(0.15),
              ),
            ),
          ),
          // Main Button
          Center(
            child: GestureDetector(
              onTap: onPressed,
              child: Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.brandPrimary,
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.brandPrimary.withOpacity(0.4),
                      blurRadius: 20,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: const Icon(
                  Icons.play_arrow_rounded,
                  color: Colors.white,
                  size: 56,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
