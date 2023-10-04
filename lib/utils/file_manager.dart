import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:vocab_language_tester/classes/statistic_data.dart';
import 'package:vocab_language_tester/constants/constants.dart';
import '../classes/word.dart';
import '../globals/globals.dart' as globals;


Future<void> checkAndCreateFile() async {
  String folderPath = await getLocalPath();
  globals.lexiqueFilePath = '$folderPath/$nameForLexiqueFile';
  globals.statisticsFilePath = '$folderPath/$nameForStatisticsFile';
  print("globals.filePath");
  print(globals.lexiqueFilePath);

  //Test for when file is empty
  // String testStringLexique =
  //     "jeruk,orange,indonesian;fruits,simple description\n"
  //     "apel,apple,indonesian;test,\n"
  //     "suka,like,indonesian;verbs,nothing\n";
  // String testStringLexiqueChatGpt = "eat, makan, indonesian; verb, To consume food.\nbook, buku, indonesian; noun, A written or printed work consisting of pages glued or sewn together along one side.\nrun, lari, indonesian; verb, To move at a speed faster than walking.\ntree, pohon, indonesian; noun, A woody perennial plant with a single main stem or trunk.\ndrink, minum, indonesian; verb, To consume a liquid.\nsing, nyanyi, indonesian; verb, To produce musical sounds with the voice.\ncar, mobil, indonesian; noun, A vehicle with four wheels, typically propelled by an internal combustion engine.\nswim, berenang, indonesian; verb, To move through water by using one's body.\ndog, anjing, indonesian; noun, A domesticated carnivorous mammal that typically has a long snout, an acute sense of smell, and a barking, howling, or whining voice.\nwrite, menulis, indonesian; verb, To mark (letters, words, or other symbols) on a surface.\ncat, kucing, indonesian; noun, A small domesticated carnivorous mammal with soft fur, a short snout, and retractile claws.\njump, melompat, indonesian; verb, To push oneself off a surface and into the air using one's legs.\ncomputer, komputer, indonesian; noun, An electronic device for storing and processing data.\nsleep, tidur, indonesian; verb, To rest in a state of suspended consciousness.\nhouse, rumah, indonesian; noun, A building for human habitation.\ndance, menari, indonesian; verb, To move rhythmically to music.\nflower, bunga, indonesian; noun, The seed-bearing part of a plant, consisting of reproductive organs (stamens and carpels) that are typically surrounded by brightly colored petals and a green calyx.\nwork, kerja, indonesian; verb, To perform tasks to achieve a purpose or goal.\nfriend, teman, indonesian; noun, A person with whom one has a bond of mutual affection.";
  // File lexiqueFile = await writeCounter(testStringLexique, nameForLexiqueFile);

  //For when file is not empty
  File lexiqueFile = File('$folderPath/$nameForLexiqueFile');
  File statisticsFile = File('$folderPath/$nameForStatisticsFile');

  bool lexiqueFileExist = await lexiqueFile.exists();
  if(!lexiqueFileExist){
    await lexiqueFile.create();
  }

  bool statisticsFileExist = await statisticsFile.exists();
  if(!statisticsFileExist){
    await statisticsFile.create();
  }

  String fileContent = await lexiqueFile.readAsString();

  // Do something with the file content
  print("File content: $fileContent");
}

Future<String> getExternalDocumentPath() async {
  // To check whether permission is given for this app or not.
  var status = await Permission.manageExternalStorage.request();
  if (!status.isGranted) {
    // If not we will ask for permission first
    await Permission.storage.request();
  }

  Directory directory = Directory("");
  if (Platform.isAndroid) {
    // Redirects it to download folder in android
    directory = Directory(pathForSaveFiles);
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
  File file = File(globals.lexiqueFilePath);

  // Write the data in the file you have created
  return file.writeAsString(bytes);
}

Future<void> writeVocabInFile(Word word) async{
  try {
    File file = File(globals.lexiqueFilePath);

    IOSink sink = file.openWrite(mode: FileMode.append);

    sink.writeln(
        "${word.foreignVersion},"
            "${word.transVersion},"
            "${word.tags.join(";")},"
            "${word.description}");

    // Close the file
    await sink.close();
  } catch (e) {
    print("Error reading wordList file in writeVocabInFile(): $e");
  }
}

Future<void> deleteWordFromFile(Word wordToDel) async {
  File file = File(globals.lexiqueFilePath);

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
  String linesAsString = '${lines.join('\n')}\n';
  await file.writeAsString(linesAsString);
}


Future<void> deleteLineFromFileFromString(String foreignWord) async {
  File file = File(globals.lexiqueFilePath);

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
  File file = File(globals.lexiqueFilePath);

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

Future<void> saveStatisticsToFile(StatisticData statData) async {

  try {
    File file = File(globals.statisticsFilePath);
    IOSink sink = file.openWrite(mode: FileMode.append);
    sink.writeln("${statData.tags},${statData.timestamp},${statData.successRate},${statData.avgRespTime}");

    // Close the file
    await sink.close();
  } catch (e) {
    print("Error reading wordList file in saveStatisticsToFile(): $e");
  }
}