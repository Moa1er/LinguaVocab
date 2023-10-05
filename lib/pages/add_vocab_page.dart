import 'package:flutter/material.dart';
import 'package:vocab_language_tester/services/vocab_list_service.dart';
import '../classes/word.dart';
import 'package:vocab_language_tester/utils/file_manager.dart';

class AddVocabPage extends StatefulWidget {
  final Word wordPassed;
  final bool fromVocabList;

  // const AddVocabPage({super.key});
  const AddVocabPage(
      {
        Key? key,
        required this.wordPassed,
        required this.fromVocabList,
      }) : super(key: key);

  @override
  State<AddVocabPage> createState() => _AddVocabPageState();
}

class _AddVocabPageState extends State<AddVocabPage> {
  VocabListService vocabListService = VocabListService();
  TextEditingController foreignWordController = TextEditingController();
  TextEditingController translationController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();

  bool isTextOrSpace(String input) {
    //only letters and spaces accepted
    final RegExp regex = RegExp(r'^[A-Za-z\s\uAC00-\uD7A3\u1100-\u11FF\u3130-\u318F]+$');
    return regex.hasMatch(input);
  }

  bool isDescriGoodFormat(String input) {
    //everything accepted exept ";" and ","
    final RegExp regex = RegExp(r'[^;,]+');
    return regex.hasMatch(input);
  }

  void _submitVocabulary() async {
    String foreignWord = foreignWordController.text;
    String translation = translationController.text;
    String description = descriptionController.text;

    if(foreignWord.isEmpty || translation.isEmpty){
      // Show an error snackbar if the input is empty
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Please enter something for the word and it's translation."),
          duration: Duration(seconds: 2),
        ),
      );
      return;
    }
    if (!isTextOrSpace(foreignWord) || !isTextOrSpace(translation)) {
      // Show an error snackbar if the input contains numbers or special characters.
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Please enter text and space only in the input boxes for the word and it's translation."),
          duration: Duration(seconds: 2),
        ),
      );
      return;
    }

    if (!isDescriGoodFormat(description) && description.isNotEmpty) {
      // Show an error snackbar if the input contains numbers or special characters.
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Please do not enter commas and/or semi-colons in the description."),
          duration: Duration(seconds: 2),
        ),
      );
      return;
    }

    //if the word is from the list of vocabulary it means it is an update but in this case,
    //we delete the old one and replace with a new word
    //TODO change the way and just modify the line in itself ?
    if(widget.fromVocabList){
      await vocabListService.deleteWord(widget.wordPassed);
    }

    // Do something with the entered vocabulary, e.g., save it to a database or display it.
    // You can add your custom logic here.
    Word newWord =
      Word(
          foreignVersion: foreignWord.toLowerCase(),
          transVersion: translation.toLowerCase(),
          tags: vocabListService.tagsForChosenWord,
          description: description,
      );

    vocabListService.wordList.add(newWord);
    await writeVocabInFile(newWord);

    vocabListService.tagsForChosenWord = {};
    refresh();

    // Clear the input fields after submission.
    foreignWordController.clear();
    translationController.clear();
    descriptionController.clear();

    if(widget.fromVocabList){
      Navigator.pop(context);
    }else{
      // Show a success Snackbar.
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Vocabulary added !'),
          duration: Duration(seconds: 2),
        ),
      );
    }
  }

  void refresh() {
    if (mounted) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    if(widget.fromVocabList){
      foreignWordController.text = widget.wordPassed.foreignVersion;
      translationController.text = widget.wordPassed.transVersion;
      descriptionController.text = widget.wordPassed.description;
      vocabListService.tagsForChosenWord = widget.wordPassed.tags;
    }
    return Scaffold(
      appBar: AppBar(
        title: const Text('Adding custom vocabulary'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: foreignWordController,
              decoration: const InputDecoration(
                labelText: 'Foreign word',
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: translationController,
              decoration: const InputDecoration(
                labelText: 'Translation',
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: descriptionController,
              decoration: const InputDecoration(
                labelText: 'Description (can be empty)',
              ),
            ),
            const SizedBox(height: 24),
            Wrap(
              spacing: 8, // Horizontal spacing between chips
              runSpacing: 4, // Vertical spacing between lines of chips
              children: List.generate(
                vocabListService.tagsForChosenWord.length,
                    (index) {
                  final tagList = vocabListService.tagsForChosenWord.toList();
                  final tag = tagList[index];
                  return Chip(
                    label: Text(tag),
                    deleteIcon: const Icon(Icons.clear),
                    onDeleted: () {
                      setState(() {
                        vocabListService.tagsForChosenWord.remove(tag);
                      });
                    },
                  );
                },
              ),
            ),
            ElevatedButton(
              onPressed: _toAddingTagPage,
              child: const Text('Add tag'),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
                onPressed: _submitVocabulary,
                child: Text(widget.fromVocabList ? "Modify word" : "Add new word"),
            ),
          ],
        ),
      ),
    );
  }
  Future<void> _toAddingTagPage() async {
    await Navigator.pushNamed(context, "/adding-tag-page");
    //Used to refresh the list of tags that has been changed on the page
    refresh();
  }
}