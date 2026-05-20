// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'progress.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

RiddleProgress _$RiddleProgressFromJson(Map<String, dynamic> json) {
  return _RiddleProgress.fromJson(json);
}

/// @nodoc
mixin _$RiddleProgress {
  bool get solved => throw _privateConstructorUsedError;
  bool get hintUsed => throw _privateConstructorUsedError;
  int get attempts => throw _privateConstructorUsedError;
  DateTime? get solvedAt => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $RiddleProgressCopyWith<RiddleProgress> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $RiddleProgressCopyWith<$Res> {
  factory $RiddleProgressCopyWith(
          RiddleProgress value, $Res Function(RiddleProgress) then) =
      _$RiddleProgressCopyWithImpl<$Res, RiddleProgress>;
  @useResult
  $Res call({bool solved, bool hintUsed, int attempts, DateTime? solvedAt});
}

/// @nodoc
class _$RiddleProgressCopyWithImpl<$Res, $Val extends RiddleProgress>
    implements $RiddleProgressCopyWith<$Res> {
  _$RiddleProgressCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? solved = null,
    Object? hintUsed = null,
    Object? attempts = null,
    Object? solvedAt = freezed,
  }) {
    return _then(_value.copyWith(
      solved: null == solved
          ? _value.solved
          : solved // ignore: cast_nullable_to_non_nullable
              as bool,
      hintUsed: null == hintUsed
          ? _value.hintUsed
          : hintUsed // ignore: cast_nullable_to_non_nullable
              as bool,
      attempts: null == attempts
          ? _value.attempts
          : attempts // ignore: cast_nullable_to_non_nullable
              as int,
      solvedAt: freezed == solvedAt
          ? _value.solvedAt
          : solvedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$RiddleProgressImplCopyWith<$Res>
    implements $RiddleProgressCopyWith<$Res> {
  factory _$$RiddleProgressImplCopyWith(_$RiddleProgressImpl value,
          $Res Function(_$RiddleProgressImpl) then) =
      __$$RiddleProgressImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({bool solved, bool hintUsed, int attempts, DateTime? solvedAt});
}

/// @nodoc
class __$$RiddleProgressImplCopyWithImpl<$Res>
    extends _$RiddleProgressCopyWithImpl<$Res, _$RiddleProgressImpl>
    implements _$$RiddleProgressImplCopyWith<$Res> {
  __$$RiddleProgressImplCopyWithImpl(
      _$RiddleProgressImpl _value, $Res Function(_$RiddleProgressImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? solved = null,
    Object? hintUsed = null,
    Object? attempts = null,
    Object? solvedAt = freezed,
  }) {
    return _then(_$RiddleProgressImpl(
      solved: null == solved
          ? _value.solved
          : solved // ignore: cast_nullable_to_non_nullable
              as bool,
      hintUsed: null == hintUsed
          ? _value.hintUsed
          : hintUsed // ignore: cast_nullable_to_non_nullable
              as bool,
      attempts: null == attempts
          ? _value.attempts
          : attempts // ignore: cast_nullable_to_non_nullable
              as int,
      solvedAt: freezed == solvedAt
          ? _value.solvedAt
          : solvedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$RiddleProgressImpl implements _RiddleProgress {
  const _$RiddleProgressImpl(
      {this.solved = false,
      this.hintUsed = false,
      this.attempts = 0,
      this.solvedAt});

  factory _$RiddleProgressImpl.fromJson(Map<String, dynamic> json) =>
      _$$RiddleProgressImplFromJson(json);

  @override
  @JsonKey()
  final bool solved;
  @override
  @JsonKey()
  final bool hintUsed;
  @override
  @JsonKey()
  final int attempts;
  @override
  final DateTime? solvedAt;

  @override
  String toString() {
    return 'RiddleProgress(solved: $solved, hintUsed: $hintUsed, attempts: $attempts, solvedAt: $solvedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$RiddleProgressImpl &&
            (identical(other.solved, solved) || other.solved == solved) &&
            (identical(other.hintUsed, hintUsed) ||
                other.hintUsed == hintUsed) &&
            (identical(other.attempts, attempts) ||
                other.attempts == attempts) &&
            (identical(other.solvedAt, solvedAt) ||
                other.solvedAt == solvedAt));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode =>
      Object.hash(runtimeType, solved, hintUsed, attempts, solvedAt);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$RiddleProgressImplCopyWith<_$RiddleProgressImpl> get copyWith =>
      __$$RiddleProgressImplCopyWithImpl<_$RiddleProgressImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$RiddleProgressImplToJson(
      this,
    );
  }
}

abstract class _RiddleProgress implements RiddleProgress {
  const factory _RiddleProgress(
      {final bool solved,
      final bool hintUsed,
      final int attempts,
      final DateTime? solvedAt}) = _$RiddleProgressImpl;

  factory _RiddleProgress.fromJson(Map<String, dynamic> json) =
      _$RiddleProgressImpl.fromJson;

  @override
  bool get solved;
  @override
  bool get hintUsed;
  @override
  int get attempts;
  @override
  DateTime? get solvedAt;
  @override
  @JsonKey(ignore: true)
  _$$RiddleProgressImplCopyWith<_$RiddleProgressImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

Progress _$ProgressFromJson(Map<String, dynamic> json) {
  return _Progress.fromJson(json);
}

/// @nodoc
mixin _$Progress {
  Map<String, RiddleProgress> get byId => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $ProgressCopyWith<Progress> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ProgressCopyWith<$Res> {
  factory $ProgressCopyWith(Progress value, $Res Function(Progress) then) =
      _$ProgressCopyWithImpl<$Res, Progress>;
  @useResult
  $Res call({Map<String, RiddleProgress> byId});
}

/// @nodoc
class _$ProgressCopyWithImpl<$Res, $Val extends Progress>
    implements $ProgressCopyWith<$Res> {
  _$ProgressCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? byId = null,
  }) {
    return _then(_value.copyWith(
      byId: null == byId
          ? _value.byId
          : byId // ignore: cast_nullable_to_non_nullable
              as Map<String, RiddleProgress>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ProgressImplCopyWith<$Res>
    implements $ProgressCopyWith<$Res> {
  factory _$$ProgressImplCopyWith(
          _$ProgressImpl value, $Res Function(_$ProgressImpl) then) =
      __$$ProgressImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({Map<String, RiddleProgress> byId});
}

/// @nodoc
class __$$ProgressImplCopyWithImpl<$Res>
    extends _$ProgressCopyWithImpl<$Res, _$ProgressImpl>
    implements _$$ProgressImplCopyWith<$Res> {
  __$$ProgressImplCopyWithImpl(
      _$ProgressImpl _value, $Res Function(_$ProgressImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? byId = null,
  }) {
    return _then(_$ProgressImpl(
      byId: null == byId
          ? _value._byId
          : byId // ignore: cast_nullable_to_non_nullable
              as Map<String, RiddleProgress>,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$ProgressImpl extends _Progress {
  const _$ProgressImpl(
      {final Map<String, RiddleProgress> byId =
          const <String, RiddleProgress>{}})
      : _byId = byId,
        super._();

  factory _$ProgressImpl.fromJson(Map<String, dynamic> json) =>
      _$$ProgressImplFromJson(json);

  final Map<String, RiddleProgress> _byId;
  @override
  @JsonKey()
  Map<String, RiddleProgress> get byId {
    if (_byId is EqualUnmodifiableMapView) return _byId;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_byId);
  }

  @override
  String toString() {
    return 'Progress(byId: $byId)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ProgressImpl &&
            const DeepCollectionEquality().equals(other._byId, _byId));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode =>
      Object.hash(runtimeType, const DeepCollectionEquality().hash(_byId));

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$ProgressImplCopyWith<_$ProgressImpl> get copyWith =>
      __$$ProgressImplCopyWithImpl<_$ProgressImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ProgressImplToJson(
      this,
    );
  }
}

abstract class _Progress extends Progress {
  const factory _Progress({final Map<String, RiddleProgress> byId}) =
      _$ProgressImpl;
  const _Progress._() : super._();

  factory _Progress.fromJson(Map<String, dynamic> json) =
      _$ProgressImpl.fromJson;

  @override
  Map<String, RiddleProgress> get byId;
  @override
  @JsonKey(ignore: true)
  _$$ProgressImplCopyWith<_$ProgressImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
