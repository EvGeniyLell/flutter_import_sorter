import 'dart:io';

import 'package:colorize/colorize.dart';

import 'package:flutter_import_flow/src/common.dart';
import 'package:flutter_import_flow/src/sort_manager.dart';

void main(List<String> args) {
  var useComments = false;
  var exitOnChange = false;
  final ignoredFiles = <String>[];
  final includedContent = [
    'lib',
    'bin',
    'test',
    'tests',
    'test_driver',
    'integration_test',
  ];

  final c = CommonMain()
    ..argParser(
      args: args,
      parserRule: _parseArgs,
      onHelp: _outputHelp,
    )
    ..readConfig(
      configName: 'flutter_import_sorter',
      configRule: (config, argResults) {
        if (config != null) {
          config
            ..readIn<bool>('comments', (v) => useComments = v)
            ..readIn<Iterable<String>>('ignored_files', ignoredFiles.addAll);
        } else {
          useComments = argResults.contains('--use-comments');
          exitOnChange = argResults.contains('--exit-if-changed');
        }
      },
    )
    ..prepareFiles(
      ignoredFiles: ignoredFiles,
      includedContent: includedContent,
    );

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
        return false;
      }

      if (exitOnChange) {
        stdout.writeln(
          '\n┗━━🚨 File ${file.path} does not have its imports sorted.',
        );
        exit(1);
      }

      file.writeAsStringSync(sortResult);
      return true;
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

void _parseArgs(ArgParser parser) {
  parser
    ..addFlag('help', abbr: 'h', negatable: false)
    ..addFlag('ignore-config', negatable: false)
    ..addFlag('exit-if-changed', negatable: false)
    ..addFlag('use-comments', negatable: false);
}

void _outputHelp() {
  stdout
    ..write('\nIMPORT SORTER\n')
    ..write('\nFlags:')
    ..write(
      '\n  --help, -h         '
      'Display this help command.',
    )
    ..write(
      '\n  --ignore-config    '
      'Ignore configuration in pubspec.yaml (if there is any).',
    )
    ..write(
      '\n  --exit-if-changed  '
      'Return an error if any file isn`t sorted. Good for CI.',
    )
    ..write(
      '\n  --use-comments      '
      'Don`t put any comments before the imports.\n',
    );
  exit(0);
}
