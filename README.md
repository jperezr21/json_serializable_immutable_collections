# immutable_json_list_builder

(De-)Serialize more collections using json_serializable.

Very early status.

## Features:

Behaves like json_serializable, but supports more collections.

Currently supported:

- BuiltList
- BuiltSet


## How to use

Add to your dev_dependencies:

    immutable_json_list_builder:
      git:
        url: https://github.com/knaeckeKami/immutable_json_list_serializer.gitAdd to your build.yaml:
        ref: master

Add to your build.yaml:

    targets:
      $default:
        builders:
          immutable_json_list_builder:
            # configure your options here, same as json_serializable
            options:
              explicit_to_json: true
          json_serializable:json_serializable:
            generate_for:
              # exclude everyting, this lib uses a custom builder 
              include:
              exclude:
                - test/**
                - lib/**
