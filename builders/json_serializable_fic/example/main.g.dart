// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'main.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Model _$ModelFromJson(Map<String, dynamic> json) => Model(
      myIntList:
          (json['myIntList'] as List).map((e) => (e as num).toInt()).toIList(),
    );

Map<String, dynamic> _$ModelToJson(Model instance) => <String, dynamic>{
      'myIntList': instance.myIntList.toList(),
    };
