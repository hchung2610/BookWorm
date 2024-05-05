import 'package:flutter/material.dart';
import 'package:practice_proj/util/book.dart';
import 'package:practice_proj/util/library_model.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:practice_proj/dictionary-related/words_tab.dart';

class DetailedView extends StatefulWidget {
  final String title;
  final List<String> author;
  final List<String> genre;
  final String icon;
  bool isFinished;
  Book book;
  DetailedView(
      {super.key,
      required this.title,
      required this.author,
      required this.genre,
      required this.icon,
      required this.book,
      required this.isFinished});

  @override
  State<DetailedView> createState() => _DetailedViewState();
}

class _DetailedViewState extends State<DetailedView> {
  SharedPreferences? _prefs;
  List<Map<String, String>> notes = [];

  @override
  void initState() {
    super.initState();
    _loadNotes();
    _loadState();
  }

  void _loadState() async {
    _prefs = await SharedPreferences.getInstance();
    // Load the finished status using a unique key, here it is based on the book's title
    setState(() {
      widget.isFinished = _prefs?.getBool('finished_${widget.title}') ?? false;
    });
  }

  void _loadNotes() async {
    _prefs = await SharedPreferences.getInstance();
    notes.clear();
    _prefs?.getKeys().forEach((key) {
      if (key.startsWith('note_${widget.title}_')) {
        notes.add({
          'title': key.split('_').last,
          'body': _prefs!.getString(key) ?? ''
        });
      }
    });
    setState(() {});
  }

  void _saveNote(String? originalTitle, String noteTitle, String noteBody) {
    final String newKey = 'note_${widget.title}_$noteTitle';
    final String? oldKey =
        originalTitle != null ? 'note_${widget.title}_$originalTitle' : null;

    if (newKey != oldKey && (_prefs?.containsKey(newKey) ?? false)) {
      // Show dialog if the new title already exists
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Error'),
              content: Text(
                  'A note with this title already exists. Please choose a different title.'),
              actions: [
                TextButton(
                  child: Text('OK'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            );
          });
      return; // Return early to prevent saving
    }
    if (oldKey != null &&
        oldKey != newKey &&
        (_prefs?.containsKey(oldKey) ?? false)) {
      _prefs?.remove(oldKey); // Remove the old note
    }

    _prefs?.setString(newKey, noteBody);
    _loadNotes();
  }

  void _addOrEditNote(
      {String? originalTitle, String? noteTitle, String? noteBody}) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => NoteEditor(
                originalTitle: originalTitle,
                title: noteTitle,
                body: noteBody,
              )),
    );
    if (result != null) {
      _saveNote(result['originalTitle'] as String?, result['title'] as String,
          result['body'] as String);
    }
  }

  void deleteNote(String noteTitle) {
    final String key = 'note_${widget.title}_$noteTitle';

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Delete Note'),
          content: Text('Are you sure you want to delete this note?'),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('No'),
            ),
            TextButton(
              onPressed: () {
                _prefs?.remove(key); // Perform the deletion
                _loadNotes(); // Refresh the notes list
                Navigator.of(context).pop();
              },
              child: Text('Yes'),
            ),
          ],
        );
      },
    );
  }

  void _toggleFinished() {
    setState(() {
      widget.isFinished = !widget.isFinished;
      // Save the updated status using the same unique key
      _prefs?.setBool('finished_${widget.title}', widget.isFinished);

      // Update the list of finished books based on the new state
      List<String> finishedBooks = _prefs?.getStringList('finishedBooks') ?? [];
      if (widget.isFinished && !finishedBooks.contains(widget.title)) {
        finishedBooks.add(widget.title);
      } else if (!widget.isFinished && finishedBooks.contains(widget.title)) {
        finishedBooks.remove(widget.title);
      }
      _prefs?.setStringList('finishedBooks', finishedBooks);
    });
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: Text("Book Details"),
          bottom: const TabBar(tabs: [
            Tab(icon: Icon(Icons.book)),
            Tab(icon: Icon(Icons.sticky_note_2)),
            Tab(icon: Icon(Icons.spellcheck)),
          ]),
        ),
        body: TabBarView(
          children: [
            BookTab(),
            notesTab(),
            WordsTab(),
          ],
        ),
      ),
    );
  }

  Widget BookTab() {
    return Consumer<LibraryModel>(
        builder: (contextLibrary, value, child) => Container(
            padding: EdgeInsets.all(20),
            child: ListView(
              children: [
                Row(children: [
                  Text(
                    "Title: ",
                    style: TextStyle(fontSize: 22),
                  ),
                  Flexible(
                    child: Text(
                      widget.title,
                      style: TextStyle(fontSize: 22),
                    ),
                  ),
                ]),
                Divider(),
                Row(children: [
                  Text(
                    "Author(s): ",
                    style: TextStyle(fontSize: 22),
                  ),
                  Flexible(
                    child: Text(
                      widget.author.join(", "),
                      style: TextStyle(fontSize: 22),
                    ),
                  )
                ]),
                Divider(),
                Row(children: [
                  Text(
                    "Genre(s): ",
                    style: TextStyle(fontSize: 22),
                  ),
                  Flexible(
                      child: Text(
                    widget.genre.join(", "),
                    style: TextStyle(fontSize: 22),
                  )),
                ]),
                Divider(),
                SwitchListTile(
                  title: Text(
                    "Mark as Finished:",
                    style: TextStyle(fontSize: 18),
                  ),
                  value: widget.isFinished,
                  onChanged: (_) => _toggleFinished(),
                ),
                ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        shadowColor: Colors.black,
                        side: BorderSide(color: Colors.redAccent),
                        textStyle: TextStyle(
                          fontSize: 15,
                        )),
                    onPressed: () {
                      showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                                actions: [
                                  TextButton(
                                      onPressed: () {
                                        final library =
                                            contextLibrary.read<LibraryModel>();
                                        library.removeBook(widget.book);
                                        Navigator.of(context).pop();
                                        Navigator.of(context).pop();
                                      },
                                      child: Text("Yes")),
                                  TextButton(
                                      onPressed: () => Navigator.pop(context),
                                      child: Text("No")),
                                ],
                                title: Text("Confirm Deletion"),
                              ));
                    },
                    child: Text("Delete Book"))
              ],
            )));
  }

  Widget notesTab() {
    return Scaffold(
      body: ListView.separated(
        itemCount: notes.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(notes[index]['title'] ?? ''),
            subtitle: Text(notes[index]['body'] ?? ''),
            onTap: () => _addOrEditNote(
              originalTitle: notes[index]['title'],
              noteTitle: notes[index]['title'],
              noteBody: notes[index]['body'],
            ),
            trailing: IconButton(
              icon: Icon(Icons.delete),
              onPressed: () => deleteNote(notes[index]['title'] ?? ''),
            ),
          );
        },
        separatorBuilder: (context, index) => Divider(),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _addOrEditNote(),
        child: Icon(Icons.add),
      ),
    );
  }
  /*Widget dictionaryTab() {
    return Container(
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSearchWidget(),
            const SizedBox(height: 12),
            if (inProgress)
              const LinearProgressIndicator()
            else if (responseModel != null)
              Expanded(child: _buildResponseWidget())
            else
              _noDataWidget(),
          ],
        ),
      ),
    );
  }*/
}

class NoteEditor extends StatelessWidget {
  final String? originalTitle;
  final String? title;
  final String? body;

  NoteEditor({Key? key, this.originalTitle, this.title, this.body})
      : super(key: key);

  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _bodyController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    _titleController.text = title ?? '';
    _bodyController.text = body ?? '';

    return Scaffold(
      appBar: AppBar(title: Text('Edit Note')),
      body: Padding(
        padding: EdgeInsets.all(8.0),
        child: Column(
          children: [
            TextField(
              controller: _titleController,
              decoration: InputDecoration(labelText: 'Title'),
            ),
            Expanded(
              child: TextField(
                controller: _bodyController,
                decoration: InputDecoration(),
                maxLines: null,
                keyboardType: TextInputType.multiline,
                expands: true,
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pop(context, {
            'originalTitle': originalTitle,
            'title': _titleController.text,
            'body': _bodyController.text,
          });
        },
        child: Icon(Icons.check),
      ),
    );
  }
}
