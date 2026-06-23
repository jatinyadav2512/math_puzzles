import 'dart:math' as math;

import 'package:confetti/confetti.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:math_riddles/core/theme/app_colors.dart';
import 'package:math_riddles/core/theme/app_spacing.dart';
import 'package:math_riddles/core/theme/app_text_styles.dart';
import 'package:math_riddles/core/utils/haptics.dart';
import 'package:math_riddles/data/models/riddle.dart';
import 'package:math_riddles/data/services/audio_service.dart';
import 'package:math_riddles/data/services/ad_service.dart';
import 'package:math_riddles/providers/app_state.dart';
import 'package:math_riddles/presentation/widgets/hint_options_modal.dart';
import 'package:math_riddles/presentation/widgets/premium_info_modal.dart';
import 'package:math_riddles/features/riddle/presentation/widgets/figure_blocks.dart';
import 'package:provider/provider.dart';

/// Riddle solve screen — equation display, numpad, answer checking.
/// See design.md §7.5.
class RiddleScreen extends StatefulWidget {
  const RiddleScreen({required this.riddleId, super.key});

  final String riddleId;

  @override
  State<RiddleScreen> createState() => _RiddleScreenState();
}

class _RiddleScreenState extends State<RiddleScreen>
    with SingleTickerProviderStateMixin {
  String _typedAnswer = '';
  bool _showHint = false;
  bool _isLoadingAd = false;
  late final AnimationController _shakeController;
  late final Animation<double> _shakeAnimation;
  late final ConfettiController _confettiController;

  @override
  void initState() {
    super.initState();
    _shakeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 250),
    );
    _shakeAnimation = TweenSequence<double>([
      TweenSequenceItem(tween: Tween(begin: 0, end: 8), weight: 1),
      TweenSequenceItem(tween: Tween(begin: 8, end: -8), weight: 2),
      TweenSequenceItem(tween: Tween(begin: -8, end: 8), weight: 2),
      TweenSequenceItem(tween: Tween(begin: 8, end: -8), weight: 2),
      TweenSequenceItem(tween: Tween(begin: -8, end: 0), weight: 1),
    ]).animate(
      CurvedAnimation(
        parent: _shakeController,
        curve: Curves.easeInOut,
      ),
    );
    _confettiController = ConfettiController(
      duration: const Duration(milliseconds: 1200),
    );
  }

  @override
  void dispose() {
    _shakeController.dispose();
    _confettiController.dispose();
    super.dispose();
  }

  void _onDigit(String digit) {
    if (_typedAnswer.length >= 6) return; // Max 6 digits.
    final audio = context.read<AudioService>();
    final appState = context.read<AppState>();
    audio.playTap(appState.settings);
    Haptics.light(appState.settings);
    setState(() => _typedAnswer += digit);
  }

  void _onBackspace() {
    if (_typedAnswer.isEmpty) return;
    final audio = context.read<AudioService>();
    final appState = context.read<AppState>();
    audio.playTap(appState.settings);
    Haptics.light(appState.settings);
    setState(
      () => _typedAnswer = _typedAnswer.substring(
        0,
        _typedAnswer.length - 1,
      ),
    );
  }

  void _onClear() {
    final audio = context.read<AudioService>();
    final appState = context.read<AppState>();
    audio.playTap(appState.settings);
    Haptics.light(appState.settings);
    setState(() => _typedAnswer = '');
  }

  Future<void> _onSubmit(Riddle? riddle) async {
    if (riddle == null || _typedAnswer.isEmpty) return;

    final userAnswer = int.tryParse(_typedAnswer);
    if (userAnswer == null) return;

    if (userAnswer == riddle.answer) {
      // Correct!
      final appState = context.read<AppState>();
      final audio = context.read<AudioService>();
      await Haptics.success(appState.settings);
      await audio.playCorrect(appState.settings);
      _confettiController.play();
      await appState.markSolved(
        riddle,
        hintUsed: _showHint,
      );

      if (!mounted) return;
      await _showCorrectDialog(riddle);
    } else {
      // Wrong — shake + snackbar.
      final appState = context.read<AppState>();
      final audio = context.read<AudioService>();
      await Haptics.error(appState.settings);
      await audio.playWrong(appState.settings);
      _shakeController
        ..reset()
        ..forward();
      setState(() => _typedAnswer = '');

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Not quite — try again.'),
          duration: Duration(seconds: 3),
        ),
      );
    }
  }

  Future<void> _showCorrectDialog(Riddle riddle) async {
    final appState = context.read<AppState>();
    final nextRiddle = appState.progress.nextRiddle(appState.riddles ?? []);
    final colors = _currentColors;

    await showGeneralDialog<void>(
      context: context,
      barrierColor: colors.background.withOpacity(0.95),
      transitionDuration: const Duration(milliseconds: 400),
      pageBuilder: (context, animation, secondaryAnimation) {
        return FadeTransition(
          opacity: animation,
          child: ScaleTransition(
            scale: Tween<double>(begin: 0.9, end: 1.0).animate(
              CurvedAnimation(parent: animation, curve: Curves.easeOutBack),
            ),
            child: Scaffold(
              backgroundColor: Colors.transparent,
              body: SafeArea(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: AppSpacing.s6),
                  child: Column(
                    children: [
                      const Spacer(flex: 2),
                      
                      // Success Icon
                      Container(
                        padding: const EdgeInsets.all(AppSpacing.s5),
                        decoration: BoxDecoration(
                          color: colors.success.withOpacity(0.1),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.check_rounded,
                          size: 80,
                          color: colors.success,
                        ),
                      ),
                      
                      const SizedBox(height: AppSpacing.s6),
                      
                      Text(
                        'EXCELLENT!',
                        style: AppTextStyles.displayLarge.copyWith(
                          color: colors.success,
                          letterSpacing: 4,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                      
                      const SizedBox(height: AppSpacing.s2),
                      
                      Text(
                        'Level ${appState.globalLevelNumber(riddle)} Cleared',
                        style: AppTextStyles.headline.copyWith(
                          color: colors.onBackground.withOpacity(0.7),
                        ),
                      ),

                      const SizedBox(height: AppSpacing.s8),
                      
                      // Explanation Box
                      Container(
                        padding: const EdgeInsets.all(AppSpacing.s6),
                        decoration: BoxDecoration(
                          color: colors.surface,
                          borderRadius: BorderRadius.circular(24),
                          border: Border.all(
                            color: colors.onSurface.withOpacity(0.05),
                          ),
                        ),
                        child: Column(
                          children: [
                            Text(
                              'HOW IT WORKS',
                              style: AppTextStyles.caption.copyWith(
                                color: colors.onSurfaceMuted,
                                letterSpacing: 1.5,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: AppSpacing.s4),
                            Text(
                              riddle.explanation,
                              style: AppTextStyles.body.copyWith(
                                color: colors.onSurface,
                                fontSize: 18,
                                height: 1.5,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),

                      const Spacer(flex: 3),
                      
                      // Action Button
                      SizedBox(
                        width: double.infinity,
                        height: 64,
                        child: FilledButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                            if (nextRiddle != null) {
                              context.pushReplacement('/riddle/${nextRiddle.id}');
                            } else {
                              context.pop(); // Back to levels.
                            }
                          },
                          style: FilledButton.styleFrom(
                            backgroundColor: colors.success,
                            foregroundColor: colors.background,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                            elevation: 0,
                          ),
                          child: Text(
                            nextRiddle != null
                                ? 'NEXT LEVEL'
                                : 'CONTINUE',
                            style: AppTextStyles.bodyEmphasis.copyWith(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 1.2,
                            ),
                          ),
                        ),
                      ),
                      
                      const SizedBox(height: AppSpacing.s8),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  AppColors get _currentColors {
    final brightness = Theme.of(context).brightness;
    return brightness == Brightness.light ? AppColors.light : AppColors.dark;
  }

  @override
  Widget build(BuildContext context) {
    final appState = context.watch<AppState>();
    final colors = _currentColors;
    final allRiddles = appState.riddles ?? [];

    // Find the riddle by ID.
    Riddle? riddle;
    for (final r in allRiddles) {
      if (r.id == widget.riddleId) {
        riddle = r;
        break;
      }
    }

    if (riddle == null) {
      return Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            tooltip: 'Back',
            onPressed: () => context.pop(),
          ),
        ),
        body: Center(
          child: Text(
            'Puzzle not found',
            style: AppTextStyles.title.copyWith(color: colors.error),
          ),
        ),
      );
    }
    final accent = colors.bucketAccent(riddle.bucketIndex);

    return Stack(
      children: [
        Scaffold(
          appBar: AppBar(
            leading: IconButton(
              icon: const Icon(Icons.arrow_back),
              tooltip: 'Back',
              onPressed: () => context.pop(),
            ),
            actions: [
              IconButton(
                icon: const Icon(Icons.grid_view_rounded),
                tooltip: 'All Levels',
                onPressed: () => context.push('/levels/-1'),
              ),
              const SizedBox(width: AppSpacing.s2),
            ],
          ),
          body: Column(
            children: [
              // Scrollable top section: Spacer + Question + Spacer
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.screenHorizontal,
                  ),
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      minHeight: MediaQuery.of(context).size.height -
                          MediaQuery.of(context).padding.top -
                          AppBar().preferredSize.height -
                          280, // Approximate numpad height
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const SizedBox(height: AppSpacing.s4),
                        // Givens block.
                        riddle.maybeMap(
                          equation: (eq) =>
                              _GivensBlock(givens: eq.givens, colors: colors),
                          trianglePattern: (tp) =>
                              _TriangleGivensBlock(triangles: tp.triangles, colors: colors),
                          sequence: (sq) =>
                              _SequenceGivensBlock(lines: sq.lines, colors: colors),
                          figure: (fg) =>
                              _FigureGivensBlock(figure: fg, colors: colors),
                          orElse: () => const SizedBox.shrink(),
                        ),
                        const SizedBox(height: AppSpacing.s6),
                        // Question equation.
                        riddle.maybeMap(
                          equation: (eq) =>
                              _QuestionRow(question: eq.question, colors: colors),
                          trianglePattern: (_) => Text(
                            'Find the missing number.',
                            style: AppTextStyles.caption.copyWith(
                              color: colors.onSurfaceMuted,
                            ),
                          ),
                          sequence: (sq) => Text(
                            sq.prompt,
                            style: AppTextStyles.caption.copyWith(
                              color: colors.onSurfaceMuted,
                            ),
                          ),
                          figure: (fg) => Text(
                            fg.prompt,
                            style: AppTextStyles.caption.copyWith(
                              color: colors.onSurfaceMuted,
                            ),
                          ),
                          orElse: () => Text('Find the missing number.', style: AppTextStyles.caption.copyWith(color: colors.onSurfaceMuted)),
                        ),
                        const SizedBox(height: AppSpacing.s6),
                      ],
                    ),
                  ),
                ),
              ),
              // Answer field with shake animation, positioned above numpad.
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.screenHorizontal,
                  vertical: AppSpacing.s3,
                ),
                child: AnimatedBuilder(
                  animation: _shakeAnimation,
                  builder: (context, child) => Transform.translate(
                    offset: Offset(_shakeAnimation.value, 0),
                    child: child,
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: _AnswerField(
                          value: _typedAnswer,
                          colors: colors,
                          accent: accent,
                        ),
                      ),
                      const SizedBox(width: AppSpacing.s4),
                      IconButton(
                        icon: Icon(
                          _showHint ? Icons.lightbulb : Icons.lightbulb_outline,
                          color: colors.warning,
                          size: 32,
                        ),
                        onPressed: () => _showHintBottomSheet(riddle),
                      ),
                    ],
                  ),
                ),
              ),
              // Numpad pinned to bottom.
              _Numpad(
                onDigit: _onDigit,
                onBackspace: _onBackspace,
                onClear: _onClear,
                onSubmit: () => _onSubmit(riddle),
                hasInput: _typedAnswer.isNotEmpty,
                colors: colors,
              ),
            ],
          ),
        ),
        Align(
          alignment: Alignment.topCenter,
          child: ConfettiWidget(
            confettiController: _confettiController,
            blastDirection: math.pi / 2, // downwards
            emissionFrequency: 0.02,
            numberOfParticles: 5,
            gravity: 0.1,
            colors: [
              colors.success,
              AppColors.brandPrimary,
              colors.warning,
              Colors.blue,
              Colors.purple,
            ],
          ),
        ),
        if (_isLoadingAd)
          Positioned.fill(
            child: Material(
              type: MaterialType.transparency,
              child: Container(
                color: Colors.black54,
                child: Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const CircularProgressIndicator(color: Colors.white),
                      const SizedBox(height: AppSpacing.s4),
                      Text(
                        'Loading Ad...',
                        style: AppTextStyles.body.copyWith(
                          color: Colors.white,
                          decoration: TextDecoration.none,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }

  void _showHintBottomSheet(Riddle? riddle) async {
    if (riddle == null) return;

    final action = await showModalBottomSheet<String>(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => const HintOptionsModal(),
    );

    if (action == null) return;
    
    if (!mounted) return;

    final adService = context.read<AdService>();

    if (action == 'hint_ad' || action == 'solution_ad') {
      setState(() => _isLoadingAd = true);
      final success = await adService.showRewardedAd();
      if (!mounted) return;
      setState(() => _isLoadingAd = false);
      if (!success) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to load ad or ad was dismissed.')),
        );
        return;
      }
    }

    if (!mounted) return;

    if (action == 'hint' || action == 'hint_ad') {
      setState(() => _showHint = true);
      _showActualHint(riddle, isSolution: false);
    } else if (action == 'solution' || action == 'solution_ad') {
      _showActualHint(riddle, isSolution: true);
    }
  }

  void _showActualHint(Riddle riddle, {bool isSolution = false}) {
    final colors = _currentColors;
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: colors.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.s6),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: colors.onSurfaceMuted.withOpacity(0.3),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(height: AppSpacing.s6),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(isSolution ? Icons.key : Icons.lightbulb, color: colors.warning, size: 32),
                  const SizedBox(width: AppSpacing.s3),
                  Text(
                    isSolution ? 'Solution' : 'Hint',
                    style: AppTextStyles.headline.copyWith(
                      color: colors.onSurface,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.s6),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(AppSpacing.s5),
                decoration: BoxDecoration(
                  color: colors.warning.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: colors.warning.withOpacity(0.3)),
                ),
                child: Column(
                  children: [
                    if (isSolution) ...[
                      Text(
                        riddle.answer.toString(),
                        style: AppTextStyles.displayLarge.copyWith(
                          color: colors.onSurface,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                      const SizedBox(height: AppSpacing.s4),
                      Container(
                        height: 1,
                        color: colors.warning.withOpacity(0.2),
                      ),
                      const SizedBox(height: AppSpacing.s4),
                    ],
                    Text(
                      (isSolution ? riddle.explanation : riddle.hint).replaceAll('→', '➔'),
                      style: AppTextStyles.body.copyWith(
                        color: colors.onSurface,
                        fontSize: 18,
                        height: 1.5,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.s8),
              SizedBox(
                width: double.infinity,
                height: 56,
                child: FilledButton(
                  onPressed: () => Navigator.pop(context),
                  style: FilledButton.styleFrom(
                    backgroundColor: AppColors.brandPrimary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  child: Text(
                    'Got it',
                    style: AppTextStyles.bodyEmphasis.copyWith(
                      color: Colors.white,
                      fontSize: 18,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ─── Sub-widgets ─────────────────────────────────────────────

/// Displays the given equations in a subtle card.
class _GivensBlock extends StatelessWidget {
  const _GivensBlock({required this.givens, required this.colors});

  final List<String> givens;
  final AppColors colors;

  @override
  Widget build(BuildContext context) {
    if (givens.length == 1) {
      // Single given — no card chrome.
      return FittedBox(
        child: Text(
          givens[0],
          style: AppTextStyles.riddleEquation.copyWith(
            color: colors.onSurface,
          ),
        ),
      );
    }

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSpacing.s4),
      decoration: BoxDecoration(
        color: colors.surfaceMuted,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          for (var i = 0; i < givens.length; i++) ...[
            if (i > 0) const SizedBox(height: AppSpacing.s2),
            FittedBox(
              child: Text(
                givens[i],
                style: AppTextStyles.riddleEquation.copyWith(
                  color: colors.onSurface,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

/// Displays triangle pattern givens using CustomPaint.
class _TriangleGivensBlock extends StatelessWidget {
  const _TriangleGivensBlock({
    required this.triangles,
    required this.colors,
  });

  final List<TriangleCell> triangles;
  final AppColors colors;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.s4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: triangles
            .map((t) => _TriangleWidget(cell: t, colors: colors))
            .toList(),
      ),
    );
  }
}

class _TriangleWidget extends StatelessWidget {
  const _TriangleWidget({required this.cell, required this.colors});

  final TriangleCell cell;
  final AppColors colors;

  @override
  Widget build(BuildContext context) {
    final textStyle = AppTextStyles.riddleEquation.copyWith(
      color: colors.onSurface,
      fontSize: 20,
    );
    final questionStyle = textStyle.copyWith(
      color: AppColors.brandPrimary,
      fontWeight: FontWeight.w700,
      fontSize: 28,
    );

    return SizedBox(
      width: 80,
      height: 100,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Positioned.fill(
            top: 24,
            bottom: 28,
            child: CustomPaint(
              painter: _TrianglePainter(color: colors.onSurfaceMuted),
            ),
          ),
          Positioned(
            top: 0,
            left: -8,
            child: Text(cell.left.toString(), style: textStyle),
          ),
          Positioned(
            top: 0,
            right: -8,
            child: Text(cell.right.toString(), style: textStyle),
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Center(
              child: Text(
                cell.bottom?.toString() ?? '?',
                style: cell.bottom == null ? questionStyle : textStyle,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _TrianglePainter extends CustomPainter {
  const _TrianglePainter({required this.color});

  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;

    final path = Path()
      ..moveTo(0, 0)
      ..lineTo(size.width, 0)
      ..lineTo(size.width / 2, size.height)
      ..close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant _TrianglePainter oldDelegate) =>
      color != oldDelegate.color;
}

/// Displays the question equation with ? highlighted.
class _QuestionRow extends StatelessWidget {
  const _QuestionRow({required this.question, required this.colors});

  final String question;
  final AppColors colors;

  @override
  Widget build(BuildContext context) {
    // Render the question, highlighting '?' in brandPrimary.
    final parts = question.split('?');
    return FittedBox(
      child: RichText(
        textAlign: TextAlign.center,
        text: TextSpan(
          style: AppTextStyles.riddleEquation.copyWith(
            color: colors.onSurface,
          ),
          children: [
            for (var i = 0; i < parts.length; i++) ...[
              TextSpan(text: parts[i]),
              if (i < parts.length - 1)
                TextSpan(
                  text: '?',
                  style: AppTextStyles.riddleEquation.copyWith(
                    color: AppColors.brandPrimary,
                    fontSize: 32,
                    fontWeight: FontWeight.w700,
                  ),
                ),
            ],
          ],
        ),
      ),
    );
  }
}

/// The answer display field.
class _AnswerField extends StatelessWidget {
  const _AnswerField({
    required this.value,
    required this.colors,
    required this.accent,
  });

  final String value;
  final AppColors colors;
  final Color accent;

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(minWidth: 160),
      height: 56,
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.s5),
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: value.isEmpty ? colors.divider : accent,
          width: 2,
        ),
      ),
      child: Center(
        child: Text(
          value.isEmpty ? 'Answer' : value,
          style: (value.isEmpty ? AppTextStyles.title : AppTextStyles.riddleAnswer)
              .copyWith(
            color: value.isEmpty
                ? colors.onSurfaceMuted.withOpacity(0.4)
                : colors.onSurface,
            fontSize: value.isEmpty ? 20 : 36,
          ),
        ),
      ),
    );
  }
}

/// Numpad with digits 1-9, 0, backspace, clear, and submit.
class _Numpad extends StatelessWidget {
  const _Numpad({
    required this.onDigit,
    required this.onBackspace,
    required this.onClear,
    required this.onSubmit,
    required this.hasInput,
    required this.colors,
  });

  final ValueChanged<String> onDigit;
  final VoidCallback onBackspace;
  final VoidCallback onClear;
  final VoidCallback onSubmit;
  final bool hasInput;
  final AppColors colors;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: colors.surface,
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.s4,
        AppSpacing.s1,
        AppSpacing.s4,
        AppSpacing.s3,
      ),
      child: SafeArea(
        top: false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildDigitRow(['1', '2', '3']),
            const SizedBox(height: AppSpacing.s1),
            // Row 2: 4 5 6
            _buildDigitRow(['4', '5', '6']),
            const SizedBox(height: AppSpacing.s1),
            // Row 3: 7 8 9
            _buildDigitRow(['7', '8', '9']),
            const SizedBox(height: AppSpacing.s1),
            // Row 4: Clear 0 Backspace
            Row(
              children: [
                _buildActionKey(
                  child: Text(
                    'C',
                    style: AppTextStyles.numpadKey.copyWith(
                      color: colors.onSurfaceMuted,
                    ),
                  ),
                  onTap: onClear,
                ),
                const SizedBox(width: AppSpacing.s1),
                _buildDigitKey('0'),
                const SizedBox(width: AppSpacing.s1),
                _buildActionKey(
                  child: Icon(
                    Icons.backspace_outlined,
                    color: colors.onSurfaceMuted,
                    size: 24,
                  ),
                  onTap: onBackspace,
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.s2),
            // Submit row.
            SizedBox(
              width: double.infinity,
              height: 48,
              child: FilledButton(
                onPressed: hasInput ? onSubmit : null,
                style: FilledButton.styleFrom(
                  backgroundColor: hasInput
                      ? AppColors.brandPrimary
                      : colors.surfaceMuted,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                child: Text(
                  'Submit',
                  style: AppTextStyles.bodyEmphasis.copyWith(
                    color: hasInput ? Colors.white : colors.onSurfaceMuted,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDigitRow(List<String> digits) {
    return Row(
      children: [
        for (var i = 0; i < digits.length; i++) ...[
          if (i > 0) const SizedBox(width: AppSpacing.s2),
          _buildDigitKey(digits[i]),
        ],
      ],
    );
  }

  Widget _buildDigitKey(String digit) {
    return Expanded(
      child: SizedBox(
        height: 48,
        child: Material(
          color: colors.surfaceMuted,
          borderRadius: BorderRadius.circular(16),
          child: InkWell(
            borderRadius: BorderRadius.circular(16),
            onTap: () => onDigit(digit),
            child: Center(
              child: Text(
                digit,
                style: AppTextStyles.numpadKey.copyWith(
                  color: colors.onSurface,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildActionKey({
    required Widget child,
    required VoidCallback onTap,
  }) {
    return Expanded(
      child: SizedBox(
        height: 48,
        child: Material(
          color: colors.surfaceMuted,
          borderRadius: BorderRadius.circular(16),
          child: InkWell(
            borderRadius: BorderRadius.circular(16),
            onTap: onTap,
            child: Center(child: child),
          ),
        ),
      ),
    );
  }
}

class _SequenceGivensBlock extends StatelessWidget {
  const _SequenceGivensBlock({required this.lines, required this.colors});

  final List<String> lines;
  final AppColors colors;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSpacing.s4),
      decoration: BoxDecoration(
        color: colors.surfaceMuted,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          for (var i = 0; i < lines.length; i++) ...[
            if (i > 0) const SizedBox(height: AppSpacing.s2),
            FittedBox(
              child: Text(
                lines[i],
                style: AppTextStyles.riddleEquation.copyWith(
                  color: colors.onSurface,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _FigureGivensBlock extends StatelessWidget {
  const _FigureGivensBlock({required this.figure, required this.colors});

  final FigureRiddle figure;
  final AppColors colors;

  @override
  Widget build(BuildContext context) {
    if (figure.figureType == 'triangle') {
      final triangles = figure.cells.map((row) {
        return TriangleCell(
          left: row[0] ?? 0,
          right: row[1] ?? 0,
          bottom: row.length > 2 ? row[2] : null,
        );
      }).toList();
      return _TriangleGivensBlock(triangles: triangles, colors: colors);
    }
    
    if (figure.figureType == 'grid' || figure.figureType == 'magicSquare') {
      return GridGivensBlock(cells: figure.cells, colors: colors);
    }
    
    if (figure.figureType == 'miniSudoku') {
      return SudokuGivensBlock(cells: figure.cells, colors: colors);
    }
    
    if (figure.figureType == 'circle') {
      return CircleGivensBlock(cells: figure.cells, colors: colors);
    }
    
    if (figure.figureType == 'box') {
      return BoxGivensBlock(cells: figure.cells, colors: colors);
    }
    
    if (figure.figureType == 'magicTriangle') {
      return MagicTriangleGivensBlock(cells: figure.cells, colors: colors);
    }

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSpacing.s4),
      decoration: BoxDecoration(
        color: colors.surfaceMuted,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Center(
        child: Wrap(
          spacing: 8,
          runSpacing: 8,
          alignment: WrapAlignment.center,
          children: figure.cells.expand((row) => row).map((cell) {
            final isMissing = cell == null;
            return Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: isMissing ? AppColors.brandPrimary.withOpacity(0.2) : colors.surface,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: isMissing ? AppColors.brandPrimary : colors.divider,
                  width: 2,
                ),
              ),
              child: Center(
                child: Text(
                  isMissing ? '?' : cell.toString(),
                  style: AppTextStyles.riddleEquation.copyWith(
                    color: isMissing ? AppColors.brandPrimary : colors.onSurface,
                    fontSize: 24,
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}
