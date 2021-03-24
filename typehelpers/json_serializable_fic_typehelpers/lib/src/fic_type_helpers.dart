// Copyright (c) 2018, the Dart project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.



import 'package:analyzer/dart/element/type.dart';
import 'package:fast_immutable_collections/fast_immutable_collections.dart';

import 'package:json_serializable/type_helper.dart';
import 'package:json_serializable/src/shared_checkers.dart';
import 'package:json_serializable/src/constants.dart';
import 'package:json_serializable/src/lambda_result.dart';
import 'package:json_serializable/src/utils.dart';
import 'package:json_serializable_type_helper_utils/json_serializable_type_helper_utils.dart';
import 'package:source_gen/source_gen.dart';


class FICIterableTypeHelper extends TypeHelper<TypeHelperContextWithConfig> {
  final bool withNullability;

  const FICIterableTypeHelper({this.withNullability = true});

  @override
  String? serialize(DartType targetType, String expression,
      TypeHelperContextWithConfig context) {
    //default iterable helper will serialize all iterables fine
    return null;
  }

  @override
  String? deserialize(
    DartType targetType,
    String expression,
    TypeHelperContextWithConfig context,
    bool defaultProvided,
  ) {
    if (!(coreIterableTypeChecker.isExactlyType(targetType) ||
        iListTypeChecker.isExactlyType(targetType) ||
        iListTypeChecker.isExactlyType(targetType) ||
        iSetTypeChecker.isExactlyType(targetType))) {
      return null;
    }
    final iterableGenericType = coreIterableGenericType(targetType);

    final itemSubVal = context.deserialize(iterableGenericType, closureArg)!;

    var output = '$expression as List';

    final targetTypeIsNullable = defaultProvided || targetType.isNullableType;

    // If `itemSubVal` is the same and it's not a Set, then we don't need to do
    // anything fancy
    if (closureArg == itemSubVal &&
        iListTypeChecker.isExactlyType(targetType)) {
      return wrapNullableIfNecessary(
          expression, '($output).toIList()', targetTypeIsNullable);
    }

    output = '($output)';

    if (closureArg != itemSubVal) {
      final lambda = LambdaResult.process(itemSubVal, closureArg);
      output += '.map($lambda)';
    }

    if (iListTypeChecker.isExactlyType(targetType)) {
      output += '.toIList()';
    } else if (iSetTypeChecker.isExactlyType(targetType)) {
      output += '.toISet()';
    }

    return wrapNullableIfNecessary(expression, output, targetTypeIsNullable);
  }
}

class FICIMapTypeHelper extends TypeHelper<TypeHelperContextWithConfig> {
  final bool withNullability;

  const FICIMapTypeHelper({this.withNullability = true});

  @override
  String? serialize(DartType targetType, String expression,
      TypeHelperContextWithConfig context) {
    if (!iMapTypeChecker.isAssignableFromType(targetType)) {
      return null;
    }
    final args = typeArgumentsOf(targetType, iMapTypeChecker);
    assert(args.length == 2);

    final keyType = args[0];
    final valueType = args[1];

    checkSafeKeyType(expression, keyType);

    final subFieldValue = context.serialize(valueType, closureArg);
    final subKeyValue = forType(keyType)?.serialize(keyType, keyParam, false) ??
        context.serialize(keyType, keyParam);

    final targetTypeIsNullable = targetType.isNullableType;

    final optionalQuestion = targetTypeIsNullable ? '?' : '';

    if (closureArg == subFieldValue && keyParam == subKeyValue) {
      return expression + optionalQuestion + ".unlockLazy";
    }

    return '$expression$optionalQuestion'
        '.unlockLazy$optionalQuestion.map(($keyParam, $closureArg) => MapEntry($subKeyValue, $subFieldValue))';
  }

  @override
  String? deserialize(DartType targetType, String expression,
      TypeHelperContextWithConfig context, bool defaultProvided) {
    if (!iMapTypeChecker.isExactlyType(targetType)) {
      return null;
    }

    final typeArgs = typeArgumentsOf(targetType, iMapTypeChecker);
    assert(typeArgs.length == 2);
    final keyArg = typeArgs.first;
    final valueArg = typeArgs.last;


    final targetTypeIsNullable = targetType.isNullableType || defaultProvided;


    final prefix =
        "IMap<${keyArg.getDisplayString(withNullability: this.withNullability)},${valueArg.getDisplayString(withNullability: this.withNullability)}>.fromEntries";

    checkSafeKeyType(expression, keyArg);

    final valueArgIsAny = isLikeDynamic(valueArg);
    final keyStringable = isKeyStringable(keyArg);

    final anyMap = context.config.anyMap;

    if (!keyStringable) {
      if (valueArgIsAny) {
        if (anyMap) {
          if (isLikeDynamic(keyArg)) {
            return wrapNullableIfNecessary(
                expression, '($expression as Map).toIMap()', targetTypeIsNullable);
          }
        } else {
          // this is the trivial case. Do a runtime cast to the known type of JSON
          // map values - `Map<String, dynamic>`
          return wrapNullableIfNecessary(
              expression,
              '($expression as Map<String, dynamic>).toIMap()',
              targetTypeIsNullable);
        }
      }

      if (!targetTypeIsNullable &&
          (valueArgIsAny ||
              simpleJsonTypeChecker.isAssignableFromType(valueArg))) {
        // No mapping of the values or null check required!
        return wrapNullableIfNecessary(
            expression,
            '(Map<String, ${valueArg.getDisplayString(withNullability: withNullability)}>.from($expression as Map)).toIMap()',
            targetTypeIsNullable);
      }
    }


    // In this case, we're going to create a new Map with matching reified
    // types.

    final itemSubVal = context.deserialize(valueArg, closureArg);

    final mapCast =
    anyMap ? 'as Map' : 'as Map<String, dynamic>';

    String keyUsage;
    if (isEnum(keyArg)) {
      keyUsage = context.deserialize(keyArg, keyParam).toString();
    } else if (anyMap && !isLikeDynamic(keyArg)) {
      keyUsage = '$keyParam as String';
    } else {
      keyUsage = keyParam;
    }

    final toFromString = forType(keyArg);
    if (toFromString != null) {
      keyUsage = toFromString.deserialize(keyArg, keyUsage, false, true)!;
    }

    return wrapNullableIfNecessary(
        expression,
        '$prefix(($expression $mapCast).map('
        '($keyParam, $closureArg) => MapEntry($keyUsage, $itemSubVal),).entries'
            ')',
        targetTypeIsNullable);
  }
}

final iListTypeChecker = TypeChecker.fromRuntime(IList);
final iSetTypeChecker = TypeChecker.fromRuntime(ISet);
final iMapTypeChecker = TypeChecker.fromRuntime(IMap);
