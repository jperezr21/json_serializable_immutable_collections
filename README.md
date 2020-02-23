# immutable_json_list_builder

(De-)Serialize more collections using json_serializable.

## Features:

Behaves like json_serializable, but supports more collections.

Currently supported:

- All types supported by json_serializable
- BuiltList
- BuiltSet
- BuiltMap
- KtList
- KtSet
- KtMap

Do you want to use even more types? Feel free to open an issue. PRs also welcome.


## How to use

Add to your dev_dependencies (package is not published on pub.dev yet, I might find a better name):

    immutable_json_list_builder:
      git:
        url: https://github.com/knaeckeKami/immutable_json_list_serializer.git
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



