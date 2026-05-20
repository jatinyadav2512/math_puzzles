import 'package:go_router/go_router.dart';
import 'package:math_riddles/features/home/presentation/home_screen.dart';
import 'package:math_riddles/features/levels/presentation/levels_screen.dart';
import 'package:math_riddles/features/riddle/presentation/riddle_screen.dart';
import 'package:math_riddles/features/settings/presentation/settings_screen.dart';
import 'package:math_riddles/features/splash/presentation/splash_screen.dart';
import 'package:math_riddles/features/stats/presentation/stats_screen.dart';

/// Route path constants.
class AppRoutes {
  AppRoutes._();

  static const splash = '/';
  static const home = '/home';
  static const levels = '/levels/:bucketIndex';
  static const riddle = '/riddle/:riddleId';
  static const stats = '/stats';
  static const settings = '/settings';
}

/// Builds a [GoRouter] for the app.
/// Redirect-based gating on first-launch flag is handled at navigation
/// time (splash decides where to go), not via GoRouter redirect.
GoRouter buildRouter() {
  return GoRouter(
    initialLocation: AppRoutes.splash,
    routes: [
      GoRoute(
        path: AppRoutes.splash,
        builder: (context, state) => const SplashScreen(),
      ),
      GoRoute(
        path: AppRoutes.home,
        builder: (context, state) => const HomeScreen(),
      ),
      GoRoute(
        path: AppRoutes.levels,
        builder: (context, state) {
          final bucketIndex =
              int.tryParse(state.pathParameters['bucketIndex'] ?? '0') ?? 0;
          return LevelsScreen(bucketIndex: bucketIndex);
        },
      ),
      GoRoute(
        path: AppRoutes.riddle,
        builder: (context, state) {
          final riddleId = state.pathParameters['riddleId'] ?? '';
          return RiddleScreen(riddleId: riddleId);
        },
      ),
      GoRoute(
        path: AppRoutes.stats,
        builder: (context, state) => const StatsScreen(),
      ),
      GoRoute(
        path: AppRoutes.settings,
        builder: (context, state) => const SettingsScreen(),
      ),
    ],
  );
}
