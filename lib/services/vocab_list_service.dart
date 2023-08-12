import '../classes/word.dart';
import 'package:vocab_language_tester/constants/constants.dart';
import 'package:vocab_language_tester/utils/utils.dart';
import 'package:flutter/material.dart';
import 'dart:io';

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

  void deleteWord(Word wordToDelete) {
    wordList.removeWhere((word) =>
      word.foreignVersion == wordToDelete.foreignVersion &&
      word.transVersion == wordToDelete.transVersion
    );
  }

  readVocabInFile() async{
    try {
      String folderPath = await getLocalPath();
      // Read the file lines
      File file = File('$folderPath/$nameForLexiqueFile');
      List<String> lines = await file.readAsLines();

      // Process each line
      for (String line in lines) {
        List<String> wordAttributes = line.split(',');
        int idxForeiWord = 0;
        int idxTrandWord = 1;
        int idxTags = 2;
        int idxDescription = 3;
        wordList.add(
            Word(
                foreignVersion: wordAttributes[idxForeiWord],
                transVersion: wordAttributes[idxTrandWord],
                tags: wordAttributes[idxTags].split(';').toSet(),
                description: wordAttributes[idxDescription],
            )
        );

        if(wordAttributes[idxTags].isNotEmpty){
          existingTags.addAll(wordAttributes[idxTags].split(';'));
        }
      }
    } catch (e) {
      print("Error reading file: $e");
    }
  }

  void createWordListForTest(List<String> selectedTags){
    print("createWordListForTest");
    filterWordsByTags(selectedTags);
    addReverseWord();
  }

  void filterWordsByTags(List<String> selectedTags) {
    print("filterWordsByTags");
    wordListForTest = wordList.where((word) => word.tags.every((tag) => selectedTags.contains(tag))).toList();

    print("TAGS");
    for(Word word in wordListForTest){
      print(word.foreignVersion);
      print(word.tags);
    }
    print("selectedTags: ");
    print(selectedTags);
    print("wordListForTest: ");
    print(wordListForTest);
    print("wordList: ");
    print(wordList);
  }

  void addReverseWord(){
    print("addReverseWord");
    List<Word> wordListForTestReversed = [];
    for(Word word in wordListForTest){
      wordListForTestReversed.add(Word(
        foreignVersion: word.transVersion,
        transVersion: word.foreignVersion,
        tags: word.tags,
        description: word.description,
      ));
    }
    wordListForTest += wordListForTestReversed;
  }
}