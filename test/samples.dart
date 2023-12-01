// ignore_for_file: unnecessary_raw_strings

const packageName = 'import_sorter_test';

class TestSampleData {
  const TestSampleData({required this.source, required this.result});

  final String source;
  final String? result;
}

/// No imports and no code
const sampleData0 = TestSampleData(
  source: r'''






''',
  result: null,
);

/// Single code line
const sampleData1 = TestSampleData(
  source: r'''
enum HomeEvent { showInfo, showDiscover, showProfile }

''',
  result: null,
);

/// No code, only imports
const sampleData2 = TestSampleData(
  source: r'''
  
import 'dart:io';


import 'dart:async';
import 'anotherFile.dart' as af;

import 'package:intl/intl.dart';

import 'package:import_sorter_test/anotherFile2.dart';
import 'package:provider/provider.dart';
import 'dart:js';

import 'package:flutter_gen/gen_l10n/translations.dart';
import 'package:mdi/mdi.dart';


part 'alert_dto.freezed.dart';

part 'alert_dto.g.dart';

''',
  result: r'''
import 'dart:async';
import 'dart:io';
import 'dart:js';

import 'package:flutter_gen/gen_l10n/translations.dart';
import 'package:intl/intl.dart';
import 'package:mdi/mdi.dart';
import 'package:provider/provider.dart';

import 'package:import_sorter_test/anotherFile2.dart';
import 'anotherFile.dart' as af;

part 'alert_dto.freezed.dart';
part 'alert_dto.g.dart';
''',
);

/// No imports
const sampleData3 = TestSampleData(
  source: r'''
  
/// Main
void main(List<String> args) async {
  final stopwatch = Stopwatch();
  stopwatch.start();

  final currentPath = Directory.current.path;
  /*
  Getting the package name and dependencies/dev_dependencies
  Package name is one factor used to identify project imports
  Dependencies/dev_dependencies names are used to identify package imports
  */
  final pubspecYamlFile = File('${currentPath}/pubspec.yaml');
  final pubspecYaml = loadYaml(pubspecYamlFile.readAsStringSync());
}
''',
  result: null,
);

const sampleData4 = TestSampleData(
  source: r'''
import 'dart:async';
import 'anotherFile.dart' as af;
import 'dart:io';
import 'package:intl/intl.dart';
import 'package:import_sorter_test/anotherFile2.dart';
import 'package:provider/provider.dart';
import 'dart:js';

import 'package:flutter_gen/gen_l10n/translations.dart';
import 'package:mdi/mdi.dart';


part 'alert_dto.freezed.dart';

part 'alert_dto.g.dart';

/// Main
void main(List<String> args) async {
  final stopwatch = Stopwatch();
  stopwatch.start();

  final currentPath = Directory.current.path;
  /*
  Getting the package name and dependencies/dev_dependencies
  Package name is one factor used to identify project imports
  Dependencies/dev_dependencies names are used to identify package imports
  */
  final pubspecYamlFile = File('${currentPath}/pubspec.yaml');
  final pubspecYaml = loadYaml(pubspecYamlFile.readAsStringSync());
}
''',
  result: r'''
import 'dart:async';
import 'dart:io';
import 'dart:js';

import 'package:flutter_gen/gen_l10n/translations.dart';
import 'package:intl/intl.dart';
import 'package:mdi/mdi.dart';
import 'package:provider/provider.dart';

import 'package:import_sorter_test/anotherFile2.dart';
import 'anotherFile.dart' as af;

part 'alert_dto.freezed.dart';
part 'alert_dto.g.dart';

/// Main
void main(List<String> args) async {
  final stopwatch = Stopwatch();
  stopwatch.start();

  final currentPath = Directory.current.path;
  /*
  Getting the package name and dependencies/dev_dependencies
  Package name is one factor used to identify project imports
  Dependencies/dev_dependencies names are used to identify package imports
  */
  final pubspecYamlFile = File('${currentPath}/pubspec.yaml');
  final pubspecYaml = loadYaml(pubspecYamlFile.readAsStringSync());
}
''',
);

const sampleData5 = TestSampleData(
  source: r'''
  
library import_sorter;

  
import 'dart:async';
import 'anotherFile.dart' as af;
import 'dart:io';
import 'package:intl/intl.dart';
import 'package:import_sorter_test/anotherFile2.dart';
import 'package:provider/provider.dart';
import 'dart:js';

enum HomeEvent { showInfo, showDiscover, showProfile }

import 'package:flutter_gen/gen_l10n/translations.dart';
import 'package:mdi/mdi.dart';


part 'alert_dto.freezed.dart';

part 'alert_dto.g.dart';

/// Main
void main(List<String> args) async {
  final stopwatch = Stopwatch();
  stopwatch.start();

  final currentPath = Directory.current.path;
  /*
  Getting the package name and dependencies/dev_dependencies
  Package name is one factor used to identify project imports
  Dependencies/dev_dependencies names are used to identify package imports
  */
  final pubspecYamlFile = File('${currentPath}/pubspec.yaml');
  final pubspecYaml = loadYaml(pubspecYamlFile.readAsStringSync());
}
''',
  result: r'''
library import_sorter;

import 'dart:async';
import 'dart:io';
import 'dart:js';

import 'package:flutter_gen/gen_l10n/translations.dart';
import 'package:intl/intl.dart';
import 'package:mdi/mdi.dart';
import 'package:provider/provider.dart';

import 'package:import_sorter_test/anotherFile2.dart';
import 'anotherFile.dart' as af;

part 'alert_dto.freezed.dart';
part 'alert_dto.g.dart';

enum HomeEvent { showInfo, showDiscover, showProfile }

/// Main
void main(List<String> args) async {
  final stopwatch = Stopwatch();
  stopwatch.start();

  final currentPath = Directory.current.path;
  /*
  Getting the package name and dependencies/dev_dependencies
  Package name is one factor used to identify project imports
  Dependencies/dev_dependencies names are used to identify package imports
  */
  final pubspecYamlFile = File('${currentPath}/pubspec.yaml');
  final pubspecYaml = loadYaml(pubspecYamlFile.readAsStringSync());
}
''',
);

const sampleData6 = TestSampleData(
  source: r'''
  
import 'dart:ui' as ui;

import 'package:import_sorter_test/src/common/ui/teg_formatted_text/teg_formatted_text.dart';
import 'package:flutter/material.dart';

import 'dart:async';
import 'dart:math';

import 'dart:io' as io;


abstract class TegTextFormatter {
  const TegTextFormatter();

  TegTextFormatterResult call(
      TegFormattedText original,
      BuildContext context,
      BoxConstraints constraints,
      );
}

''',
  result: r'''
import 'dart:async';
import 'dart:io' as io;
import 'dart:math';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';

import 'package:import_sorter_test/src/common/ui/teg_formatted_text/teg_formatted_text.dart';

abstract class TegTextFormatter {
  const TegTextFormatter();

  TegTextFormatterResult call(
      TegFormattedText original,
      BuildContext context,
      BoxConstraints constraints,
      );
}
''',
);
