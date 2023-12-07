// ignore_for_file: avoid_escaping_inner_quotes

import 'package:flutter_import_flow/src/sort/sort_strategy.dart';

abstract class PartSortStrategy extends SortStrategy {
  PartSortStrategy({
    required super.comment,
    required super.regExp,
  });

  factory PartSortStrategy.parts() = PartsSortStrategy;
}


class PartsSortStrategy extends PartSortStrategy {
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
