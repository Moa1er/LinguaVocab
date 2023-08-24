import 'package:flutter/material.dart';
import '../services/vocab_list_service.dart';
import '../template-widgets/elevated_button.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  final String title = "LinguaVocab";

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  VocabListService vocabListService = VocabListService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ElevatedBtnTemplate(text: "Add vocab", func: _toAddVocabPage),
            const SizedBox(height: 20),
            ElevatedBtnTemplate(text: "Vocabulary List", func: _toVocabListPage),
            const SizedBox(height: 20),
            ElevatedBtnTemplate(text: "Test me !", func: _toVocabTestingPage),
            const SizedBox(height: 20),
            ElevatedBtnTemplate(text: "Statistics", func: _toStatisticsPage),
          ],
        ),
      ),
    );
  }

  void _toAddVocabPage() {
    vocabListService.tagsForChosenWord = {};
    Navigator.pushNamed(context, "/add-vocab-page");
  }

  void _toVocabListPage() {
    Navigator.pushNamed(context, "/vocab-list-page");
  }

  void _toVocabTestingPage() {
    vocabListService.wordListForTest = vocabListService.wordList;
    Navigator.pushNamed(context, "/vocab-testing-page");
  }

  void _toStatisticsPage() {
    Navigator.pushNamed(context, "/statistics-page");
  }
}