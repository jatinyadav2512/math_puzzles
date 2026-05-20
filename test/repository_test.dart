import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:math_riddles/data/models/app_settings.dart';
import 'package:math_riddles/data/models/progress.dart';
import 'package:math_riddles/data/repositories/progress_repository.dart';
import 'package:math_riddles/data/repositories/settings_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  group('SharedPrefsProgressRepository', () {
    setUp(() {
      SharedPreferences.setMockInitialValues({});
    });

    test('load returns empty Progress when nothing saved', () async {
      final repo = SharedPrefsProgressRepository();
      final progress = await repo.load();
      expect(progress.byId, isEmpty);
    });

    test('save then load round-trips Progress', () async {
      final repo = SharedPrefsProgressRepository();
      final original = Progress(
        byId: {
          'easy_01': RiddleProgress(
            solved: true,
            hintUsed: true,
            attempts: 3,
            solvedAt: DateTime.utc(2026, 5, 3, 12),
          ),
          'easy_02': const RiddleProgress(attempts: 1),
        },
      );

      await repo.save(original);
      final loaded = await repo.load();

      expect(loaded.byId.length, 2);
      expect(loaded.byId['easy_01']!.solved, isTrue);
      expect(loaded.byId['easy_01']!.hintUsed, isTrue);
      expect(loaded.byId['easy_01']!.attempts, 3);
      expect(loaded.byId['easy_01']!.solvedAt, DateTime.utc(2026, 5, 3, 12));
      expect(loaded.byId['easy_02']!.solved, isFalse);
      expect(loaded.byId['easy_02']!.attempts, 1);
    });

    test('reset clears all progress keys', () async {
      final repo = SharedPrefsProgressRepository();

      // Save some progress first.
      await repo.save(
        Progress(
          byId: {
            'easy_01': RiddleProgress(
              solved: true,
              attempts: 1,
              solvedAt: DateTime.utc(2026),
            ),
          },
        ),
      );

      // Verify it was saved.
      var loaded = await repo.load();
      expect(loaded.byId, isNotEmpty);

      // Reset.
      await repo.reset();

      // Verify it's gone.
      loaded = await repo.load();
      expect(loaded.byId, isEmpty);
    });

    test('load returns empty Progress on corrupted data', () async {
      // Write garbage JSON to the shared prefs key.
      SharedPreferences.setMockInitialValues({
        'mr.progress.json': 'not valid json {{{',
      });

      final repo = SharedPrefsProgressRepository();
      final progress = await repo.load();
      expect(progress.byId, isEmpty);
    });

    test('save stores schema version', () async {
      final repo = SharedPrefsProgressRepository();
      await repo.save(const Progress());

      final prefs = await SharedPreferences.getInstance();
      expect(prefs.getInt('mr.progress.version'), 1);
    });
  });

  group('SharedPrefsSettingsRepository', () {
    setUp(() {
      SharedPreferences.setMockInitialValues({});
    });

    test('load returns defaults when nothing saved', () async {
      final repo = SharedPrefsSettingsRepository();
      final settings = await repo.load();

      expect(settings.themeMode, ThemeMode.dark);
      expect(settings.soundEnabled, isTrue);
      expect(settings.hapticsEnabled, isTrue);
    });

    test('save then load round-trips settings', () async {
      final repo = SharedPrefsSettingsRepository();
      const original = AppSettings(
        themeMode: ThemeMode.dark,
        soundEnabled: false,
        hapticsEnabled: false,
      );

      await repo.save(original);
      final loaded = await repo.load();

      expect(loaded.themeMode, ThemeMode.dark);
      expect(loaded.soundEnabled, isFalse);
      expect(loaded.hapticsEnabled, isFalse);
    });

    test('save then load round-trips light theme mode', () async {
      final repo = SharedPrefsSettingsRepository();
      const original = AppSettings(themeMode: ThemeMode.light);

      await repo.save(original);
      final loaded = await repo.load();

      expect(loaded.themeMode, ThemeMode.light);
    });

    test('load falls back to system theme for invalid themeMode index',
        () async {
      SharedPreferences.setMockInitialValues({
        'mr.settings.themeMode': 999,
      });

      final repo = SharedPrefsSettingsRepository();
      final settings = await repo.load();

      // In current implementation, ThemeMode.system is the default in SharedPrefsSettingsRepository if index is invalid
      expect(settings.themeMode, ThemeMode.system);
    });
  });

  group('AppSettings serialization', () {
    test('AppSettings round-trips via JSON', () {
      const original = AppSettings(
        themeMode: ThemeMode.dark,
        soundEnabled: false,
      );
      final jsonMap = original.toJson();
      final restored = AppSettings.fromJson(jsonMap);

      expect(restored.themeMode, ThemeMode.dark);
      expect(restored.soundEnabled, isFalse);
      expect(restored.hapticsEnabled, isTrue);
    });

    test('AppSettings defaults are correct', () {
      const settings = AppSettings();
      expect(settings.themeMode, ThemeMode.dark);
      expect(settings.soundEnabled, isTrue);
      expect(settings.hapticsEnabled, isTrue);
    });
  });
}
