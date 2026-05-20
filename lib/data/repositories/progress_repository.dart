import 'dart:convert';

import 'package:math_riddles/core/constants/app_constants.dart';
import 'package:math_riddles/data/models/progress.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Abstract interface for persisting riddle progress.
abstract class ProgressRepository {
  /// Load persisted progress. Returns empty Progress if none saved.
  Future<Progress> load();

  /// Save progress to persistent storage.
  Future<void> save(Progress progress);

  /// Reset all progress data.
  Future<void> reset();
}

/// SharedPreferences-backed implementation of ProgressRepository.
class SharedPrefsProgressRepository implements ProgressRepository {
  static const _progressKey = '${AppConstants.sharedPrefsPrefix}progress.json';
  static const _versionKey =
      '${AppConstants.sharedPrefsPrefix}progress.version';

  @override
  Future<Progress> load() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final jsonString = prefs.getString(_progressKey);
      if (jsonString == null) return const Progress();

      final jsonMap = json.decode(jsonString) as Map<String, dynamic>;
      return Progress.fromJson(jsonMap);
    } on Exception {
      // If deserialization fails, return empty progress rather than crashing.
      return const Progress();
    }
  }

  @override
  Future<void> save(Progress progress) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final jsonString = json.encode(progress.toJson());
      await prefs.setString(_progressKey, jsonString);
      await prefs.setInt(_versionKey, AppConstants.schemaVersion);
    } on Exception {
      // Swallow + log; do not surface to user (architecture.md §8).
    }
  }

  @override
  Future<void> reset() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_progressKey);
      await prefs.remove(_versionKey);
    } on Exception {
      // Swallow + log.
    }
  }
}
