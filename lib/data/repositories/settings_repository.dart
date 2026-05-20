import 'package:flutter/material.dart';
import 'package:math_riddles/core/constants/app_constants.dart';
import 'package:math_riddles/data/models/app_settings.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Abstract interface for persisting app settings.
abstract class SettingsRepository {
  /// Load persisted settings. Returns defaults if none saved.
  Future<AppSettings> load();

  /// Save settings to persistent storage.
  Future<void> save(AppSettings settings);
}

/// SharedPreferences-backed implementation of SettingsRepository.
class SharedPrefsSettingsRepository implements SettingsRepository {
  static const _prefix = AppConstants.sharedPrefsPrefix;
  static const _themeModeKey = '${_prefix}settings.themeMode';
  static const _soundEnabledKey = '${_prefix}settings.soundEnabled';
  static const _hapticsEnabledKey = '${_prefix}settings.hapticsEnabled';

  @override
  Future<AppSettings> load() async {
    try {
      final prefs = await SharedPreferences.getInstance();

      final themeModeIndex = prefs.getInt(_themeModeKey);
      final themeMode = themeModeIndex != null &&
              themeModeIndex >= 0 &&
              themeModeIndex < ThemeMode.values.length
          ? ThemeMode.values[themeModeIndex]
          : ThemeMode.system;

      return AppSettings(
        themeMode: themeMode,
        soundEnabled: prefs.getBool(_soundEnabledKey) ?? true,
        hapticsEnabled: prefs.getBool(_hapticsEnabledKey) ?? true,
      );
    } on Exception {
      // If loading fails, return defaults.
      return const AppSettings();
    }
  }

  @override
  Future<void> save(AppSettings settings) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setInt(_themeModeKey, settings.themeMode.index);
      await prefs.setBool(_soundEnabledKey, settings.soundEnabled);
      await prefs.setBool(_hapticsEnabledKey, settings.hapticsEnabled);
    } on Exception {
      // Swallow + log (architecture.md §8).
    }
  }
}
