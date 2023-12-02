import 'dart:io';

/// Reviewing the imports
/// where:
/// [lines] - all lines of file.
/// Returns [int] as number of errors.
int reviewImports(
  String packageName,
  String filePath,
  List<String> lines, {
  required String appDirName,
  required String featuresPath,
}) {
  void detectFeature(
    void Function(String featureName, String featureExtension) callback,
  ) {
    final matchFilePath =
        RegExp('^.*/$appDirName/lib/$featuresPath/(.*?)/(.*)\$')
            .firstMatch(filePath);
    if (matchFilePath != null) {
      final featureName = matchFilePath.group(1);
      final featureExtension = matchFilePath.group(2);
      if (featureName != null && featureExtension != null) {
        callback(featureName, featureExtension);
      }
    }
  }

  void detectAppImport(
    void Function(String line, int index, String importPath) callback,
  ) {
    final extractAppImport =
        RegExp("^\\s*import 'package:$packageName/$featuresPath/(.*)'\\s*;");
    for (int i = 0; i < lines.length; i += 1) {
      final line = lines[i];

      final match = extractAppImport.firstMatch(line);

      if (match != null) {
        final extractedAppImport = match.group(1);

        if (extractedAppImport != null) {
          callback(line, i, extractedAppImport);
        }
      }
    }
  }

  void detectAppExport(
    void Function(String line, int index, String exportPath) callback,
  ) {
    final extractAppImport = RegExp(r"^\s*export '(.*)'\s*;");
    for (int i = 0; i < lines.length; i += 1) {
      final line = lines[i];
      final exportPath = extractAppImport.firstMatch(line)?.group(1);
      if (exportPath != null) {
        callback(line, i, exportPath);
      }
    }
  }

  /// like: import 'package:app/src/feature.dart';
  bool isShortFeatureImport(String appImport) {
    final appImportMatch = RegExp(r'^([^/]*)\.dart$').firstMatch(appImport);
    if (appImportMatch != null) {
      return true;
    }
    return false;
  }

  /// like: import 'package:app/src/featureA/featureA.dart';
  bool isFeatureImport(String appImport) {
    final appImportMatch = RegExp(r'^(.*?)/(.*)\.dart$').firstMatch(appImport);
    if (appImportMatch != null) {
      final part1 = appImportMatch.group(1);
      final part2 = appImportMatch.group(2);
      return part1 != null && part2 != null && part1 == part2;
    }
    return false;
  }

  /// like: import 'package:app/src/feature/dtos/dtos.dart';
  bool isFeatureDtosImport(String appImport) {
    final appImportMatch =
        RegExp(r'^(.*)/(.*?)/(.*?)\.dart$').firstMatch(appImport);

    if (appImportMatch != null) {
      return (appImportMatch.group(2) == appImportMatch.group(3));
    }
    return false;
  }

  int numberOfErrors = 0;
  String? previousExportPath;

  detectFeature((featureName, featureExtension) {
    void addError(String title, int lineIndex, String tag) {
      if (numberOfErrors < 1) {
        stdout.write(
          '┣━ for file '
          'package:$packageName/$featuresPath/'
          '$featureName/$featureExtension\n',
        );
      }
      stdout.write(
        '┃ ┗━ $title '
        '$tag (package:$packageName/$featuresPath/'
        '$featureName/$featureExtension:${lineIndex + 1})\n',
      );
      numberOfErrors += 1;
    }

    detectAppImport((line, lineIndex, appImport) {
      if (appImport.startsWith(featureName)) {
        return;
      } else {
        if (isShortFeatureImport(appImport) ||
            isFeatureImport(appImport) ||
            isFeatureDtosImport(appImport)) {
          return;
        } else {
          addError('wrong import', lineIndex, appImport);
        }
      }
    });
    detectAppExport((line, lineIndex, exportPath) {
      if (previousExportPath != null && previousExportPath == exportPath) {
        addError('duplicate export', lineIndex, exportPath);
      }
      previousExportPath = exportPath;
    });
  });

  return numberOfErrors;
}
