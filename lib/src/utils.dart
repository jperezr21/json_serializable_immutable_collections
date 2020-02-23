import 'package:analyzer/dart/element/type.dart';
import 'package:immutable_json_list_builder/src/wrap_nullable.dart';
import 'package:source_gen/source_gen.dart' show TypeChecker;
import 'package:json_serializable/type_helper.dart';

import 'package:json_serializable/src/constants.dart';
import 'package:json_serializable/src/lambda_result.dart';
import 'package:json_serializable/src/shared_checkers.dart';
import 'package:built_collection/built_collection.dart';
import 'package:json_serializable/src/utils.dart';
import 'package:json_serializable/src/type_helpers/to_from_string.dart';

import "package:kt_dart/collection.dart";

final _intString = ToFromStringHelper('int.parse', 'toString()', 'int');

void checkSafeKeyType(String expression, DartType keyArg) {
  // We're not going to handle converting key types at the moment
  // So the only safe types for key are dynamic/Object/String/enum
  final safeKey = isObjectOrDynamic(keyArg) ||
      coreStringTypeChecker.isExactlyType(keyArg) ||
      isKeyStringable(keyArg);

  if (!safeKey) {
    throw UnsupportedTypeError(keyArg, expression,
        'Map keys must be one of: ${allowedTypeNames.join(', ')}.');
  }
}

/// The names of types that can be used as [Map] keys.
///
/// Used in [_checkSafeKeyType] to provide a helpful error with unsupported
/// types.
Iterable<String> get allowedTypeNames => const [
      'Object',
      'dynamic',
      'enum',
      'String',
    ].followedBy(instances.map((i) => i.coreTypeName));
const keyParam = 'k';

/// [ToFromStringHelper] instances representing non-String types that can
/// be used as [Map] keys.
final instances = [
  bigIntString,
  dateTimeString,
  _intString,
  uriString,
];

ToFromStringHelper forType(DartType type) =>
    instances.singleWhere((i) => i.matches(type), orElse: () => null);

bool isObjectOrDynamic(DartType type) => type.isObject || type.isDynamic;

/// Returns `true` if [keyType] can be automatically converted to/from String –
/// and is therefor usable as a key in a [Map].
bool isKeyStringable(DartType keyType) =>
    isEnum(keyType) || instances.any((inst) => inst.matches(keyType));
