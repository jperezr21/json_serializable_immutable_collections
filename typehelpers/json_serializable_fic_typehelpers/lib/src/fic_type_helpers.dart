// Copyright (c) 2018, the Dart project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:analyzer/dart/element/type.dart';
import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:json_serializable_type_helper_utils/json_serializable_type_helper_utils.dart';
import 'package:json_serializable/type_helper.dart';
// ignore: implementation_imports
import 'package:json_serializable/src/constants.dart';
import 'package:source_gen/source_gen.dart' show TypeChecker;
import 'package:source_helper/source_helper.dart';

class FICIListTypeHelper extends CustomIterableTypeHelper<IList> {
  @override
  TypeChecker get typeChecker => const TypeChecker.typeNamed(
    IList,
    inPackage: 'fast_immutable_collections',
  );

  @override
  String deserializeFromIterableExpression(
    String expression,
    DartType resolvedGenericType,
  ) {
    return '$expression.toIList()';
  }

  @override
  String serializeToList(
    String expression,
    DartType resolvedGenericType,
    bool isExpressionNullable,
  ) {
    // not needed as IList implements Iterable
    throw UnimplementedError();
  }
}

class FICISetTypeHelper extends CustomIterableTypeHelper<ISet> {
  @override
  TypeChecker get typeChecker => const TypeChecker.typeNamed(
    ISet,
    inPackage: 'fast_immutable_collections',
  );

  @override
  String deserializeFromIterableExpression(
    String expression,
    DartType resolvedGenericType,
  ) {
    return '$expression.toISet()';
  }

  @override
  String serializeToList(
    String expression,
    DartType resolvedGenericType,
    bool isExpressionNullable,
  ) {
    // not needed as IList implements Iterable
    throw UnimplementedError();
  }
}

class FICIMapTypeHelper extends CustomMapTypeHelper<IMap> {
  @override
  TypeChecker get typeChecker => const TypeChecker.typeNamed(
    IMap,
    inPackage: 'fast_immutable_collections',
  );

  @override
  String deserializeFromMapExpression(
    String mapExpression,
    DartType keyType,
    DartType valueType,
  ) {
    return '$mapExpression.toIMap()';
  }

  @override
  String serializeToMapExpression(
    String mapExpression,
    DartType keyType,
    DartType valueType,
    bool isMapExpressionNullable,
  ) {
    final optionalQuestion = isMapExpressionNullable ? '?' : '';
    return '$mapExpression$optionalQuestion.unlockLazy';
  }
}

class FICListSetTypeHelper extends CustomIterableTypeHelper<ListSet> {
  @override
  TypeChecker get typeChecker => const TypeChecker.typeNamed(
    ListSet,
    inPackage: 'fast_immutable_collections',
  );

  @override
  String deserializeFromIterableExpression(
    String expression,
    DartType resolvedGenericType,
  ) {
    // Convert to List first to ensure consistent ordering and equality
    return 'ListSet.of(($expression).toList())';
  }

  @override
  String serializeToList(
    String expression,
    DartType resolvedGenericType,
    bool isExpressionNullable,
  ) {
    // not needed as ListSet implements Iterable
    throw UnimplementedError();
  }
}

class FICListMapTypeHelper extends CustomMapTypeHelper<ListMap> {
  @override
  TypeChecker get typeChecker => const TypeChecker.typeNamed(
    ListMap,
    inPackage: 'fast_immutable_collections',
  );

  @override
  String deserializeFromMapExpression(
    String mapExpression,
    DartType keyType,
    DartType valueType,
  ) {
    return 'ListMap.of($mapExpression)';
  }

  @override
  String serializeToMapExpression(
    String mapExpression,
    DartType keyType,
    DartType valueType,
    bool isMapExpressionNullable,
  ) {
    // ListMap implements Map directly, so we can use it as-is
    // No conversion needed since ListMap is already a Map
    return mapExpression;
  }
}

class FICIMapOfSetsTypeHelper extends TypeHelper<TypeHelperContextWithConfig> {
  final TypeChecker typeChecker = const TypeChecker.typeNamed(
    IMapOfSets,
    inPackage: 'fast_immutable_collections',
  );

  DartType _getKeyType(DartType type) =>
      type.typeArgumentsOf(typeChecker)!.first;

  DartType _getValueType(DartType type) {
    // IMapOfSets<K, V> is Map<K, Set<V>>
    // The type arguments are [K, V] where V is the element type of the sets
    // So we can directly return the second type argument
    return type.typeArgumentsOf(typeChecker)!.last;
  }

  @override
  Object? serialize(
    DartType targetType,
    String expression,
    TypeHelperContext context,
  ) {
    if (!typeChecker.isAssignableFromType(targetType)) {
      return null;
    }

    final keyType = _getKeyType(targetType);
    final valueType = _getValueType(targetType);
    final targetTypeIsNullable = targetType.isNullableType;
    final optionalQuestion = targetTypeIsNullable ? '?' : '';

    // Serialize each Set<V> value to List<V>
    final subFieldValue = context.serialize(valueType, closureArg);
    final subKeyValue =
        forType(keyType)?.serialize(keyType, keyParam, false) ??
        context.serialize(keyType, keyParam);

    if (closureArg == subFieldValue && keyParam == subKeyValue) {
      // Simple case: just convert Set<V> to List<V>
      return '$expression$optionalQuestion.unlock.map(($keyParam, v) => MapEntry($subKeyValue, v.toList()))';
    }

    // Complex case: need to serialize individual values
    return '$expression$optionalQuestion.unlock.map(($keyParam, v) => MapEntry($subKeyValue, (v as Set<${valueType.getDisplayString()}>).map((e) => $subFieldValue).toList()))';
  }

  @override
  Object? deserialize(
    DartType targetType,
    String expression,
    TypeHelperContextWithConfig context,
    bool defaultProvided,
  ) {
    if (!typeChecker.isExactlyType(targetType)) {
      return null;
    }

    final keyType = _getKeyType(targetType);
    final valueType = _getValueType(targetType);
    final targetTypeIsNullable = targetType.isNullableType || defaultProvided;

    checkSafeKeyType(expression, keyType);

    final itemSubValObj = context.deserialize(valueType, closureArg);
    final itemSubVal = itemSubValObj.toString();
    final mapCast = context.config.anyMap
        ? 'as Map'
        : 'as Map<String, dynamic>';

    String keyUsage;
    if (keyType.isEnum) {
      keyUsage = context.deserialize(keyType, keyParam).toString();
    } else if (context.config.anyMap &&
        !(keyType.isDartCoreObject || keyType is DynamicType)) {
      keyUsage = '$keyParam as String';
    } else if (context.config.anyMap &&
        keyType.isDartCoreObject &&
        !keyType.isNullableType) {
      keyUsage = '$keyParam as Object';
    } else {
      keyUsage = keyParam;
    }

    final toFromString = forType(keyType);
    if (toFromString != null) {
      keyUsage = toFromString
          .deserialize(keyType, keyUsage, false, true)
          .toString();
    }

    // Convert Map<K, List<V>> to Map<K, Set<V>>, then use .lock
    if (closureArg == itemSubValObj) {
      return wrapNullableIfNecessary(
        expression,
        '(($expression $mapCast).map(($keyParam, v) => MapEntry($keyUsage, Set<${valueType.getDisplayString()}>.from(v as List)))).lock',
        targetTypeIsNullable,
      );
    }

    return wrapNullableIfNecessary(
      expression,
      '(($expression $mapCast).map(($keyParam, v) => MapEntry($keyUsage, Set<${valueType.getDisplayString()}>.from((v as List).map((e) => $itemSubVal))))).lock',
      targetTypeIsNullable,
    );
  }
}
