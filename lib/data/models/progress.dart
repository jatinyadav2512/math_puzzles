import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:math_riddles/data/models/riddle.dart';

part 'progress.freezed.dart';
part 'progress.g.dart';

/// Per-riddle progress state.
@freezed
class RiddleProgress with _$RiddleProgress {
  const factory RiddleProgress({
    @Default(false) bool solved,
    @Default(false) bool hintUsed,
    @Default(0) int attempts,
    DateTime? solvedAt,
  }) = _RiddleProgress;

  factory RiddleProgress.fromJson(Map<String, dynamic> json) =>
      _$RiddleProgressFromJson(json);
}

/// Aggregate progress across all riddles.
@freezed
class Progress with _$Progress {
  const factory Progress({
    @Default(<String, RiddleProgress>{})
    Map<String, RiddleProgress> byId,
  }) = _Progress;

  const Progress._();

  factory Progress.fromJson(Map<String, dynamic> json) =>
      _$ProgressFromJson(json);

  /// Whether a riddle is unlocked based on the linear-within-bucket,
  /// bucket-gate unlock rule (architecture.md §2.10):
  ///
  /// A riddle is unlocked iff:
  /// (a) it's the first riddle in the first bucket, OR
  /// (b) the previous riddle in the same bucket is solved, OR
  /// (c) it's the first riddle in a bucket and every riddle in the
  ///     previous bucket is solved.
  bool isUnlocked(Riddle riddle, List<Riddle> allRiddles) {
    // First riddle in the first bucket is always unlocked.
    if (riddle.bucketIndex == 0 && riddle.orderInBucket == 1) {
      return true;
    }

    // If not the first in the bucket, check the previous riddle in same bucket.
    if (riddle.orderInBucket > 1) {
      final previousInBucket = allRiddles.where(
        (r) =>
            r.bucketIndex == riddle.bucketIndex &&
            r.orderInBucket == riddle.orderInBucket - 1,
      );
      if (previousInBucket.isNotEmpty) {
        final prev = previousInBucket.first;
        return byId[prev.id]?.solved ?? false;
      }
      // No previous riddle found — treat as locked.
      return false;
    }

    // First riddle in a non-first bucket: every riddle in the previous
    // bucket must be solved.
    final previousBucketRiddles = allRiddles.where(
      (r) => r.bucketIndex == riddle.bucketIndex - 1,
    );
    if (previousBucketRiddles.isEmpty) {
      // No previous bucket exists — treat as unlocked.
      return true;
    }
    return previousBucketRiddles.every(
      (r) => byId[r.id]?.solved ?? false,
    );
  }

  /// Returns the next unsolved unlocked riddle, or null if all are solved.
  Riddle? nextRiddle(List<Riddle> allRiddles) {
    // Sort by bucket then by order to ensure deterministic traversal.
    final sorted = List<Riddle>.from(allRiddles)
      ..sort((a, b) {
        final bucketCmp = a.bucketIndex.compareTo(b.bucketIndex);
        if (bucketCmp != 0) return bucketCmp;
        return a.orderInBucket.compareTo(b.orderInBucket);
      });

    for (final riddle in sorted) {
      if (!(byId[riddle.id]?.solved ?? false) &&
          isUnlocked(riddle, allRiddles)) {
        return riddle;
      }
    }
    return null;
  }
}
