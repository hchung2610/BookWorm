import 'package:practice_proj/pages/books_page.dart';
import 'package:flutter/material.dart';
import 'package:practice_proj/util/book.dart';
import 'package:practice_proj/util/library_model.dart';
import 'package:provider/provider.dart';
import '../pages/explore_page.dart';

class ExploreBookCard extends StatefulWidget {
  final Book book;
  final VoidCallback addBook;
  final VoidCallback onRemove;

  ExploreBookCard({
    super.key,
    required this.book,
    required this.addBook,
    required this.onRemove,
  });

  @override
  State<ExploreBookCard> createState() => _ExploreBookCardState();
}

class _ExploreBookCardState extends State<ExploreBookCard> {
  int _selectedRating = 1;
  @override
  Widget build(BuildContext context) {
    return Consumer<LibraryModel>(
      builder: (contextLibrary, value, child) => Card(
        child: Stack(
          children: [
            InkWell(
              onTap: () {
                showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                          title: Text("Add Book"),
                          content: Text("Would you like to add \"" +
                              widget.book.name +
                              "\" to your library?"),
                          actions: [
                            TextButton(
                                onPressed: () => Navigator.pop(context),
                                child: Text("Cancel")),
                            TextButton(
                                onPressed: () {
                                  widget.addBook();
                                },
                                child: Text("Confirm")),
                          ],
                        ));
              },
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Expanded(
                    child: Image.network(
                      widget.book.icon,
                      fit: BoxFit.cover,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text(
                      widget.book.name,
                      style: Theme.of(context).textTheme.titleLarge,
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
