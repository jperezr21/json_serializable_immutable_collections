import 'package:fake_json_example/src/ignored_json_type.dart';
import 'package:json_annotation/json_annotation.dart';

part 'allowlist_example.g.dart';

@JsonSerializable()
class MyModel {

  final String name;

  final IgnoredType ignoredType;


  MyModel({
    required this.name,
    required this.ignoredType
  });

  factory MyModel.fromJson(Map<String, dynamic> json) =>
      _$MyModelFromJson(json);

  Map<String, dynamic> toJson() => _$MyModelToJson(this);

}


