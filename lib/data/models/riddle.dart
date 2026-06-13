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
/// - `equation`: standard symbol-equation riddle (also used for simple algebra).
/// - `trianglePattern`: legacy three-triangle diagram riddle.
/// - `sequence`: text/symbolic puzzle rendered as rows of cells, one is `?`
///   (number series, analogy, coding pairs, odd-one-out, define-the-operation,
///   missing-number equation).
/// - `figure`: visual puzzle drawn with a CustomPainter; `figureType` selects
///   the layout (triangle, box, circle, pyramid, grid, magicSquare,
///   magicTriangle, dice, balance, pathSum, miniSudoku). `cells` holds the
///   numbers in a figureType-specific order; a `null` marks the unknown.
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

  const factory Riddle.sequence({
    required String id,
    required Difficulty difficulty,
    required int bucketIndex,
    required int orderInBucket,

    /// series | analogy | coding | oddOneOut | operation | missingNumber
    required String sequenceType,

    /// Display rows; for most types exactly one contains the literal `?`.
    required List<String> lines,

    /// Instruction shown under the rows (e.g. "Find the missing number").
    required String prompt,
    required int answer,
    required String hint,
    required String explanation,
  }) = SequenceRiddle;

  const factory Riddle.figure({
    required String id,
    required Difficulty difficulty,
    required int bucketIndex,
    required int orderInBucket,

    /// triangle | box | circle | pyramid | grid | magicSquare |
    /// magicTriangle | dice | balance | pathSum | miniSudoku
    required String figureType,

    /// figureType-specific numbers, in row order; `null` = the unknown.
    required List<List<int?>> cells,

    /// Instruction shown under the figure.
    required String prompt,
    required int answer,
    required String hint,
    required String explanation,
  }) = FigureRiddle;

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
