// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MyModel _$MyModelFromJson(Map<String, dynamic> json) => MyModel(
      myList: (json['myList'] as List).map((e) => e as int).toIList(),
      builtMapString:
          Map<String, String>.from(json['builtMapString'] as Map).toIMap(),
      myString: (json['myString'] as List).map((e) => e as String).toISet(),
      dynamicMap: (json['dynamicMap'] as Map<String, dynamic>).toIMap(),
      myNested: (json['myNested'] as List)
          .map((e) => Nested.fromJson(e as Map<String, dynamic>))
          .toIList(),
      normalList: (json['normalList'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      builtMap: (json['builtMap'] as Map<String, dynamic>)
          .map(
            (k, e) => MapEntry(int.parse(k), e as String),
          )
          .toIMap(),
      builtMapNested: (json['builtMapNested'] as Map<String, dynamic>)
          .map(
            (k, e) => MapEntry(
                int.parse(k), Nested.fromJson(e as Map<String, dynamic>)),
          )
          .toIMap(),
      nullList: json['nullList'] != null
          ? (json['nullList'] as List).map((e) => e as String).toIList()
          : null,
      nullMap: json['nullMap'] != null
          ? (json['nullMap'] as Map<String, dynamic>)
              .map(
                (k, e) => MapEntry(k, e as String),
              )
              .toIMap()
          : null,
      nullSet: json['nullSet'] != null
          ? (json['nullSet'] as List).map((e) => e as String).toISet()
          : null,
      normalSet:
          (json['normalSet'] as List<dynamic>).map((e) => e as String).toSet(),
      nullablelistWithNullable: json['nullablelistWithNullable'] != null
          ? (json['nullablelistWithNullable'] as List)
              .map((e) => e as String?)
              .toIList()
          : null,
      listWithNullable:
          (json['listWithNullable'] as List).map((e) => e as String?).toIList(),
      nullableMap:
          Map<String, String?>.from(json['nullableMap'] as Map).toIMap(),
      nullableSet:
          (json['nullableSet'] as List).map((e) => e as String?).toISet(),
      enumMap: (json['enumMap'] as Map<String, dynamic>)
          .map(
            (k, e) => MapEntry($enumDecode(_$MyEnumEnumMap, k), e as String),
          )
          .toIMap(),
    );

Map<String, dynamic> _$MyModelToJson(MyModel instance) => <String, dynamic>{
      'myList': instance.myList.toList(),
      'myString': instance.myString.toList(),
      'myNested': instance.myNested.map((e) => e.toJson()).toList(),
      'normalList': instance.normalList,
      'normalSet': instance.normalSet.toList(),
      'builtMap':
          instance.builtMap.unlockLazy.map((k, e) => MapEntry(k.toString(), e)),
      'builtMapString': instance.builtMapString.unlockLazy,
      'builtMapNested': instance.builtMapNested.unlockLazy
          .map((k, e) => MapEntry(k.toString(), e.toJson())),
      'nullList': instance.nullList?.toList(),
      'listWithNullable': instance.listWithNullable.toList(),
      'nullablelistWithNullable': instance.nullablelistWithNullable?.toList(),
      'nullSet': instance.nullSet?.toList(),
      'nullableSet': instance.nullableSet.toList(),
      'nullMap': instance.nullMap?.unlockLazy,
      'nullableMap': instance.nullableMap.unlockLazy,
      'dynamicMap': instance.dynamicMap.unlockLazy,
      'enumMap': instance.enumMap.unlockLazy
          .map((k, e) => MapEntry(_$MyEnumEnumMap[k]!, e)),
    };

const _$MyEnumEnumMap = {
  MyEnum.one: 'one',
  MyEnum.two: 'two',
  MyEnum.three: 'three',
};

Nested _$NestedFromJson(Map<String, dynamic> json) => Nested(
      json['a'] as int,
    );

Map<String, dynamic> _$NestedToJson(Nested instance) => <String, dynamic>{
      'a': instance.a,
    };
