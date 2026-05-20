import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:math_riddles/core/routing/app_router.dart';
import 'package:math_riddles/providers/app_state.dart';
import 'package:provider/provider.dart';

/// Splash screen — 900ms brand reveal, then navigate based on first-launch.
/// See design.md §7.1.
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  @override
  void initState() {
    super.initState();

    // Navigate as soon as initialized to see native transitions.
    _navigate();
  }

  Future<void> _navigate() async {
    if (!mounted) return;

    final appState = context.read<AppState>();

    // Wait for init if not yet complete.
    if (!appState.initialized) {
      await Future<void>.delayed(const Duration(milliseconds: 100));
      if (!mounted) return;
      return _navigate();
    }

    if (!mounted) return;

    if (!mounted) return;
    
    context.go(AppRoutes.home);
  }


  @override
  Widget build(BuildContext context) {
    /*
    final brightness = Theme.of(context).brightness;
    final colors =
        brightness == Brightness.light ? AppColors.light : AppColors.dark;

    return Scaffold(
      backgroundColor: colors.background,
      body: Center(
        child: ScaleTransition(
          scale: _scaleAnimation,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // App icon
              ClipRRect(
                borderRadius: BorderRadius.circular(24),
                child: Image.asset(
                  'assets/images/icon.png',
                  width: 96,
                  height: 96,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                AppConstants.appName,
                style: AppTextStyles.displayLarge.copyWith(
                  color: colors.onBackground,
                ),
              ),
            ],
          ),
        ),
      ),
    );
    */
    return const SizedBox.shrink();
  }
}
