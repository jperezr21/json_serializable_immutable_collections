import 'package:analyzer/dart/element/type.dart';
import 'package:immutable_json_list_builder/src/built_collection_type_helpers.dart';
import 'package:source_gen/source_gen.dart' show TypeChecker;
import 'package:json_serializable/type_helper.dart';

import 'package:json_serializable/src/constants.dart';
import 'package:json_serializable/src/lambda_result.dart';
import 'package:json_serializable/src/shared_checkers.dart';
import 'package:json_serializable/src/utils.dart';
import 'package:json_serializable/src/type_helpers/to_from_string.dart';

import "package:kt_dart/collection.dart";

const ktIterableTypeChecker = TypeChecker.fromRuntime(KtIterable);
const ktListTypeChecker = TypeChecker.fromRuntime(KtList);
const ktSetTypeChecker = TypeChecker.fromRuntime(KtSet);

DartType ktIterableGenericType(DartType type) =>
    typeArgumentsOf(type, ktIterableTypeChecker).single;

class KtIterableTypeHelper extends TypeHelper<TypeHelperContext> {
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
      output =  'KtList<$iterableGenericType>.from($output)';
    } else if (ktSetTypeChecker.isExactlyType(targetType)) {
      output = 'KtSet<$iterableGenericType>.from($output)';
    }



    return wrapNullableIfNecessary(expression, output, context.nullable);
  }
}

final builtListTypeChecker = TypeChecker.fromRuntime(KtList);
