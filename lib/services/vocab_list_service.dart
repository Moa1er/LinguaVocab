import '../classes/word.dart';

import 'package:flutter/material.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';

class VocabListService with ChangeNotifier {
  static final VocabListService _vocabListService = VocabListService._internal();

  List<Word> wordList = [];
  List<Word> wordListForTest = [];
  Set<String> tagsForChosenWord = {};
  Set<String> existingTags = {};

  factory VocabListService(){
    return _vocabListService;
  }

  VocabListService._internal() {
    print("initializeing");
    // wordList = [
    //   Word(foreignVersion: 'Bonjour', transVersion: 'Hello', tags: ['greeting', 'formal', 'noun', 'animal', 'test', 'long']),
    //   Word(foreignVersion: 'Chat', transVersion: 'Cat', tags: ['noun', 'animal']),
    //   Word(foreignVersion: 'Livre', transVersion: 'Book', tags: ['noun']),
    //   // Add more items as needed
    // ];
    // Iterate through each Word in the wordList
    updateExistingTags();
  }

  updateExistingTags(){
    existingTags = {};
    for (Word word in wordList) {
      // Add the tags of the current word to the existingTags set
      existingTags.addAll(word.tags);
    }
  }

  readVocabInFile() async{
    try {
      // Get the application documents directory
      Directory appDocumentsDirectory = await getApplicationDocumentsDirectory();

      // Define the file path
      String filePath = "${appDocumentsDirectory.path}/wordList.txt";

      // Read the file lines
      File file = File(filePath);
      List<String> lines = await file.readAsLines();

      // Process each line
      for (String line in lines) {
        List<String> wordAttributes = line.split(',');
        int idxForeiWord = 0;
        int idxTrandWord = 1;
        int idxTags = 2;
        wordList.add(
            Word(
                foreignVersion: wordAttributes[idxForeiWord],
                transVersion: wordAttributes[idxTrandWord],
                tags: wordAttributes[idxTags].split(';').toSet()
            )
        );
        existingTags.addAll(wordAttributes[idxTags].split(';'));
      }
    } catch (e) {
      print("Error reading file: $e");
    }
  }
  writeVocabInFile(Word word) async{
    try {
      // Get the application documents directory
      Directory appDocumentsDirectory = await getApplicationDocumentsDirectory();

      // Define the file path
      String filePath = "${appDocumentsDirectory.path}/wordList.txt";

      // Read the file lines
      File file = File(filePath);
      IOSink sink = file.openWrite(mode: FileMode.append);

      sink.writeln("${word.foreignVersion},${word.transVersion},${word.tags.join(";")}");

      // Close the file
      await sink.close();
    } catch (e) {
      print("Error reading file: $e");
    }
  }

  Future<void> deleteLineFromFileFromString(String foreignWord) async {
    // Get the application documents directory
    Directory appDocumentsDirectory = await getApplicationDocumentsDirectory();
    // Define the file path
    String filePath = "${appDocumentsDirectory.path}/wordList.txt";

    File file = File(filePath);

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
    // Get the application documents directory
    Directory appDocumentsDirectory = await getApplicationDocumentsDirectory();

    // Define the file path
    String filePath = "${appDocumentsDirectory.path}/wordList.txt";

    File file = File(filePath);

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

  void filterWordsByTags(List<String> selectedTags) {
    wordListForTest = wordList.where((word) => word.tags.every((tag) => selectedTags.contains(tag))).toList();
  }
}