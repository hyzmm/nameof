import 'package:nameof_annotation/nameof_annotation.dart';

/// Generator options
class NameofOptions {
  /// Exclude and include rules
  final Coverage coverage;

  /// Scope options (public or all)
  final NameofScope scope;

  /// Field rename option
  final FieldRename fieldRename;

  NameofOptions({
    required this.coverage,
    required this.scope,
    this.fieldRename = FieldRename.none,
  });
}
