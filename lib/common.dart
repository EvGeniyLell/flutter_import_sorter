import 'dart:io';

import 'package:args/args.dart';
import 'package:yaml/yaml.dart';
import 'package:flutter_import_flow/sorter/files.dart' as files;

class CommonMain {
  CommonMain();

  late final List<String> args;
  late final List<String> argResults;

  void argParser({
    required List<String> args,
    required void Function(ArgParser) parserRule,
    required void Function() outputHelp,
  }) {
    this.args = args;
    final parser = ArgParser();
    parserRule(parser);
    argResults = parser.parse(args).arguments;
    if (argResults.contains('-h') || argResults.contains('--help')) {
      outputHelp();
    }
  }

  late final String currentPath;
  late final String packageName;
  late final Stopwatch stopwatch;

  // bool useComments = false;
  // bool exitOnChange = false;
  final dependencies = [];

  //final ignoredFiles = [];

  void readConfig({
    required String configName,
    required void Function(dynamic, List<String>) configRule,
  }) {
    currentPath = Directory.current.path;
    final pubspecYamlFile = File('$currentPath/pubspec.yaml');
    final pubspecYaml = loadYaml(pubspecYamlFile.readAsStringSync());

    // Getting all dependencies and project package name
    packageName = pubspecYaml['name'].toString();

    stopwatch = Stopwatch()..start();

    final pubspecLockFile = File('$currentPath/pubspec.lock');
    final pubspecLock = loadYaml(pubspecLockFile.readAsStringSync());
    dependencies.addAll(pubspecLock['packages'].keys);

    if (!argResults.contains('--ignore-config') &&
        pubspecYaml.containsKey(configName)) {
      final config = pubspecYaml[configName];
      configRule(config, argResults);
      // if (config.containsKey('ignored_files')) {
      //   ignoredFiles.addAll(config['ignored_files']);
      // }
    } else {
      configRule(null, argResults);
    }
  }

  late final Map<String, File> dartFiles;
  void prepareFiles({
    required List<dynamic> ignoredFiles,
  }) {
    dartFiles = files.dartFiles(currentPath, args);
    final containsFlutter = dependencies.contains('flutter');
    final containsRegistrant = dartFiles
        .containsKey('$currentPath/lib/generated_plugin_registrant.dart');

    stdout
      ..writeln('contains flutter: $containsFlutter')
      ..writeln('contains registrant: $containsRegistrant');

    if (containsFlutter && containsRegistrant) {
      dartFiles.remove('$currentPath/lib/generated_plugin_registrant.dart');
    }

    for (final pattern in ignoredFiles) {
      dartFiles.removeWhere(
        (key, _) => RegExp(pattern).hasMatch(key.replaceFirst(currentPath, '')),
      );
    }
  }

  List<String> filesProcess({
    required void Function(File) onFile,
}) {
    final sortedFiles = <String>[];
    for (final filePath in dartFiles.keys) {
      final file = dartFiles[filePath];
      if (file == null) {
        continue;
      }

      onFile(file);

      sortedFiles.add(filePath);
    }
    stopwatch.stop();
    return sortedFiles;
  }
}
