import 'package:vocab_language_tester/classes/word.dart';

import 'package:flutter/material.dart';
import 'package:vocab_language_tester/services/vocab_list_service.dart';

class VocabListPage extends StatefulWidget {
  const VocabListPage({super.key});

  @override
  State<VocabListPage> createState() => _VocabListPageState();
}

class _VocabListPageState extends State<VocabListPage> {
  VocabListService vocabListService = VocabListService();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Vocabulary List'),
      ),
      body: ListView.builder(
        itemCount: vocabListService.wordList.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(vocabListService.wordList[index].foreignVersion),
            subtitle: Text(vocabListService.wordList[index].transVersion),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                ElevatedButton(
                  onPressed: () {
                    _showTagsModal(context, vocabListService.wordList[index].tags);
                  },
                  child: const Text('Tags'),
                ),
                const SizedBox(width: 5),
                IconButton(
                  onPressed: () {
                    _showDeleteConfirmationDialog(context, index);
                  },
                  icon: const Icon(Icons.delete),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  void _showTagsModal(BuildContext context, Set<String> tags) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          padding: const EdgeInsets.all(16),
          child: Wrap(
            spacing: 8.0,
            children: tags.map((tag) {
              return Chip(
                label: Text(
                  tag,
                  style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                ),
                backgroundColor: Colors.grey[300],
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
              );
            }).toList(),
          ),
        );
      },
    );
  }
  void _showDeleteConfirmationDialog(BuildContext context, int index) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Confirm Deletion'),
          content: const Text('Are you sure you want to delete this word?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                _deleteWord(index);
              },
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );
  }

  void _deleteWord(int index) {
    vocabListService.deleteLineFromFileFromString(vocabListService.wordList[index].foreignVersion);
    setState(() {
      vocabListService.wordList.removeAt(index);
      vocabListService.updateExistingTags();
    });
  }
}