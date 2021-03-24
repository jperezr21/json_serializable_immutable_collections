
import 'package:analyzer/dart/element/type.dart';
import 'package:json_serializable_type_helper_utils/json_serializable_type_helper_utils.dart';
import 'package:source_gen/source_gen.dart' show TypeChecker;
import 'package:json_serializable/type_helper.dart';
import 'package:json_serializable/src/constants.dart';
import 'package:json_serializable/src/lambda_result.dart';
import 'package:json_serializable/src/shared_checkers.dart';
import 'package:json_serializable/src/utils.dart';

import "package:kt_dart/collection.dart";

const ktMapTypeChecker = TypeChecker.fromRuntime(KtMap);

class KtListTypeHelper extends CustomIterableTypeHelper<KtList> {

  @override
  String convertForDeserialize(String expression, DartType type) {
     return 'KtList<${type.getDisplayString(withNullability: true)}>.from($expression)';
  }

  @override
  String convertForSerialize(String expression, DartType type, bool isExpressionNullable) {
    final optionalQuestion = isExpressionNullable ? '?' : '';

    return expression +  optionalQuestion + '.asList()';
  }
}


class KtSetTypeHelper extends CustomIterableTypeHelper<KtSet> {

  @override
  String convertForDeserialize(String expression, DartType type) {
    return 'KtSet.from($expression)';
  }

  @override
  String convertForSerialize(String expression, DartType type, bool isExpressionNullable) {
    final optionalQuestion = isExpressionNullable ? '?' : '';
    return expression + optionalQuestion + '.iter.toList()';
  }
}

class KtMapTypeHelper extends TypeHelper<TypeHelperContextWithConfig> {
  final bool withNullability;

  const KtMapTypeHelper({this.withNullability = true});

  @override
  Object? serialize(
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

    final targetTypeIsNullable = targetType.isNullableType;


    final optionalQuestion = targetTypeIsNullable ? '?' : '';

    if (closureArg == subFieldValue && keyParam == subKeyValue) {
      return expression + optionalQuestion + '.asMap()';
    }

    return '$expression$optionalQuestion'
        '.asMap()$optionalQuestion.map(($keyParam, $closureArg) => MapEntry($subKeyValue, $subFieldValue))';
  }

  @override
  Object? deserialize(DartType targetType, String expression,
      TypeHelperContextWithConfig context, bool defaultProvided) {
    if (!ktMapTypeChecker.isExactlyType(targetType)) {
      return null;
    }
    final typeArgs = typeArgumentsOf(targetType, ktMapTypeChecker);
    assert(typeArgs.length == 2);
    final keyArg = typeArgs.first;
    final valueArg = typeArgs.last;
    final keyArgAsGenericString = keyArg.getDisplayString(withNullability: withNullability);
    final valueArgAsGenericString = valueArg.getDisplayString(withNullability: withNullability);

    final prefix =
        "KtMap<$keyArgAsGenericString,$valueArgAsGenericString>.from";

    checkSafeKeyType(expression, keyArg);

    final valueArgIsAny = isLikeDynamic(valueArg);
    final keyStringable = isKeyStringable(keyArg);
    final targetTypeIsNullable = targetType.isNullableType || defaultProvided;
    final anyMap = context.config.anyMap;


    if (!keyStringable) {
      if (valueArgIsAny) {
        if (anyMap) {
          if (isLikeDynamic(keyArg)) {
            return wrapNullableIfNecessary(
                expression, '$prefix($expression as Map)',targetTypeIsNullable);
          }
        } else {
          // this is the trivial case. Do a runtime cast to the known type of JSON
          // map values - `Map<String, dynamic>`
          return wrapNullableIfNecessary(
              expression,
              'KtMap<String,dynamic>.from($expression as Map<String, dynamic>)',
              targetTypeIsNullable);
        }
      }

      if (!targetTypeIsNullable &&
          (valueArgIsAny ||
              simpleJsonTypeChecker.isAssignableFromType(valueArg))) {
        // No mapping of the values or null check required!
        return wrapNullableIfNecessary(
            expression,
            'KtMap<String,$valueArgAsGenericString>.from(Map<String, $valueArgAsGenericString>.from($expression as Map))',
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
        '($keyParam, $closureArg) => MapEntry($keyUsage, $itemSubVal),))',
        targetTypeIsNullable);
  }
}
