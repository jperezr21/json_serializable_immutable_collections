
import 'package:fast_immutable_collections/fast_immutable_collections.dart';

import 'package:test/test.dart';
import 'model.dart';

final model = MyModel(
    myList: [1, 2, 3].toIList(),
    myString: ["1", "2", "3"].toISet(),
    normalList: ["a", "b"],
    normalSet: {"a", "b", "c"},
    builtMap: {1: "a", 2: "b"}.toIMap(),
    builtMapString: {"a": "a"}.toIMap(),
    builtMapNested: {1: Nested(1)}.toIMap(),
    myNested: [Nested(1)].toIList(),
    nullList: null,
    nullSet: null,
    nullMap: null,
    dynamicMap: {
      "a": 1,
      "b": "string",
    }.toIMap(),
    listWithNullable: ["1", null].toIList(),
    nullablelistWithNullable: ["1", null].toIList(),
    nullableMap: {"a": null}.toIMap(),
    nullableSet: {"", null}.toISet());

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
  ],
  "nullList": null,
  "nullSet": null,
  "nullMap": null,
  "dynamicMap": {
    "a": 1,
    "b": "string",
  },
  "listWithNullable": ["1", null],
  "nullablelistWithNullable": ["1", null],
  "nullableMap": {"a": null},
  "nullableSet": ["", null]
};

void main() {
  test("can serialize", () {
    final jsonMap = model.toJson();
    expect(jsonMap, jsonMapExpected);
  });

  test("can deserialize", () {
    expect(MyModel.fromJson(jsonMapExpected), model);
  });

  test("can deserialize & serialize", () {
    expect(MyModel.fromJson(jsonMapExpected).toJson(), jsonMapExpected);
    expect(MyModel.fromJson(model.toJson()), model);

  });
}
