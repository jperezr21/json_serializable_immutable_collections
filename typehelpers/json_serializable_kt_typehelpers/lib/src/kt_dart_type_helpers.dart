import 'package:analyzer/dart/element/type.dart';
import 'package:json_serializable_type_helper_utils/json_serializable_type_helper_utils.dart';
import 'package:kt_dart/collection.dart';
import 'package:source_gen/source_gen.dart' show TypeChecker;

class KtListTypeHelper extends CustomIterableTypeHelper<KtList> {
  @override
  TypeChecker get typeChecker =>
      const TypeChecker.typeNamed(KtList, inPackage: 'kt_dart');

  @override
  String deserializeFromIterableExpression(
      String expression, DartType resolvedGenericType) {
    return 'KtList<${resolvedGenericType.getDisplayString()}>.from($expression)';
  }

  @override
  String serializeToList(String expression, DartType resolvedGenericType,
      bool isExpressionNullable) {
    final optionalQuestion = isExpressionNullable ? '?' : '';

    return '$expression$optionalQuestion.asList()';
  }
}

class KtSetTypeHelper extends CustomIterableTypeHelper<KtSet> {
  @override
  TypeChecker get typeChecker =>
      const TypeChecker.typeNamed(KtSet, inPackage: 'kt_dart');

  @override
  String deserializeFromIterableExpression(
      String expression, DartType resolvedGenericType) {
    return 'KtSet.from($expression)';
  }

  @override
  String serializeToList(String expression, DartType resolvedGenericType,
      bool isExpressionNullable) {
    final optionalQuestion = isExpressionNullable ? '?' : '';
    return '$expression$optionalQuestion.iter.toList()';
  }
}

class KtMapTypeHelper extends CustomMapTypeHelper<KtMap> {
  @override
  TypeChecker get typeChecker =>
      const TypeChecker.typeNamed(KtMap, inPackage: 'kt_dart');

  @override
  String deserializeFromMapExpression(
      String mapExpression, DartType keyType, DartType valueType) {
    final keyTypeString = keyType.getDisplayString();
    final valueTypeString = valueType.getDisplayString();
    final prefix = 'KtMap<$keyTypeString,$valueTypeString>.from';

    return '$prefix($mapExpression)';
  }

  @override
  String serializeToMapExpression(String mapExpression, DartType keyType,
      DartType valueType, bool isMapExpressionNullable) {
    final optionalQuestion = isMapExpressionNullable ? '?' : '';
    return '$mapExpression$optionalQuestion.asMap()';
  }
}
