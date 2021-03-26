// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MyModel _$MyModelFromJson(Map<String, dynamic> json) {
  return MyModel(
    myList:
        ObservableList<int>.of((json['myList'] as List).map((e) => e as int)),
    myListWithNulls: ObservableList<int?>.of(
        (json['myListWithNulls'] as List).map((e) => e as int?)),
    builtMapString: ObservableMap<String, String>.of(
        Map<String, String>.from(json['builtMapString'] as Map)),
    myString: ObservableList<String>.of(
        (json['myString'] as List).map((e) => e as String)),
    myStringWithNulls: ObservableList<String?>.of(
        (json['myStringWithNulls'] as List).map((e) => e as String?)),
    dynamicMap: ObservableMap<String, dynamic>.of(
        (json['dynamicMap'] as Map<String, dynamic>)),
    myNested: ObservableList<Nested>.of((json['myNested'] as List)
        .map((e) => Nested.fromJson(e as Map<String, dynamic>))),
    myNestedWithNulls: ObservableList<Nested?>.of(
        (json['myNestedWithNulls'] as List).map((e) =>
            e == null ? null : Nested.fromJson(e as Map<String, dynamic>))),
    normalList:
        (json['normalList'] as List<dynamic>).map((e) => e as String).toList(),
    builtMap: ObservableMap<int, String>.of(
        (json['builtMap'] as Map<String, dynamic>).map(
      (k, e) => MapEntry(int.parse(k), e as String),
    )),
    builtMapNested: ObservableMap<int, Nested>.of(
        (json['builtMapNested'] as Map<String, dynamic>).map(
      (k, e) =>
          MapEntry(int.parse(k), Nested.fromJson(e as Map<String, dynamic>)),
    )),
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
    normalSet:
        (json['normalSet'] as List<dynamic>).map((e) => e as String).toSet(),
    stringSet: ObservableSet<String>.of(
        (json['stringSet'] as List).map((e) => e as String)),
    nestedMap: ObservableMap<String, Nested>.of(
        (json['nestedMap'] as Map<String, dynamic>).map(
      (k, e) => MapEntry(k, Nested.fromJson(e as Map<String, dynamic>)),
    )),
    nestedMapWithNulls: ObservableMap<String, Nested?>.of(
        (json['nestedMapWithNulls'] as Map<String, dynamic>).map(
      (k, e) => MapEntry(
          k, e == null ? null : Nested.fromJson(e as Map<String, dynamic>)),
    )),
    stringObservable: Observable(json['stringObservable'] as String),
    nullobservable: json['nullobservable'] != null
        ? Observable(json['nullobservable'] as int)
        : null,
    nestedSet: ObservableSet<Nested>.of((json['nestedSet'] as List)
        .map((e) => Nested.fromJson(e as Map<String, dynamic>))),
  );
}

Map<String, dynamic> _$MyModelToJson(MyModel instance) => <String, dynamic>{
      'myList': instance.myList,
      'myListWithNulls': instance.myListWithNulls,
      'myString': instance.myString,
      'myStringWithNulls': instance.myStringWithNulls,
      'myNested': instance.myNested.map((e) => e.toJson()).toList(),
      'myNestedWithNulls':
          instance.myNestedWithNulls.map((e) => e?.toJson()).toList(),
      'normalList': instance.normalList,
      'normalSet': instance.normalSet.toList(),
      'builtMap': instance.builtMap.map((k, e) => MapEntry(k.toString(), e)),
      'builtMapString': instance.builtMapString,
      'builtMapNested': instance.builtMapNested
          .map((k, e) => MapEntry(k.toString(), e.toJson())),
      'nullList': instance.nullList,
      'nullSet': instance.nullSet?.toList(),
      'nullMap': instance.nullMap,
      'stringSet': instance.stringSet.toList(),
      'nestedSet': instance.nestedSet.map((e) => e.toJson()).toList(),
      'dynamicMap': instance.dynamicMap,
      'nestedMap': instance.nestedMap.map((k, e) => MapEntry(k, e.toJson())),
      'nestedMapWithNulls':
          instance.nestedMapWithNulls.map((k, e) => MapEntry(k, e?.toJson())),
      'stringObservable': (instance.stringObservable).value,
      'nullobservable': (instance.nullobservable)?.value,
    };

Nested _$NestedFromJson(Map<String, dynamic> json) {
  return Nested(
    json['a'] as int?,
  );
}

Map<String, dynamic> _$NestedToJson(Nested instance) => <String, dynamic>{
      'a': instance.a,
    };
