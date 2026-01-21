import 'package:json_annotation/json_annotation.dart';
import 'package:built_collection/built_collection.dart';
import 'package:kt_dart/collection.dart';

part 'model.g.dart';

@JsonSerializable()
class MyModel {
  const MyModel({
    required this.myList,
    required this.builtMapString,
    required this.myString,
    required this.dynamicMap,
    required this.myNested,
    required this.normalList,
    required this.builtMap,
    required this.builtMapNested,
    required this.nullList,
    required this.nullMap,
    required this.nullSet,
    required this.normalSet,
    required this.nestedKtList,
    required this.nestedKtSet,
    required this.nullKtList,
    required this.nullKtSet,
    required this.stringKtList,
    required this.stringKtSet,
    required this.nestedKtMap,
    required this.nestedKtMapWithNulls,
    required this.stringKtMap,
    required this.stringKtMapWithNulls,
    required this.nullKtMap,
    required this.dynamicKtMap,
    required this.stringKtListWithNulls,
    required this.stringKtSetWithNulls,
  });

  final BuiltList<int> myList;

  final BuiltSet<String> myString;

  final BuiltList<Nested> myNested;

  final List<String> normalList;

  final Set<String> normalSet;

  final BuiltMap<int, String> builtMap;

  final BuiltMap<String, String> builtMapString;

  final BuiltMap<int, Nested> builtMapNested;

  final BuiltList<String>? nullList;

  final BuiltSet<String>? nullSet;

  final BuiltMap<String, String>? nullMap;

  final KtList<String> stringKtList;

  final KtList<String?> stringKtListWithNulls;

  final KtSet<String> stringKtSet;

  final KtSet<String?> stringKtSetWithNulls;

  final KtList<Nested> nestedKtList;

  final KtSet<Nested> nestedKtSet;

  final KtList<String>? nullKtList;

  final KtSet<String>? nullKtSet;

  final BuiltMap<String, dynamic> dynamicMap;

  final KtMap<String, Nested> nestedKtMap;

  final KtMap<String, Nested?> nestedKtMapWithNulls;

  final KtMap<String, String> stringKtMap;

  final KtMap<String, String?> stringKtMapWithNulls;

  final KtMap<String, Object>? nullKtMap;

  final KtMap<String, dynamic> dynamicKtMap;

  factory MyModel.fromJson(Map<String, dynamic> json) =>
      _$MyModelFromJson(json);

  Map<String, dynamic> toJson() => _$MyModelToJson(this);

  @override
  // ignore: hash_and_equals
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MyModel && toString() == other.toString();

  @override
  String toString() {
    return 'MyModel{myList: $myList, myString: $myString, myNested: $myNested, normalList: $normalList, normalSet: $normalSet, builtMap: $builtMap, builtMapString: $builtMapString, builtMapNested: $builtMapNested, nullList: $nullList, nullSet: $nullSet, nullMap: $nullMap, stringKtList: $stringKtList, stringKtListWithNulls: $stringKtListWithNulls, stringKtSet: $stringKtSet, stringKtSetWithNulls: $stringKtSetWithNulls, nestedKtList: $nestedKtList, nestedKtSet: $nestedKtSet, nullKtList: $nullKtList, nullKtSet: $nullKtSet, dynamicMap: $dynamicMap, nestedKtMap: $nestedKtMap, nestedKtMapWithNulls: $nestedKtMapWithNulls, stringKtMap: $stringKtMap, stringKtMapWithNulls: $stringKtMapWithNulls, nullKtMap: $nullKtMap, dynamicKtMap: $dynamicKtMap}';
  }
}

@JsonSerializable()
class Nested {
  const Nested(this.a);

  final int a;

  Map<String, dynamic> toJson() => _$NestedToJson(this);

  factory Nested.fromJson(Map<String, dynamic> json) => _$NestedFromJson(json);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Nested && runtimeType == other.runtimeType && a == other.a;

  @override
  int get hashCode => a.hashCode;
}
