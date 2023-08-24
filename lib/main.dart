import 'package:vocab_language_tester/pages/adding_tag_page.dart';
import 'package:vocab_language_tester/pages/home_page.dart';
import 'package:vocab_language_tester/pages/add_vocab_page.dart';
import 'package:vocab_language_tester/pages/statistics_page.dart';
import 'package:vocab_language_tester/pages/tag_selection_page.dart';
import 'package:vocab_language_tester/pages/vocab_list_page.dart';
import 'package:vocab_language_tester/pages/vocab_testing_page.dart';
import 'package:vocab_language_tester/services/statistic_service.dart';
import 'package:vocab_language_tester/services/vocab_list_service.dart';
import 'package:vocab_language_tester/utils/utils.dart';
import 'package:vocab_language_tester/utils/file_manager.dart';
import 'package:vocab_language_tester/classes/word.dart';

import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await checkAndCreateFile();
  //reading the files with data + stats
  VocabListService vocabListService = VocabListService();
  await vocabListService.readVocabInFile();
  StatisticService statisticService = StatisticService();
  await statisticService.readStatsInFile();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'LinguaVocab',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        colorScheme: ColorScheme.fromSwatch().copyWith(
          primary: createMaterialColor(const Color(0xFF0c483f)),
          secondary: createMaterialColor(const Color(0xFFf5deb3)),
          tertiary: createMaterialColor(const Color(0xFF000000)),
        ),
      ),
      routes: <String, WidgetBuilder>{
        '/add-vocab-page': (BuildContext context) => AddVocabPage(wordPassed: Word(foreignVersion: "", transVersion: "", tags: {}, description: ""), fromVocabList: false),
        '/vocab-list-page': (BuildContext context) => const VocabListPage(),
        '/vocab-testing-page': (BuildContext context) => const VocabTestingPage(),
        '/adding-tag-page': (BuildContext context) => const AddingTagPage(),
        '/tag-selection-page': (BuildContext context) => const TagSelectionPage(),
        '/statistics-page': (BuildContext context) => const StatisticsPage(),
      },
      home: const HomePage(),
    );
  }
}


