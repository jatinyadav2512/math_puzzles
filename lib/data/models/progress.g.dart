// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'progress.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$RiddleProgressImpl _$$RiddleProgressImplFromJson(Map<String, dynamic> json) =>
    _$RiddleProgressImpl(
      solved: json['solved'] as bool? ?? false,
      hintUsed: json['hintUsed'] as bool? ?? false,
      attempts: (json['attempts'] as num?)?.toInt() ?? 0,
      solvedAt: json['solvedAt'] == null
          ? null
          : DateTime.parse(json['solvedAt'] as String),
    );

Map<String, dynamic> _$$RiddleProgressImplToJson(
        _$RiddleProgressImpl instance) =>
    <String, dynamic>{
      'solved': instance.solved,
      'hintUsed': instance.hintUsed,
      'attempts': instance.attempts,
      'solvedAt': instance.solvedAt?.toIso8601String(),
    };

_$ProgressImpl _$$ProgressImplFromJson(Map<String, dynamic> json) =>
    _$ProgressImpl(
      byId: (json['byId'] as Map<String, dynamic>?)?.map(
            (k, e) =>
                MapEntry(k, RiddleProgress.fromJson(e as Map<String, dynamic>)),
          ) ??
          const <String, RiddleProgress>{},
    );

Map<String, dynamic> _$$ProgressImplToJson(_$ProgressImpl instance) =>
    <String, dynamic>{
      'byId': instance.byId.map((k, e) => MapEntry(k, e.toJson())),
    };
