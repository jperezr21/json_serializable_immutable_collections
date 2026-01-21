import 'package:built_collection/built_collection.dart';
import 'package:kt_dart/collection.dart';
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
  myNested: BuiltList.of([Nested(1)]),
  nullList: null,
  nullSet: null,
  nullMap: null,
  stringKtList: KtList.from(["a"]),
  stringKtSet: KtSet.from(["a"]),
  stringKtListWithNulls: KtList.from(["", null]),
  stringKtSetWithNulls: KtSet.from(["", null]),
  nestedKtList: KtList.from([Nested(1)]),
  nestedKtSet: KtSet.from([Nested(1)]),
  nullKtList: null,
  nullKtSet: null,
  dynamicMap: BuiltMap<String, Object>.of({"a": 1, "b": "string"}),
  stringKtMap: KtMap.from({"a": "a"}),
  stringKtMapWithNulls: KtMap.from({"a": null}),
  nestedKtMap: KtMap.from({"a": Nested(0)}),
  nestedKtMapWithNulls: KtMap.from({"a": null}),
  nullKtMap: null,
  dynamicKtMap: KtMap.from({"a": "a", "b": 1, "c": null}),
);

const jsonMapExpected = {
  "myList": [1, 2, 3],
  "myString": ["1", "2", "3"],
  "normalList": ["a", "b"],
  "normalSet": ["a", "b", "c"],
  "builtMap": {"1": "a", "2": "b"},
  "builtMapString": {"a": "a"},
  "builtMapNested": {
    "1": {"a": 1},
  },
  "myNested": [
    {"a": 1},
  ],
  "nullList": null,
  "nullSet": null,
  "nullMap": null,
  "stringKtList": ["a"],
  "stringKtSet": ["a"],
  "stringKtListWithNulls": ["", null],
  "stringKtSetWithNulls": ["", null],
  "nestedKtList": [
    {"a": 1},
  ],
  "nestedKtSet": [
    {"a": 1},
  ],
  "nullKtList": null,
  "nullKtSet": null,
  "dynamicMap": {"a": 1, "b": "string"},
  "stringKtMap": {"a": "a"},
  "stringKtMapWithNulls": {"a": null},
  "nestedKtMap": {
    "a": {"a": 0},
  },
  "nestedKtMapWithNulls": {"a": null},
  "nullKtMap": null,
  "dynamicKtMap": {"a": "a", "b": 1, "c": null},
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
