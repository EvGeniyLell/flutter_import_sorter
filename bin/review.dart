import 'dart:io';

import 'package:colorize/colorize.dart';

import 'package:flutter_import_flow/src/common.dart';
import 'package:flutter_import_flow/src/review.dart' as review;

void main(List<String> args) {
  var featuresPath = 'src';
  final ignoredFiles = <String>[];
  final includedContent = [
    'lib',
  ];

  final c = CommonMain()
    ..argParser(
      args: args,
      parserRule: _parseArgs,
      onHelp: _outputHelp,
    )
    ..readConfig(
      configName: 'flutter_import_reviewer',
      configRule: (config, argResults) {
        if (config != null) {
          config
            ..readIn<String>('features_path', (v) => featuresPath = v)
            ..readIn<Iterable<String>>('ignored_files', ignoredFiles.addAll);
        }
      },
    )
    ..prepareFiles(
      ignoredFiles: ignoredFiles,
      includedContent: includedContent,
    );

  stdout.write(
    '┏━━ Review ${c.dartFiles.length} dart files\n',
  );

  int numberOfErrors = 0;
  c.filesProcess(
    onFile: (file) {
      numberOfErrors += review.reviewImports(
        c.packageName,
        file.path,
        file.readAsLinesSync(),
        appDirName: c.currentPath.split('/').last,
        featuresPath: featuresPath,
      );
      return false;
    },
  );

  final errorsTitle = Colorize('with $numberOfErrors errors');
  if (numberOfErrors > 0) {
    errorsTitle.red();
  }
  stdout.writeln(
    '┗━━ Reviewed $errorsTitle in '
    '${c.stopwatch.elapsed.inSeconds}.'
    '${c.stopwatch.elapsedMilliseconds} seconds',
  );
}

void _parseArgs(ArgParser parser) {
  parser
    ..addFlag('help', abbr: 'h', negatable: false)
    ..addFlag('ignore-config', negatable: false);
}

void _outputHelp() {
  stdout
    ..write('\nIMPORT REVIEWER\n')
    ..write('\nFlags:')
    ..write(
      '\n  --help, -h         '
      'Display this help command.',
    )
    ..write(
      '\n  --ignore-config    '
      'Ignore configuration in pubspec.yaml (if there is any).',
    )
    ..write('\n');
}
