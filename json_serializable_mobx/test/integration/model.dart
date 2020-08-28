import 'package:json_annotation/json_annotation.dart';
import 'package:mobx/mobx.dart';

part 'model.g.dart';

@JsonSerializable()
class MyModel {
  const MyModel(
      {this.myList,
      this.builtMapString,
      this.myString,
      this.dynamicMap,
      this.myNested,
      this.normalList,
      this.builtMap,
      this.builtMapNested,
      this.nullList,
      this.nullMap,
      this.nullSet,
      this.normalSet,
      this.stringSet,
      this.nestedMap,
      this.nestedSet});

  final ObservableList<int> myList;

  final ObservableList<String> myString;

  final ObservableList<Nested> myNested;

  final List<String> normalList;

  final Set<String> normalSet;

  final ObservableMap<int, String> builtMap;

  final ObservableMap<String, String> builtMapString;

  final ObservableMap<int, Nested> builtMapNested;

  final ObservableList<String> nullList;

  final ObservableSet<String> nullSet;

  final ObservableMap<String, String> nullMap;

  final ObservableSet<String> stringSet;

  final ObservableSet<Nested> nestedSet;

  final ObservableMap<String, dynamic> dynamicMap;

  final ObservableMap<String, Nested> nestedMap;

  factory MyModel.fromJson(Map<String, dynamic> json) =>
      _$MyModelFromJson(json);

  Map<String, dynamic> toJson() => _$MyModelToJson(this);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MyModel && toString() == other.toString();

  @override
  String toString() {
    return 'MyModel{myList: $myList, myString: $myString, myNested: $myNested, normalList: $normalList, normalSet: $normalSet, builtMap: $builtMap, builtMapString: $builtMapString, builtMapNested: $builtMapNested, nullList: $nullList, nullSet: $nullSet, nullMap: $nullMap, stringSet: $stringSet, nestedSet: $nestedSet, dynamicMap: $dynamicMap, nestedMap: $nestedMap}';
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
