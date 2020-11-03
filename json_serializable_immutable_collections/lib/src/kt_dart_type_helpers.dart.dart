import 'package:analyzer/dart/element/type.dart';
import 'package:json_serializable_type_helper_utils/json_serializable_type_helper_utils.dart';
import 'package:source_gen/source_gen.dart' show TypeChecker;
import 'package:json_serializable/type_helper.dart';
import 'package:json_serializable/src/constants.dart';
import 'package:json_serializable/src/lambda_result.dart';
import 'package:json_serializable/src/shared_checkers.dart';
import 'package:json_serializable/src/utils.dart';

import "package:kt_dart/collection.dart";

const ktIterableTypeChecker = TypeChecker.fromRuntime(KtIterable);
const ktListTypeChecker = TypeChecker.fromRuntime(KtList);
const ktSetTypeChecker = TypeChecker.fromRuntime(KtSet);
const ktMapTypeChecker = TypeChecker.fromRuntime(KtMap);

DartType ktIterableGenericType(DartType type) =>
    typeArgumentsOf(type, ktIterableTypeChecker).single;

class KtIterableTypeHelper extends TypeHelper<TypeHelperContext> {
  const KtIterableTypeHelper();

  @override
  String serialize(
      DartType targetType, String expression, TypeHelperContext context) {
    if (!ktIterableTypeChecker.isAssignableFromType(targetType)) {
      return null;
    }

    final itemType = ktIterableGenericType(targetType);

    // This block will yield a regular list, which works fine for JSON
    // Although it's possible that child elements may be marked unsafe

    var isList = ktListTypeChecker.isAssignableFromType(targetType);
    final subField = context.serialize(itemType, closureArg);

    final optionalQuestion = context.nullable ? '?' : '';

    // In the case of trivial JSON types (int, String, etc), `subField`
    // will be identical to `substitute` – so no explicit mapping is needed.
    // If they are not equal, then we to write out the substitution.
    if (subField != closureArg) {
      final lambda = LambdaResult.process(subField, closureArg);

      expression = '$expression$optionalQuestion.map($lambda)';

      // expression now represents an Iterable (even if it started as a List
      // ...resetting `isList` to `false`.
      isList = false;
    }

    if (!isList) {
      // If the static type is not a List, generate one.
      return expression += '$optionalQuestion.iter$optionalQuestion.toList()';
    }

    return expression + optionalQuestion + '.asList()';
  }

  @override
  String deserialize(
      DartType targetType, String expression, TypeHelperContext context) {
    if (!(ktIterableTypeChecker.isExactlyType(targetType) ||
        ktListTypeChecker.isExactlyType(targetType) ||
        ktSetTypeChecker.isExactlyType(targetType))) {
      return null;
    }

    final iterableGenericType = ktIterableGenericType(targetType);

    final itemSubVal = context.deserialize(iterableGenericType, closureArg);

    var output = '$expression as List';

    // If `itemSubVal` is the same and it's not a Set, then we don't need to do
    // anything fancy
    if (closureArg == itemSubVal &&
        !ktSetTypeChecker.isExactlyType(targetType)) {
      return 'KtList<$iterableGenericType>.from($output)';
    }

    output = '($output)';

    if (closureArg != itemSubVal) {
      final lambda = LambdaResult.process(itemSubVal, closureArg);
      output += '.map($lambda)';
    }

    if (ktListTypeChecker.isExactlyType(targetType)) {
      output = 'KtList<$iterableGenericType>.from($output)';
    } else if (ktSetTypeChecker.isExactlyType(targetType)) {
      output = 'KtSet<$iterableGenericType>.from($output)';
    }

    return wrapNullableIfNecessary(expression, output, context.nullable);
  }
}

class KtMapTypeHelper extends TypeHelper<TypeHelperContextWithConfig> {
  final bool withNullability;

  const KtMapTypeHelper({this.withNullability = false});

  @override
  Object serialize(
      DartType targetType, String expression, TypeHelperContext context) {
    if (!ktMapTypeChecker.isAssignableFromType(targetType)) {
      return null;
    }
    final args = typeArgumentsOf(targetType, ktMapTypeChecker);
    assert(args.length == 2);

    final keyType = args[0];
    final valueType = args[1];

    checkSafeKeyType(expression, keyType);

    final subFieldValue = context.serialize(valueType, closureArg);
    final subKeyValue = forType(keyType)?.serialize(keyType, keyParam, false) ??
        context.serialize(keyType, keyParam);

    final optionalQuestion = context.nullable ? '?' : '';

    if (closureArg == subFieldValue && keyParam == subKeyValue) {
      return expression + optionalQuestion + ".asMap()";
    }

    return '$expression$optionalQuestion'
        '.asMap()$optionalQuestion.map(($keyParam, $closureArg) => MapEntry($subKeyValue, $subFieldValue))';
  }

  @override
  Object deserialize(DartType targetType, String expression,
      TypeHelperContextWithConfig context) {
    if (!ktMapTypeChecker.isExactlyType(targetType)) {
      return null;
    }
    final typeArgs = typeArgumentsOf(targetType, ktMapTypeChecker);
    assert(typeArgs.length == 2);
    final keyArg = typeArgs.first;
    final valueArg = typeArgs.last;

    var prefix =
        "KtMap<${keyArg.getDisplayString(withNullability: withNullability)},${valueArg.getDisplayString(withNullability: withNullability)}>.from";

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
              'KtMap<String,dynamic>.from($expression as Map<String, dynamic>)',
              context.nullable);
        }
      }

      if (!context.nullable &&
          (valueArgIsAny ||
              simpleJsonTypeChecker.isAssignableFromType(valueArg))) {
        // No mapping of the values or null check required!
        return wrapNullableIfNecessary(
            expression,
            'KtMap<String,$valueArg>.of(Map<String, $valueArg>.from($expression as Map))',
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
