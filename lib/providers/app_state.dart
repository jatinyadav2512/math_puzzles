import 'package:flutter/foundation.dart';
import 'package:math_riddles/data/models/app_settings.dart';
import 'package:math_riddles/data/models/progress.dart';
import 'package:math_riddles/data/models/riddle.dart';
import 'package:math_riddles/data/repositories/progress_repository.dart';
import 'package:math_riddles/data/repositories/riddle_repository.dart';
import 'package:math_riddles/data/repositories/settings_repository.dart';

/// Derived stats for the stats screen.
class Stats {
  const Stats({
    required this.totalSolved,
    required this.totalRiddles,
    required this.solvedPerBucket,
    required this.riddlesPerBucket,
    required this.hintsUsed,
  });

  final int totalSolved;
  final int totalRiddles;

  /// Key = bucketIndex, Value = solved count.
  final Map<int, int> solvedPerBucket;
  final Map<int, int> riddlesPerBucket;
  final int hintsUsed;
}

/// Root-level state holder aggregating riddles, progress, and settings.
/// Exposed via ChangeNotifierProvider in the root MultiProvider.
///
/// See architecture.md §2.17.
class AppState extends ChangeNotifier {
  AppState({
    required RiddleRepository riddleRepository,
    required ProgressRepository progressRepository,
    required SettingsRepository settingsRepository,
  })  : _riddleRepo = riddleRepository,
        _progressRepo = progressRepository,
        _settingsRepo = settingsRepository;

  final RiddleRepository _riddleRepo;
  final ProgressRepository _progressRepo;
  final SettingsRepository _settingsRepo;

  // ─── State ────────────────────────────────────────────

  List<Riddle>? _riddles;
  Progress _progress = const Progress();
  AppSettings _settings = const AppSettings();
  bool _initialized = false;
  String? _initError;

  // ─── Getters ──────────────────────────────────────────

  List<Riddle>? get riddles => _riddles;
  Progress get progress => _progress;
  AppSettings get settings => _settings;
  bool get initialized => _initialized;
  String? get initError => _initError;

  /// Riddles filtered to a specific bucket.
  List<Riddle> riddlesForBucket(int bucketIndex) {
    return (_riddles ?? [])
        .where((r) => r.bucketIndex == bucketIndex)
        .toList()
      ..sort(
        (a, b) => a.orderInBucket.compareTo(b.orderInBucket),
      );
  }

  /// Number of solved riddles in a bucket.
  int solvedCountForBucket(int bucketIndex) {
    final bucket = riddlesForBucket(bucketIndex);
    return bucket.where((r) => _progress.byId[r.id]?.solved ?? false).length;
  }

  /// Whether a bucket is unlocked (first riddle in the bucket is unlocked).
  bool isBucketUnlocked(int bucketIndex) {
    final bucket = riddlesForBucket(bucketIndex);
    if (bucket.isEmpty) return false;
    return _progress.isUnlocked(bucket.first, _riddles ?? []);
  }

  /// Check if a specific riddle is unlocked.
  bool isUnlocked(Riddle riddle) {
    return _progress.isUnlocked(riddle, _riddles ?? []);
  }

  /// Derived stats.
  Stats get stats {
    final all = _riddles ?? [];
    final solvedPerBucket = <int, int>{};
    final riddlesPerBucket = <int, int>{};
    var hintsUsed = 0;

    for (var i = 0; i < 5; i++) {
      final bucket = all.where((r) => r.bucketIndex == i);
      riddlesPerBucket[i] = bucket.length;
      solvedPerBucket[i] =
          bucket.where((r) => _progress.byId[r.id]?.solved ?? false).length;
    }

    for (final entry in _progress.byId.values) {
      if (entry.hintUsed) hintsUsed++;
    }

    return Stats(
      totalSolved: _progress.byId.values.where((p) => p.solved).length,
      totalRiddles: all.length,
      solvedPerBucket: solvedPerBucket,
      riddlesPerBucket: riddlesPerBucket,
      hintsUsed: hintsUsed,
    );
  }

  /// Returns a continuous level number across all buckets.
  int globalLevelNumber(Riddle riddle) {
    final all = _riddles ?? [];
    final index = all.indexWhere((r) => r.id == riddle.id);
    return index != -1 ? index + 1 : riddle.orderInBucket;
  }

  /// Returns the next unsolved unlocked riddle, or null if all are solved.
  Riddle? get nextUnsolvedRiddle => _progress.nextRiddle(_riddles ?? []);

  // ─── Init ─────────────────────────────────────────────

  /// Call once on startup. Loads riddles, progress, and settings.
  Future<void> init() async {
    try {
      _riddles = await _riddleRepo.loadAll();
      _progress = await _progressRepo.load();
      _settings = await _settingsRepo.load();
      _initialized = true;
      _initError = null;
    } on Exception catch (e) {
      _initError = e.toString();
      _initialized = true;
    }
    notifyListeners();
  }

  // ─── Mutations ────────────────────────────────────────

  /// Mark a riddle as solved and persist.
  Future<void> markSolved(
    Riddle riddle, {
    bool hintUsed = false,
    int attempts = 1,
  }) async {
    final updated = Map<String, RiddleProgress>.from(_progress.byId);
    updated[riddle.id] = RiddleProgress(
      solved: true,
      hintUsed: hintUsed,
      attempts: attempts,
      solvedAt: DateTime.now(),
    );
    _progress = Progress(byId: updated);
    notifyListeners();
    await _progressRepo.save(_progress);
  }

  /// Reset all progress.
  Future<void> resetProgress() async {
    _progress = const Progress();
    notifyListeners();
    await _progressRepo.reset();
  }

  /// Update settings and persist.
  Future<void> updateSettings(AppSettings newSettings) async {
    _settings = newSettings;
    notifyListeners();
    await _settingsRepo.save(newSettings);
  }

}
