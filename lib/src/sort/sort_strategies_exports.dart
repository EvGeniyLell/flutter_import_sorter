import 'package:flutter_import_flow/src/sort/sort_strategy.dart';

// ignore_for_file: avoid_escaping_inner_quotes

abstract class ExportSortStrategy extends SortStrategy {
  static List<ExportSortStrategy> all(String projectName) {
    return [
      ExportSortStrategy.dart(),
      ExportSortStrategy.flutter(),
      ExportSortStrategy.package(projectName),
      ExportSortStrategy.project(projectName),
    ];
  }

  ExportSortStrategy({
    required super.comment,
    required super.regExp,
  });

  factory ExportSortStrategy.dart() = DartExportsSortStrategy;

  factory ExportSortStrategy.flutter() = FlutterExportsSortStrategy;

  factory ExportSortStrategy.package(String excludeProjectName) =
      PackageExportsSortStrategy;

  factory ExportSortStrategy.project(String projectName) =
      ProjectExportsSortStrategy;
}

class DartExportsSortStrategy extends ExportSortStrategy {
  static String defComment = '// Dart exports:';

  DartExportsSortStrategy()
      : super(
          comment: defComment,
          regExp: RegExp(
            '^export \'dart:.*;\$',
            dotAll: true,
          ),
        );
}

class FlutterExportsSortStrategy extends ExportSortStrategy {
  static String defComment = '// Flutter exports:';

  FlutterExportsSortStrategy()
      : super(
          comment: defComment,
          regExp: RegExp(
            '^export \'package:flutter/.*;\$',
            dotAll: true,
          ),
        );
}

class PackageExportsSortStrategy extends ExportSortStrategy {
  static String defComment = '// Package exports:';

  PackageExportsSortStrategy(String excludeProjectName)
      : super(
          comment: defComment,
          regExp: RegExp(
            '^export \'package:(?:(?!$excludeProjectName).).*;\$',
            dotAll: true,
          ),
        );
}

class ProjectExportsSortStrategy extends ExportSortStrategy {
  static String defComment = '// Project exports:';

  ProjectExportsSortStrategy(String projectName)
      : super(
          comment: defComment,
          regExp: RegExp(
            '^export \'package:$projectName/.*;\$',
            dotAll: true,
          ),
        );

  final relative = ProjectRelativeExportsSortStrategy();

  @override
  List<String> getList() {
    return [...super.getList(), '', ...relative.getList()];
  }

  @override
  void clearList() {
    super.clearList();
    relative.clearList();
  }

  @override
  bool tryAdd(String string) {
    if (super.tryAdd(string)) {
      return true;
    }
    return relative.tryAdd(string);
  }
}

class ProjectRelativeExportsSortStrategy extends ExportSortStrategy {
  static String defComment = '// Project relative exports:';

  ProjectRelativeExportsSortStrategy()
      : super(
          comment: defComment,
          regExp: RegExp(
            '^export \'.*;\$',
            dotAll: true,
          ),
        );
}
