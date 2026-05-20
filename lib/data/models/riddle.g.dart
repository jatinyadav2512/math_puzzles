// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'riddle.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$EquationRiddleImpl _$$EquationRiddleImplFromJson(Map<String, dynamic> json) =>
    _$EquationRiddleImpl(
      id: json['id'] as String,
      difficulty: $enumDecode(_$DifficultyEnumMap, json['difficulty']),
      bucketIndex: (json['bucketIndex'] as num).toInt(),
      orderInBucket: (json['orderInBucket'] as num).toInt(),
      givens:
          (json['givens'] as List<dynamic>).map((e) => e as String).toList(),
      question: json['question'] as String,
      answer: (json['answer'] as num).toInt(),
      hint: json['hint'] as String,
      explanation: json['explanation'] as String,
      $type: json['displayType'] as String?,
    );

Map<String, dynamic> _$$EquationRiddleImplToJson(
        _$EquationRiddleImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'difficulty': _$DifficultyEnumMap[instance.difficulty]!,
      'bucketIndex': instance.bucketIndex,
      'orderInBucket': instance.orderInBucket,
      'givens': instance.givens,
      'question': instance.question,
      'answer': instance.answer,
      'hint': instance.hint,
      'explanation': instance.explanation,
      'displayType': instance.$type,
    };

const _$DifficultyEnumMap = {
  Difficulty.easy: 'easy',
  Difficulty.medium: 'medium',
  Difficulty.hard: 'hard',
  Difficulty.expert: 'expert',
  Difficulty.master: 'master',
};

_$TrianglePatternRiddleImpl _$$TrianglePatternRiddleImplFromJson(
        Map<String, dynamic> json) =>
    _$TrianglePatternRiddleImpl(
      id: json['id'] as String,
      difficulty: $enumDecode(_$DifficultyEnumMap, json['difficulty']),
      bucketIndex: (json['bucketIndex'] as num).toInt(),
      orderInBucket: (json['orderInBucket'] as num).toInt(),
      triangles: (json['triangles'] as List<dynamic>)
          .map((e) => TriangleCell.fromJson(e as Map<String, dynamic>))
          .toList(),
      answer: (json['answer'] as num).toInt(),
      hint: json['hint'] as String,
      explanation: json['explanation'] as String,
      $type: json['displayType'] as String?,
    );

Map<String, dynamic> _$$TrianglePatternRiddleImplToJson(
        _$TrianglePatternRiddleImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'difficulty': _$DifficultyEnumMap[instance.difficulty]!,
      'bucketIndex': instance.bucketIndex,
      'orderInBucket': instance.orderInBucket,
      'triangles': instance.triangles.map((e) => e.toJson()).toList(),
      'answer': instance.answer,
      'hint': instance.hint,
      'explanation': instance.explanation,
      'displayType': instance.$type,
    };

_$TriangleCellImpl _$$TriangleCellImplFromJson(Map<String, dynamic> json) =>
    _$TriangleCellImpl(
      left: (json['left'] as num).toInt(),
      right: (json['right'] as num).toInt(),
      bottom: (json['bottom'] as num?)?.toInt(),
    );

Map<String, dynamic> _$$TriangleCellImplToJson(_$TriangleCellImpl instance) =>
    <String, dynamic>{
      'left': instance.left,
      'right': instance.right,
      'bottom': instance.bottom,
    };
