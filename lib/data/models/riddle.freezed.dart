// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'riddle.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

Riddle _$RiddleFromJson(Map<String, dynamic> json) {
  switch (json['displayType']) {
    case 'trianglePattern':
      return TrianglePatternRiddle.fromJson(json);

    default:
      return EquationRiddle.fromJson(json);
  }
}

/// @nodoc
mixin _$Riddle {
  String get id => throw _privateConstructorUsedError;
  Difficulty get difficulty => throw _privateConstructorUsedError;
  int get bucketIndex => throw _privateConstructorUsedError;
  int get orderInBucket => throw _privateConstructorUsedError;
  int get answer => throw _privateConstructorUsedError;
  String get hint => throw _privateConstructorUsedError;
  String get explanation => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(
            String id,
            Difficulty difficulty,
            int bucketIndex,
            int orderInBucket,
            List<String> givens,
            String question,
            int answer,
            String hint,
            String explanation)
        equation,
    required TResult Function(
            String id,
            Difficulty difficulty,
            int bucketIndex,
            int orderInBucket,
            List<TriangleCell> triangles,
            int answer,
            String hint,
            String explanation)
        trianglePattern,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(
            String id,
            Difficulty difficulty,
            int bucketIndex,
            int orderInBucket,
            List<String> givens,
            String question,
            int answer,
            String hint,
            String explanation)?
        equation,
    TResult? Function(
            String id,
            Difficulty difficulty,
            int bucketIndex,
            int orderInBucket,
            List<TriangleCell> triangles,
            int answer,
            String hint,
            String explanation)?
        trianglePattern,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(
            String id,
            Difficulty difficulty,
            int bucketIndex,
            int orderInBucket,
            List<String> givens,
            String question,
            int answer,
            String hint,
            String explanation)?
        equation,
    TResult Function(
            String id,
            Difficulty difficulty,
            int bucketIndex,
            int orderInBucket,
            List<TriangleCell> triangles,
            int answer,
            String hint,
            String explanation)?
        trianglePattern,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(EquationRiddle value) equation,
    required TResult Function(TrianglePatternRiddle value) trianglePattern,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(EquationRiddle value)? equation,
    TResult? Function(TrianglePatternRiddle value)? trianglePattern,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(EquationRiddle value)? equation,
    TResult Function(TrianglePatternRiddle value)? trianglePattern,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $RiddleCopyWith<Riddle> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $RiddleCopyWith<$Res> {
  factory $RiddleCopyWith(Riddle value, $Res Function(Riddle) then) =
      _$RiddleCopyWithImpl<$Res, Riddle>;
  @useResult
  $Res call(
      {String id,
      Difficulty difficulty,
      int bucketIndex,
      int orderInBucket,
      int answer,
      String hint,
      String explanation});
}

/// @nodoc
class _$RiddleCopyWithImpl<$Res, $Val extends Riddle>
    implements $RiddleCopyWith<$Res> {
  _$RiddleCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? difficulty = null,
    Object? bucketIndex = null,
    Object? orderInBucket = null,
    Object? answer = null,
    Object? hint = null,
    Object? explanation = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      difficulty: null == difficulty
          ? _value.difficulty
          : difficulty // ignore: cast_nullable_to_non_nullable
              as Difficulty,
      bucketIndex: null == bucketIndex
          ? _value.bucketIndex
          : bucketIndex // ignore: cast_nullable_to_non_nullable
              as int,
      orderInBucket: null == orderInBucket
          ? _value.orderInBucket
          : orderInBucket // ignore: cast_nullable_to_non_nullable
              as int,
      answer: null == answer
          ? _value.answer
          : answer // ignore: cast_nullable_to_non_nullable
              as int,
      hint: null == hint
          ? _value.hint
          : hint // ignore: cast_nullable_to_non_nullable
              as String,
      explanation: null == explanation
          ? _value.explanation
          : explanation // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$EquationRiddleImplCopyWith<$Res>
    implements $RiddleCopyWith<$Res> {
  factory _$$EquationRiddleImplCopyWith(_$EquationRiddleImpl value,
          $Res Function(_$EquationRiddleImpl) then) =
      __$$EquationRiddleImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      Difficulty difficulty,
      int bucketIndex,
      int orderInBucket,
      List<String> givens,
      String question,
      int answer,
      String hint,
      String explanation});
}

/// @nodoc
class __$$EquationRiddleImplCopyWithImpl<$Res>
    extends _$RiddleCopyWithImpl<$Res, _$EquationRiddleImpl>
    implements _$$EquationRiddleImplCopyWith<$Res> {
  __$$EquationRiddleImplCopyWithImpl(
      _$EquationRiddleImpl _value, $Res Function(_$EquationRiddleImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? difficulty = null,
    Object? bucketIndex = null,
    Object? orderInBucket = null,
    Object? givens = null,
    Object? question = null,
    Object? answer = null,
    Object? hint = null,
    Object? explanation = null,
  }) {
    return _then(_$EquationRiddleImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      difficulty: null == difficulty
          ? _value.difficulty
          : difficulty // ignore: cast_nullable_to_non_nullable
              as Difficulty,
      bucketIndex: null == bucketIndex
          ? _value.bucketIndex
          : bucketIndex // ignore: cast_nullable_to_non_nullable
              as int,
      orderInBucket: null == orderInBucket
          ? _value.orderInBucket
          : orderInBucket // ignore: cast_nullable_to_non_nullable
              as int,
      givens: null == givens
          ? _value._givens
          : givens // ignore: cast_nullable_to_non_nullable
              as List<String>,
      question: null == question
          ? _value.question
          : question // ignore: cast_nullable_to_non_nullable
              as String,
      answer: null == answer
          ? _value.answer
          : answer // ignore: cast_nullable_to_non_nullable
              as int,
      hint: null == hint
          ? _value.hint
          : hint // ignore: cast_nullable_to_non_nullable
              as String,
      explanation: null == explanation
          ? _value.explanation
          : explanation // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$EquationRiddleImpl implements EquationRiddle {
  const _$EquationRiddleImpl(
      {required this.id,
      required this.difficulty,
      required this.bucketIndex,
      required this.orderInBucket,
      required final List<String> givens,
      required this.question,
      required this.answer,
      required this.hint,
      required this.explanation,
      final String? $type})
      : _givens = givens,
        $type = $type ?? 'equation';

  factory _$EquationRiddleImpl.fromJson(Map<String, dynamic> json) =>
      _$$EquationRiddleImplFromJson(json);

  @override
  final String id;
  @override
  final Difficulty difficulty;
  @override
  final int bucketIndex;
  @override
  final int orderInBucket;
  final List<String> _givens;
  @override
  List<String> get givens {
    if (_givens is EqualUnmodifiableListView) return _givens;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_givens);
  }

  @override
  final String question;
  @override
  final int answer;
  @override
  final String hint;
  @override
  final String explanation;

  @JsonKey(name: 'displayType')
  final String $type;

  @override
  String toString() {
    return 'Riddle.equation(id: $id, difficulty: $difficulty, bucketIndex: $bucketIndex, orderInBucket: $orderInBucket, givens: $givens, question: $question, answer: $answer, hint: $hint, explanation: $explanation)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$EquationRiddleImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.difficulty, difficulty) ||
                other.difficulty == difficulty) &&
            (identical(other.bucketIndex, bucketIndex) ||
                other.bucketIndex == bucketIndex) &&
            (identical(other.orderInBucket, orderInBucket) ||
                other.orderInBucket == orderInBucket) &&
            const DeepCollectionEquality().equals(other._givens, _givens) &&
            (identical(other.question, question) ||
                other.question == question) &&
            (identical(other.answer, answer) || other.answer == answer) &&
            (identical(other.hint, hint) || other.hint == hint) &&
            (identical(other.explanation, explanation) ||
                other.explanation == explanation));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      difficulty,
      bucketIndex,
      orderInBucket,
      const DeepCollectionEquality().hash(_givens),
      question,
      answer,
      hint,
      explanation);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$EquationRiddleImplCopyWith<_$EquationRiddleImpl> get copyWith =>
      __$$EquationRiddleImplCopyWithImpl<_$EquationRiddleImpl>(
          this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(
            String id,
            Difficulty difficulty,
            int bucketIndex,
            int orderInBucket,
            List<String> givens,
            String question,
            int answer,
            String hint,
            String explanation)
        equation,
    required TResult Function(
            String id,
            Difficulty difficulty,
            int bucketIndex,
            int orderInBucket,
            List<TriangleCell> triangles,
            int answer,
            String hint,
            String explanation)
        trianglePattern,
  }) {
    return equation(id, difficulty, bucketIndex, orderInBucket, givens,
        question, answer, hint, explanation);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(
            String id,
            Difficulty difficulty,
            int bucketIndex,
            int orderInBucket,
            List<String> givens,
            String question,
            int answer,
            String hint,
            String explanation)?
        equation,
    TResult? Function(
            String id,
            Difficulty difficulty,
            int bucketIndex,
            int orderInBucket,
            List<TriangleCell> triangles,
            int answer,
            String hint,
            String explanation)?
        trianglePattern,
  }) {
    return equation?.call(id, difficulty, bucketIndex, orderInBucket, givens,
        question, answer, hint, explanation);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(
            String id,
            Difficulty difficulty,
            int bucketIndex,
            int orderInBucket,
            List<String> givens,
            String question,
            int answer,
            String hint,
            String explanation)?
        equation,
    TResult Function(
            String id,
            Difficulty difficulty,
            int bucketIndex,
            int orderInBucket,
            List<TriangleCell> triangles,
            int answer,
            String hint,
            String explanation)?
        trianglePattern,
    required TResult orElse(),
  }) {
    if (equation != null) {
      return equation(id, difficulty, bucketIndex, orderInBucket, givens,
          question, answer, hint, explanation);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(EquationRiddle value) equation,
    required TResult Function(TrianglePatternRiddle value) trianglePattern,
  }) {
    return equation(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(EquationRiddle value)? equation,
    TResult? Function(TrianglePatternRiddle value)? trianglePattern,
  }) {
    return equation?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(EquationRiddle value)? equation,
    TResult Function(TrianglePatternRiddle value)? trianglePattern,
    required TResult orElse(),
  }) {
    if (equation != null) {
      return equation(this);
    }
    return orElse();
  }

  @override
  Map<String, dynamic> toJson() {
    return _$$EquationRiddleImplToJson(
      this,
    );
  }
}

abstract class EquationRiddle implements Riddle {
  const factory EquationRiddle(
      {required final String id,
      required final Difficulty difficulty,
      required final int bucketIndex,
      required final int orderInBucket,
      required final List<String> givens,
      required final String question,
      required final int answer,
      required final String hint,
      required final String explanation}) = _$EquationRiddleImpl;

  factory EquationRiddle.fromJson(Map<String, dynamic> json) =
      _$EquationRiddleImpl.fromJson;

  @override
  String get id;
  @override
  Difficulty get difficulty;
  @override
  int get bucketIndex;
  @override
  int get orderInBucket;
  List<String> get givens;
  String get question;
  @override
  int get answer;
  @override
  String get hint;
  @override
  String get explanation;
  @override
  @JsonKey(ignore: true)
  _$$EquationRiddleImplCopyWith<_$EquationRiddleImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$TrianglePatternRiddleImplCopyWith<$Res>
    implements $RiddleCopyWith<$Res> {
  factory _$$TrianglePatternRiddleImplCopyWith(
          _$TrianglePatternRiddleImpl value,
          $Res Function(_$TrianglePatternRiddleImpl) then) =
      __$$TrianglePatternRiddleImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      Difficulty difficulty,
      int bucketIndex,
      int orderInBucket,
      List<TriangleCell> triangles,
      int answer,
      String hint,
      String explanation});
}

/// @nodoc
class __$$TrianglePatternRiddleImplCopyWithImpl<$Res>
    extends _$RiddleCopyWithImpl<$Res, _$TrianglePatternRiddleImpl>
    implements _$$TrianglePatternRiddleImplCopyWith<$Res> {
  __$$TrianglePatternRiddleImplCopyWithImpl(_$TrianglePatternRiddleImpl _value,
      $Res Function(_$TrianglePatternRiddleImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? difficulty = null,
    Object? bucketIndex = null,
    Object? orderInBucket = null,
    Object? triangles = null,
    Object? answer = null,
    Object? hint = null,
    Object? explanation = null,
  }) {
    return _then(_$TrianglePatternRiddleImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      difficulty: null == difficulty
          ? _value.difficulty
          : difficulty // ignore: cast_nullable_to_non_nullable
              as Difficulty,
      bucketIndex: null == bucketIndex
          ? _value.bucketIndex
          : bucketIndex // ignore: cast_nullable_to_non_nullable
              as int,
      orderInBucket: null == orderInBucket
          ? _value.orderInBucket
          : orderInBucket // ignore: cast_nullable_to_non_nullable
              as int,
      triangles: null == triangles
          ? _value._triangles
          : triangles // ignore: cast_nullable_to_non_nullable
              as List<TriangleCell>,
      answer: null == answer
          ? _value.answer
          : answer // ignore: cast_nullable_to_non_nullable
              as int,
      hint: null == hint
          ? _value.hint
          : hint // ignore: cast_nullable_to_non_nullable
              as String,
      explanation: null == explanation
          ? _value.explanation
          : explanation // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$TrianglePatternRiddleImpl implements TrianglePatternRiddle {
  const _$TrianglePatternRiddleImpl(
      {required this.id,
      required this.difficulty,
      required this.bucketIndex,
      required this.orderInBucket,
      required final List<TriangleCell> triangles,
      required this.answer,
      required this.hint,
      required this.explanation,
      final String? $type})
      : _triangles = triangles,
        $type = $type ?? 'trianglePattern';

  factory _$TrianglePatternRiddleImpl.fromJson(Map<String, dynamic> json) =>
      _$$TrianglePatternRiddleImplFromJson(json);

  @override
  final String id;
  @override
  final Difficulty difficulty;
  @override
  final int bucketIndex;
  @override
  final int orderInBucket;
  final List<TriangleCell> _triangles;
  @override
  List<TriangleCell> get triangles {
    if (_triangles is EqualUnmodifiableListView) return _triangles;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_triangles);
  }

  @override
  final int answer;
  @override
  final String hint;
  @override
  final String explanation;

  @JsonKey(name: 'displayType')
  final String $type;

  @override
  String toString() {
    return 'Riddle.trianglePattern(id: $id, difficulty: $difficulty, bucketIndex: $bucketIndex, orderInBucket: $orderInBucket, triangles: $triangles, answer: $answer, hint: $hint, explanation: $explanation)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$TrianglePatternRiddleImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.difficulty, difficulty) ||
                other.difficulty == difficulty) &&
            (identical(other.bucketIndex, bucketIndex) ||
                other.bucketIndex == bucketIndex) &&
            (identical(other.orderInBucket, orderInBucket) ||
                other.orderInBucket == orderInBucket) &&
            const DeepCollectionEquality()
                .equals(other._triangles, _triangles) &&
            (identical(other.answer, answer) || other.answer == answer) &&
            (identical(other.hint, hint) || other.hint == hint) &&
            (identical(other.explanation, explanation) ||
                other.explanation == explanation));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      difficulty,
      bucketIndex,
      orderInBucket,
      const DeepCollectionEquality().hash(_triangles),
      answer,
      hint,
      explanation);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$TrianglePatternRiddleImplCopyWith<_$TrianglePatternRiddleImpl>
      get copyWith => __$$TrianglePatternRiddleImplCopyWithImpl<
          _$TrianglePatternRiddleImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(
            String id,
            Difficulty difficulty,
            int bucketIndex,
            int orderInBucket,
            List<String> givens,
            String question,
            int answer,
            String hint,
            String explanation)
        equation,
    required TResult Function(
            String id,
            Difficulty difficulty,
            int bucketIndex,
            int orderInBucket,
            List<TriangleCell> triangles,
            int answer,
            String hint,
            String explanation)
        trianglePattern,
  }) {
    return trianglePattern(id, difficulty, bucketIndex, orderInBucket,
        triangles, answer, hint, explanation);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(
            String id,
            Difficulty difficulty,
            int bucketIndex,
            int orderInBucket,
            List<String> givens,
            String question,
            int answer,
            String hint,
            String explanation)?
        equation,
    TResult? Function(
            String id,
            Difficulty difficulty,
            int bucketIndex,
            int orderInBucket,
            List<TriangleCell> triangles,
            int answer,
            String hint,
            String explanation)?
        trianglePattern,
  }) {
    return trianglePattern?.call(id, difficulty, bucketIndex, orderInBucket,
        triangles, answer, hint, explanation);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(
            String id,
            Difficulty difficulty,
            int bucketIndex,
            int orderInBucket,
            List<String> givens,
            String question,
            int answer,
            String hint,
            String explanation)?
        equation,
    TResult Function(
            String id,
            Difficulty difficulty,
            int bucketIndex,
            int orderInBucket,
            List<TriangleCell> triangles,
            int answer,
            String hint,
            String explanation)?
        trianglePattern,
    required TResult orElse(),
  }) {
    if (trianglePattern != null) {
      return trianglePattern(id, difficulty, bucketIndex, orderInBucket,
          triangles, answer, hint, explanation);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(EquationRiddle value) equation,
    required TResult Function(TrianglePatternRiddle value) trianglePattern,
  }) {
    return trianglePattern(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(EquationRiddle value)? equation,
    TResult? Function(TrianglePatternRiddle value)? trianglePattern,
  }) {
    return trianglePattern?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(EquationRiddle value)? equation,
    TResult Function(TrianglePatternRiddle value)? trianglePattern,
    required TResult orElse(),
  }) {
    if (trianglePattern != null) {
      return trianglePattern(this);
    }
    return orElse();
  }

  @override
  Map<String, dynamic> toJson() {
    return _$$TrianglePatternRiddleImplToJson(
      this,
    );
  }
}

abstract class TrianglePatternRiddle implements Riddle {
  const factory TrianglePatternRiddle(
      {required final String id,
      required final Difficulty difficulty,
      required final int bucketIndex,
      required final int orderInBucket,
      required final List<TriangleCell> triangles,
      required final int answer,
      required final String hint,
      required final String explanation}) = _$TrianglePatternRiddleImpl;

  factory TrianglePatternRiddle.fromJson(Map<String, dynamic> json) =
      _$TrianglePatternRiddleImpl.fromJson;

  @override
  String get id;
  @override
  Difficulty get difficulty;
  @override
  int get bucketIndex;
  @override
  int get orderInBucket;
  List<TriangleCell> get triangles;
  @override
  int get answer;
  @override
  String get hint;
  @override
  String get explanation;
  @override
  @JsonKey(ignore: true)
  _$$TrianglePatternRiddleImplCopyWith<_$TrianglePatternRiddleImpl>
      get copyWith => throw _privateConstructorUsedError;
}

TriangleCell _$TriangleCellFromJson(Map<String, dynamic> json) {
  return _TriangleCell.fromJson(json);
}

/// @nodoc
mixin _$TriangleCell {
  int get left => throw _privateConstructorUsedError;
  int get right => throw _privateConstructorUsedError;
  int? get bottom => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $TriangleCellCopyWith<TriangleCell> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $TriangleCellCopyWith<$Res> {
  factory $TriangleCellCopyWith(
          TriangleCell value, $Res Function(TriangleCell) then) =
      _$TriangleCellCopyWithImpl<$Res, TriangleCell>;
  @useResult
  $Res call({int left, int right, int? bottom});
}

/// @nodoc
class _$TriangleCellCopyWithImpl<$Res, $Val extends TriangleCell>
    implements $TriangleCellCopyWith<$Res> {
  _$TriangleCellCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? left = null,
    Object? right = null,
    Object? bottom = freezed,
  }) {
    return _then(_value.copyWith(
      left: null == left
          ? _value.left
          : left // ignore: cast_nullable_to_non_nullable
              as int,
      right: null == right
          ? _value.right
          : right // ignore: cast_nullable_to_non_nullable
              as int,
      bottom: freezed == bottom
          ? _value.bottom
          : bottom // ignore: cast_nullable_to_non_nullable
              as int?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$TriangleCellImplCopyWith<$Res>
    implements $TriangleCellCopyWith<$Res> {
  factory _$$TriangleCellImplCopyWith(
          _$TriangleCellImpl value, $Res Function(_$TriangleCellImpl) then) =
      __$$TriangleCellImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({int left, int right, int? bottom});
}

/// @nodoc
class __$$TriangleCellImplCopyWithImpl<$Res>
    extends _$TriangleCellCopyWithImpl<$Res, _$TriangleCellImpl>
    implements _$$TriangleCellImplCopyWith<$Res> {
  __$$TriangleCellImplCopyWithImpl(
      _$TriangleCellImpl _value, $Res Function(_$TriangleCellImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? left = null,
    Object? right = null,
    Object? bottom = freezed,
  }) {
    return _then(_$TriangleCellImpl(
      left: null == left
          ? _value.left
          : left // ignore: cast_nullable_to_non_nullable
              as int,
      right: null == right
          ? _value.right
          : right // ignore: cast_nullable_to_non_nullable
              as int,
      bottom: freezed == bottom
          ? _value.bottom
          : bottom // ignore: cast_nullable_to_non_nullable
              as int?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$TriangleCellImpl implements _TriangleCell {
  const _$TriangleCellImpl(
      {required this.left, required this.right, required this.bottom});

  factory _$TriangleCellImpl.fromJson(Map<String, dynamic> json) =>
      _$$TriangleCellImplFromJson(json);

  @override
  final int left;
  @override
  final int right;
  @override
  final int? bottom;

  @override
  String toString() {
    return 'TriangleCell(left: $left, right: $right, bottom: $bottom)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$TriangleCellImpl &&
            (identical(other.left, left) || other.left == left) &&
            (identical(other.right, right) || other.right == right) &&
            (identical(other.bottom, bottom) || other.bottom == bottom));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, left, right, bottom);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$TriangleCellImplCopyWith<_$TriangleCellImpl> get copyWith =>
      __$$TriangleCellImplCopyWithImpl<_$TriangleCellImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$TriangleCellImplToJson(
      this,
    );
  }
}

abstract class _TriangleCell implements TriangleCell {
  const factory _TriangleCell(
      {required final int left,
      required final int right,
      required final int? bottom}) = _$TriangleCellImpl;

  factory _TriangleCell.fromJson(Map<String, dynamic> json) =
      _$TriangleCellImpl.fromJson;

  @override
  int get left;
  @override
  int get right;
  @override
  int? get bottom;
  @override
  @JsonKey(ignore: true)
  _$$TriangleCellImplCopyWith<_$TriangleCellImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
