// Copyright (c) 2017, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

/// Configuration for using `package:build`-compatible build systems.
///
/// See:
/// * [build_runner](https://pub.dev/packages/build_runner)
///
/// This library is **not** intended to be imported by typical end-users unless
/// you are creating a custom compilation pipeline. See documentation for
/// details, and `build.yaml` for how these builders are configured by default.

import 'package:build/build.dart';
import 'package:json_annotation/json_annotation.dart';

import 'package:source_gen/source_gen.dart';
import 'package:json_serializable/json_serializable.dart';

/// import all the type helpers that you want
import 'package:json_serializable_fic_typehelpers/json_serializable_fic_typehelpers.dart';
import 'package:json_serializable_mobx_typehelpers/json_serializable_mobx_typehelpers.dart';
import 'package:json_serializable_built_typehelpers/json_serializable_built_typehelpers.dart';
import 'package:json_serializable_kt_typehelpers/json_serializable_kt_typehelpers.dart';

/// Supports `package:build_runner` creation and configuration of
/// `json_serializable`.
///
/// Not meant to be invoked by hand-authored code.
Builder jsonSerializable(BuilderOptions options) {
  try {
    final config = JsonSerializable.fromJson(options.config);
    return SharedPartBuilder([
      JsonSerializableGenerator.withDefaultHelpers(
         [
          /// add the type helpers here
          FICIterableTypeHelper(),
          FICIMapTypeHelper(),
          MobxIterableTypeHelper(),
          MobxMapTypeHelper(),
          MobxObservableTypeHelper(),
          BuiltIterableTypeHelper(),
          BuiltMapTypeHelper(),
          KtListTypeHelper(),
          KtSetTypeHelper(),
          KtMapTypeHelper()
        ],
        config: config,
      ),
      const JsonLiteralGenerator()
    ], 'json_serializable');
  } on CheckedFromJsonException catch (e) {
    final lines = <String>[
      'Could not parse the options provided for `json_serializable`.'
    ];

    if (e.key != null) {
      lines.add('There is a problem with "${e.key}".');
    }
    final msg = e.message;
    if (msg != null) {
      lines.add(msg);
    } else if (e.innerError != null) {
      lines.add(e.innerError.toString());
    }

    throw StateError(lines.join('\n'));
  }
}
