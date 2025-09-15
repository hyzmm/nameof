import 'package:analyzer/dart/element/element.dart';
import 'package:nameof/src/model/element_info.dart';
import 'package:nameof/src/util/element_extensions.dart';
import 'package:nameof/src/util/string_extensions.dart';
import 'package:nameof_annotation/nameof_annotation.dart';

import 'model/property_info.dart';

/// Class for collect info about inner elements of class (or mixin)
class NameofVisitor {
  late String className;

  final constructors = <String, ElementInfo>{};
  final fields = <String, ElementInfo>{};
  final functions = <String, ElementInfo>{};
  final properties = <String, PropertyInfo>{};

  NameofVisitor(this.className);

  void collectFrom(Element element) {
    if (element is ClassElement) {
      _collectFromClass(element);
    } else if (element is MixinElement) {
      _collectFromMixin(element);
    } else {
      throw UnsupportedError('Element must be ClassElement or MixinElement');
    }
  }

  void _collectFromClass(ClassElement element) {
    className = element.name ?? (throw UnsupportedError('Class has no name'));
    for (final c in element.constructors) {
      final key = (c.name == 'new' || c.name == null) ? '' : c.name!;
      constructors[key] = _getElementInfo(c);
    }
    for (final frag in element.fragments) {
      for (final fFrag in frag.fields) {
        final f = fFrag.element;
        if (f.isSynthetic) continue;
        final name = f.name ?? '';
        fields[name] = _getElementInfo(f);
      }
      for (final gFrag in frag.getters) {
        if (gFrag.isSynthetic) continue;
        final g = gFrag.element;
        final name = g.name ?? '';
        final info = _getElementInfo(g);
        properties[name] =
            PropertyInfo.fromElementInfo(info, isGetter: true, isSetter: false);
      }
      for (final sFrag in frag.setters) {
        if (sFrag.isSynthetic) continue;
        final s = sFrag.element;
        final name = s.name ?? '';
        final info = _getElementInfo(s);
        properties[name] =
            PropertyInfo.fromElementInfo(info, isGetter: false, isSetter: true);
      }
      for (final mFrag in frag.methods) {
        final m = mFrag.element;
        final name = m.name ?? '';
        functions[name] = _getElementInfo(m);
      }
    }
  }

  void _collectFromMixin(MixinElement element) {
    className = element.name ?? (throw UnsupportedError('Mixin has no name'));
    for (final frag in element.fragments) {
      for (final fFrag in frag.fields) {
        final f = fFrag.element;
        if (f.isSynthetic) continue;
        final name = f.name ?? '';
        fields[name] = _getElementInfo(f);
      }
      for (final gFrag in frag.getters) {
        if (gFrag.isSynthetic) continue;
        final g = gFrag.element;
        final name = g.name ?? '';
        final info = _getElementInfo(g);
        properties[name] =
            PropertyInfo.fromElementInfo(info, isGetter: true, isSetter: false);
      }
      for (final sFrag in frag.setters) {
        if (sFrag.isSynthetic) continue;
        final s = sFrag.element;
        final name = s.name ?? '';
        final info = _getElementInfo(s);
        properties[name] =
            PropertyInfo.fromElementInfo(info, isGetter: false, isSetter: true);
      }
      for (final mFrag in frag.methods) {
        final m = mFrag.element;
        final name = m.name ?? '';
        functions[name] = _getElementInfo(m);
      }
    }
  }

  ElementInfo _getElementInfo(Element element) {
    if (element.name == null) {
      throw UnsupportedError('Element does not have a name!');
    }

    final isPrivate = element.name!.startsWith('_');
    final isAnnotated = element.hasAnnotation(NameofKey);
    final isIgnore = element.hasAnnotation(NameofIgnore);

  String? name = (isAnnotated
            ? element
                    .getAnnotation(NameofKey)
                    ?.getField('name')
                    ?.toStringValue() ??
        _elementNameForValue(element)
      : _elementNameForValue(element))
        .cleanFromServiceSymbols();

  String originalName = _elementOriginalName(element).cleanFromServiceSymbols();

    return ElementInfo(
        name: name,
        originalName: originalName,
        isPrivate: isPrivate,
        isAnnotated: isAnnotated,
        isIgnore: isIgnore);
  }

  String _elementNameForValue(Element element) {
    if (element is ConstructorElement) {
      return (element.name == 'new' || element.name == null) ? '' : element.name!;
    }
    return element.name ?? '';
  }

  String _elementOriginalName(Element element) {
    if (element is ConstructorElement) {
      return (element.name == 'new' || element.name == null) ? '' : element.name!;
    }
    return element.name ?? '';
  }
}
