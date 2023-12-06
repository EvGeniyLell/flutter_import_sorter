// ignore_for_file: avoid_escaping_inner_quotes

abstract class SortStrategy {
  SortStrategy({
    required this.comment,
    required this.regExp,
  });

  factory SortStrategy.dartImports() = DartImportsSortStrategy;

  factory SortStrategy.flutterImports() = FlutterImportsSortStrategy;

  factory SortStrategy.packageImports(String excludeProjectName) =
      PackageImportsSortStrategy;

  factory SortStrategy.projectImports(String projectName) =
      ProjectImportsSortStrategy;

  factory SortStrategy.parts() = PartsSortStrategy;

  final String comment;
  final RegExp regExp;
  final List<String> _list = [];

  List<String> getList() => _list..sort();

  void clearList() => _list.clear();

  bool tryAdd(String string) {
    if (regExp.hasMatch(string.trim())) {
      _list.add(string);
      return true;
    }
    return false;
  }
}

class DartImportsSortStrategy extends SortStrategy {
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

class FlutterImportsSortStrategy extends SortStrategy {
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

class PackageImportsSortStrategy extends SortStrategy {
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

class ProjectImportsSortStrategy extends SortStrategy {
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
    return [...super.getList(), ...relative.getList()];
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

class ProjectRelativeImportsSortStrategy extends SortStrategy {
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

class PartsSortStrategy extends SortStrategy {
  static String defComment = '// Parts:';

  PartsSortStrategy()
      : super(
          comment: defComment,
          regExp: RegExp(
            '^part \'.*;\$',
            dotAll: true,
          ),
        );
}
