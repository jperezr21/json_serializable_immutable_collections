
This is an example project on how to combine the TypeHelpers of multiple json_serializable_* packages
and support, for example, types from fast_immutable_collections and mobx.

# How to add this your project (see the corresponding files in the example project for details)

- Add all the packages that you want to support to your dependencies

- Create a builder.dart file and use the `JsonSerializableGenerator.withDefaultHelpers` method to add
 all the `TypeHelpers` that you want

- in your build.yaml, deactivate all other builders (otherwise there will be
conflicts because multiple builders want to generate the same file)

- in your build.yaml, add the builder from your build.dart

- run build_runner and verify that it works
