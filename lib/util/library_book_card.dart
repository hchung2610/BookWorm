import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import 'package:practice_proj/pages/books_page.dart';
import 'package:practice_proj/util/book.dart';
import 'package:practice_proj/util/library_model.dart';
import 'package:provider/provider.dart';
import '../pages/explore_page.dart';

class LibraryBookCard extends StatefulWidget {
  final Book book;
  final VoidCallback showDetails;
  bool finished = false;
  final VoidCallback onRemove;
  LibraryBookCard(
      {super.key,
      required this.book,
      required this.showDetails,
      required this.onRemove,
      required this.finished});

  @override
  State<LibraryBookCard> createState() => _LibraryBookCardState();
}

class _LibraryBookCardState extends State<LibraryBookCard> {
  @override
  int _selectedRating = 1;
  @override
  Widget build(BuildContext context) {
    return Consumer<LibraryModel>(
      builder: (context, value, child) => Card(
        child: Stack(
          children: [
            InkWell(
              onTap: () {
                widget.showDetails();
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
                  Align(
                    alignment: Alignment.center,
                    child: Icon(
                      Icons.circle,
                      color: widget.finished ? Colors.green : Colors.orange,
                    ),
                  ),
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
          ],
        ),
      ),
    );
  }
}
