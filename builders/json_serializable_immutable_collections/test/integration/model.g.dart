// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MyModel _$MyModelFromJson(Map<String, dynamic> json) => MyModel(
  myList: ((json['myList'] as List).map(
    (e) => (e as num).toInt(),
  )).toBuiltList(),
  builtMapString: BuiltMap<String, String>.of(
    Map<String, String>.from(json['builtMapString'] as Map),
  ),
  myString: ((json['myString'] as List).map((e) => e as String)).toBuiltSet(),
  dynamicMap: BuiltMap<String, Object?>.of(
    (json['dynamicMap'] as Map<String, dynamic>),
  ),
  myNested: ((json['myNested'] as List).map(
    (e) => Nested.fromJson(e as Map<String, dynamic>),
  )).toBuiltList(),
  normalList: (json['normalList'] as List<dynamic>)
      .map((e) => e as String)
      .toList(),
  builtMap: BuiltMap<int, String>.of(
    (json['builtMap'] as Map<String, dynamic>).map(
      (k, e) => MapEntry(int.parse(k), e as String),
    ),
  ),
  builtMapNested: BuiltMap<int, Nested>.of(
    (json['builtMapNested'] as Map<String, dynamic>).map(
      (k, e) =>
          MapEntry(int.parse(k), Nested.fromJson(e as Map<String, dynamic>)),
    ),
  ),
  nullList: json['nullList'] != null
      ? ((json['nullList'] as List).map((e) => e as String)).toBuiltList()
      : null,
  nullMap: json['nullMap'] != null
      ? BuiltMap<String, String>.of(
          (json['nullMap'] as Map<String, dynamic>).map(
            (k, e) => MapEntry(k, e as String),
          ),
        )
      : null,
  nullSet: json['nullSet'] != null
      ? ((json['nullSet'] as List).map((e) => e as String)).toBuiltSet()
      : null,
  normalSet: (json['normalSet'] as List<dynamic>)
      .map((e) => e as String)
      .toSet(),
  nestedKtList: KtList<Nested>.from(
    (json['nestedKtList'] as List).map(
      (e) => Nested.fromJson(e as Map<String, dynamic>),
    ),
  ),
  nestedKtSet: KtSet.from(
    (json['nestedKtSet'] as List).map(
      (e) => Nested.fromJson(e as Map<String, dynamic>),
    ),
  ),
  nullKtList: json['nullKtList'] != null
      ? KtList<String>.from(
          (json['nullKtList'] as List).map((e) => e as String),
        )
      : null,
  nullKtSet: json['nullKtSet'] != null
      ? KtSet.from((json['nullKtSet'] as List).map((e) => e as String))
      : null,
  stringKtList: KtList<String>.from(
    (json['stringKtList'] as List).map((e) => e as String),
  ),
  stringKtSet: KtSet.from(
    (json['stringKtSet'] as List).map((e) => e as String),
  ),
  nestedKtMap: KtMap<String, Nested>.from(
    (json['nestedKtMap'] as Map<String, dynamic>).map(
      (k, e) => MapEntry(k, Nested.fromJson(e as Map<String, dynamic>)),
    ),
  ),
  nestedKtMapWithNulls: KtMap<String, Nested?>.from(
    (json['nestedKtMapWithNulls'] as Map<String, dynamic>).map(
      (k, e) => MapEntry(
        k,
        e == null ? null : Nested.fromJson(e as Map<String, dynamic>),
      ),
    ),
  ),
  stringKtMap: KtMap<String, String>.from(
    Map<String, String>.from(json['stringKtMap'] as Map),
  ),
  stringKtMapWithNulls: KtMap<String, String?>.from(
    Map<String, String?>.from(json['stringKtMapWithNulls'] as Map),
  ),
  nullKtMap: json['nullKtMap'] != null
      ? KtMap<String, Object>.from(
          (json['nullKtMap'] as Map<String, dynamic>).map(
            (k, e) => MapEntry(k, e as Object),
          ),
        )
      : null,
  dynamicKtMap: KtMap<String, dynamic>.from(
    (json['dynamicKtMap'] as Map<String, dynamic>),
  ),
  stringKtListWithNulls: KtList<String?>.from(
    (json['stringKtListWithNulls'] as List).map((e) => e as String?),
  ),
  stringKtSetWithNulls: KtSet.from(
    (json['stringKtSetWithNulls'] as List).map((e) => e as String?),
  ),
);

Map<String, dynamic> _$MyModelToJson(MyModel instance) => <String, dynamic>{
  'myList': instance.myList.toList(),
  'myString': instance.myString.toList(),
  'myNested': instance.myNested.map((e) => e.toJson()).toList(),
  'normalList': instance.normalList,
  'normalSet': instance.normalSet.toList(),
  'builtMap': instance.builtMap.toMap().map(
    (k, e) => MapEntry(k.toString(), e),
  ),
  'builtMapString': instance.builtMapString.toMap(),
  'builtMapNested': instance.builtMapNested.toMap().map(
    (k, e) => MapEntry(k.toString(), e.toJson()),
  ),
  'nullList': instance.nullList?.toList(),
  'nullSet': instance.nullSet?.toList(),
  'nullMap': instance.nullMap?.toMap(),
  'stringKtList': instance.stringKtList.asList(),
  'stringKtListWithNulls': instance.stringKtListWithNulls.asList(),
  'stringKtSet': instance.stringKtSet.iter.toList(),
  'stringKtSetWithNulls': instance.stringKtSetWithNulls.iter.toList(),
  'nestedKtList': instance.nestedKtList.map((e) => e.toJson()).asList(),
  'nestedKtSet': instance.nestedKtSet.map((e) => e.toJson()).iter.toList(),
  'nullKtList': instance.nullKtList?.asList(),
  'nullKtSet': instance.nullKtSet?.iter.toList(),
  'dynamicMap': instance.dynamicMap.toMap(),
  'nestedKtMap': instance.nestedKtMap.asMap().map(
    (k, e) => MapEntry(k, e.toJson()),
  ),
  'nestedKtMapWithNulls': instance.nestedKtMapWithNulls.asMap().map(
    (k, e) => MapEntry(k, e?.toJson()),
  ),
  'stringKtMap': instance.stringKtMap.asMap(),
  'stringKtMapWithNulls': instance.stringKtMapWithNulls.asMap(),
  'nullKtMap': instance.nullKtMap?.asMap(),
  'dynamicKtMap': instance.dynamicKtMap.asMap(),
};

Nested _$NestedFromJson(Map<String, dynamic> json) =>
    Nested((json['a'] as num).toInt());

Map<String, dynamic> _$NestedToJson(Nested instance) => <String, dynamic>{
  'a': instance.a,
};
