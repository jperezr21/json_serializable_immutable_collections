import 'package:analyzer/dart/element/type.dart';
import 'package:json_serializable/type_helper.dart';
import 'package:source_gen/source_gen.dart';

class FakeJsonTypeHelper extends TypeHelper<TypeHelperContextWithConfig> {
  final Set<Type> fakeJsonTypes;
  late final Iterable<TypeChecker> _fakeJsonTypeCheckers =
      fakeJsonTypes.map(TypeChecker.fromRuntime);

  FakeJsonTypeHelper(this.fakeJsonTypes);

  @override
  Object? deserialize(DartType targetType, String expression, TypeHelperContextWithConfig context,
      bool defaultProvided) {
    if (_fakeJsonTypeCheckers.any((typeChecker) => typeChecker.isExactlyType(targetType))) {
      return expression;
    }
    return null;
  }

  @override
  Object? serialize(DartType targetType, String expression, TypeHelperContextWithConfig context) {
    if (_fakeJsonTypeCheckers.any((typeChecker) => typeChecker.isExactlyType(targetType))) {
      return expression;
    }
    return null;
  }
}
