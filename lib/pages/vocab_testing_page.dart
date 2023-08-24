import 'package:flutter/material.dart';
import 'package:vocab_language_tester/pages/tag_selection_page.dart';
import 'package:vocab_language_tester/services/statistic_service.dart';

import '../services/vocab_list_service.dart';
import '../classes/word.dart';
import '../utils/utils.dart';



class VocabTestingPage extends StatefulWidget {
  const VocabTestingPage({super.key});

  @override
  State<VocabTestingPage> createState() => _VocabTestingPageState();
}

class _VocabTestingPageState extends State<VocabTestingPage> {
  VocabListService vocabListService = VocabListService();
  StatisticService statisticService = StatisticService();

  List<Word> remainingWords = [];
  Word currentWord = Word(foreignVersion: '', transVersion: '', tags: {}, description: '');
  TextEditingController answerController = TextEditingController();
  Color backgroundColor = Colors.white;
  bool showNextButton = false;
  List<String>? selectedTags;
  int nbGoodAnswers = 0;
  double successRate = 0;
  int timeStart = 0;
  int avgRespTime = 0;
  String timeUsed = "--- ms";

  @override
  void initState() {
    super.initState();
    nbGoodAnswers = 0;
    if(vocabListService.wordListForTest.isNotEmpty){
      if (remainingWords.isEmpty) {
        vocabListService.addReverseWord();
      }
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
          children: [
            Text(
              selectedTags == null
                  ? "Working on every words."
                  : "Working on words with tag: ${selectedTags?.join(", ")}.",
              style: const TextStyle(fontSize: 16),
            ),
            Text(
              "Word ${vocabListService.wordListForTest.length - remainingWords.length} out of ${vocabListService.wordListForTest.length}.",
              style: const TextStyle(fontSize: 16),
            ),
            if(backgroundColor == Colors.white)...[
              Text("$nbGoodAnswers words correct -- ${vocabListService.wordListForTest.length - remainingWords.length - nbGoodAnswers - 1} words wrong. "
                  "Success rate: $successRate%"),
            ]else...[
              Text("$nbGoodAnswers words correct -- ${vocabListService.wordListForTest.length - remainingWords.length - nbGoodAnswers} words wrong. "
                  "Success rate: $successRate%"),
              Text("It took you $timeUsed to respond.")
            ],
            Text("Your average response time is: $avgRespTime ms."),
            const SizedBox(height: 20),
            Center(
              heightFactor: 3,
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
                ],
              ),
            ),
            const SizedBox(height: 16),
            if (backgroundColor == Colors.red) ...[
              Text(
                'Correct translation: ${currentWord.transVersion}',
                style: const TextStyle(
                  color: Colors.black,
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 16),
            ],
            if ((backgroundColor == Colors.red || backgroundColor == Colors.green) && currentWord.description.isNotEmpty) ...[
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

  void calculateSuccessRate(){
    //case division by 0
    if((vocabListService.wordListForTest.length - remainingWords.length) == 0
        || (vocabListService.wordListForTest.length - (remainingWords.length + 1)) == 0){
       successRate = 0.0;
       return;
    }
    if(backgroundColor == Colors.white) {
      successRate = roundDouble((nbGoodAnswers/(vocabListService.wordListForTest.length - (remainingWords.length + 1))) * 100, 2);
    }else{
      successRate = roundDouble((nbGoodAnswers/(vocabListService.wordListForTest.length - (remainingWords.length))) * 100, 2);
    }
  }

  void _checkAnswer() {
    String userAnswer = answerController.text;
    if (userAnswer.replaceAll(' ', '').toLowerCase() == currentWord.transVersion.replaceAll(' ', '').toLowerCase()) {
      nbGoodAnswers++;
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
    calculateSuccessRate();
    int timeUsedInt = DateTime.now().millisecondsSinceEpoch - timeStart;
    timeUsed = "$timeUsedInt ms";
    avgRespTime =
        ((avgRespTime * (vocabListService.wordListForTest.length - remainingWords.length - 1) + timeUsedInt)
          /
        (vocabListService.wordListForTest.length - remainingWords.length)).round();
  }

  void _getNextWord() {
    print("_getNextWord");
    if(remainingWords.isEmpty){
      statisticService.saveStats(selectedTags, successRate, avgRespTime);
    }
    setState(() {
      backgroundColor =  Colors.white;
      showNextButton = false;
      answerController.clear();
      _getRandomWord();
    });
    calculateSuccessRate();
  }

  void _getRandomWord() {
    print("_getRandomWord");
    if (remainingWords.isEmpty) {
      print("remainingWords.isEmpty");
      remainingWords.addAll(vocabListService.wordListForTest);
      remainingWords.shuffle();
      nbGoodAnswers = 0;
      avgRespTime = 0;
    }
    timeStart = DateTime.now().millisecondsSinceEpoch;
    timeUsed = "--- ms";
    setState(() {
      currentWord = remainingWords.removeAt(0);
    });
  }

  void _selectTags() async {
    selectedTags = await Navigator.push<List<String>>(
      context,
      MaterialPageRoute(
        builder: (context) => const TagSelectionPage(),
      ),
    );

    remainingWords = [];
    _getRandomWord();
  }
}