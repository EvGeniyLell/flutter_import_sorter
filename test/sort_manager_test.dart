import 'package:flutter_import_sorter/sort_manager.dart';
import 'package:test/test.dart';

import 'samples.dart';

void main() {
  final sortManager = SortManager(packageName: packageName);
  void testSampleData(TestSampleData data) {
    expect(
      sortManager.sort(
        lines: data.source.split('\n'),
        useComments: false,
      ),
      data.result,
    );
  }

  group('Samples', () {
    test('No imports and no code', () {
      testSampleData(sampleData0);
    });
    test('Single code line', () {
      testSampleData(sampleData1);
    });
    test('No code, only imports', () {
      testSampleData(sampleData2);
    });
    test('No imports', () {
      testSampleData(sampleData3);
    });
    test('Imports and code', () {
      testSampleData(sampleData4);
    });
    test('Code before all imports', () {
      testSampleData(sampleData5);
    });
    test('Dart imports', () {
      testSampleData(sampleData6);
    });
    test('Dart imports', () {
      testSampleData(sampleData7);
    });

  });
}
