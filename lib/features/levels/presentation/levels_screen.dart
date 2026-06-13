import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:math_riddles/core/constants/app_constants.dart';
import 'package:math_riddles/core/theme/app_colors.dart';
import 'package:math_riddles/core/theme/app_spacing.dart';
import 'package:math_riddles/core/theme/app_text_styles.dart';
import 'package:math_riddles/data/models/riddle.dart';
import 'package:math_riddles/providers/app_state.dart';
import 'package:provider/provider.dart';

/// Levels screen — 4-column grid of 20 tiles for a selected bucket.
/// See design.md §7.4.
class LevelsScreen extends StatelessWidget {
  const LevelsScreen({required this.bucketIndex, super.key});

  final int bucketIndex;

  @override
  Widget build(BuildContext context) {
    final appState = context.watch<AppState>();
    final brightness = Theme.of(context).brightness;
    final colors =
        brightness == Brightness.light ? AppColors.light : AppColors.dark;
    final accent = colors.bucketAccent(bucketIndex);

    final bucketRiddles = bucketIndex == -1
        ? (appState.riddles ?? [])
        : appState.riddlesForBucket(bucketIndex);
    final solvedCount = bucketIndex == -1
        ? appState.stats.totalSolved
        : appState.solvedCountForBucket(bucketIndex);
    final totalInBucket = bucketRiddles.length;
    final bucketName = bucketIndex == -1
        ? 'All Levels'
        : (bucketIndex < AppConstants.tierNames.length
            ? AppConstants.tierNames[bucketIndex]
            : '?');

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          tooltip: 'Back',
          onPressed: () => context.pop(),
        ),
        title: Text(
          bucketName,
          style: AppTextStyles.headline.copyWith(color: accent),
        ),
        centerTitle: true,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: AppSpacing.s5),
            child: Center(
              child: Text(
                '$solvedCount / $totalInBucket',
                style: AppTextStyles.caption.copyWith(
                  color: colors.onSurfaceMuted,
                ),
              ),
            ),
          ),
        ],
      ),
      body: GridView.builder(
        padding: const EdgeInsets.all(AppSpacing.s5),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 4,
          mainAxisSpacing: AppSpacing.s3,
          crossAxisSpacing: AppSpacing.s3,
        ),
        itemCount: totalInBucket,
        itemBuilder: (context, index) {
          final riddle = bucketRiddles[index];
          final isSolved =
              appState.progress.byId[riddle.id]?.solved ?? false;
          final isUnlocked = appState.isUnlocked(riddle);

          final isCurrent = isUnlocked && !isSolved;
          return _LevelTile(
            key: ValueKey(riddle.id),
            riddle: riddle,
            index: index,
            isSolved: isSolved,
            isUnlocked: isUnlocked,
            isCurrent: isCurrent,
            accent: accent,
            colors: colors,
          );
        },
      ),
    );
  }
}

/// A single level tile — solved / current / locked.
/// See design.md §7.4 LevelTile.
class _LevelTile extends StatefulWidget {
  const _LevelTile({
    required this.riddle,
    required this.index,
    required this.isSolved,
    required this.isUnlocked,
    required this.isCurrent,
    required this.accent,
    required this.colors,
    super.key,
  });

  final Riddle riddle;
  final int index;
  final bool isSolved;
  final bool isUnlocked;
  final bool isCurrent;
  final Color accent;
  final AppColors colors;

  @override
  State<_LevelTile> createState() => _LevelTileState();
}

class _LevelTileState extends State<_LevelTile>
    with SingleTickerProviderStateMixin {
  AnimationController? _pulseController;
  late Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();
    _pulseAnimation = const AlwaysStoppedAnimation(1);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _setupPulse();
  }

  @override
  void didUpdateWidget(_LevelTile oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isCurrent != oldWidget.isCurrent) {
      _setupPulse();
    }
  }

  void _setupPulse() {
    if (widget.isCurrent) {
      // Respect reduce-motion accessibility.
      final reduceMotion =
          MediaQuery.maybeOf(context)?.disableAnimations ?? false;
      if (!reduceMotion) {
        _pulseController ??= AnimationController(
          vsync: this,
          duration: const Duration(milliseconds: 1200),
        );
        final controller = _pulseController;
        if (controller != null) {
          _pulseAnimation = Tween<double>(begin: 1, end: 1.04).animate(
            CurvedAnimation(
              parent: controller,
              curve: Curves.easeInOut,
            ),
          );
          controller.repeat(reverse: true);
        }
      } else {
        _pulseAnimation = const AlwaysStoppedAnimation(1);
      }
    } else {
      _pulseController?.stop();
      _pulseController?.dispose();
      _pulseController = null;
      _pulseAnimation = const AlwaysStoppedAnimation(1);
    }
  }

  @override
  void dispose() {
    _pulseController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final c = widget.colors;

    // Determine tile appearance.
    Color tileBackground;
    Widget tileContent;
    BoxBorder? tileBorder;
    var opacity = 1.0;

    if (widget.isSolved) {
      // Solved: green background, check icon + riddle number.
      tileBackground = c.solvedTile;
      tileContent = Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.check, size: 24, color: c.success),
          const SizedBox(height: 2),
          Text(
            '${context.read<AppState>().globalLevelNumber(widget.riddle)}',
            style: AppTextStyles.tileNumber.copyWith(
              color: c.onSurfaceMuted,
            ),
          ),
        ],
      );
    } else if (widget.isCurrent) {
      // Current: surface background, 2px glow border, riddle number.
      tileBackground = c.surface;
      tileBorder = Border.all(color: c.currentTileGlow, width: 2);
      tileContent = Center(
        child: Text(
          '${context.read<AppState>().globalLevelNumber(widget.riddle)}',
          style: AppTextStyles.tileNumber.copyWith(
            color: c.onSurface,
          ),
        ),
      );
    } else {
      // Locked: muted background, riddle number, reduced opacity.
      tileBackground = c.lockedTile;
      opacity = 0.55;
      tileContent = Center(
        child: Text(
          '${context.read<AppState>().globalLevelNumber(widget.riddle)}',
          style: AppTextStyles.tileNumber.copyWith(
            color: c.onSurfaceMuted,
          ),
        ),
      );
    }

    Widget tile = AnimatedOpacity(
      duration: const Duration(milliseconds: 200),
      opacity: opacity,
      child: GestureDetector(
        onTap: () => _onTap(context),
        child: Container(
          decoration: BoxDecoration(
            color: tileBackground,
            borderRadius: BorderRadius.circular(16),
            border: tileBorder,
          ),
          child: tileContent,
        ),
      ),
    );

    // Wrap current tile in pulse animation.
    if (widget.isCurrent && _pulseController != null) {
      tile = ScaleTransition(
        scale: _pulseAnimation,
        child: tile,
      );
    }

    return tile;
  }

  void _onTap(BuildContext context) {
    if (widget.isSolved || widget.isCurrent) {
      context.push('/riddle/${widget.riddle.id}');
    } else {
      // Locked — show snackbar.
      final previousGlobalLevel = context.read<AppState>().globalLevelNumber(widget.riddle) - 1;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Solve Level $previousGlobalLevel first.'),
          duration: const Duration(seconds: 3),
        ),
      );
    }
  }
}
