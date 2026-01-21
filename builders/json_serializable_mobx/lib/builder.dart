import 'package:build/build.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:json_serializable/json_serializable.dart';
import 'package:json_serializable_mobx_typehelpers/json_serializable_mobx_typehelpers.dart';
import 'package:source_gen/source_gen.dart';

import 'type_helpers.dart';

/// Supports `package:build_runner` creation and configuration of
/// `json_serializable`.
///
/// Not meant to be invoked by hand-authored code.
Builder jsonSerializable(BuilderOptions options) {
  try {
    final config = JsonSerializable.fromJson(options.config);
    return SharedPartBuilder([
      JsonSerializableGenerator.withDefaultHelpers([
        MobxListTypeHelper(),
        MobxSetTypeHelper(),
        MobxMapTypeHelper(),
        MobxObservableTypeHelper(),
      ], config: config),
      const JsonLiteralGenerator(),
    ], 'json_serializable');
  } on CheckedFromJsonException catch (e) {
    final List<String> lines = [
      'Could not parse the options provided for `json_serializable_mobx`.',
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
