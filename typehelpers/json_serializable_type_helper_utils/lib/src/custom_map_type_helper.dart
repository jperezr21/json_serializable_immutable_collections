import 'package:analyzer/dart/element/type.dart';
// ignore: implementation_imports
import 'package:json_serializable/src/constants.dart';
import 'package:json_serializable/type_helper.dart';
import 'package:json_serializable_type_helper_utils/json_serializable_type_helper_utils.dart';
import 'package:source_gen/source_gen.dart' show TypeChecker;
import 'package:source_helper/source_helper.dart';

const _keyParam = 'k';

abstract class CustomMapTypeHelper<T>
    extends TypeHelper<TypeHelperContextWithConfig> {
  late final TypeChecker typeChecker = TypeChecker.fromRuntime(T);

  CustomMapTypeHelper()
      : assert(T != dynamic,
            'you need to specify the type to (de)-serialize of generic parameter');

  /// Deserialize your custom map from an expression, that evaluates to an
  /// Iterable<MapEntry> with the given DartTypes.
  ///
  /// Return a string, which is an expression that evaluates to your custom
  /// map implementation.
  /// Example: if your custom map implementation has a constructor `MyMap.of(Map m)`,
  /// implement this method like this:
  ///
  /// ```dart
  ///  String deserializeFromMapExpression(String mapExpression, DartType keyArg, DartType valueArg) {
  ///    final prefix = 'MyMap.of';
  ///    return '$prefix($mapExpression)';
  ///   }
  /// ```
  String deserializeFromMapExpression(
      String mapExpression, DartType keyType, DartType valueType);

  /// Serialize your custom map implementation to a standard Map.
  ///
  /// Given [mapExpression], which a String that evaluates to your custom
  /// map implementation [T]
  /// not that if [isMapExpressionNullable] is true, that [mapExpression] is
  /// nullable and you need null safe accessors
  ///
  /// Example: if your custom map implementation has a method `.toMap(),`
  /// implement this method like this:
  ///
  /// ```dart
  /// String serializeToMap(String mapExpression, DartType keyType,
  ///       DartType valueType, bool isMapExpressionNullable){
  ///          final optionalQuestion = isMapExpressionNullable ? '?' : '';
  ///          return mapExpression + optionalQuestion + '.toMap()';
  /// }
  /// ```
  String serializeToMapExpression(String mapExpression, DartType keyType,
      DartType valueType, bool isMapExpressionNullable);

  @override
  Object? serialize(
      DartType targetType, String expression, TypeHelperContext context) {
    if (!typeChecker.isAssignableFromType(targetType)) {
      return null;
    }
    final args = targetType.typeArgumentsOf(typeChecker)!;
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
      return serializeToMapExpression(
          expression, keyType, valueType, targetTypeIsNullable);
    }

    return serializeToMapExpression(
            expression, keyType, valueType, targetTypeIsNullable) +
        '$optionalQuestion.map(($keyParam, $closureArg) => MapEntry($subKeyValue, $subFieldValue))';
  }

  @override
  Object? deserialize(DartType targetType, String expression,
      TypeHelperContextWithConfig context, bool defaultProvided) {
    if (!typeChecker.isExactlyType(targetType)) {
      return null;
    }
    final typeArgs = targetType.typeArgumentsOf(typeChecker)!;
    assert(typeArgs.length == 2);
    final keyArg = typeArgs.first;
    final valueArg = typeArgs.last;
    final valueArgAsGenericString =
        valueArg.getDisplayString(withNullability: true);

    checkSafeKeyType(expression, keyArg);

    final valueArgIsAny = valueArg.isLikeDynamic;
    final keyStringable = isKeyStringable(keyArg);
    final targetTypeIsNullable = targetType.isNullableType || defaultProvided;
    final anyMap = context.config.anyMap;
    final optionalQuestion = targetTypeIsNullable ? '?' : '';

    if (!keyStringable) {
      if (valueArgIsAny) {
        if (anyMap) {
          if (keyArg.isLikeDynamic) {
            return wrapNullableIfNecessary(
                expression,
                deserializeFromMapExpression(
                    '($expression as Map$optionalQuestion)', keyArg, valueArg),
                targetTypeIsNullable);
          }
        } else {
          // this is the trivial case. Do a runtime cast to the known type of JSON
          // map values - `Map<String, dynamic>`
          return wrapNullableIfNecessary(
              expression,
              deserializeFromMapExpression(
                  '($expression as Map<String, dynamic>)', keyArg, valueArg),
              targetTypeIsNullable);
        }
      }

      if (!targetTypeIsNullable &&
          (valueArgIsAny ||
              simpleJsonTypeChecker.isAssignableFromType(valueArg))) {
        // No mapping of the values or null check required!
        return wrapNullableIfNecessary(
            expression,
            deserializeFromMapExpression(
                'Map<String, $valueArgAsGenericString>.from($expression as Map)',
                keyArg,
                valueArg),
            targetTypeIsNullable);
      }
    }

    // In this case, we're going to create a new Map with matching reified
    // types.

    var itemSubVal = context.deserialize(valueArg, closureArg).toString();

    final mapCast = anyMap ? 'as Map' : 'as Map<String, dynamic>';

    String keyUsage;
    if (keyArg.isEnum) {
      keyUsage = context.deserialize(keyArg, _keyParam).toString();
    } else if (context.config.anyMap &&
        !(keyArg.isDartCoreObject || keyArg.isDynamic)) {
      keyUsage = '$_keyParam as String';
    } else if (context.config.anyMap &&
        keyArg.isDartCoreObject &&
        !keyArg.isNullableType) {
      keyUsage = '$_keyParam as Object';
    } else {
      keyUsage = _keyParam;
    }

    final toFromString = forType(keyArg);
    if (toFromString != null) {
      keyUsage = toFromString.deserialize(keyArg, keyUsage, false, true)!;
    }

    return wrapNullableIfNecessary(
        expression,
        deserializeFromMapExpression(
            '($expression $mapCast).map('
            '($keyParam, $closureArg) => MapEntry($keyUsage, $itemSubVal),)',
            keyArg,
            valueArg),
        targetTypeIsNullable);
  }
}
