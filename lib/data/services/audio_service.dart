import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/foundation.dart';
import 'package:math_riddles/core/constants/asset_paths.dart';
import 'package:math_riddles/data/models/app_settings.dart';

/// Audio service wrapping `audioplayers`. Respects [AppSettings.soundEnabled].
///
/// Preloads three SFX. All play methods are no-ops when sound is disabled.
/// See architecture.md §2.16.
class AudioService {
  final _correctPlayer = AudioPlayer();
  final _wrongPlayer = AudioPlayer();
  final _tapPlayer = AudioPlayer();

  bool _initialized = false;

  /// Preload audio assets. Call once during app startup.
  Future<void> init() async {
    if (_initialized) return;
    try {
      debugPrint('AudioService: Initializing...');
      
      // Pre-set volume for players.
      await _tapPlayer.setVolume(0.5);
      await _correctPlayer.setVolume(0.8);
      await _wrongPlayer.setVolume(0.8);

      _initialized = true;
      debugPrint('AudioService: Initialized successfully');
    } catch (e) {
      debugPrint('AudioService: Initialization failed: $e');
      _initialized = false;
    }
  }

  /// Play the "correct answer" sound.
  Future<void> playCorrect(AppSettings settings) async {
    if (!settings.soundEnabled) return;
    try {
      await _correctPlayer.play(AssetSource(AssetPaths.soundCorrect));
    } catch (e) {
      debugPrint('AudioService: Error playing correct sound: $e');
    }
  }

  /// Play the "wrong answer" sound.
  Future<void> playWrong(AppSettings settings) async {
    if (!settings.soundEnabled) return;
    try {
      await _wrongPlayer.play(AssetSource(AssetPaths.soundWrong));
    } catch (e) {
      debugPrint('AudioService: Error playing wrong sound: $e');
    }
  }

  /// Play a subtle tap sound (numpad key press).
  Future<void> playTap(AppSettings settings) async {
    if (!settings.soundEnabled) return;
    try {
      // For fast tapping, we stop and restart.
      await _tapPlayer.stop();
      await _tapPlayer.play(AssetSource(AssetPaths.soundTap));
    } catch (e) {
      debugPrint('AudioService: Error playing tap sound: $e');
    }
  }

  /// Release player resources.
  void dispose() {
    _correctPlayer.dispose();
    _wrongPlayer.dispose();
    _tapPlayer.dispose();
  }
}
