// Copyright (c) 2018, the Dart project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:analyzer/dart/element/type.dart';
import 'package:json_serializable_immutable_collections/src/utils.dart';
import 'package:json_serializable_immutable_collections/src/wrap_nullable.dart';
import 'package:source_gen/source_gen.dart' show TypeChecker;
import 'package:json_serializable/type_helper.dart';

import 'package:json_serializable/src/constants.dart';
import 'package:json_serializable/src/lambda_result.dart';
import 'package:json_serializable/src/shared_checkers.dart';
import 'package:json_serializable/src/utils.dart';


import 'package:built_collection/built_collection.dart';

class BuiltIterableTypeHelper extends TypeHelper<TypeHelperContext> {
  const BuiltIterableTypeHelper();

  @override
  String serialize(
      DartType targetType, String expression, TypeHelperContext context) {
    //default iterable helper will serialize all iterables fine
    return null;
  }

  @override
  String deserialize(
      DartType targetType, String expression, TypeHelperContext context) {
    if (!(coreIterableTypeChecker.isExactlyType(targetType) ||
        builtListTypeChecker.isExactlyType(targetType) ||
        builtSetTypeChecker.isExactlyType(targetType))) {
      return null;
    }
    final iterableGenericType = coreIterableGenericType(targetType);

    final itemSubVal = context.deserialize(iterableGenericType, closureArg);

    var output = '$expression as List';

    // If `itemSubVal` is the same and it's not a Set, then we don't need to do
    // anything fancy
    if (closureArg == itemSubVal &&
        builtListTypeChecker.isExactlyType(targetType)) {
      return wrapNullableIfNecessary(
          expression, '($output).toBuiltList()', context.nullable);
    }

    output = '($output)';

    final optionalQuestion = context.nullable ? '?' : '';

    if (closureArg != itemSubVal) {
      final lambda = LambdaResult.process(itemSubVal, closureArg);
      output += '$optionalQuestion.map($lambda)';
    }

    if (builtListTypeChecker.isExactlyType(targetType)) {
      output += '.toBuiltList()';
    } else if (builtSetTypeChecker.isExactlyType(targetType)) {
      output += '.toBuiltSet()';
    }

    return wrapNullableIfNecessary(expression, output, context.nullable);
  }
}

class BuiltMapTypeHelper extends TypeHelper<TypeHelperContext> {
  const BuiltMapTypeHelper();

  @override
  String serialize(
      DartType targetType, String expression, TypeHelperContext context) {
    if (!builtMapTypeChecker.isAssignableFromType(targetType)) {
      return null;
    }
    final args = typeArgumentsOf(targetType, builtMapTypeChecker);
    assert(args.length == 2);

    final keyType = args[0];
    final valueType = args[1];

    checkSafeKeyType(expression, keyType);

    final subFieldValue = context.serialize(valueType, closureArg);
    final subKeyValue = forType(keyType)?.serialize(keyType, keyParam, false) ??
        context.serialize(keyType, keyParam);

    final optionalQuestion = context.nullable ? '?' : '';

    if (closureArg == subFieldValue && keyParam == subKeyValue) {
      return expression + optionalQuestion + ".toMap()";
    }

    return '$expression$optionalQuestion'
        '.toMap()$optionalQuestion.map(($keyParam, $closureArg) => MapEntry($subKeyValue, $subFieldValue))';
  }

  @override
  String deserialize(DartType targetType, String expression, dynamic context) {
    if (!builtMapTypeChecker.isExactlyType(targetType)) {
      return null;
    }
    final typeArgs = typeArgumentsOf(targetType, builtMapTypeChecker);
    assert(typeArgs.length == 2);
    final keyArg = typeArgs.first;
    final valueArg = typeArgs.last;

    var prefix =
        "BuiltMap<${keyArg.getDisplayString()},${valueArg.getDisplayString()}>.of";

    checkSafeKeyType(expression, keyArg);

    final valueArgIsAny = isObjectOrDynamic(valueArg);
    final keyStringable = isKeyStringable(keyArg);

    if (!keyStringable) {
      if (valueArgIsAny) {
        if (context.config.anyMap) {
          if (isObjectOrDynamic(keyArg)) {
            return wrapNullableIfNecessary(
                expression, '$prefix($expression as Map)', context.nullable);
          }
        } else {
          // this is the trivial case. Do a runtime cast to the known type of JSON
          // map values - `Map<String, dynamic>`
          return wrapNullableIfNecessary(
              expression,
              'BuiltMap<String,Object>.of($expression as Map<String, dynamic>)',
              context.nullable);
        }
      }

      if (!context.nullable &&
          (valueArgIsAny ||
              simpleJsonTypeChecker.isAssignableFromType(valueArg))) {
        // No mapping of the values or null check required!
        return wrapNullableIfNecessary(
            expression,
            'BuiltMap<String,$valueArg>.of(Map<String, $valueArg>.from($expression as Map))',
            context.nullable);
      }
    }

    // In this case, we're going to create a new Map with matching reified
    // types.

    final itemSubVal = context.deserialize(valueArg, closureArg);

    final mapCast =
        context.config.anyMap ? 'as Map' : 'as Map<String, dynamic>';

    String keyUsage;
    if (isEnum(keyArg)) {
      keyUsage = context.deserialize(keyArg, keyParam).toString();
    } else if (context.config.anyMap && !isObjectOrDynamic(keyArg)) {
      keyUsage = '$keyParam as String';
    } else {
      keyUsage = keyParam;
    }

    final toFromString = forType(keyArg);
    if (toFromString != null) {
      keyUsage = toFromString.deserialize(keyArg, keyUsage, false, true);
    }

    return wrapNullableIfNecessary(
        expression,
        '$prefix(($expression $mapCast).map('
        '($keyParam, $closureArg) => MapEntry($keyUsage, $itemSubVal),))',
        context.nullable);
  }
}

final builtListTypeChecker = TypeChecker.fromRuntime(BuiltList);
final builtSetTypeChecker = TypeChecker.fromRuntime(BuiltSet);
final builtMapTypeChecker = TypeChecker.fromRuntime(BuiltMap);
