import 'package:flutter_test/flutter_test.dart';
import 'package:math_riddles/data/models/progress.dart';
import 'package:math_riddles/data/models/riddle.dart';

void main() {
  // Helper to create equation riddles with specific bucket/order.
  Riddle makeRiddle({
    required String id,
    int bucketIndex = 0,
    int orderInBucket = 1,
    Difficulty difficulty = Difficulty.easy,
  }) {
    return Riddle.equation(
      id: id,
      difficulty: difficulty,
      bucketIndex: bucketIndex,
      orderInBucket: orderInBucket,
      givens: const ['A+A=4'],
      question: 'A=?',
      answer: 2,
      hint: 'hint',
      explanation: 'explanation',
    );
  }

  RiddleProgress solved() {
    return RiddleProgress(
      solved: true,
      attempts: 1,
      solvedAt: DateTime(2026),
    );
  }

  group('Unlock rules', () {
    test('First riddle in first bucket is always unlocked', () {
      final riddles = [
        makeRiddle(id: 'easy_01'),
        makeRiddle(id: 'easy_02', orderInBucket: 2),
      ];
      const progress = Progress();

      expect(progress.isUnlocked(riddles[0], riddles), isTrue);
    });

    test('Second riddle in first bucket is locked when first unsolved', () {
      final riddles = [
        makeRiddle(id: 'easy_01'),
        makeRiddle(id: 'easy_02', orderInBucket: 2),
      ];
      const progress = Progress();

      expect(progress.isUnlocked(riddles[1], riddles), isFalse);
    });

    test(
        'Second riddle in first bucket is unlocked when first is solved',
        () {
      final riddles = [
        makeRiddle(id: 'easy_01'),
        makeRiddle(id: 'easy_02', orderInBucket: 2),
      ];
      final progress = Progress(
        byId: {'easy_01': solved()},
      );

      expect(progress.isUnlocked(riddles[1], riddles), isTrue);
    });

    test('Mid-bucket riddle is locked when predecessor unsolved', () {
      final riddles = [
        makeRiddle(id: 'easy_01'),
        makeRiddle(id: 'easy_02', orderInBucket: 2),
        makeRiddle(id: 'easy_03', orderInBucket: 3),
      ];
      // Solved only the first, skip the second.
      final progress = Progress(
        byId: {'easy_01': solved()},
      );

      expect(progress.isUnlocked(riddles[2], riddles), isFalse);
    });

    test('Mid-bucket riddle unlocked when predecessor solved', () {
      final riddles = [
        makeRiddle(id: 'easy_01'),
        makeRiddle(id: 'easy_02', orderInBucket: 2),
        makeRiddle(id: 'easy_03', orderInBucket: 3),
      ];
      final progress = Progress(
        byId: {
          'easy_01': solved(),
          'easy_02': solved(),
        },
      );

      expect(progress.isUnlocked(riddles[2], riddles), isTrue);
    });

    test(
        'First riddle of next bucket is locked when previous bucket '
        'is not fully solved',
        () {
      final riddles = [
        makeRiddle(id: 'easy_01'),
        makeRiddle(id: 'easy_02', orderInBucket: 2),
        makeRiddle(
          id: 'med_01',
          bucketIndex: 1,
          difficulty: Difficulty.medium,
        ),
      ];
      // Only first of bucket 0 solved.
      final progress = Progress(
        byId: {'easy_01': solved()},
      );

      expect(progress.isUnlocked(riddles[2], riddles), isFalse);
    });

    test(
        'First riddle of next bucket is unlocked when previous bucket '
        'is fully solved',
        () {
      final riddles = [
        makeRiddle(id: 'easy_01'),
        makeRiddle(id: 'easy_02', orderInBucket: 2),
        makeRiddle(
          id: 'med_01',
          bucketIndex: 1,
          difficulty: Difficulty.medium,
        ),
      ];
      final progress = Progress(
        byId: {
          'easy_01': solved(),
          'easy_02': solved(),
        },
      );

      expect(progress.isUnlocked(riddles[2], riddles), isTrue);
    });

    test('Bucket 2 unlocked only when bucket 1 fully done', () {
      final riddles = [
        makeRiddle(id: 'easy_01'),
        makeRiddle(
          id: 'med_01',
          bucketIndex: 1,
          difficulty: Difficulty.medium,
        ),
        makeRiddle(
          id: 'med_02',
          bucketIndex: 1,
          orderInBucket: 2,
          difficulty: Difficulty.medium,
        ),
        makeRiddle(
          id: 'hard_01',
          bucketIndex: 2,
          difficulty: Difficulty.hard,
        ),
      ];

      // Bucket 0 done, bucket 1 partially done.
      final progress = Progress(
        byId: {
          'easy_01': solved(),
          'med_01': solved(),
        },
      );

      // hard_01 should be locked because med_02 is not solved.
      expect(progress.isUnlocked(riddles[3], riddles), isFalse);

      // Now solve med_02 too.
      final fullProgress = Progress(
        byId: {
          'easy_01': solved(),
          'med_01': solved(),
          'med_02': solved(),
        },
      );

      expect(fullProgress.isUnlocked(riddles[3], riddles), isTrue);
    });
  });

  group('nextRiddle', () {
    test('Returns first riddle when none solved', () {
      final riddles = [
        makeRiddle(id: 'easy_02', orderInBucket: 2),
        makeRiddle(id: 'easy_01'),
      ];
      const progress = Progress();

      final next = progress.nextRiddle(riddles);
      expect(next, isNotNull);
      expect(next!.id, 'easy_01');
    });

    test('Returns second riddle when first solved', () {
      final riddles = [
        makeRiddle(id: 'easy_01'),
        makeRiddle(id: 'easy_02', orderInBucket: 2),
      ];
      final progress = Progress(
        byId: {'easy_01': solved()},
      );

      final next = progress.nextRiddle(riddles);
      expect(next, isNotNull);
      expect(next!.id, 'easy_02');
    });

    test('Returns null when all solved', () {
      final riddles = [
        makeRiddle(id: 'easy_01'),
        makeRiddle(id: 'easy_02', orderInBucket: 2),
      ];
      final progress = Progress(
        byId: {
          'easy_01': solved(),
          'easy_02': solved(),
        },
      );

      expect(progress.nextRiddle(riddles), isNull);
    });

    test('Skips to next bucket when current bucket fully solved', () {
      final riddles = [
        makeRiddle(id: 'easy_01'),
        makeRiddle(
          id: 'med_01',
          bucketIndex: 1,
          difficulty: Difficulty.medium,
        ),
      ];
      final progress = Progress(
        byId: {'easy_01': solved()},
      );

      final next = progress.nextRiddle(riddles);
      expect(next, isNotNull);
      expect(next!.id, 'med_01');
    });
  });

  group('RiddleProgress serialization', () {
    test('RiddleProgress round-trips via JSON', () {
      final original = RiddleProgress(
        solved: true,
        hintUsed: true,
        attempts: 3,
        solvedAt: DateTime.utc(2026, 5, 3, 12),
      );
      final json = original.toJson();
      final restored = RiddleProgress.fromJson(json);

      expect(restored.solved, original.solved);
      expect(restored.hintUsed, original.hintUsed);
      expect(restored.attempts, original.attempts);
      expect(restored.solvedAt, original.solvedAt);
    });

    test('RiddleProgress defaults are correct', () {
      const p = RiddleProgress();
      expect(p.solved, isFalse);
      expect(p.hintUsed, isFalse);
      expect(p.attempts, 0);
      expect(p.solvedAt, isNull);
    });
  });

  group('Progress serialization', () {
    test('Progress round-trips via JSON', () {
      final original = Progress(
        byId: {
          'easy_01': RiddleProgress(
            solved: true,
            attempts: 2,
            solvedAt: DateTime.utc(2026, 5, 3),
          ),
          'easy_02': const RiddleProgress(),
        },
      );
      final json = original.toJson();
      final restored = Progress.fromJson(json);

      expect(restored.byId.length, 2);
      expect(restored.byId['easy_01']!.solved, isTrue);
      expect(restored.byId['easy_01']!.attempts, 2);
      expect(restored.byId['easy_02']!.solved, isFalse);
    });

    test('Empty Progress round-trips', () {
      const original = Progress();
      final json = original.toJson();
      final restored = Progress.fromJson(json);

      expect(restored.byId, isEmpty);
    });
  });
}
