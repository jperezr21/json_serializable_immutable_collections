// Copyright (c) 2018, the Dart project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:analyzer/dart/element/type.dart';
import 'package:source_gen/source_gen.dart' show TypeChecker;
import 'package:json_serializable/type_helper.dart';

import 'package:json_serializable/src/constants.dart';
import 'package:json_serializable/src/lambda_result.dart';
import 'package:json_serializable/src/shared_checkers.dart';

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

final builtListTypeChecker = TypeChecker.fromRuntime(BuiltList);
final builtSetTypeChecker = TypeChecker.fromRuntime(BuiltSet);
const coreIterableTypeChecker = TypeChecker.fromUrl('dart:core#Iterable');
const coreMapTypeChecker = TypeChecker.fromUrl('dart:core#Map');
