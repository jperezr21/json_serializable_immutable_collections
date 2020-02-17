// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MyModel _$MyModelFromJson(Map<String, dynamic> json) {
  return MyModel(
    myList: (json['myList'] as List)?.map((e) => e as int)?.toBuiltList(),
    myString: (json['myString'] as List)?.map((e) => e as String)?.toBuiltSet(),
    myNested: (json['myNested'] as List)
        ?.map((e) =>
            e == null ? null : Nested.fromJson(e as Map<String, dynamic>))
        ?.toBuiltList(),
    normalList: (json['normalList'] as List)?.map((e) => e as String)?.toList(),
    normalSet: (json['normalSet'] as List)?.map((e) => e as String)?.toSet(),
  );
}

Map<String, dynamic> _$MyModelToJson(MyModel instance) => <String, dynamic>{
      'myList': instance.myList?.toList(),
      'myString': instance.myString?.toList(),
      'myNested': instance.myNested?.map((e) => e?.toJson())?.toList(),
      'normalList': instance.normalList,
      'normalSet': instance.normalSet?.toList(),
    };

Nested _$NestedFromJson(Map<String, dynamic> json) {
  return Nested(
    json['a'] as int,
  );
}

Map<String, dynamic> _$NestedToJson(Nested instance) => <String, dynamic>{
      'a': instance.a,
    };
