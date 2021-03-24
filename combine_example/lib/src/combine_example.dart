import 'package:built_collection/built_collection.dart';
import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:kt_dart/collection.dart';
import 'package:mobx/mobx.dart';

part 'combine_example.g.dart';

@JsonSerializable()
class MyModel {
  final BuiltList<int> builtList;

  final KtSet<bool> ktSet;

  final IList<String> iList;

  final ObservableList<bool> mobxList;

  MyModel({
    required this.builtList,
    required this.iList,
    required this.ktSet,
    required this.mobxList,
  });

  factory MyModel.fromJson(Map<String, dynamic> json) =>
      _$MyModelFromJson(json);

  Map<String, dynamic> toJson() => _$MyModelToJson(this);
}
