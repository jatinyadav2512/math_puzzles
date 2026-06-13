import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:math_riddles/core/constants/app_constants.dart';
import 'package:math_riddles/core/routing/app_router.dart';
import 'package:math_riddles/core/theme/app_theme.dart';
import 'package:math_riddles/data/repositories/progress_repository.dart';
import 'package:math_riddles/data/repositories/remote_riddle_repository.dart';
import 'package:math_riddles/data/repositories/riddle_repository.dart';
import 'package:math_riddles/data/repositories/settings_repository.dart';
import 'package:math_riddles/data/services/ad_service.dart';
import 'package:math_riddles/data/services/audio_service.dart';
import 'package:math_riddles/data/services/hint_service.dart';
import 'package:math_riddles/data/services/rewarded_ad_hint_service.dart';
import 'package:math_riddles/providers/app_state.dart';
import 'package:provider/provider.dart';

/// Root widget. MultiProvider + MaterialApp.router with theme + router.
/// See architecture.md §2.2 and §3 for provider wiring.
class MathRiddlesApp extends StatefulWidget {
  const MathRiddlesApp({super.key});

  @override
  State<MathRiddlesApp> createState() => _MathRiddlesAppState();
}

class _MathRiddlesAppState extends State<MathRiddlesApp> {
  late final _router = buildRouter();

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        // ─── Repositories ─────────────────────────────
        Provider<RiddleRepository>(
          create: (_) => RemoteRiddleRepository(
            backendUrl: 'https://math-puzzles-a88e1.web.app/riddles.json',
          ),
        ),
        Provider<ProgressRepository>(
          create: (_) => SharedPrefsProgressRepository(),
        ),
        Provider<SettingsRepository>(
          create: (_) => SharedPrefsSettingsRepository(),
        ),

        // ─── Services ─────────────────────────────────
        Provider<AdService>(
          create: (_) => AdService()..init(),
          dispose: (_, service) => service.dispose(),
        ),
        Provider<HintService>(
          create: (ctx) => RewardedAdHintService(
            adService: ctx.read<AdService>(),
          ),
        ),
        Provider<AudioService>(
          create: (_) => AudioService()..init(),
          dispose: (_, service) => service.dispose(),
        ),

        // ─── Root State ───────────────────────────────
        ChangeNotifierProvider<AppState>(
          create: (ctx) => AppState(
            riddleRepository: ctx.read<RiddleRepository>(),
            progressRepository: ctx.read<ProgressRepository>(),
            settingsRepository: ctx.read<SettingsRepository>(),
          )..init(),
        ),
      ],
      child: _AppWithTheme(router: _router),
    );
  }
}

/// Inner widget that watches AppState for theme changes.
class _AppWithTheme extends StatelessWidget {
  const _AppWithTheme({required this.router});

  final GoRouter router;

  @override
  Widget build(BuildContext context) {

    return MaterialApp.router(
      title: AppConstants.appName,
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light(),
      darkTheme: AppTheme.dark(),
      themeMode: ThemeMode.dark,
      routerConfig: router,
    );
  }
}
