import 'dart:io';

import 'package:args/args.dart';
import 'package:flutter_import_flow/src/files.dart' as files;
import 'package:yaml/yaml.dart';

export 'package:args/args.dart';

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
    stopwatch = Stopwatch()..start();

    currentPath = Directory.current.path;
    final pubspecYamlFile = File('$currentPath/pubspec.yaml');
    final pubspecYaml = loadYaml(pubspecYamlFile.readAsStringSync()) as YamlMap;

    // Getting all dependencies and project package name
    packageName = pubspecYaml['name'].toString();

    final pubspecLockFile = File('$currentPath/pubspec.lock');
    final pubspecLock = loadYaml(pubspecLockFile.readAsStringSync());
    dependencies.addAll(pubspecLock['packages'].keys);

    if (!argResults.contains('--ignore-config') &&
        pubspecYaml.containsKey(configName)) {
      final config = pubspecYaml[configName];
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
    dartFiles = files.dartFiles(currentPath, args, includedContent);
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
  void readList<T extends Object>(String key, void Function(List<T>) setter) {
    final value = this[key];
    if (value == null) {
      return;
    }
    final result = _decodeList<T>(value);
    if (result != null) {
      setter(result);
      return;
    }
    stdout.write(
      ' 🚨Key $key has $result with type ${result.runtimeType}'
      ' but expected ${List<T>} type',
    );
  }

  void readScalar<T extends Object>(String key, void Function(T) setter) {
    final value = this[key];
    if (value == null) {
      return;
    }
    final result = _decodeScalar<T>(this[value]);
    if (result != null) {
      setter(result);
      return;
    }
    stdout.write(
      ' 🚨Key $key has $result with type ${result.runtimeType}'
      ' but expected $T type',
    );
  }

  List<T>? _decodeList<T extends Object>(dynamic value) {
    if (value != null) {
      if (value is YamlList) {
        return value.nodes
            .map<T?>((node) {
              final v = _decodeScalar<T>(node);
              if (v != null) {
                return v;
              }
              return null;
            })
            .nonNulls
            .toList();
      }
    }
    return null;
  }

  T? _decodeScalar<T>(dynamic value) {
    if (value != null) {
      if (value != null && value is YamlScalar) {
        if (value.value is T) {
          return value.value as T;
        }
      }
      if (value != null && value is T) {
        return value;
      }
    }
    return null;
  }
}
