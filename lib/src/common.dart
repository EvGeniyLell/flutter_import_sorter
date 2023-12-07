import 'dart:io';

import 'package:args/args.dart';
import 'package:flutter_import_flow/src/files.dart' as files;
import 'package:yaml/yaml.dart';

export 'package:args/args.dart';

typedef YamlMap = Map<String, Object>;

class CommonMain {
  CommonMain();

  late final List<String> args;
  late final List<String> argResults;

  void argParser({
    required List<String> args,
    required void Function(ArgParser) parserRule,
    required void Function() onHelp,
  }) {
    this.args = args;
    final parser = ArgParser();
    parserRule(parser);
    argResults = parser.parse(args).arguments;
    if (argResults.contains('-h') || argResults.contains('--help')) {
      onHelp();
      exit(0);
    }
  }

  late final String currentPath;
  late final String packageName;
  late final Stopwatch stopwatch;

  final dependencies = [];

  void readConfig({
    required String configName,
    required void Function(YamlMap?, List<String>) configRule,
  }) {
    currentPath = Directory.current.path;
    final pubspecYamlFile = File('$currentPath/pubspec.yaml');
    final pubspecYaml = loadYaml(pubspecYamlFile.readAsStringSync());

    // Getting all dependencies and project package name
    packageName = pubspecYaml['name'].toString();
    print('### pubspecYaml:\n$pubspecYaml');

    stopwatch = Stopwatch()..start();

    final pubspecLockFile = File('$currentPath/pubspec.lock');
    final pubspecLock = loadYaml(pubspecLockFile.readAsStringSync());
    dependencies.addAll(pubspecLock['packages'].keys);

    if (!argResults.contains('--ignore-config') &&
        pubspecYaml.containsKey(configName)) {
      final config = pubspecYaml[configName];
      print('### config:\n$config');
      if (config is YamlMap) {
        configRule(config, argResults);
        return;
      }
    }
    configRule(null, argResults);
  }

  late final Map<String, File> dartFiles;

  void prepareFiles({
    required List<String> ignoredFiles,
    required List<String> includedContent,
  }) {
    print('### ignoredFiles:\n$ignoredFiles');
    print('### includedContent:\n$includedContent');
    dartFiles = files.dartFiles(currentPath, args, includedContent);
    print('### dartFiles:\n$dartFiles');
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
      dartFiles.removeWhere((key, _) {
        print('### pattern:\n$pattern in ${key.replaceFirst(currentPath, '')}');
        return RegExp(pattern).hasMatch(key.replaceFirst(currentPath, ''));
      });
    }
  }

  List<String> filesProcess({
    required bool Function(File) onFile,
  }) {
    final changedFiles = <String>[];
    for (final filePath in dartFiles.keys) {
      final file = dartFiles[filePath];
      if (file == null) {
        continue;
      }
      if (onFile(file)) {
        changedFiles.add(filePath);
      }
    }
    stopwatch.stop();
    return changedFiles;
  }
}

extension YamlMapExtension on YamlMap {
  void readIn<T extends Object>(String parameter, void Function(T) setter) {
    final value = this[parameter];
    if (value != null && value is T) {
      setter(value);
    }
  }
}
