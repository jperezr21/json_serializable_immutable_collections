import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:collection/collection.dart';

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
    required this.nullablelistWithNullable,
    required this.listWithNullable,
    required this.nullableMap,
    required this.nullableSet,
    required this.enumMap,
    required this.myListSet,
    required this.myListMap,
    required this.myMapOfSets,
  });

  final IList<int> myList;

  final ISet<String> myString;

  final IList<Nested> myNested;

  final List<String> normalList;

  final Set<String> normalSet;

  final IMap<int, String> builtMap;

  final IMap<String, String> builtMapString;

  final IMap<int, Nested> builtMapNested;

  final IList<String>? nullList;

  final IList<String?> listWithNullable;

  final IList<String?>? nullablelistWithNullable;

  final ISet<String>? nullSet;

  final ISet<String?> nullableSet;

  final IMap<String, String>? nullMap;

  final IMap<String, String?> nullableMap;

  final IMap<String, dynamic> dynamicMap;

  final IMap<MyEnum, String> enumMap;

  final ListSet<String> myListSet;

  final ListMap<String, int> myListMap;

  final IMapOfSets<String, int> myMapOfSets;

  factory MyModel.fromJson(Map<String, dynamic> json) =>
      _$MyModelFromJson(json);

  Map<String, dynamic> toJson() => _$MyModelToJson(this);

  @override
  String toString() {
    return 'MyModel{myList: $myList, myString: $myString, myNested: $myNested, normalList: $normalList, normalSet: $normalSet, builtMap: $builtMap, builtMapString: $builtMapString, builtMapNested: $builtMapNested, nullList: $nullList, listWithNullable: $listWithNullable, nullablelistWithNullable: $nullablelistWithNullable, nullSet: $nullSet, nullableSet: $nullableSet, nullMap: $nullMap, nullableMap: $nullableMap, dynamicMap: $dynamicMap, enumMap: $enumMap, myListSet: $myListSet, myListMap: $myListMap, myMapOfSets: $myMapOfSets}';
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MyModel &&
          runtimeType == other.runtimeType &&
          myList == other.myList &&
          myString == other.myString &&
          myNested == other.myNested &&
          DeepCollectionEquality().equals(normalList, other.normalList) &&
          DeepCollectionEquality().equals(normalSet, other.normalSet) &&
          builtMap == other.builtMap &&
          builtMapString == other.builtMapString &&
          builtMapNested == other.builtMapNested &&
          nullList == other.nullList &&
          listWithNullable == other.listWithNullable &&
          nullablelistWithNullable == other.nullablelistWithNullable &&
          nullSet == other.nullSet &&
          nullableSet == other.nullableSet &&
          nullMap == other.nullMap &&
          nullableMap == other.nullableMap &&
          dynamicMap == other.dynamicMap &&
          enumMap == other.enumMap &&
          DeepCollectionEquality().equals(myListSet, other.myListSet) &&
          DeepCollectionEquality().equals(myListMap, other.myListMap) &&
          myMapOfSets == other.myMapOfSets;

  @override
  int get hashCode {
    final deepEquality = DeepCollectionEquality();
    return myList.hashCode ^
        myString.hashCode ^
        myNested.hashCode ^
        deepEquality.hash(normalList) ^
        deepEquality.hash(normalSet) ^
        builtMap.hashCode ^
        builtMapString.hashCode ^
        builtMapNested.hashCode ^
        nullList.hashCode ^
        listWithNullable.hashCode ^
        nullablelistWithNullable.hashCode ^
        nullSet.hashCode ^
        nullableSet.hashCode ^
        nullMap.hashCode ^
        nullableMap.hashCode ^
        dynamicMap.hashCode ^
        enumMap.hashCode ^
        deepEquality.hash(myListSet) ^
        deepEquality.hash(myListMap) ^
        myMapOfSets.hashCode;
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

enum MyEnum { one, two, three }
