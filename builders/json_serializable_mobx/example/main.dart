import 'package:json_annotation/json_annotation.dart';
import 'package:mobx/mobx.dart';

part 'main.g.dart';

@JsonSerializable()
class Model {
  final ObservableList<int> myIntList;

  Model({required this.myIntList});

  factory Model.fromJson(Map<String, dynamic> json) => _$ModelFromJson(json);

  Map<String, dynamic> toJson() => _$ModelToJson(this);
}

void main() {
  print(Model(myIntList: ObservableList.of([1, 2, 3])).toJson());
}
