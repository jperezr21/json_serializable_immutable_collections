import 'package:mobx/mobx.dart';
import 'package:test/test.dart';
import 'model.dart';

final model = MyModel(
  myList: ObservableList.of([1, 2, 3]),
  myListWithNulls: ObservableList.of([1, null]),
  myString: ObservableList.of(["1", "2", "3"]),
  myStringWithNulls: ObservableList.of(["1", null]),
  normalList: ["a", "b"],
  normalSet: {"a", "b", "c"},
  nullList: null,
  nullSet: null,
  nullMap: null,
  stringSet: ObservableSet.of(["1", "2"]),
  nestedSet: ObservableSet.of([Nested(1), Nested(2)]),
  builtMap: ObservableMap.of({1: "hi"}),
  builtMapNested: ObservableMap.of({1: Nested(1)}),
  nestedMap: ObservableMap.of({"a": Nested(1)}),
  nestedMapWithNulls: ObservableMap.of({"a": Nested(1), "b": null}),
  builtMapString: ObservableMap.of({"a": "b"}),
  myNested: ObservableList.of([Nested(0), Nested(1)]),
  myNestedWithNulls: ObservableList.of([Nested(0), null]),
  dynamicMap: ObservableMap.of({"a": "a", "b": 1, "c": null}),
  stringObservable: Observable<String>("string"),
  nullobservable: null,
);

const jsonMapExpected = {
  "myList": [1, 2, 3],
  "myListWithNulls": [1, null],
  "myStringWithNulls": ["1", null],
  "myString": ["1", "2", "3"],
  "normalList": ["a", "b"],
  "normalSet": ["a", "b", "c"],
  "nullList": null,
  "nullSet": null,
  "nullMap": null,
  "stringSet": ["1", "2"],
  "nestedSet": [
    {"a": 1},
    {"a": 2}
  ],
  "builtMap": {"1": "hi"},
  "builtMapNested": {
    "1": {"a": (1)}
  },
  "nestedMap": {
    "a": {"a": (1)}
  },
  "nestedMapWithNulls": {
    "a": {"a": (1)},
    "b": null,
  },
  "builtMapString": {"a": "b"},
  "myNested": [
    {"a": 0},
    {"a": 1}
  ],
  "myNestedWithNulls": [
    {"a": 0},
    null,
  ],
  "dynamicMap": {"a": "a", "b": 1, "c": null},
  "stringObservable": "string",
  "nullobservable": null,
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
