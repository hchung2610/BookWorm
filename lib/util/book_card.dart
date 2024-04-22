import 'package:flutter/material.dart';
import '../pages/explore_page.dart';
import 'global_books.dart';

List<Book> books = [];

class BookCard extends StatefulWidget {
  final Book book;
  final VoidCallback onToggleAdded;
  final VoidCallback onRemove;
  final bool showActions;

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
  @override
  Widget build(BuildContext context) {
    return Card(
      child: Stack(
        children: [
          InkWell(
            onTap: () {
              widget.onToggleAdded();
              setState(() {
                // This assumes book.isAdded is a part of the Book model
                widget.book.isAdded = true;
              });
            },
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Expanded(
                  // Use Expanded to allow the image to take up all available space
                  child: Image.network(
                    widget.book.icon,
                    fit: BoxFit
                        .cover, // This ensures the image covers the card area without stretching
                  ),
                ),
                Padding(
                  padding:
                      EdgeInsets.all(8.0), // Add some padding around the text
                  child: Text(
                    widget.book.name,
                    style: Theme.of(context).textTheme.titleLarge,
                    textAlign: TextAlign.center,
                  ),
                ),
                if (widget.showActions) // Render actions conditionally
                  ElevatedButton(
                    onPressed: widget.onRemove,
                    child: const Text('Remove'),
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.white,
                      backgroundColor: Colors.red, // Text color
                    ),
                  ),
              ],
            ),
          ),
          Positioned(
            right: 8,
            top: 8,
            child: Icon(
              widget.book.isAdded ? Icons.check : Icons.add,
              color: widget.book.isAdded ? Colors.green : Colors.grey,
            ),
          ),
        ],
      ),
    );
  }
}
