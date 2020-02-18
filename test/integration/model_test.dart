import 'dart:convert';

import 'package:built_collection/built_collection.dart';
import 'package:test/test.dart';

import 'model.dart';

final model = MyModel(
    myList: BuiltList.of([1, 2, 3]),
    myString: BuiltSet.of(["1", "2", "3"]),
    normalList: ["a", "b"],
    normalSet: {"a", "b", "c"},
    builtMap: BuiltMap.of({1: "a", 2: "b"}),
    builtMapString: BuiltMap.of({"a": "a"}),
    builtMapNested: BuiltMap.of({1: Nested(1)}),
    myNested: BuiltList.of([Nested(1)]));

const jsonMapExpected = {
  "myList": [1, 2, 3],
  "myString": ["1", "2", "3"],
  "normalList": ["a", "b"],
  "normalSet": ["a", "b", "c"],
  "builtMap": {"1": "a", "2": "b"},
  "builtMapString": {"a": "a"},
  "builtMapNested": {
    "1": {"a": 1}
  },
  "myNested": [
    {"a": 1}
  ]
};

void main() {
  test("can serialize", () {
    final jsonMap = model.toJson();
    expect(jsonMap, jsonMapExpected);
  });

  test("can deserialize", () {
    expect(MyModel.fromJson(jsonMapExpected), model);
  });
}
