# typehelpers

This directory holds all packages that just contain custom typehelpers.

Typehelpers are classes that are used for json_serializable to generate code for specific types,
such as lists, maps, or custom types.

These packages do not configure any builders by themselves, they are just used as dependency for
packages that depend on one or multiple typehelper projects and then add custom builders.

These packages can also be used by users who want to add a custom builder for json_serializable.
(e.g. if they want to add support for their own types AND types that are supported by one of these packages)
