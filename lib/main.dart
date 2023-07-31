import 'package:vocab_language_tester/pages/adding_tag_page.dart';
import 'package:vocab_language_tester/pages/home_page.dart';
import 'package:vocab_language_tester/pages/add_vocab_page.dart';
import 'package:vocab_language_tester/pages/tag_selection_page.dart';
import 'package:vocab_language_tester/pages/vocab_list_page.dart';
import 'package:vocab_language_tester/pages/vocab_testing_page.dart';
import 'package:vocab_language_tester/services/vocab_list_service.dart';
import 'package:vocab_language_tester/utils/utils.dart';

import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await checkAndCreateFile();
  VocabListService vocabListService = VocabListService();
  await vocabListService.readVocabInFile();
  runApp(const MyApp());
}

Future<void> checkAndCreateFile() async {
  // Get the application documents directory
  Directory appDocumentsDirectory = await getApplicationDocumentsDirectory();
  // Define the file path
  String filePath = "${appDocumentsDirectory.path}/wordList.txt";

  // Check if the file exists
  bool fileExists = await File(filePath).exists();

  if (!fileExists) {
    // If the file does not exist, create it
    File file = File(filePath);
    await file.create();

    print("File created at: $filePath");
  } else {
    File file = File(filePath);
    // file.writeAsString(
    //     "jeruk,orange,indonesian;fruits\n"
    //     "apel,apple,indonesian;test\n"
    //     "suka,like,indonesian;verbs\n");
    // file.writeAsString(
    //     "jeruk,orange,fruits\n"
    //     "apel,apple,indonesian\n"
    //     "suka,like,verbs\n");
    // used to start clean
    // await file.delete();
    // File file2 = File(filePath);
    String fileContent = await file.readAsString();

    // Do something with the file content
    print("File content: $fileContent");
    print("File already exists at: $filePath");
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'LinguaVocab',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
        colorScheme: ColorScheme.fromSwatch().copyWith(
          primary: createMaterialColor(const Color(0xFF0c483f)),
          secondary: createMaterialColor(const Color(0xFFf5deb3)),
          tertiary: createMaterialColor(const Color(0xFF000000)),
        ),
      ),
      routes: <String, WidgetBuilder>{
        '/add-vocab-page': (BuildContext context) => const AddVocabPage(),
        '/vocab-list-page': (BuildContext context) => const VocabListPage(),
        '/vocab-testing-page': (BuildContext context) => const VocabTestingPage(),
        '/adding-tag-page': (BuildContext context) => const AddingTagPage(),
        '/tag-selection-page': (BuildContext context) => const TagSelectionPage(),
      },
      home: const HomePage(),
    );
  }
}


