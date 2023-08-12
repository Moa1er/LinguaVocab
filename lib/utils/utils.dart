import 'package:flutter/material.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:vocab_language_tester/constants/constants.dart';
import '../classes/word.dart';

//Taken from https://medium.com/@nickysong/creating-a-custom-color-swatch-in-flutter-554bcdcb27f3
MaterialColor createMaterialColor(Color color) {
  List strengths = <double>[.05];
  Map<int, Color> swatch = {};
  final int r = color.red, g = color.green, b = color.blue;

  for (int i = 1; i < 10; i++) {
    strengths.add(0.1 * i);
  }
  for (var strength in strengths) {
    final double ds = 0.5 - strength;
    swatch[(strength * 1000).round()] = Color.fromRGBO(
      r + ((ds < 0 ? r : (255 - r)) * ds).round(),
      g + ((ds < 0 ? g : (255 - g)) * ds).round(),
      b + ((ds < 0 ? b : (255 - b)) * ds).round(),
      1,
    );
  }
  return MaterialColor(color.value, swatch);
}

Future<String> getExternalDocumentPath() async {
  // To check whether permission is given for this app or not.
  var status = await Permission.storage.status;
  if (!status.isGranted) {
    // If not we will ask for permission first
    await Permission.storage.request();
  }

  Directory directory = Directory("");
  if (Platform.isAndroid) {
  // Redirects it to download folder in android
    directory = Directory(pathForLexiqueFile);
  } else {
    directory = await getApplicationDocumentsDirectory();
  }

  final exPath = directory.path;
  await Directory(exPath).create(recursive: true);

  return exPath;
}

Future<String> getLocalPath() async {
  // To get the external path from device of download folder
  final String directory = await getExternalDocumentPath();
  return directory;
}

Future<File> writeCounter(String bytes,String name) async {
  final path = await getLocalPath();
  // Create a file for the path of
  // device and file name with extension
  File file = File('$path/$name');

  // Write the data in the file you have created
  return file.writeAsString(bytes);
}

writeVocabInFile(Word word) async{
  try {
    String folderPath = await getLocalPath();
    // Read the file lines
    File file = File('$folderPath/$nameForLexiqueFile');

    IOSink sink = file.openWrite(mode: FileMode.append);

    sink.writeln(
        "${word.foreignVersion},"
        "${word.transVersion},"
        "${word.tags.join(";")},"
        "${word.description}");

    // Close the file
    await sink.close();
  } catch (e) {
    print("Error reading file: $e");
  }
}

Future<void> deleteWordFromFile(Word wordToDel) async {
  String folderPath = await getLocalPath();
  // Read the file lines
  File file = File('$folderPath/$nameForLexiqueFile');

  if (!await file.exists()) {
    throw Exception('File does not exist');
  }

  List<String> lines = await file.readAsLines();

  int lineNumber = -1;
  int idxForWord = 0;
  int idxTraWord= 1;
  for (int i = 0; i < lines.length; i++) {
    List<String> wordElems = lines[i].split(',');
    if (wordElems[idxForWord] == wordToDel.foreignVersion && wordElems[idxTraWord] == wordToDel.transVersion) {
      lineNumber = i;
      break;
    }
  }

  if (lineNumber < 0 || lineNumber >= lines.length) {
    throw Exception('Invalid line number');
  }

  lines.removeAt(lineNumber);

  await file.writeAsString(lines.join('\n'));
}


Future<void> deleteLineFromFileFromString(String foreignWord) async {
  String folderPath = await getLocalPath();
  // Read the file lines
  File file = File('$folderPath/$nameForLexiqueFile');

  if (!await file.exists()) {
    throw Exception('File does not exist');
  }

  List<String> lines = await file.readAsLines();

  int idxForeignWord = 0;
  int lineNumber = -1;
  for (int i = 0; i < lines.length; i++) {
    if (lines[i].split(',')[idxForeignWord] == foreignWord) {
      lineNumber = i;
      break;
    }
  }

  if (lineNumber < 0 || lineNumber >= lines.length) {
    throw Exception('Invalid line number');
  }

  lines.removeAt(lineNumber);

  await file.writeAsString(lines.join('\n'));
}

Future<void> writeLineToFile(int lineNumber, String content) async {
  String folderPath = await getLocalPath();
  // Read the file lines
  File file = File('$folderPath/$nameForLexiqueFile');

  if (!await file.exists()) {
    throw Exception('File does not exist');
  }

  List<String> lines = await file.readAsLines();

  if (lineNumber < 0 || lineNumber >= lines.length) {
    throw Exception('Invalid line number');
  }

  lines[lineNumber] = content;

  await file.writeAsString(lines.join('\n'));
}