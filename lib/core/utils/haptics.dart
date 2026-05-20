import 'package:flutter/services.dart';
import 'package:math_riddles/data/models/app_settings.dart';

/// Thin haptic feedback wrapper that respects [AppSettings.hapticsEnabled].
///
/// All methods are no-ops when haptics are disabled.
/// See architecture.md §2.8.
class Haptics {
  Haptics._();

  /// Light tap feedback (e.g. digit key press).
  static Future<void> light(AppSettings settings) async {
    if (!settings.hapticsEnabled) return;
    // selectionClick is often more noticeable on Android than lightImpact.
    await HapticFeedback.selectionClick();
  }

  /// Selection feedback (e.g. tile tap).
  static Future<void> selection(AppSettings settings) async {
    if (!settings.hapticsEnabled) return;
    await HapticFeedback.mediumImpact();
  }

  /// Heavy success feedback (correct answer).
  static Future<void> success(AppSettings settings) async {
    if (!settings.hapticsEnabled) return;
    // Vibrate is the most forceful feedback.
    await HapticFeedback.vibrate();
  }

  /// Light error feedback (wrong answer).
  static Future<void> error(AppSettings settings) async {
    if (!settings.hapticsEnabled) return;
    await HapticFeedback.vibrate();
  }
}
