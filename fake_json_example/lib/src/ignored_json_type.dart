


import 'dart:async';

/// this type is referenced by the builder, do not put in in
/// a file that also contains models that need codegen, this will not work
class IgnoredType {

  final String string;

  //just a random type that would not be serialized under normal circumstances
  final Timer timer;

  IgnoredType(this.string, this.timer);

}