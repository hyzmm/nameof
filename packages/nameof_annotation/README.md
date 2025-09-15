Annotations for [nameof].\
This package does nothing without [nameof].

[nameof]: https://pub.dartlang.org/packages/nameof

## Options

- `coverage`: include or exclude implicit members.
- `fieldRename`: transform field names (`none`, `snake`, `kebab`, `pascal`).

### Example

```dart
@Nameof(coverage: Coverage.includeImplicit, fieldRename: FieldRename.snake)
class Example {}
```