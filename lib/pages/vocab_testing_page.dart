import 'dart:math';
import 'package:flutter/material.dart';
import 'package:vocab_language_tester/pages/tag_selection_page.dart';

import '../services/vocab_list_service.dart';
import '../classes/word.dart';

class VocabTestingPage extends StatefulWidget {
  const VocabTestingPage({super.key});

  @override
  State<VocabTestingPage> createState() => _VocabTestingPageState();
}

class _VocabTestingPageState extends State<VocabTestingPage> {
  VocabListService vocabListService = VocabListService();

  List<Word> remainingWords = [];
  Word currentWord = Word(foreignVersion: '', transVersion: '', tags: {}, description: '');
  TextEditingController answerController = TextEditingController();
  Color backgroundColor = Colors.white;
  bool showNextButton = false;

  void _checkAnswer() {
    String userAnswer = answerController.text;
    if (userAnswer.replaceAll(' ', '').toLowerCase() == currentWord.transVersion.replaceAll(' ', '').toLowerCase()) {
      setState(() {
        backgroundColor = Colors.green;
        showNextButton = true;
      });
    } else {
      setState(() {
        backgroundColor = Colors.red;
        showNextButton = true;
      });
    }
  }

  void _getNextWord() {
    print("_getNextWord");
    setState(() {
      backgroundColor = Colors.white;
      showNextButton = false;
      answerController.clear();
      _getRandomWord();
    });
  }

  void _getRandomWord() {
    print("_getRandomWord");
    if (remainingWords.isEmpty) {
      print("remainingWords.isEmpty");
      remainingWords.addAll(vocabListService.wordListForTest);
      remainingWords.shuffle();

      for(Word word in remainingWords){
        print(word.foreignVersion);
        print(word.tags);
      }
    }



    setState(() {
      currentWord = remainingWords.removeAt(0);
    });
  }

  void _selectTags() async {
    List<String>? selectedTags = await Navigator.push<List<String>>(
      context,
      MaterialPageRoute(
        builder: (context) => const TagSelectionPage(),
      ),
    );
    remainingWords = [];
    _getRandomWord();
  }

  @override
  void initState() {
    super.initState();
    if(vocabListService.wordListForTest.isNotEmpty){
      _getRandomWord();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Word Quiz'),
        actions: [
          IconButton(
            onPressed: _selectTags,
            icon: const Icon(Icons.filter_list),
          ),
        ],
      ),
      body: Container(
        color: backgroundColor,
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              currentWord.foreignVersion,
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: answerController,
              decoration: const InputDecoration(labelText: 'Enter translation'),
              enabled: !showNextButton,
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: showNextButton ? _getNextWord : _checkAnswer,
              child: Text(showNextButton ? 'Next' : 'Submit Answer'),
            ),
            const SizedBox(height: 16),
            if (backgroundColor == Colors.red)...[
              Text(
                'Correct translation: ${currentWord.transVersion}',
                style: const TextStyle(
                  color: Colors.black,
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 16),
            ],
            if((backgroundColor == Colors.red || backgroundColor == Colors.green) && currentWord.description.isNotEmpty)...[
              Text(
                'More info: ${currentWord.description}',
                style: const TextStyle(
                  color: Colors.black,
                  fontSize: 16,
                ),
                textAlign: TextAlign.justify,
              ),
            ],
          ],
        ),
      ),
    );
  }
}