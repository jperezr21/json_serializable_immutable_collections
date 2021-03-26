import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:json_annotation/json_annotation.dart';

part 'main.g.dart';

@JsonSerializable()
class Model {
  final IList<int> myIntList;

  Model({required this.myIntList});

  factory Model.fromJson(Map<String, dynamic> json) => _$ModelFromJson(json);

  Map<String, dynamic> toJson() => _$ModelToJson(this);
}

void main() {
  print(Model(myIntList: [1, 2, 3].toIList()).toJson());
}
