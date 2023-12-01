const packageName = 'import_sorter_test';

class TestSampleData {
  const TestSampleData({required this.source, required this.result});

  final String source;
  final String? result;
}

/// No imports and no code
const sampleData0 = TestSampleData(
  source: '''






''',
  result: null,
);

/// Single code line
const sampleData1 = TestSampleData(
  source: '''
enum HomeEvent { showInfo, showDiscover, showProfile }

''',
  result: null,
);

/// No code, only imports
const sampleData2 = TestSampleData(
  source: '''
  
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
  result: '''
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
  source: '''
  
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
  final pubspecYamlFile = File('\${currentPath}/pubspec.yaml');
  final pubspecYaml = loadYaml(pubspecYamlFile.readAsStringSync());
}

''',
  result: null,
);

const sampleData4 = TestSampleData(
  source: '''
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
  final pubspecYamlFile = File('\${currentPath}/pubspec.yaml');
  final pubspecYaml = loadYaml(pubspecYamlFile.readAsStringSync());
}
''',
  result: '''
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
  final pubspecYamlFile = File('\${currentPath}/pubspec.yaml');
  final pubspecYaml = loadYaml(pubspecYamlFile.readAsStringSync());
}

''',
);


const sampleData5 = TestSampleData(
  source: '''
  
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
  final pubspecYamlFile = File('\${currentPath}/pubspec.yaml');
  final pubspecYaml = loadYaml(pubspecYamlFile.readAsStringSync());
}
''',
  result: '''
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
  final pubspecYamlFile = File('\${currentPath}/pubspec.yaml');
  final pubspecYaml = loadYaml(pubspecYamlFile.readAsStringSync());
}

''',
);