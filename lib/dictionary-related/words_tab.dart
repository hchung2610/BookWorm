import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dictionary_tab.dart';
class WordsTab extends StatefulWidget {
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
      words = prefs.getStringList('words') ?? [];
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
    setState(() {
      words.remove(word);
      prefs.setStringList('words', words);
    });
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
                  MaterialPageRoute(builder: (context) => DictionaryTab(initialWord: words[index])))
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
              MaterialPageRoute(builder: (context) => DictionaryTab()))
              .then((_) => loadWords()); // Reload words after adding
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
