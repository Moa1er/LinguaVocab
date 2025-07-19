import 'package:flutter/material.dart';

import '../services/vocab_list_service.dart';

class TagSelectionPage extends StatefulWidget {
  const TagSelectionPage({
    super.key,
    this.initialSelectedTags = const [],
  });
  final List<String> initialSelectedTags;

  @override
  State<TagSelectionPage> createState() => _TagSelectionPageState();
}

class _TagSelectionPageState extends State<TagSelectionPage> {
  late final List<String> selectedTags = widget.initialSelectedTags;
  final VocabListService vocabListService = VocabListService();

  @override
  Widget build(BuildContext context) {
    final tags = vocabListService.existingTags.toList()..sort();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Select Tags'),
      ),
      body: ListView.builder(
        itemCount: vocabListService.existingTags.length,
        itemBuilder: (context, index) {
          final tag = tags[index];
          final isSelected = selectedTags.contains(tag);

          return ListTile(
            title: Text(tag),
            leading: Checkbox(
              value: isSelected,
              onChanged: (value) {
                setState(() {
                  if (value == true) {
                    selectedTags.add(tag);
                  } else {
                    selectedTags.remove(tag);
                  }
                });
              },
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          if(!vocabListService.doesFilteringHaveWords(selectedTags)){
            showDialog(
              context: context,
              builder: (context) {
                return AlertDialog(
                  title: const Text('No Words Found'),
                  content: const Text(
                      'No words match the selected combination of tags.'),
                  actions: [
                    ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: const Text('OK'),
                    ),
                  ],
                );
              }
            );
          }else{
            vocabListService.createWordListForTest(selectedTags);
            selectedTags.sort();
            Navigator.pop(context, selectedTags);
          }
        },
        child: const Icon(Icons.check),
      ),
    );
  }
}