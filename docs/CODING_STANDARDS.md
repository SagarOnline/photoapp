# Coding Standards

## Dart

- Use Dart 3 features.
- Prefer final everywhere.
- Prefer const widgets.
- No dynamic unless unavoidable.

## Widgets

- One widget per responsibility.
- Separate screen widgets from reusable components.

## Naming

Files:

snake_case.dart

Classes:

PascalCase

Variables:

camelCase

## Error Handling

Use Result or Exception mapping inside repositories.

UI should receive friendly failures.

## Logging

Use debugPrint during MVP.

Avoid print().

## Testing

Repository tests.

Widget tests for screens.

Avoid snapshot tests.