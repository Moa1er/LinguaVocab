import 'package:vocab_language_tester/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:vocab_language_tester/classes/word.dart';
import 'package:vocab_language_tester/services/vocab_list_service.dart';

class VocabListPage extends StatefulWidget {
  const VocabListPage({super.key});

  @override
  State<VocabListPage> createState() => _VocabListPageState();
}

class _VocabListPageState extends State<VocabListPage> {
  VocabListService vocabListService = VocabListService();

  String _searchQuery = ''; // Variable to store the search query
  // Function to update the search query and rebuild the UI
  void _updateSearchQuery(String query) {
    setState(() {
      _searchQuery = query.toLowerCase();
    });
  }

  @override
  Widget build(BuildContext context) {
    // Filter the word list based on the search query
    final filteredWordList = vocabListService.wordList.where((word) {
      final foreignMatch = word.foreignVersion.toLowerCase().contains(_searchQuery);
      final transMatch = word.transVersion.toLowerCase().contains(_searchQuery);
      return foreignMatch || transMatch;
    }).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Vocabulary List'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: SizedBox(
              width: double.infinity, // Set the width to take the entire available space
              child: TextField(
                onChanged: _updateSearchQuery,
                decoration: const InputDecoration(
                  hintText: 'Search...',
                  border: OutlineInputBorder(),
                ),
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: filteredWordList.length,
              itemBuilder: (context, index) {
                final word = filteredWordList[index];
                return ListTile(
                  title: Text(word.foreignVersion),
                  subtitle: Text(word.transVersion),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          _showDescrTagsModal(context, word);
                        },
                        child: const Text('Description/Tags'),
                      ),
                      const SizedBox(width: 5),
                      IconButton(
                        onPressed: () {
                          _showDeleteConfirmationDialog(context, word);
                        },
                        icon: const Icon(Icons.delete),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  void _showDescrTagsModal(BuildContext context, Word word) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          height: MediaQuery.of(context).size.height * 0.1 + MediaQuery.of(context).size.height * 0.04 * (word.description.length / 76).ceil(), // Adjust the height as needed
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                child: Wrap(
                  spacing: 8.0,
                  children: word.tags.map((tag) {
                    return Chip(
                      label: Text(
                        tag,
                        style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
                      ),
                      backgroundColor: Colors.grey[300],
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
                    );
                  }).toList(),
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0), // Add 16 pixels of padding on the left and right
                  child: SingleChildScrollView(
                    child: Text(
                      word.description,
                      style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _showDeleteConfirmationDialog(BuildContext context, Word wordToDel) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Confirm Deletion'),
          content: Text.rich(
            TextSpan(
              children: [
                const TextSpan(text: 'Are you sure you want to delete the word "'),
                TextSpan(
                  text: wordToDel.foreignVersion,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                const TextSpan(text: '" ?'),
              ],
            ),
          ),
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
                deleteWord(wordToDel);
              },
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );
  }

  void deleteWord(Word wordToDel) async {
    await deleteWordFromFile(wordToDel);
    setState(() {
      vocabListService.deleteWord(wordToDel);
      vocabListService.updateExistingTags();
    });
  }
}