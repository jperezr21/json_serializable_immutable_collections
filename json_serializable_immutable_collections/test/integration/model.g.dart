// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MyModel _$MyModelFromJson(Map<String, dynamic> json) {
  return MyModel(
    myList: json['myList'] != null
        ? (json['myList'] as List).map((e) => e as int).toBuiltList()
        : null,
    builtMapString: json['builtMapString'] != null
        ? BuiltMap<String, String>.of(
            (json['builtMapString'] as Map<String, dynamic>).map(
            (k, e) => MapEntry(k, e as String),
          ))
        : null,
    myString: json['myString'] != null
        ? (json['myString'] as List).map((e) => e as String).toBuiltSet()
        : null,
    dynamicMap: json['dynamicMap'] != null
        ? BuiltMap<String, Object>.of(
            json['dynamicMap'] as Map<String, dynamic>)
        : null,
    myNested: json['myNested'] != null
        ? (json['myNested'] as List)
            .map((e) =>
                e == null ? null : Nested.fromJson(e as Map<String, dynamic>))
            .toBuiltList()
        : null,
    normalList: (json['normalList'] as List)?.map((e) => e as String)?.toList(),
    builtMap: json['builtMap'] != null
        ? BuiltMap<int, String>.of(
            (json['builtMap'] as Map<String, dynamic>).map(
            (k, e) => MapEntry(int.parse(k), e as String),
          ))
        : null,
    builtMapNested: json['builtMapNested'] != null
        ? BuiltMap<int, Nested>.of(
            (json['builtMapNested'] as Map<String, dynamic>).map(
            (k, e) => MapEntry(int.parse(k),
                e == null ? null : Nested.fromJson(e as Map<String, dynamic>)),
          ))
        : null,
    nullList: json['nullList'] != null
        ? (json['nullList'] as List).map((e) => e as String).toBuiltList()
        : null,
    nullMap: json['nullMap'] != null
        ? BuiltMap<String, String>.of(
            (json['nullMap'] as Map<String, dynamic>).map(
            (k, e) => MapEntry(k, e as String),
          ))
        : null,
    nullSet: json['nullSet'] != null
        ? (json['nullSet'] as List).map((e) => e as String).toBuiltSet()
        : null,
    normalSet: (json['normalSet'] as List)?.map((e) => e as String)?.toSet(),
    nestedKtList: json['nestedKtList'] != null
        ? KtList<Nested>.from((json['nestedKtList'] as List).map((e) =>
            e == null ? null : Nested.fromJson(e as Map<String, dynamic>)))
        : null,
    nestedKtSet: json['nestedKtSet'] != null
        ? KtSet<Nested>.from((json['nestedKtSet'] as List).map((e) =>
            e == null ? null : Nested.fromJson(e as Map<String, dynamic>)))
        : null,
    nullKtList: json['nullKtList'] != null
        ? KtList<String>.from(
            (json['nullKtList'] as List).map((e) => e as String))
        : null,
    nullKtSet: json['nullKtSet'] != null
        ? KtSet<String>.from(
            (json['nullKtSet'] as List).map((e) => e as String))
        : null,
    stringKtList: json['stringKtList'] != null
        ? KtList<String>.from(
            (json['stringKtList'] as List).map((e) => e as String))
        : null,
    stringKtSet: json['stringKtSet'] != null
        ? KtSet<String>.from(
            (json['stringKtSet'] as List).map((e) => e as String))
        : null,
    nestedKtMap: json['nestedKtMap'] != null
        ? KtMap<String, Nested>.from(
            (json['nestedKtMap'] as Map<String, dynamic>).map(
            (k, e) => MapEntry(k,
                e == null ? null : Nested.fromJson(e as Map<String, dynamic>)),
          ))
        : null,
    stringKtMap: json['stringKtMap'] != null
        ? KtMap<String, String>.from(
            (json['stringKtMap'] as Map<String, dynamic>).map(
            (k, e) => MapEntry(k, e as String),
          ))
        : null,
    nullKtMap: json['nullKtMap'] != null
        ? KtMap<String, dynamic>.from(json['nullKtMap'] as Map<String, dynamic>)
        : null,
    dynamicKtMap: json['dynamicKtMap'] != null
        ? KtMap<String, dynamic>.from(
            json['dynamicKtMap'] as Map<String, dynamic>)
        : null,
  );
}

Map<String, dynamic> _$MyModelToJson(MyModel instance) => <String, dynamic>{
      'myList': instance.myList?.toList(),
      'myString': instance.myString?.toList(),
      'myNested': instance.myNested?.map((e) => e?.toJson())?.toList(),
      'normalList': instance.normalList,
      'normalSet': instance.normalSet?.toList(),
      'builtMap':
          instance.builtMap?.toMap()?.map((k, e) => MapEntry(k.toString(), e)),
      'builtMapString': instance.builtMapString?.toMap(),
      'builtMapNested': instance.builtMapNested
          ?.toMap()
          ?.map((k, e) => MapEntry(k.toString(), e?.toJson())),
      'nullList': instance.nullList?.toList(),
      'nullSet': instance.nullSet?.toList(),
      'nullMap': instance.nullMap?.toMap(),
      'stringKtList': instance.stringKtList?.asList(),
      'stringKtSet': instance.stringKtSet?.iter?.toList(),
      'nestedKtList':
          instance.nestedKtList?.map((e) => e?.toJson())?.iter?.toList(),
      'nestedKtSet':
          instance.nestedKtSet?.map((e) => e?.toJson())?.iter?.toList(),
      'nullKtList': instance.nullKtList?.asList(),
      'nullKtSet': instance.nullKtSet?.iter?.toList(),
      'dynamicMap': instance.dynamicMap?.toMap(),
      'nestedKtMap': instance.nestedKtMap
          ?.asMap()
          ?.map((k, e) => MapEntry(k, e?.toJson())),
      'stringKtMap': instance.stringKtMap?.asMap(),
      'nullKtMap': instance.nullKtMap?.asMap(),
      'dynamicKtMap': instance.dynamicKtMap?.asMap(),
    };

Nested _$NestedFromJson(Map<String, dynamic> json) {
  return Nested(
    json['a'] as int,
  );
}

Map<String, dynamic> _$NestedToJson(Nested instance) => <String, dynamic>{
      'a': instance.a,
    };
