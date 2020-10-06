// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'main.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Model _$ModelFromJson(Map<String, dynamic> json) {
  return Model(
    myIntList: json['myIntList'] != null
        ? ObservableList<int>.of(
            (json['myIntList'] as List).map((e) => e as int))
        : null,
  );
}

Map<String, dynamic> _$ModelToJson(Model instance) => <String, dynamic>{
      'myIntList': instance.myIntList,
    };
