import 'package:analyzer/dart/element/element.dart';
import 'package:build/build.dart';
import 'package:nameof/src/nameof_code_processor.dart';
import 'package:nameof/src/util/enum_extensions.dart';
import 'package:nameof_annotation/nameof_annotation.dart';
import 'package:source_gen/source_gen.dart';
import 'model/options.dart';
import 'nameof_visitor.dart';

class NameofGenerator extends GeneratorForAnnotation<Nameof> {
  final Map<String, dynamic> config;

  NameofGenerator(this.config);

  @override
  String generateForAnnotatedElement(
      Element element, ConstantReader annotation, BuildStep buildStep) {
    if (element.kind != ElementKind.CLASS &&
        element.kind != ElementKind.MIXIN) {
      throw UnsupportedError("This is not a class (or mixin)!");
    }

    final options = _parseConfig(annotation);

    final className = element.name ?? element.displayName;
    if (className.isEmpty) {
      throw UnsupportedError('Class or mixin element does not have a name!');
    }
    final visitor = NameofVisitor(className);
    visitor.collectFrom(element);

    final code = NameofCodeProcessor(options, visitor).process();

    return code;
  }

  NameofOptions _parseConfig(ConstantReader annotation) {
    final coverageConfigString = config['coverage']?.toString();
    final fieldRenameConfigString = config['field_rename']?.toString();

    bool covTest(Coverage coverage) =>
        coverageConfigString == coverage.toShortString();

    final coverageConfig = Coverage.values.any(covTest)
        ? Coverage.values.firstWhere(covTest)
        : null;

    bool frTest(FieldRename v) => fieldRenameConfigString == v.toShortString();
    final fieldRenameConfig = FieldRename.values.any(frTest)
        ? FieldRename.values.firstWhere(frTest)
        : null;

    final coverageAnnotation = enumValueForDartObject(
      annotation.read('coverage'),
      Coverage.values,
    );

    final fieldRenameAnnotation = enumValueForDartObject(
      annotation.read('fieldRename'),
      FieldRename.values,
    );

    return NameofOptions(
        coverage:
            coverageAnnotation ?? coverageConfig ?? Coverage.includeImplicit,
        scope: NameofScope.onlyPublic,
        fieldRename:
            fieldRenameAnnotation ?? fieldRenameConfig ?? FieldRename.none);
  }

  T? enumValueForDartObject<T>(
    ConstantReader reader,
    List<T> items,
  ) {
    return reader.isNull
        ? null
        : items[reader.objectValue.getField('index')!.toIntValue()!];
  }
}
