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
library immutable_json_list_builder;

import 'package:build/build.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:json_serializable_mobx/src/mobx_type_helpers.dart';

import 'package:source_gen/source_gen.dart';
import 'package:json_serializable/json_serializable.dart';

import 'type_helpers.dart';

/// Supports `package:build_runner` creation and configuration of
/// `json_serializable`.
///
/// Not meant to be invoked by hand-authored code.
Builder jsonSerializable(BuilderOptions options) {
  try {
    final config = JsonSerializable.fromJson(options.config);
    return SharedPartBuilder([
      JsonSerializableGenerator.withDefaultHelpers(
        const [
          MobxIterableTypeHelper(),
          MobxMapTypeHelper(),
          MobxObservableTypeHelper(),
        ],
        config: config,
      ),
      const JsonLiteralGenerator()
    ], 'json_serializable');
  } on CheckedFromJsonException catch (e) {
    final lines = <String>[
      'Could not parse the options provided for `json_serializable_mobx`.'
    ];

    if (e.key != null) {
      lines.add('There is a problem with "${e.key}".');
    }
    if (e.message != null) {
      lines.add(e.message);
    } else if (e.innerError != null) {
      lines.add(e.innerError.toString());
    }

    throw StateError(lines.join('\n'));
  }
}
