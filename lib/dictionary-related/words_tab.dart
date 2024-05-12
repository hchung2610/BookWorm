import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dictionary_tab.dart';

class WordsTab extends StatefulWidget {
  final String bookTitle;
  WordsTab({Key? key, required this.bookTitle}) : super(key: key);

  @override
  _WordsTabState createState() => _WordsTabState();
}

class _WordsTabState extends State<WordsTab> {
  List<String> words = [];

  @override
  void initState() {
    super.initState();
    loadWords();
  }

  void loadWords() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      words = prefs.getStringList('words_${widget.bookTitle}') ?? [];
    });
  }

  void confirmDelete(String word) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Delete Word'),
          content: Text('Are you sure you want to delete this word?'),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('No'),
            ),
            TextButton(
              onPressed: () {
                deleteWord(word);
                Navigator.of(context).pop();
              },
              child: Text('Yes'),
            ),
          ],
        );
      },
    );
  }

  void deleteWord(String word) async {
    final prefs = await SharedPreferences.getInstance();
    words.remove(word);
    await prefs.setStringList('words_${widget.bookTitle}', words);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView.separated(
        itemCount: words.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(words[index]),
            onTap: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => DictionaryTab(initialWord: words[index], bookTitle: widget.bookTitle)))
                  .then((_) => loadWords());
            },
            trailing: IconButton(
              icon: Icon(Icons.delete),
              onPressed: () => confirmDelete(words[index]),
            ),
          );
        },
        separatorBuilder: (context, index) => Divider(),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => DictionaryTab(bookTitle: widget.bookTitle)))
              .then((_) => loadWords()); // Reload words after adding
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
