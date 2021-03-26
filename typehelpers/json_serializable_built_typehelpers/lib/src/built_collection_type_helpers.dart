// Copyright (c) 2018, the Dart project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:analyzer/dart/element/type.dart';
import 'package:json_serializable_type_helper_utils/json_serializable_type_helper_utils.dart';

import 'package:built_collection/built_collection.dart';

class BuiltListTypeHelper extends CustomIterableTypeHelper<BuiltList> {
  @override
  String deserializeFromIterableExpression(
      String expression, DartType resolvedGenericType) {
    return '($expression).toBuiltList()';
  }

  @override
  String serializeToList(String expression, DartType resolvedGenericType,
      bool isExpressionNullable) {
    throw StateError('not necessary as builtlist is iterable');
  }
}

class BuiltSetTypeHelper extends CustomIterableTypeHelper<BuiltSet> {
  @override
  String deserializeFromIterableExpression(
      String expression, DartType resolvedGenericType) {
    return '($expression).toBuiltSet()';
  }

  @override
  String serializeToList(String expression, DartType resolvedGenericType,
      bool isExpressionNullable) {
    throw StateError('not necessary as builtlist is iterable');
  }
}

class BuiltMapTypeHelper extends CustomMapTypeHelper<BuiltMap> {
  @override
  String deserializeFromMapExpression(
      String mapExpression, DartType keyType, DartType valueType) {
    String valueTypeString;
    if (valueType.isDynamic) {
      //use Object? instead because builtMap does not support explicit dynamic types
      valueTypeString = 'Object?';
    } else {
      valueTypeString = valueType.getDisplayString(withNullability: true);
    }
    final keyTypeString = keyType.getDisplayString(withNullability: true);
    final prefix = 'BuiltMap<$keyTypeString,$valueTypeString>.of';

    return prefix + '($mapExpression)';
  }

  @override
  String serializeToMapExpression(String mapExpression, DartType keyType,
      DartType valueType, bool isMapExpressionNullable) {
    final optionalQuestion = isMapExpressionNullable ? '?' : '';
    return mapExpression + optionalQuestion + '.toMap()';
  }
}
