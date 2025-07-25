import 'package:flutter/material.dart';
import 'package:vocab_language_tester/classes/word.dart';
import 'package:vocab_language_tester/pages/tag_selection_page.dart';
import 'package:vocab_language_tester/services/vocab_list_service.dart';

import 'add_vocab_page.dart';

class VocabListPage extends StatefulWidget {
  const VocabListPage({super.key});

  @override
  State<VocabListPage> createState() => _VocabListPageState();
}

class _VocabListPageState extends State<VocabListPage> {
  VocabListService vocabListService = VocabListService();

  List<String>? selectedTags; // List of tags to filter the word list
  String _searchQuery = ''; // Variable to store the search query

  @override
  Widget build(BuildContext context) {
    final q = _searchQuery.trim().toLowerCase();
    final selectedSet = selectedTags?.map((t) => t.toLowerCase()).toSet();

    bool matchesSearch(Word w) {
      if (q.isEmpty) return true;            // No query → don’t restrict
      return w.foreignVersion.toLowerCase().contains(q) ||
            w.transVersion.toLowerCase().contains(q);
    }

    bool matchesTags(Word w) {
      if (selectedSet == null || selectedSet.isEmpty) return true;
      return selectedSet.every(
        (neededTag) => w.tags.map((t) => t.toLowerCase()).contains(neededTag),
      );
    }

    final filteredWordList = vocabListService.wordList
        .where((w) => matchesSearch(w) && matchesTags(w)) // AND between filters
        .toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Vocabulary List'),
        actions: [
          IconButton(
            onPressed: _selectTags,
            icon: const Icon(Icons.filter_list),
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: SizedBox(
              width: double.infinity, // Set the width to take the entire available space
              child: TextField(
                onChanged: _updateSearchQuery,
                decoration: InputDecoration(
                  hintText: 'Search...',
                  isDense: true,
                  contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(6),
                    borderSide: BorderSide(color: Colors.grey.shade700, width: 0.7),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(6),
                    borderSide: BorderSide(color: Colors.grey.shade700, width: 0.7),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(6),
                    borderSide: const BorderSide(color: Colors.black, width: 1),
                  ),
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
                      const SizedBox(width: 10),
                      GestureDetector(
                        onTapDown: (TapDownDetails details) async {
                          await _showPopupMenu(
                              details.globalPosition,
                              word,
                          );
                        },
                        child: const Icon(Icons.more_vert),
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

  _showPopupMenu(Offset offset, Word word) async {
    double left = offset.dx;
    double top = offset.dy;
    await showMenu(
      context: context,
      position: RelativeRect.fromLTRB(left, top, 0, 0),
      items: [
        //this weird code is used bc PopupMenuItem calls a navigator.pop so it pop our
        //alertDialog. With this timer the dialog appear correctly
        PopupMenuItem<String>(
            onTap: () {
              setState(() {
                Future.delayed(
                    const Duration(seconds: 0),
                        () {
                          Navigator.push(context, MaterialPageRoute(builder: (context) => AddVocabPage(
                            wordPassed: word,
                            fromVocabList: true,
                          ))).then((value) => setState(() {}));
                    }
                );
              });
          },
          value: 'Modify',
          child: const Text('Modify')
        ),
        //this weird code is used bc PopupMenuItem calls a navigator.pop so it pop our
        //alertDialog. With this timer the dialog appear correctly
        PopupMenuItem<String>(
          onTap: () {
            Future.delayed(
              const Duration(seconds: 0),
              () => {_showDeleteConfirmationDialog(context, word)}
            );
          },
          value: 'Delete',
          child: const Text('Delete'),
        ),
      ],
      elevation: 8.0,
    );
  }

  void _showDescrTagsModal(BuildContext context, Word word) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return SizedBox(
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
  
  // Function to update the search query and rebuild the UI
  void _updateSearchQuery(String query) {
    setState(() {
      _searchQuery = query.toLowerCase();
    });
  }

  void _selectTags() {
    Navigator.push<List<String>>(
      context,
      MaterialPageRoute(
        builder: (context) => TagSelectionPage(initialSelectedTags: selectedTags ?? []),
      ),
    ).then((result) {
      if (!mounted || result == null) return;
      setState(() {
        print("selectedTags: $result");
        selectedTags = result;
      });
    }); 
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
                setState(() {
                  vocabListService.deleteWord(wordToDel);
                });
              },
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );
  }
}