# json_serializable_immutable_collections

(De-)Serialize more collections using json_serializable.

Unofficial package, meant to extend the functionality of json_serializable.

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

Add to your dev_dependencies:

```yaml
    json_serializable_immutable_collections: <current_version>
```    
    
Add to your build.yaml:

```yaml
    targets:
      $default:
        builders:
          json_serializable_immutable_collections:
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
```



