import 'dart:io';

void outputHelp() {
  stdout
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
