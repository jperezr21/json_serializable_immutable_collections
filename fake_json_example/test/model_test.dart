import 'dart:async';

import 'package:fake_json_example/src/allowlist_example.dart';
import 'package:fake_json_example/src/ignored_json_type.dart';

import 'package:test/test.dart';

void main() {
  test("can serialize", () {
    final unserializedType =
        IgnoredType("test", Timer.periodic(Duration(seconds: 1), (timer) {})..cancel());

    expect(MyModel(name: "test", ignoredType: unserializedType).toJson(),
        {"name": "test", "ignoredType": unserializedType});
  });

  test("can deserialize", () {
    final unserializedType =
        IgnoredType("test", Timer.periodic(Duration(seconds: 1), (timer) {})..cancel());

    expect(MyModel.fromJson({"name": "test", "ignoredType": unserializedType}).ignoredType,
        unserializedType);
  });
}
