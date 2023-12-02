import 'dart:io';

import 'package:colorize/colorize.dart';
import 'package:flutter_import/common.dart';
import 'package:flutter_import/sorter/output_help.dart';
import 'package:flutter_import/sorter/manager.dart';

void main(List<String> args) {
  var useComments = false;
  var exitOnChange = false;
  final ignoredFiles = [];

  final c = CommonMain()
    ..argParser(
      args: args,
      parserRule: (parser) {
        parser
          ..addFlag('help', abbr: 'h', negatable: false)
          ..addFlag('ignore-config', negatable: false)
          ..addFlag('exit-if-changed', negatable: false)
          ..addFlag('use-comments', negatable: false);
      },
      outputHelp: outputHelp,
    )
    ..readConfig(
      configName: 'flutter_import_sorter',
      configRule: (config, argResults) {
        if (config != null) {
          if (config.containsKey('comments')) {
            useComments = config['comments'];
          }
          if (config.containsKey('ignored_files')) {
            ignoredFiles.addAll(config['ignored_files']);
          }
        } else {
          useComments = argResults.contains('--use-comments');
          exitOnChange = argResults.contains('--exit-if-changed');
        }
      },
    )
    ..prepareFiles(ignoredFiles: ignoredFiles);

  final sortManager = SortManager(packageName: c.packageName);
  final success = Colorize('✔')..green();
  stdout.write('┏━━ Sorting ${c.dartFiles.length} dart files');

  final sortedFiles = c.filesProcess(
    onFile: (file) {
      final sortResult = sortManager.sort(
        lines: file.readAsLinesSync(),
        useComments: useComments,
      );

      if (sortResult == null) {
        return;
      }

      if (exitOnChange) {
        stdout.writeln(
          '\n┗━━🚨 File ${file.path} does not have its imports sorted.',
        );
        exit(1);
      }

      file.writeAsStringSync(sortResult);
    },
  );

  // Outputting results
  if (sortedFiles.length > 1) {
    stdout.write('\n');
  }
  for (int i = 0; i < sortedFiles.length; i++) {
    final file = c.dartFiles[sortedFiles[i]];
    stdout.write(
      '${sortedFiles.length == 1 ? '\n' : ''}┃  '
      '${i == sortedFiles.length - 1 ? '┗' : '┣'}━━ '
      '$success Sorted imports for '
      '${file?.path.replaceFirst(c.currentPath, '')}/',
    );
    final filename = file!.path.split(Platform.pathSeparator).last;
    stdout.write('$filename\n');
  }

  if (sortedFiles.isEmpty) {
    stdout.write('\n');
  }
  stdout.write(
    '┗━━ $success Sorted '
    '${sortedFiles.length} files in '
    '${c.stopwatch.elapsed.inSeconds}.'
    '${c.stopwatch.elapsedMilliseconds} seconds\n',
  );
}
