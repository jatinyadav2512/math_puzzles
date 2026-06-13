import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:math_riddles/core/constants/app_constants.dart';
import 'package:math_riddles/data/models/riddle.dart';

/// Validates the authored puzzle content in assets/data/riddles.json.
///
/// Structural checks run on every puzzle. Rule checks recompute the answer
/// from the puzzle's own data for every machine-computable type
/// (pathSum, balance, pyramid, magicSquare, miniSudoku, magicTriangle).
void main() {
  final raw = File('assets/data/riddles.json').readAsStringSync();
  final list = (json.decode(raw) as List).cast<Map<String, dynamic>>();

  const knownFigureTypes = {
    'triangle',
    'box',
    'circle',
    'pyramid',
    'grid',
    'magicSquare',
    'magicTriangle',
    'dice',
    'balance',
    'pathSum',
    'miniSudoku',
  };
  const knownSequenceTypes = {
    'series',
    'analogy',
    'coding',
    'oddOneOut',
    'operation',
    'missingNumber',
    'workBackwards',
  };

  test('exactly 100 puzzles, unique ids', () {
    expect(list.length, 100);
    final ids = list.map((e) => e['id']).toSet();
    expect(ids.length, 100, reason: 'duplicate ids found');
  });

  test('10 buckets x 10, orderInBucket 1..10 sequential', () {
    for (var b = 0; b < AppConstants.bucketCount; b++) {
      final bucket = list.where((e) => e['bucketIndex'] == b).toList()
        ..sort((a, z) =>
            (a['orderInBucket'] as int).compareTo(z['orderInBucket'] as int));
      expect(bucket.length, 10, reason: 'bucket $b should have 10 puzzles');
      for (var i = 0; i < bucket.length; i++) {
        expect(bucket[i]['orderInBucket'], i + 1,
            reason: 'bucket $b order should be sequential');
      }
    }
  });

  test('every puzzle parses via Riddle.fromJson', () {
    for (final m in list) {
      expect(() => Riddle.fromJson(m), returnsNormally,
          reason: 'failed to parse ${m['id']}');
    }
  });

  test('answers are non-negative integers <= 6 digits', () {
    for (final m in list) {
      final a = m['answer'];
      expect(a, isA<int>(), reason: '${m['id']} answer must be int');
      expect(a as int, greaterThanOrEqualTo(0), reason: '${m['id']} negative');
      expect(a, lessThanOrEqualTo(999999), reason: '${m['id']} too large');
    }
  });

  test('known displayType / figureType / sequenceType + one unknown', () {
    for (final m in list) {
      final type = m['displayType'] as String? ?? 'equation';
      if (type == 'figure') {
        final ft = m['figureType'] as String;
        expect(knownFigureTypes, contains(ft), reason: '${m['id']} bad figureType');
        final cells = (m['cells'] as List)
            .map((r) => (r as List).cast<int?>())
            .toList();
        final nulls = cells.expand((r) => r).where((v) => v == null).length;
        if (ft == 'pathSum' || ft == 'balance') {
          expect(nulls, 0, reason: '${m['id']} should have no blank');
        } else {
          expect(nulls, 1, reason: '${m['id']} should have exactly one blank');
        }
      } else if (type == 'sequence') {
        final st = m['sequenceType'] as String;
        expect(knownSequenceTypes, contains(st),
            reason: '${m['id']} bad sequenceType');
        final qCount = (m['lines'] as List)
            .cast<String>()
            .fold<int>(0, (n, l) => n + '?'.allMatches(l).length);
        if (st == 'oddOneOut' || st == 'workBackwards') {
          expect(qCount, 0, reason: '${m['id']} should have no ?');
        } else {
          expect(qCount, 1, reason: '${m['id']} should have exactly one ?');
        }
      }
    }
  });

  group('rule checks (recompute the answer)', () {
    List<List<int?>> cellsOf(Map<String, dynamic> m) => (m['cells'] as List)
        .map((r) => (r as List).cast<int?>())
        .toList();

    List<Map<String, dynamic>> figuresOfType(String ft) => list
        .where((m) => m['displayType'] == 'figure' && m['figureType'] == ft)
        .toList();

    test('pathSum = sum of all numbers', () {
      for (final m in figuresOfType('pathSum')) {
        final sum = cellsOf(m).first.fold<int>(0, (s, v) => s + v!);
        expect(m['answer'], sum, reason: '${m['id']}');
      }
    });

    test('balance = total / count', () {
      for (final m in figuresOfType('balance')) {
        final c = cellsOf(m);
        final count = c[0][0]!;
        final total = c[1][0]!;
        expect(total % count, 0, reason: '${m['id']} not divisible');
        expect(m['answer'], total ~/ count, reason: '${m['id']}');
      }
    });

    test('pyramid: each block = sum of two below', () {
      for (final m in figuresOfType('pyramid')) {
        final rows = cellsOf(m);
        // Fill the single blank with the answer.
        for (final row in rows) {
          for (var j = 0; j < row.length; j++) {
            row[j] ??= m['answer'] as int;
          }
        }
        for (var i = 0; i < rows.length - 1; i++) {
          for (var j = 0; j < rows[i].length; j++) {
            expect(rows[i][j], rows[i + 1][j]! + rows[i + 1][j + 1]!,
                reason: '${m['id']} broken at row $i col $j');
          }
        }
      }
    });

    test('magicSquare: every line equal', () {
      for (final m in figuresOfType('magicSquare')) {
        final g = cellsOf(m);
        for (final row in g) {
          for (var j = 0; j < row.length; j++) {
            row[j] ??= m['answer'] as int;
          }
        }
        final n = g.length;
        final target = g[0].fold<int>(0, (s, v) => s + v!);
        for (var i = 0; i < n; i++) {
          expect(g[i].fold<int>(0, (s, v) => s + v!), target,
              reason: '${m['id']} row $i');
          var col = 0;
          for (var r = 0; r < n; r++) {
            col += g[r][i]!;
          }
          expect(col, target, reason: '${m['id']} col $i');
        }
        var d1 = 0;
        var d2 = 0;
        for (var i = 0; i < n; i++) {
          d1 += g[i][i]!;
          d2 += g[i][n - 1 - i]!;
        }
        expect(d1, target, reason: '${m['id']} diag1');
        expect(d2, target, reason: '${m['id']} diag2');
      }
    });

    test('miniSudoku: rows & columns distinct 1..n', () {
      for (final m in figuresOfType('miniSudoku')) {
        final g = cellsOf(m);
        for (final row in g) {
          for (var j = 0; j < row.length; j++) {
            row[j] ??= m['answer'] as int;
          }
        }
        final n = g.length;
        for (var i = 0; i < n; i++) {
          final row = {for (var j = 0; j < n; j++) g[i][j]};
          final colSet = {for (var r = 0; r < n; r++) g[r][i]};
          expect(row.length, n, reason: '${m['id']} row $i repeats');
          expect(colSet.length, n, reason: '${m['id']} col $i repeats');
          expect(row.every((v) => v! >= 1 && v <= n), isTrue,
              reason: '${m['id']} row $i out of range');
        }
      }
    });

    test('magicTriangle: three sides equal', () {
      for (final m in figuresOfType('magicTriangle')) {
        final r = cellsOf(m);
        for (final row in r) {
          for (var j = 0; j < row.length; j++) {
            row[j] ??= m['answer'] as int;
          }
        }
        // r = [[A], [D, F], [B, E, C]]
        final left = r[0][0]! + r[1][0]! + r[2][0]!;
        final right = r[0][0]! + r[1][1]! + r[2][2]!;
        final bottom = r[2][0]! + r[2][1]! + r[2][2]!;
        expect(left, right, reason: '${m['id']} left != right');
        expect(left, bottom, reason: '${m['id']} left != bottom');
      }
    });
  });
}
