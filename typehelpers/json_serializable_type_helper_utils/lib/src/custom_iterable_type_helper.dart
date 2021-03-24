import 'package:analyzer/dart/element/type.dart';
import 'package:json_serializable/type_helper.dart';
import 'package:source_gen/source_gen.dart' show TypeChecker;
import 'package:json_serializable/src/shared_checkers.dart';
import 'package:json_serializable/src/constants.dart';
import 'package:json_serializable/src/lambda_result.dart';
import 'package:json_serializable/src/utils.dart';

import '../json_serializable_type_helper_utils.dart';

abstract class CustomIterableTypeHelper<T extends Object>
    extends TypeHelper<TypeHelperContextWithConfig> {
  late final TypeChecker typeChecker = TypeChecker.fromRuntime(T);

  CustomIterableTypeHelper() :
        assert(T != dynamic, 'you need to specify the type parameter, got $T');

  /// convert the given expression for deserialization
  /// the expression is dart code that evaluates to an iterable,
  /// so you need to convert this iterable to your custom type
  String convertForDeserialize(String expression, DartType resolvedGenericType);

  /// convert the given expression for serialization TODO document what this means
  String convertForSerialize(String expression, DartType resolvedGenericType, bool isExpressionNullable);

  DartType genericType(DartType type) =>
      typeArgumentsOf(type, typeChecker).single;

  @override
  String? serialize(DartType targetType, String expression,
      TypeHelperContextWithConfig context) {
    if (!typeChecker.isAssignableFromType(targetType) ||
        TypeChecker.fromRuntime(Iterable).isSuperTypeOf(targetType)) {
      return null;
    }

    // This block will yield a regular list, which works fine for JSON
    // Although it's possible that child elements may be marked unsafe

    final itemType = genericType(targetType);

    var isList = typeChecker.isAssignableFromType(targetType);
    final subField = context.serialize(itemType, closureArg)!;

    final targetTypeIsNullable = targetType.isNullableType;

    final optionalQuestion = targetTypeIsNullable ? '?' : '';

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

    /*if (!isList) {
      // If the static type is not a List, generate one.
      return expression += '$optionalQuestion.iter$optionalQuestion.toList()';
    }

    return expression + optionalQuestion + '.asList()';*/

    return convertForSerialize(expression, itemType, targetTypeIsNullable);

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

    final itemSubVal = context.deserialize(resolvedGenericType, closureArg)!;

    var output = '$expression as List';

    final targetTypeIsNullable = defaultProvided || targetType.isNullableType;

    // If `itemSubVal` is the same and it's not a Set, then we don't need to do
    // anything fancy
    if (closureArg == itemSubVal && typeChecker.isExactlyType(targetType)) {
      return wrapNullableIfNecessary(
          expression, convertForDeserialize(output, resolvedGenericType), targetTypeIsNullable);
    }

    output = '($output)';

    if (closureArg != itemSubVal) {
      final lambda = LambdaResult.process(itemSubVal, closureArg);
      output += '.map($lambda)';
    }

    output = convertForDeserialize(output, resolvedGenericType);

    return wrapNullableIfNecessary(expression, output, targetTypeIsNullable);
  }
}
