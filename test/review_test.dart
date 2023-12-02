import 'package:flutter_import_flow/reviewer/review.dart';
import 'package:test/test.dart';

import 'samples.dart';

void main() {
  //final sortManager = SortManager(packageName: packageName);
  void testSampleData({
    required String lines,
    required String path,
    required int expectErrors,
  }) {
    final count = reviewImports(
      'fif',
      path, //'disk/project/lib/src/feature/ui/screen.dart',
      lines.split('\n'), //data.source.split('\n'),
      appDirName: 'project',
      featuresPath: 'src',
    );
    expect(count, expectErrors);
  }

  group('Samples', () {
    test('feature A', () {
      testSampleData(
        lines: lines0,
        path: 'disk/project/lib/src/featureA/ui/screen.dart',
        expectErrors: 3,
      );
    });
    test('feature B', () {
      testSampleData(
        lines: lines0,
        path: 'disk/project/lib/src/featureB/ui/screen.dart',
        expectErrors: 4,
      );
    });
  });
}

const lines0 = '''
library aaa_bbb;

import 'package:fif/src/banana/toucan.dart';
import 'package:fif/src/featureA/featureA.dart';
import 'package:fif/src/featureA/business_objects/object.dart';
import 'package:fif/src/featureA/subA/subA.dart';
import 'package:fif/src/featureA/subA/subS/subS.dart';
import 'package:fif/src/featureA/subA/suba.dart';
import 'package:fif/src/featureA/subA/subB.dart';
import 'package:fif/src/featureB/featureA.dart';        
import 'package:fif/src/featureB/subAAd/subB.dart';

myCode() {
}
''';
