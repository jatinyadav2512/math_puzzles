import 'package:freezed_annotation/freezed_annotation.dart';

part 'riddle.freezed.dart';
part 'riddle.g.dart';

/// Difficulty levels mapping to 5 buckets (0..4).
enum Difficulty {
  easy,
  medium,
  hard,
  expert,
  master;

  static Difficulty fromString(String s) {
    return Difficulty.values.firstWhere(
      (d) => d.name == s,
      orElse: () => throw FormatException('Unknown difficulty: $s'),
    );
  }
}

/// A single riddle. Union type discriminated by `displayType` in JSON.
///
/// - `equation`: standard symbol-equation riddle.
/// - `trianglePattern`: three-triangle diagram riddle.
///
/// See architecture.md §2.9 and projectOverview.md §6.1.
@Freezed(unionKey: 'displayType', fallbackUnion: 'equation')
class Riddle with _$Riddle {
  const factory Riddle.equation({
    required String id,
    required Difficulty difficulty,
    required int bucketIndex,
    required int orderInBucket,
    required List<String> givens,
    required String question,
    required int answer,
    required String hint,
    required String explanation,
  }) = EquationRiddle;

  const factory Riddle.trianglePattern({
    required String id,
    required Difficulty difficulty,
    required int bucketIndex,
    required int orderInBucket,
    required List<TriangleCell> triangles,
    required int answer,
    required String hint,
    required String explanation,
  }) = TrianglePatternRiddle;

  factory Riddle.fromJson(Map<String, dynamic> json) => _$RiddleFromJson(json);
}

/// A single triangle in a triangle-pattern riddle.
/// `bottom == null` marks the unknown the user must solve.
@freezed
class TriangleCell with _$TriangleCell {
  const factory TriangleCell({
    required int left,
    required int right,
    required int? bottom,
  }) = _TriangleCell;

  factory TriangleCell.fromJson(Map<String, dynamic> json) =>
      _$TriangleCellFromJson(json);
}
