import 'package:analyzer/dart/element/type.dart';
import 'package:json_serializable/type_helper.dart';
import 'package:source_gen/source_gen.dart' show TypeChecker;
import 'package:json_serializable/src/shared_checkers.dart';
import 'package:json_serializable/src/constants.dart';
import 'package:json_serializable/src/lambda_result.dart';
import 'package:json_serializable/src/utils.dart';
import 'package:source_helper/source_helper.dart';

import '../json_serializable_type_helper_utils.dart';

abstract class CustomIterableTypeHelper<T extends Object>
    extends TypeHelper<TypeHelperContextWithConfig> {
  late final TypeChecker typeChecker = TypeChecker.fromRuntime(T);

  CustomIterableTypeHelper()
      : assert(T != dynamic, 'you need to specify the type parameter, got $T');

  /// convert the given expression for deserialization.
  /// the expression is Dart code that evaluates to an iterable,
  /// so you need to convert this iterable to your custom type
  /// @param [expression] the expression, that evaluates to an Iterable
  /// @param [resolvedGenericType] the generic type of the list that will be deserialized
  /// @return A String, which is a Dart expression that evaluates to your custom Iterable type
  ///
  /// Example for BuiltList:
  /// ````dart
  ///   @override
  ///   String deserializeFromIterableExpression(
  ///       String expression, DartType resolvedGenericType) {
  ///     return '($expression).toBuiltList()';
  ///   }
  ///```
  String deserializeFromIterableExpression(
      String expression, DartType resolvedGenericType);

  /// convert the given expression for serialization.
  /// The expression is dart code that evaluates to your custom iterable type.
  /// you need to return an expression that evaluates to a Dart list
  ///
  /// Note: you don't need to implement this if your type implements Iterable.
  /// you can throw an exception , this method will never be called in that case
  ///
  /// example for kt_dart:
  ///
  ///
  /// ```dart
  ///   @override
  ///   String serializeToList(
  ///       String expression, DartType type, bool isExpressionNullable) {
  ///     final optionalQuestion = isExpressionNullable ? '?' : '';
  ///     return expression + optionalQuestion + '.iter.toList()';
  ///   }
  /// ```
  String serializeToList(String expression, DartType resolvedGenericType,
      bool isExpressionNullable);

  DartType genericType(DartType type) =>
      type.typeArgumentsOf(typeChecker)!.single;

  @override
  String? serialize(DartType targetType, String expression,
      TypeHelperContextWithConfig context) {
    if ((!typeChecker.isAssignableFromType(targetType)) ||
        _isDartCoreIterable<T>()) {
      return null;
    }

    // This block will yield a regular list, which works fine for JSON
    // Although it's possible that child elements may be marked unsafe

    final itemType = genericType(targetType);

    final subField = context.serialize(itemType, closureArg)!;

    final targetTypeIsNullable = targetType.isNullableType;

    final optionalQuestion = targetTypeIsNullable ? '?' : '';

    // In the case of trivial JSON types (int, String, etc), `subField`
    // will be identical to `substitute` – so no explicit mapping is needed.
    // If they are not equal, then we to write out the substitution.
    if (subField != closureArg) {
      final lambda = LambdaResult.process(subField);

      expression = '$expression$optionalQuestion.map($lambda)';

      // expression now represents an Iterable (even if it started as a List
      // ...resetting `isList` to `false`.
      //isList = false;
    }

    /*if (!isList) {
      // If the static type is not a List, generate one.
      return expression += '$optionalQuestion.iter$optionalQuestion.toList()';
    }

    return expression + optionalQuestion + '.asList()';*/

    return serializeToList(expression, itemType, targetTypeIsNullable);
  }

  @override
  String? deserialize(
    DartType targetType,
    String expression,
    TypeHelperContextWithConfig context,
    bool defaultProvided,
  ) {
    if (!typeChecker.isExactlyType(targetType)) {
      return null;
    }
    final resolvedGenericType = genericType(targetType);

    var itemSubVal = context.deserialize(resolvedGenericType, closureArg)!.toString();

    final targetTypeIsNullable = defaultProvided || targetType.isNullableType;

    itemSubVal = wrapNullableIfNecessary(closureArg, itemSubVal, resolvedGenericType.isNullableType);


    var output = '$expression as List';



    // If `itemSubVal` is the same and it's not a Set, then we don't need to do
    // anything fancy
    if (closureArg == itemSubVal && typeChecker.isExactlyType(targetType)) {
      return wrapNullableIfNecessary(
          expression,
          deserializeFromIterableExpression(output, resolvedGenericType),
          targetTypeIsNullable);
    }

    output = '($output)';

    if (closureArg != itemSubVal) {
      final lambda = LambdaResult.process(itemSubVal);
      output += '.map($lambda)';
    }

    output = deserializeFromIterableExpression(output, resolvedGenericType);

    return wrapNullableIfNecessary(expression, output, targetTypeIsNullable);
  }
}

//danger, dirty hack ahead
bool _isDartCoreIterable<T>() {
  return <T>[] is List<Iterable>;
}
