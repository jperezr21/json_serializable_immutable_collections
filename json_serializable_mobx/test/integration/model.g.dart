// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MyModel _$MyModelFromJson(Map<String, dynamic> json) {
  return MyModel(
    myList: json['myList'] != null
        ? ObservableList<int>.of((json['myList'] as List).map((e) => e as int))
        : null,
    builtMapString: json['builtMapString'] != null
        ? ObservableMap<String, String>.of(
            (json['builtMapString'] as Map<String, dynamic>).map(
            (k, e) => MapEntry(k, e as String),
          ))
        : null,
    myString: json['myString'] != null
        ? ObservableList<String>.of(
            (json['myString'] as List).map((e) => e as String))
        : null,
    dynamicMap: json['dynamicMap'] != null
        ? ObservableMap<String, dynamic>.of(
            json['dynamicMap'] as Map<String, dynamic>)
        : null,
    myNested: json['myNested'] != null
        ? ObservableList<Nested>.of((json['myNested'] as List).map((e) =>
            e == null ? null : Nested.fromJson(e as Map<String, dynamic>)))
        : null,
    normalList: (json['normalList'] as List)?.map((e) => e as String)?.toList(),
    builtMap: json['builtMap'] != null
        ? ObservableMap<int, String>.of(
            (json['builtMap'] as Map<String, dynamic>).map(
            (k, e) => MapEntry(int.parse(k), e as String),
          ))
        : null,
    builtMapNested: json['builtMapNested'] != null
        ? ObservableMap<int, Nested>.of(
            (json['builtMapNested'] as Map<String, dynamic>).map(
            (k, e) => MapEntry(int.parse(k),
                e == null ? null : Nested.fromJson(e as Map<String, dynamic>)),
          ))
        : null,
    nullList: json['nullList'] != null
        ? ObservableList<String>.of(
            (json['nullList'] as List).map((e) => e as String))
        : null,
    nullMap: json['nullMap'] != null
        ? ObservableMap<String, String>.of(
            (json['nullMap'] as Map<String, dynamic>).map(
            (k, e) => MapEntry(k, e as String),
          ))
        : null,
    nullSet: json['nullSet'] != null
        ? ObservableSet<String>.of(
            (json['nullSet'] as List).map((e) => e as String))
        : null,
    normalSet: (json['normalSet'] as List)?.map((e) => e as String)?.toSet(),
    stringSet: json['stringSet'] != null
        ? ObservableSet<String>.of(
            (json['stringSet'] as List).map((e) => e as String))
        : null,
    nestedMap: json['nestedMap'] != null
        ? ObservableMap<String, Nested>.of(
            (json['nestedMap'] as Map<String, dynamic>).map(
            (k, e) => MapEntry(k,
                e == null ? null : Nested.fromJson(e as Map<String, dynamic>)),
          ))
        : null,
    stringObservable: Observable(json['stringObservable'] as String),
    nullobservable: Observable(json['nullobservable'] as int),
    nestedSet: json['nestedSet'] != null
        ? ObservableSet<Nested>.of((json['nestedSet'] as List).map((e) =>
            e == null ? null : Nested.fromJson(e as Map<String, dynamic>)))
        : null,
  );
}

Map<String, dynamic> _$MyModelToJson(MyModel instance) => <String, dynamic>{
      'myList': instance.myList,
      'myString': instance.myString,
      'myNested': instance.myNested?.map((e) => e?.toJson())?.toList(),
      'normalList': instance.normalList,
      'normalSet': instance.normalSet?.toList(),
      'builtMap': instance.builtMap?.map((k, e) => MapEntry(k.toString(), e)),
      'builtMapString': instance.builtMapString,
      'builtMapNested': instance.builtMapNested
          ?.map((k, e) => MapEntry(k.toString(), e?.toJson())),
      'nullList': instance.nullList,
      'nullSet': instance.nullSet?.toList(),
      'nullMap': instance.nullMap,
      'stringSet': instance.stringSet?.toList(),
      'nestedSet': instance.nestedSet?.map((e) => e?.toJson())?.toList(),
      'dynamicMap': instance.dynamicMap,
      'nestedMap': instance.nestedMap?.map((k, e) => MapEntry(k, e?.toJson())),
      'stringObservable': (instance.stringObservable)?.value,
      'nullobservable': (instance.nullobservable)?.value,
    };

Nested _$NestedFromJson(Map<String, dynamic> json) {
  return Nested(
    json['a'] as int,
  );
}

Map<String, dynamic> _$NestedToJson(Nested instance) => <String, dynamic>{
      'a': instance.a,
    };
