import 'dart:io';

void outputHelp() {
  stdout
    ..write('\nIMPORT REVIEWER\n')
    ..write('\nFlags:')
    ..write(
      '\n  --help, -h         '
      'Display this help command.',
    )
    ..write(
      '\n  --ignore-config    '
      'Ignore configuration in pubspec.yaml (if there is any).',
    )
    ..write('\n');
  exit(0);
}
