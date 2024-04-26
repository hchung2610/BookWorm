import 'package:practice_proj/pages/books_page.dart';
import 'package:flutter/material.dart';
import '../pages/explore_page.dart';
import 'global_books.dart';

List<Book> books = [];

class BookCard extends StatefulWidget {
  final Book book;
  final VoidCallback onToggleAdded;
  final bool showActions;
  final VoidCallback onRemove;

  BookCard({
    super.key,
    required this.book,
    required this.onToggleAdded,
    required this.onRemove,
    this.showActions = false,
  });

  @override
  _BookCardState createState() => _BookCardState();
}

class _BookCardState extends State<BookCard> {
  int _selectedRating = 1;
  @override
  Widget build(BuildContext context) {
    return Card(
      child: Stack(
        children: [
          InkWell(
            onTap: () {
              widget.onToggleAdded();
              setState(() {
                widget.book.isAdded = !widget.book.isAdded;
              });
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
                if (widget.showActions)
                  Column(
                    children: [
                      DropdownButton<int>(
                        value: widget.book.rating,
                        items: List.generate(5, (index) {
                          return DropdownMenuItem(
                            value: index + 1,
                            child: Text('${index + 1}'),
                          );
                        }),
                        onChanged: (newValue) {
                          setState(() {
                            widget.book.rating = newValue!;
                          });
                        },
                      ),
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: List.generate(widget.book.rating, (index) {
                          return Icon(Icons.star, color: Colors.amber);
                        }),
                      ),
                    ],
                  ),
              ],
            ),
          ),
          Positioned(
            right: 8,
            top: 8,
            child: widget.showActions
                ? ElevatedButton(
                    onPressed: () {
                      widget
                          .onRemove(); // Assuming this calls setState or similar
                      unique_books.remove(widget.book.name);
                      setState(() {
                        widget.book.isAdded =
                            false; // Update the isAdded property
                      });
                    },
                    child: const Text('remove'),
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.white,
                      backgroundColor: Colors.red,
                      padding: EdgeInsets.all(4),
                      minimumSize: Size(20, 20),
                    ),
                  )
                : SizedBox(
                    width: 5,
                    height: 5,
                  ),
          )
        ],
      ),
    );
  }
}
