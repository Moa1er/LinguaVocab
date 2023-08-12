import 'package:vocab_language_tester/pages/adding_tag_page.dart';
import 'package:vocab_language_tester/pages/home_page.dart';
import 'package:vocab_language_tester/pages/add_vocab_page.dart';
import 'package:vocab_language_tester/pages/tag_selection_page.dart';
import 'package:vocab_language_tester/pages/vocab_list_page.dart';
import 'package:vocab_language_tester/pages/vocab_testing_page.dart';
import 'package:vocab_language_tester/services/vocab_list_service.dart';
import 'package:vocab_language_tester/utils/utils.dart';
import 'package:vocab_language_tester/constants/constants.dart';

import 'dart:io';
import 'package:flutter/material.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await checkAndCreateFile();
  VocabListService vocabListService = VocabListService();
  await vocabListService.readVocabInFile();
  runApp(const MyApp());
}

Future<void> checkAndCreateFile() async {

  //Test for when file is empty
  // String testString =
  //     "jeruk,orange,indonesian;fruits,simple description\n"
  //     "apel,apple,indonesian;test,\n"
  //     "suka,like,indonesian;verbs,vraiment big descriptionvraiment big descriptionvraiment big descriptionvraiment big descriptionvraiment big descriptionvraiment big descriptionvraiment big descriptionvraiment big descriptionvraiment big descriptionvraiment big descriptionvraiment big descriptionvraiment big descriptionvraiment big descriptionvraiment big descriptionvraiment big descriptionvraiment big descriptionvraiment big descriptionvraiment big descriptionvraiment big descriptionvraiment big descriptionvraiment big descriptionvraiment big descriptionvraiment big descriptionvraiment big descriptionvraiment big descriptionvraiment big descriptionvraiment big descriptionvraiment big descriptionvraiment big description\n";
  // String testStringChatGpt = "eat, makan, indonesian; verb, To consume food.\nbook, buku, indonesian; noun, A written or printed work consisting of pages glued or sewn together along one side.\nrun, lari, indonesian; verb, To move at a speed faster than walking.\ntree, pohon, indonesian; noun, A woody perennial plant with a single main stem or trunk.\ndrink, minum, indonesian; verb, To consume a liquid.\nsing, nyanyi, indonesian; verb, To produce musical sounds with the voice.\ncar, mobil, indonesian; noun, A vehicle with four wheels, typically propelled by an internal combustion engine.\nswim, berenang, indonesian; verb, To move through water by using one's body.\ndog, anjing, indonesian; noun, A domesticated carnivorous mammal that typically has a long snout, an acute sense of smell, and a barking, howling, or whining voice.\nwrite, menulis, indonesian; verb, To mark (letters, words, or other symbols) on a surface.\ncat, kucing, indonesian; noun, A small domesticated carnivorous mammal with soft fur, a short snout, and retractile claws.\njump, melompat, indonesian; verb, To push oneself off a surface and into the air using one's legs.\ncomputer, komputer, indonesian; noun, An electronic device for storing and processing data.\nsleep, tidur, indonesian; verb, To rest in a state of suspended consciousness.\nhouse, rumah, indonesian; noun, A building for human habitation.\ndance, menari, indonesian; verb, To move rhythmically to music.\nflower, bunga, indonesian; noun, The seed-bearing part of a plant, consisting of reproductive organs (stamens and carpels) that are typically surrounded by brightly colored petals and a green calyx.\nwork, kerja, indonesian; verb, To perform tasks to achieve a purpose or goal.\nfriend, teman, indonesian; noun, A person with whom one has a bond of mutual affection.";
  // File file = await writeCounter(testStringChatGpt, nameForLexiqueFile);

  //For when file is not empty
  String folderPath = await getLocalPath();
  File file = File('$folderPath/$nameForLexiqueFile');

  String fileContent = await file.readAsString();

  // Do something with the file content
  print("File content: $fileContent");
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


