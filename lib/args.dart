import 'dart:io';

void outputHelp() {
  stdout.write('\nFlags:');
  stdout.write('\n  --help, -h         Display this help command.');
  stdout.write(
      '\n  --ignore-config    Ignore configuration in pubspec.yaml (if there is any).');
  stdout.write(
      "\n  --exit-if-changed  Return an error if any file isn't sorted. Good for CI.");
  stdout.write(
      "\n  --no-comments      Don't put any comments before the imports.\n");
  exit(0);
}
