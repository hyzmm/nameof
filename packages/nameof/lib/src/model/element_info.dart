class ElementInfo {
  final String name;
  final String originalName;
  final bool isPrivate;
  final bool isAnnotated;
  final bool isIgnore;
  final bool hasCustomName;

  ElementInfo(
      {required this.name,
      required this.originalName,
      required this.isPrivate,
      required this.isAnnotated,
      this.isIgnore = false,
      this.hasCustomName = false});

  String get scopePrefix => isPrivate ? 'Private' : '';
}
