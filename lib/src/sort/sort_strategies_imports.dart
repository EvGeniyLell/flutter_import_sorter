import 'package:flutter_import_flow/src/sort/sort_strategy.dart';

// ignore_for_file: avoid_escaping_inner_quotes

abstract class ImportSortStrategy extends SortStrategy {
  static List<ImportSortStrategy> all(String projectName) {
    return [
      ImportSortStrategy.dart(),
      ImportSortStrategy.flutter(),
      ImportSortStrategy.package(projectName),
      ImportSortStrategy.project(projectName),
    ];
  }

  ImportSortStrategy({
    required super.comment,
    required super.regExp,
  });

  factory ImportSortStrategy.dart() = DartImportsSortStrategy;

  factory ImportSortStrategy.flutter() = FlutterImportsSortStrategy;

  factory ImportSortStrategy.package(String excludeProjectName) =
      PackageImportsSortStrategy;

  factory ImportSortStrategy.project(String projectName) =
      ProjectImportsSortStrategy;

// factory SortStrategyImport.exports() = ProjectRelativeExportsSortStrategy;
//
// factory SortStrategyImport.parts() = PartsSortStrategy;
}

class DartImportsSortStrategy extends ImportSortStrategy {
  static String defComment = '// Dart imports:';

  DartImportsSortStrategy()
      : super(
          comment: defComment,
          regExp: RegExp(
            '^import \'dart:.*;\$',
            dotAll: true,
          ),
        );
}

class FlutterImportsSortStrategy extends ImportSortStrategy {
  static String defComment = '// Flutter imports:';

  FlutterImportsSortStrategy()
      : super(
          comment: defComment,
          regExp: RegExp(
            '^import \'package:flutter/.*;\$',
            dotAll: true,
          ),
        );
}

class PackageImportsSortStrategy extends ImportSortStrategy {
  static String defComment = '// Package imports:';

  PackageImportsSortStrategy(String excludeProjectName)
      : super(
          comment: defComment,
          regExp: RegExp(
            '^import \'package:(?:(?!$excludeProjectName).).*;\$',
            dotAll: true,
          ),
        );
}

class ProjectImportsSortStrategy extends ImportSortStrategy {
  static String defComment = '// Project imports:';

  ProjectImportsSortStrategy(String projectName)
      : super(
          comment: defComment,
          regExp: RegExp(
            '^import \'package:$projectName/.*;\$',
            dotAll: true,
          ),
        );

  final relative = ProjectRelativeImportsSortStrategy();

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

class ProjectRelativeImportsSortStrategy extends ImportSortStrategy {
  static String defComment = '// Project relative imports:';

  ProjectRelativeImportsSortStrategy()
      : super(
          comment: defComment,
          regExp: RegExp(
            '^import \'.*;\$',
            dotAll: true,
          ),
        );
}
