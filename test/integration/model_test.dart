import 'dart:convert';

import 'package:built_collection/built_collection.dart';
import 'package:test/test.dart';

import 'model.dart';

const json =
"""{"myList":[1,2,3],"myString":["1","2","3"],"normalList":["a","b"],"normalSet":["a","b","c"],"myNested":[{"a":1}]}""";

final model = MyModel(
    myList: BuiltList.of([1, 2, 3]),
    myString: BuiltSet.of(["1", "2", "3"]),
    normalList: ["a", "b"],
    normalSet: {"a", "b", "c"},
    myNested: BuiltList.of([Nested(1)]));

const jsonMapExpected = {
  "myList": [1, 2, 3],
  "myString": ["1", "2", "3"],
  "normalList": ["a", "b"],
  "normalSet": ["a", "b", "c"],
  "myNested": [
    {"a": 1}
  ]
};

void main() {
  test("can serialize", () {
    final jsonMap = model.toJson();
    expect(jsonMap, jsonMapExpected );
  });

  test("can deserialize", (){
    expect(MyModel.fromJson(jsonMapExpected), model);
  });

}

