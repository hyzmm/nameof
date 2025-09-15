/// Library
library nameof_annotation;

/// Annotation for generate names for code entities
/// Tag class or mixin with this annotation
class Nameof {
  /// This setting response for including and excluding elements of class
  final Coverage? coverage;

  /// Rename strategy for generated field names
  final FieldRename? fieldRename;

  const Nameof({this.coverage, this.fieldRename});
}

///  Annotation for ignore inner elements of class (or mixin)
class NameofIgnore {
  const NameofIgnore();
}

///  Annotation for tagging inner elements of class (or mixin)
class NameofKey {
  /// Set this for override name of element
  final String? name;

  const NameofKey({this.name});
}

/// Default instanse of [Nameof] annotation
const nameof = Nameof();

/// Default instanse of [NameofKey] annotation
const nameofKey = NameofKey();

/// Default instanse of [NameofIgnore] annotation
const nameofIgnore = NameofIgnore();

/// Rule for including inner elements
enum NameofScope {
  /// Include only public members (fields, methods, etc..)
  onlyPublic,

  /// Include public and private elements
  all
}

/// Behaviour for generating nameof code
enum Coverage {
  /// Include all elements, even not marked with annotation [NameofKey]
  includeImplicit,

  /// Include elements only tagged with annotation [NameofKey]
  excludeImplicit
}

/// Rename strategies for fields
enum FieldRename {
  /// Do not rename fields
  none,

  /// Convert to snake_case
  snake,

  /// Convert to kebab-case
  kebab,

  /// Convert to PascalCase
  pascal,
}
