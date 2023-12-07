import 'package:test/test.dart';

import 'package:flutter_import_flow/src/sort/sort_manager.dart';
import 'samples.dart';
import 'samples_fx/samples_journey.dart';

void main() {
  final sortManager = SortManager(packageName: 'fx');
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
    test('journey', () {
      testSampleData(sample_fx_journey);
    });

  });
}
