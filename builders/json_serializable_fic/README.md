# Discontinued

See https://github.com/marcglasberg/fast_immutable_collections/issues/6
fast_immutable_collections now supports json_serializable out of the box.

# json_serializable_fic

[![Pub Package](https://img.shields.io/pub/v/json_serializable_fic.svg)](https://pub.dartlang.org/packages/json_serializable_fic)


(De-)Serialize more collections using json_serializable.

Unofficial package, meant to extend the functionality of json_serializable.

## Features:

Behaves like json_serializable, but supports more collections.

Currently supported:

- All types supported by json_serializable
- IList
- ISet
- IMap

Do you want to use even more types? Feel free to open an issue. PRs also welcome.


## How to use

Add to your dev_dependencies:

```yaml
    json_serializable_fic: <current_version>
```    
    
Add to your `build.yaml` (create the file if necessary, this is necessary to avoid conflicts between json_serializable and this library):

```yaml
    targets:
      $default:
        builders:
          json_serializable_fic:
            # configure your options here, same as json_serializable
            options:
              explicit_to_json: true
          json_serializable:json_serializable:
            generate_for:
              # exclude everything to avoid conflicts, this library uses a custom builder
              include:
              exclude:
                - test/**
                - lib/**
```



