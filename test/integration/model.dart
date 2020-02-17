import 'package:json_annotation/json_annotation.dart';
import 'package:built_collection/built_collection.dart';

part 'model.g.dart';

@JsonSerializable()
class MyModel {
  const MyModel(
      {this.myList,
      this.myString,
      this.myNested,
      this.normalList,
      this.normalSet});

  final BuiltList<int> myList;

  final BuiltSet<String> myString;

  final BuiltList<Nested> myNested;

  final List<String> normalList;

  final Set<String> normalSet;

  factory MyModel.fromJson(Map<String, dynamic> json) =>
      _$MyModelFromJson(json);

  Map<String, dynamic> toJson() => _$MyModelToJson(this);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MyModel && toString() == other.toString();

  @override
  String toString() {
    return 'MyModel{myList: $myList, myString: $myString, myNested: $myNested, normalList: $normalList, normalSet: $normalSet}';
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
