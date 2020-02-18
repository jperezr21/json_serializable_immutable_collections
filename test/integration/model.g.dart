// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MyModel _$MyModelFromJson(Map<String, dynamic> json) {
  return MyModel(
    myList: (json['myList'] as List)?.map((e) => e as int)?.toBuiltList(),
    builtMapString: BuiltMap<String, String>.of(
        (json['builtMapString'] as Map<String, dynamic>)?.map(
      (k, e) => MapEntry(k, e as String),
    )),
    myString: (json['myString'] as List)?.map((e) => e as String)?.toBuiltSet(),
    myNested: (json['myNested'] as List)
        ?.map((e) =>
            e == null ? null : Nested.fromJson(e as Map<String, dynamic>))
        ?.toBuiltList(),
    normalList: (json['normalList'] as List)?.map((e) => e as String)?.toList(),
    builtMap: BuiltMap<int, String>.of(
        (json['builtMap'] as Map<String, dynamic>)?.map(
      (k, e) => MapEntry(int.parse(k), e as String),
    )),
    builtMapNested: BuiltMap<int, Nested>.of(
        (json['builtMapNested'] as Map<String, dynamic>)?.map(
      (k, e) => MapEntry(int.parse(k),
          e == null ? null : Nested.fromJson(e as Map<String, dynamic>)),
    )),
    normalSet: (json['normalSet'] as List)?.map((e) => e as String)?.toSet(),
  );
}

Map<String, dynamic> _$MyModelToJson(MyModel instance) => <String, dynamic>{
      'myList': instance.myList?.toList(),
      'myString': instance.myString?.toList(),
      'myNested': instance.myNested?.map((e) => e?.toJson())?.toList(),
      'normalList': instance.normalList,
      'normalSet': instance.normalSet?.toList(),
      'builtMap':
          instance.builtMap?.toMap().map((k, e) => MapEntry(k.toString(), e)),
      'builtMapString': instance.builtMapString.toMap(),
      'builtMapNested': instance.builtMapNested
          ?.toMap()
          .map((k, e) => MapEntry(k.toString(), e?.toJson())),
    };

Nested _$NestedFromJson(Map<String, dynamic> json) {
  return Nested(
    json['a'] as int,
  );
}

Map<String, dynamic> _$NestedToJson(Nested instance) => <String, dynamic>{
      'a': instance.a,
    };
