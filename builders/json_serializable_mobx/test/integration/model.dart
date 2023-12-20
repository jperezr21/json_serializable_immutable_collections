import 'package:json_annotation/json_annotation.dart';
import 'package:mobx/mobx.dart';

part 'model.g.dart';

@JsonSerializable()
class MyModel {
const MyModel(
      {required this.myList,
      required this.myListWithNulls,
      required this.builtMapString,
      required this.myString,
      required this.myStringWithNulls,
      required this.dynamicMap,
      required this.myNested,
      required this.myNestedWithNulls,
      required this.normalList,
      required this.builtMap,
      required this.builtMapNested,
      required this.nullList,
      required this.nullMap,
      required this.nullSet,
      required this.normalSet,
      required this.stringSet,
      required this.nestedMap,
      required this.nestedMapWithNulls,
      required this.stringObservable,
      required this.nullobservable,
      required this.nestedSet});

  final ObservableList<int> myList;

  final ObservableList<int?> myListWithNulls;

  final ObservableList<String> myString;

  final ObservableList<String?> myStringWithNulls;

  final ObservableList<Nested> myNested;

  final ObservableList<Nested?> myNestedWithNulls;

  final List<String> normalList;

  final Set<String> normalSet;

  final ObservableMap<int, String> builtMap;

  final ObservableMap<String, String> builtMapString;

  final ObservableMap<int, Nested> builtMapNested;

  final ObservableList<String>? nullList;

  final ObservableSet<String>? nullSet;

  final ObservableMap<String, String>? nullMap;

  final ObservableSet<String> stringSet;

  final ObservableSet<Nested> nestedSet;

  final ObservableMap<String, dynamic> dynamicMap;

  final ObservableMap<String, Nested> nestedMap;

  final ObservableMap<String, Nested?> nestedMapWithNulls;

  final Observable<String> stringObservable;

  final Observable<int>? nullobservable;

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
    return 'MyModel{myList: $myList, myListWithNulls: $myListWithNulls, myString: $myString, myStringWithNulls: $myStringWithNulls, myNested: $myNested, myNestedWithNulls: $myNestedWithNulls, normalList: $normalList, normalSet: $normalSet, builtMap: $builtMap, builtMapString: $builtMapString, builtMapNested: $builtMapNested, nullList: $nullList, nullSet: $nullSet, nullMap: $nullMap, stringSet: $stringSet, nestedSet: $nestedSet, dynamicMap: $dynamicMap, nestedMap: $nestedMap, nestedMapWithNulls: $nestedMapWithNulls, stringObservable: ${stringObservable.value}, nullobservable: ${nullobservable?.value}';
  }
}

@JsonSerializable()
class Nested {
  const Nested(this.a);

  final int? a;

  Map<String, dynamic> toJson() => _$NestedToJson(this);

  factory Nested.fromJson(Map<String, dynamic> json) => _$NestedFromJson(json);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Nested && runtimeType == other.runtimeType && a == other.a;

  @override
  int get hashCode => a.hashCode;
}
