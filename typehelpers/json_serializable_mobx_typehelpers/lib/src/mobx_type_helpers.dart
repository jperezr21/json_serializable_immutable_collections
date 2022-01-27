import 'package:analyzer/dart/element/type.dart';
import 'package:json_serializable_type_helper_utils/json_serializable_type_helper_utils.dart';
import 'package:mobx/mobx.dart';
import 'package:source_gen/source_gen.dart' show TypeChecker;
import 'package:json_serializable/type_helper.dart';
import 'package:source_helper/source_helper.dart';

const mobxMapTypeChecker = TypeChecker.fromRuntime(ObservableMap);

const withNullability = true;

class MobxListTypeHelper extends CustomIterableTypeHelper<ObservableList> {
  @override
  String deserializeFromIterableExpression(
      String expression, DartType resolvedGenericType) {
    return 'ObservableList<${resolvedGenericType.getDisplayString(withNullability: true)}>.of($expression)';
  }

  @override
  String serializeToList(String expression, DartType resolvedGenericType,
      bool isExpressionNullable) {
    ///not needed as ObservableList is Iterable, so it's handled by the default TypeHelper
    throw UnimplementedError();
  }
}

class MobxSetTypeHelper extends CustomIterableTypeHelper<ObservableSet> {
  @override
  String deserializeFromIterableExpression(
      String expression, DartType resolvedGenericType) {
    return 'ObservableSet<${resolvedGenericType.getDisplayString(withNullability: true)}>.of($expression)';
  }

  @override
  String serializeToList(String expression, DartType resolvedGenericType,
      bool isExpressionNullable) {
    ///not needed as ObservableList is Iterable, so it's handled by the default TypeHelper
    throw UnimplementedError();
  }
}

class MobxMapTypeHelper extends CustomMapTypeHelper<ObservableMap> {
  @override
  String deserializeFromMapExpression(
      String mapExpression, DartType keyType, DartType valueType) {
    final prefix =
        'ObservableMap<${keyType.getDisplayString(withNullability: true)},${valueType.getDisplayString(withNullability: true)}>.of';
    return '$prefix($mapExpression)';
  }

  @override
  String serializeToMapExpression(String mapExpression, DartType keyType,
      DartType valueType, bool isMapExpressionNullable) {
    return mapExpression;

    /// [ObservableMap] has MapMixin this should be enough?
  }
}

class MobxObservableTypeHelper extends TypeHelper<TypeHelperContextWithConfig> {
  const MobxObservableTypeHelper();

  @override
  Object? serialize(DartType targetType, String expression,
      TypeHelperContextWithConfig context) {
    if (observableTypeChecker.isExactlyType(targetType)) {
      final typeArg = targetType.typeArgumentsOf(observableTypeChecker)!.single;
      final optionalQuestion = targetType.isNullableType ? '?' : '';

      return context.serialize(typeArg, '($expression)$optionalQuestion.value');
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
    if (observableTypeChecker.isExactlyType(targetType)) {
      final typeArg = targetType.typeArgumentsOf(observableTypeChecker)!.single;
      final nullable = targetType.isNullableType || defaultProvided;
      return wrapNullableIfNecessary(expression,
          'Observable(${context.deserialize(typeArg, expression)})', nullable);
    }

    return null;
  }
}

const observableTypeChecker = TypeChecker.fromRuntime(Observable);
