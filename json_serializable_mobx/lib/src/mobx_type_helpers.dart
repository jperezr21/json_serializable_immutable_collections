import 'package:analyzer/dart/element/type.dart';
import 'package:json_serializable_type_helper_utils/json_serializable_type_helper_utils.dart';
import 'package:mobx/mobx.dart';
import 'package:source_gen/source_gen.dart' show TypeChecker;
import 'package:json_serializable/type_helper.dart';
import 'package:json_serializable/src/constants.dart';
import 'package:json_serializable/src/lambda_result.dart';
import 'package:json_serializable/src/shared_checkers.dart';
import 'package:json_serializable/src/utils.dart';

const mobxListTypeChecker = TypeChecker.fromRuntime(ObservableList);
const mobxSetTypeChecker = TypeChecker.fromRuntime(ObservableSet);
const mobxMapTypeChecker = TypeChecker.fromRuntime(ObservableMap);

const withNullability = true;

class MobxIterableTypeHelper extends TypeHelper<TypeHelperContextWithConfig> {
  const MobxIterableTypeHelper();

  @override
  String? serialize(
      DartType targetType, String expression, TypeHelperContext context) {
    return null;
  }

  @override
  String? deserialize(DartType targetType, String expression,
      TypeHelperContextWithConfig context, bool defaultProvided) {
    if (!(coreIterableTypeChecker.isExactlyType(targetType) ||
        mobxListTypeChecker.isExactlyType(targetType) ||
        mobxSetTypeChecker.isExactlyType(targetType))) {
      return null;
    }

    final iterableGenericType = coreIterableGenericType(targetType);

    final itemSubVal = context.deserialize(iterableGenericType, closureArg)!;

    var output = '$expression as List';

    final targetTypeIsNullable = targetType.isNullableType || defaultProvided;

    // If `itemSubVal` is the same and it's not a Set, then we don't need to do
    // anything fancy
    if (closureArg == itemSubVal &&
        mobxListTypeChecker.isExactlyType(targetType)) {
      return wrapNullableIfNecessary(
          expression,
          'ObservableList<${iterableGenericType.getDisplayString(withNullability: withNullability)}>.of($output)',
          targetTypeIsNullable);
    }

    output = '($output)';

    if (closureArg != itemSubVal) {
      final lambda = LambdaResult.process(itemSubVal, closureArg);
      output += '.map($lambda)';
    }

    if (mobxListTypeChecker.isExactlyType(targetType)) {
      output =
          'ObservableList<${iterableGenericType.getDisplayString(withNullability: withNullability)}>.of($output)';
    } else if (mobxSetTypeChecker.isExactlyType(targetType)) {
      output =
          'ObservableSet<${iterableGenericType.getDisplayString(withNullability: withNullability)}>.of($output)';
    }

    return wrapNullableIfNecessary(expression, output, targetTypeIsNullable);
  }
}

class MobxMapTypeHelper extends TypeHelper<TypeHelperContextWithConfig> {
  const MobxMapTypeHelper();

  @override
  Object? serialize(
      DartType targetType, String expression, TypeHelperContext context) {
    if (!mobxMapTypeChecker.isAssignableFromType(targetType)) {
      return null;
    }
    final args = typeArgumentsOf(targetType, mobxMapTypeChecker);
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
      return expression;
    }

    return '$expression$optionalQuestion'
        '.map(($keyParam, $closureArg) => MapEntry($subKeyValue, $subFieldValue))';
  }

  @override
  Object? deserialize(DartType targetType, String expression,
      TypeHelperContextWithConfig context, bool defaultProvided) {
    if (!mobxMapTypeChecker.isExactlyType(targetType)) {
      return null;
    }
    final typeArgs = typeArgumentsOf(targetType, mobxMapTypeChecker);
    assert(typeArgs.length == 2);
    final keyArg = typeArgs.first;
    final valueArg = typeArgs.last;


    var prefix =
        "ObservableMap<${keyArg.getDisplayString(withNullability: withNullability)},${valueArg.getDisplayString(withNullability: withNullability)}>.of";

    checkSafeKeyType(expression, keyArg);

    final valueArgIsAny = isLikeDynamic(valueArg);
    final keyStringable = isKeyStringable(keyArg);

    final targetTypeIsNullable = targetType.isNullableType || defaultProvided;

    if (!keyStringable) {
      if (valueArgIsAny) {
        if (context.config.anyMap!) {
          if (isLikeDynamic(keyArg)) {
            return wrapNullableIfNecessary(expression,
                '$prefix($expression as Map)', targetTypeIsNullable);
          }
        } else {
          // this is the trivial case. Do a runtime cast to the known type of JSON
          // map values - `Map<String, dynamic>`
          return wrapNullableIfNecessary(
              expression,
              'ObservableMap<String,dynamic>.of($expression as Map<String, dynamic>)',
              targetTypeIsNullable);
        }
      }

      if (!targetTypeIsNullable &&
          (valueArgIsAny ||
              simpleJsonTypeChecker.isAssignableFromType(valueArg))) {
        // No mapping of the values or null check required!
        return wrapNullableIfNecessary(
            expression,
            'ObservableMap<String,$valueArg>.of(Map<String, $valueArg>.of($expression as Map<String,$valueArg>))',
            targetTypeIsNullable);
      }
    }

    // In this case, we're going to create a new Map with matching reified
    // types.

    final itemSubVal = context.deserialize(valueArg, closureArg);

    final mapCast =
        context.config.anyMap! ? 'as Map' : 'as Map<String, dynamic>';

    String keyUsage;
    if (isEnum(keyArg)) {
      keyUsage = context.deserialize(keyArg, keyParam).toString();
    } else if (context.config.anyMap! && !isLikeDynamic(keyArg)) {
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

class MobxObservableTypeHelper extends TypeHelper<TypeHelperContextWithConfig> {
  const MobxObservableTypeHelper();

  @override
  Object? serialize(DartType targetType, String expression,
      TypeHelperContextWithConfig context) {

    if (observableTypeChecker.isExactlyType(targetType)) {
      final typeArg = typeArgumentsOf(targetType, observableTypeChecker).single;
      final optionalQuestion = targetType.isNullableType ? '?' : '';

      return context.serialize(
          typeArg,
          "($expression)$optionalQuestion.value");
    }
    return null;
  }

  @override
  String? deserialize(
    DartType targetType,
    String expression,
    TypeHelperContextWithConfig context,
    bool defaultProvided,
  ) {
    final typeArg = typeArgumentsOf(targetType, observableTypeChecker).single;
    if (observableTypeChecker.isExactlyType(targetType)) {
      return 'Observable(${context.deserialize(typeArg, expression)})';
    }

    return null;
  }
}

const observableTypeChecker = TypeChecker.fromRuntime(Observable);
