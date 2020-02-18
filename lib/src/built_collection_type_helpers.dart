// Copyright (c) 2018, the Dart project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:analyzer/dart/element/type.dart';
import 'package:source_gen/source_gen.dart' show TypeChecker;
import 'package:json_serializable/type_helper.dart';

import 'package:json_serializable/src/constants.dart';
import 'package:json_serializable/src/lambda_result.dart';
import 'package:json_serializable/src/shared_checkers.dart';
import 'package:json_serializable/src/utils.dart';
import 'package:json_serializable/src/type_helpers/to_from_string.dart';

import 'package:built_collection/built_collection.dart';

class BuiltIterableTypeHelper extends TypeHelper<TypeHelperContext> {
  const BuiltIterableTypeHelper();

  @override
  String serialize(
      DartType targetType, String expression, TypeHelperContext context) {
    //default iterable helper will serialize all iterables fine
    return null;
  }

  @override
  String deserialize(
      DartType targetType, String expression, TypeHelperContext context) {
    if (!(coreIterableTypeChecker.isExactlyType(targetType) ||
        builtListTypeChecker.isExactlyType(targetType) ||
        builtSetTypeChecker.isExactlyType(targetType))) {
      return null;
    }
    final iterableGenericType = coreIterableGenericType(targetType);

    final itemSubVal = context.deserialize(iterableGenericType, closureArg);

    var output = '$expression as List';

    // If `itemSubVal` is the same and it's not a Set, then we don't need to do
    // anything fancy
    if (closureArg == itemSubVal &&
        builtListTypeChecker.isExactlyType(targetType)) {
      return '($output).toBuiltList()';
    }

    output = '($output)';

    final optionalQuestion = context.nullable ? '?' : '';

    if (closureArg != itemSubVal) {
      final lambda = LambdaResult.process(itemSubVal, closureArg);
      output += '$optionalQuestion.map($lambda)';
    }

    if (builtListTypeChecker.isExactlyType(targetType)) {
      output += '$optionalQuestion.toBuiltList()';
    } else if (builtSetTypeChecker.isExactlyType(targetType)) {
      output += '$optionalQuestion.toBuiltSet()';
    }

    return output;
  }
}

class BuiltMapTypeHelper extends TypeHelper<TypeHelperContext> {
  const BuiltMapTypeHelper();

  @override
  String serialize(
      DartType targetType, String expression, TypeHelperContext context) {
    if (!builtMapTypeChecker.isAssignableFromType(targetType)) {
      return null;
    }
    final args = typeArgumentsOf(targetType, builtMapTypeChecker);
    assert(args.length == 2);

    final keyType = args[0];
    final valueType = args[1];

    _checkSafeKeyType(expression, keyType);

    final subFieldValue = context.serialize(valueType, closureArg);
    final subKeyValue =
        _forType(keyType)?.serialize(keyType, _keyParam, false) ??
            context.serialize(keyType, _keyParam);

    if (closureArg == subFieldValue && _keyParam == subKeyValue) {
      return expression+ ".toMap()";
    }

    final optionalQuestion = context.nullable ? '?' : '';

    return '$expression$optionalQuestion'
        '.toMap().map(($_keyParam, $closureArg) => MapEntry($subKeyValue, $subFieldValue))';
  }

  @override
  String deserialize(DartType targetType, String expression, dynamic context) {
    if (!builtMapTypeChecker.isExactlyType(targetType)) {
      return null;
    }
    final typeArgs = typeArgumentsOf(targetType, builtMapTypeChecker);
    assert(typeArgs.length == 2);
    final keyArg = typeArgs.first;
    final valueArg = typeArgs.last;

    final prefix =
        "BuiltMap<${keyArg.getDisplayString()},${valueArg.getDisplayString()}>.of";

    _checkSafeKeyType(expression, keyArg);

    final valueArgIsAny = _isObjectOrDynamic(valueArg);
    final isKeyStringable = _isKeyStringable(keyArg);

    if (!isKeyStringable) {
      if (valueArgIsAny) {
        if (context.config.anyMap) {
          if (_isObjectOrDynamic(keyArg)) {
            return '$prefix($expression as Map)';
          }
        } else {
          // this is the trivial case. Do a runtime cast to the known type of JSON
          // map values - `Map<String, dynamic>`
          return 'BuiltList<String,dynamic>.of($expression as Map<String, dynamic>)';
        }
      }

      if (!context.nullable &&
          (valueArgIsAny ||
              simpleJsonTypeChecker.isAssignableFromType(valueArg))) {
        // No mapping of the values or null check required!
        return 'BuiltList<String,$valueArg>.of(Map<String, $valueArg>.from($expression as Map))';
      }
    }

    // In this case, we're going to create a new Map with matching reified
    // types.

    final itemSubVal = context.deserialize(valueArg, closureArg);

    final optionalQuestion = context.nullable ? '?' : '';

    final mapCast =
        context.config.anyMap ? 'as Map' : 'as Map<String, dynamic>';

    String keyUsage;
    if (isEnum(keyArg)) {
      keyUsage = context.deserialize(keyArg, _keyParam).toString();
    } else if (context.config.anyMap && !_isObjectOrDynamic(keyArg)) {
      keyUsage = '$_keyParam as String';
    } else {
      keyUsage = _keyParam;
    }

    final toFromString = _forType(keyArg);
    if (toFromString != null) {
      keyUsage = toFromString.deserialize(keyArg, keyUsage, false, true);
    }

    return '$prefix(($expression $mapCast)$optionalQuestion.map('
        '($_keyParam, $closureArg) => MapEntry($keyUsage, $itemSubVal),))';
  }
}

final _intString = ToFromStringHelper('int.parse', 'toString()', 'int');

/// [ToFromStringHelper] instances representing non-String types that can
/// be used as [Map] keys.
final _instances = [
  bigIntString,
  dateTimeString,
  _intString,
  uriString,
];

ToFromStringHelper _forType(DartType type) =>
    _instances.singleWhere((i) => i.matches(type), orElse: () => null);

bool _isObjectOrDynamic(DartType type) => type.isObject || type.isDynamic;

/// Returns `true` if [keyType] can be automatically converted to/from String –
/// and is therefor usable as a key in a [Map].
bool _isKeyStringable(DartType keyType) =>
    isEnum(keyType) || _instances.any((inst) => inst.matches(keyType));

void _checkSafeKeyType(String expression, DartType keyArg) {
  // We're not going to handle converting key types at the moment
  // So the only safe types for key are dynamic/Object/String/enum
  final safeKey = _isObjectOrDynamic(keyArg) ||
      coreStringTypeChecker.isExactlyType(keyArg) ||
      _isKeyStringable(keyArg);

  if (!safeKey) {
    throw UnsupportedTypeError(keyArg, expression,
        'Map keys must be one of: ${_allowedTypeNames.join(', ')}.');
  }
}

/// The names of types that can be used as [Map] keys.
///
/// Used in [_checkSafeKeyType] to provide a helpful error with unsupported
/// types.
Iterable<String> get _allowedTypeNames => const [
      'Object',
      'dynamic',
      'enum',
      'String',
    ].followedBy(_instances.map((i) => i.coreTypeName));
const _keyParam = 'k';

final builtListTypeChecker = TypeChecker.fromRuntime(BuiltList);
final builtSetTypeChecker = TypeChecker.fromRuntime(BuiltSet);
final builtMapTypeChecker = TypeChecker.fromRuntime(BuiltMap);
