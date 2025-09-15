extension StringExtension on String {
  String capitalize() {
    if (isEmpty) return '';

    return '${this[0].toUpperCase()}${substring(1)}';
  }

  /// Remove underscore and capitalize first letter without underscore
  String privatize() {
    if (isNotEmpty && this[0] == '_') {
      return substring(1).capitalize();
    }

    return this;
  }

  /// Clean string representation of element from service symbols
  /// For example '=' symbol in the property setter
  String cleanFromServiceSymbols() {
    return replaceAll('=', '');
  }

  String toSnakeCase() {
    if (isEmpty) return this;
    var s = replaceAllMapped(
        RegExp(r'([A-Z]+)([A-Z][a-z])'), (m) => '${m[1]}_${m[2]}');
    s = s.replaceAllMapped(
        RegExp(r'([a-z0-9])([A-Z])'), (m) => '${m[1]}_${m[2]}');
    s = s.replaceAll(RegExp(r'[-\s]+'), '_');
    s = s.replaceAll(RegExp(r'__+'), '_');
    return s.toLowerCase();
  }

  String toKebabCase() {
    if (isEmpty) return this;
    var s = toSnakeCase();
    return s.replaceAll('_', '-');
  }

  String toPascalCase() {
    if (isEmpty) return this;
    final parts = toSnakeCase().split('_');
    return parts
        .map((p) => p.isEmpty ? '' : p[0].toUpperCase() + p.substring(1))
        .join();
  }
}

String join(Iterable<String> codeArray) => codeArray.join('\n');
