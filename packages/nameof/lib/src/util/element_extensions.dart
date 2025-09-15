import 'package:analyzer/dart/constant/value.dart';
import 'package:analyzer/dart/element/element.dart';

extension AnnotationChecker on Element {
  bool hasAnnotation(final Type type) {
    return metadata.annotations.any((m) => _matchesAnnotation(m, type));
  }

  DartObject? getAnnotation(final Type type) {
    for (final m in metadata.annotations) {
      if (_matchesAnnotation(m, type)) {
        return m.computeConstantValue();
      }
    }
    return null;
  }
}

bool _matchesAnnotation(ElementAnnotation annotation, Type type) {
  final DartObject? value = annotation.computeConstantValue();
  final element = value?.type?.element;
  if (element == null) return false;
  // Compare by class name. This is sufficient for our annotations which are unique.
  return element.name == type.toString();
}
