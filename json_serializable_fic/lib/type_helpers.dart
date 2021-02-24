/// this library file exports custom type helpers used for json_serializable code generation for built_value and kt.dart collections.
/// normal users of this library should not need this, this is for advanced users who want to add their own, additional TypeHelpers
/// and write their own builder

export 'src/fic_type_helpers.dart'
    show FICIterableTypeHelper, FICIMapTypeHelper;
