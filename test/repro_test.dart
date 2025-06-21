import 'package:analyzer/dart/element/element.dart';
import 'package:build/src/builder/build_step.dart';
import 'package:build_test/build_test.dart';
import 'package:repro/repro.dart';
import 'package:source_gen/source_gen.dart';
import 'package:test/test.dart';

void main() {
  test('repro', () async {
    const testPkg = 'pkg';
    const testLib = 'lib';

    final readerWriter = TestReaderWriter(rootPackage: testPkg);
    await readerWriter.testing.loadIsolateSources();

    await testBuilder(
      TestBuilder(),
      {
        '$testPkg|$testLib.dart': '''
import 'package:repro/repro.dart';

@A()
const b = 0;
'''
      },
      outputs: {
        '$testPkg|$testLib.g.dart': '''
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: directives_ordering, lines_longer_than_80_chars
// **************************************************************************
// TestGenerator
// **************************************************************************
const foo = "bar";
''',
      },
      readerWriter: readerWriter,
    );
  });
}

class TestGenerator extends GeneratorForAnnotation<A> {
  @override
  String generateForAnnotatedElement(
    Element element,
    ConstantReader annotation,
    BuildStep buildStep,
  ) =>
      'const foo = "bar"';
}

class TestBuilder extends LibraryBuilder {
  TestBuilder() : super(TestGenerator(), generatedExtension: '.g.dart');
}
