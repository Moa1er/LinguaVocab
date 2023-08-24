import 'package:flutter/material.dart';

import '../services/vocab_list_service.dart';


class AddingTagPage extends StatefulWidget {
  const AddingTagPage({super.key});

  @override
  State<AddingTagPage> createState() => _AddingTagPageState();
}

class _AddingTagPageState extends State<AddingTagPage> {
  VocabListService vocabListService = VocabListService();
  List<String> filteredTags = [];
  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    filteredTags = List.from(vocabListService.existingTags);
  }

  void _onSearchTextChanged(String searchText) {
    setState(() {
      filteredTags = vocabListService.existingTags
          .where((tag) => tag.toLowerCase().contains(searchText.toLowerCase()))
          .toList();
    });
  }

  bool isTagGoodFormat(String input) {
    //everything accepted exept ";" and ","
    final RegExp regex = RegExp(r'[^;,]+');
    return regex.hasMatch(input);
  }

  void _addNewTag(String newTag) {
    if (newTag.isEmpty) {
      return;
    }
    if (!isTagGoodFormat(newTag)) {
      // Show an error snackbar if the input contains numbers or special characters.
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Please do not enter commas and/or semi-colons in the tag."),
          duration: Duration(seconds: 2),
        ),
      );
      return;
    }

    setState(() {
      vocabListService.tagsForChosenWord.add(newTag);
    });
    if(!vocabListService.existingTags.contains(newTag)){
      vocabListService.existingTags.add(newTag);
    }
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tags'),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: searchController,
                    onChanged: _onSearchTextChanged,
                    decoration: const InputDecoration(
                      labelText: 'Search or create new tag',
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                ElevatedButton(
                  onPressed: () => _addNewTag(searchController.text.trim()),
                  child: const Text('Create tag'),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: filteredTags.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(filteredTags[index]),
                  onTap: () {
                    // Perform some action when a preexisting tag is selected.
                    vocabListService.tagsForChosenWord.add(filteredTags[index]);
                    Navigator.pop(context);
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}