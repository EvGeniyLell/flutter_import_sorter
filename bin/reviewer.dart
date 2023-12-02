import 'dart:io';

import 'package:colorize/colorize.dart';
import 'package:flutter_import/common.dart';
import 'package:flutter_import/reviewer/output_help.dart';
import 'package:flutter_import/reviewer/review.dart' as review;

void main(List<String> args) {
  final ignoredFiles = [];

  final c = CommonMain()
    ..argParser(
      args: args,
      parserRule: (parser) {
        parser
          ..addFlag('help', abbr: 'h', negatable: false)
          ..addFlag('ignore-config', negatable: false);
      },
      outputHelp: outputHelp,
    )
    ..readConfig(
      configName: 'flutter_import_sorter',
      configRule: (config, argResults) {
        if (config != null) {
          if (config.containsKey('ignored_files')) {
            ignoredFiles.addAll(config['ignored_files']);
          }
        }
      },
    )
    ..prepareFiles(ignoredFiles: ignoredFiles);

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
      );
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
