import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import 'package:practice_proj/pages/books_page.dart';
import 'package:practice_proj/pages/detailed_view.dart';
import 'package:practice_proj/util/book.dart';
import 'package:practice_proj/util/library_model.dart';
import 'package:provider/provider.dart';
import '../pages/explore_page.dart';

class LibraryBookCard extends StatefulWidget {
  final Book book;
  bool finished = false;
  VoidCallback showDetails;
  LibraryBookCard({
    super.key,
    required this.book,
    required this.finished,
    required this.showDetails,
  });

  @override
  State<LibraryBookCard> createState() => _LibraryBookCardState();
}

class _LibraryBookCardState extends State<LibraryBookCard> {
  void _toggleFinished() {
    setState(() {
      widget.finished = !widget.finished;
    });
  }

  @override
  int _selectedRating = 1;
  @override
  Widget build(BuildContext context) {
    return Consumer<LibraryModel>(
      builder: (context, value, child) => Padding(
        padding: const EdgeInsets.only(left: 10, right: 10),
        child: Card(
          child: Container(
            padding: EdgeInsets.only(top: 8),
            decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.scrim,
                boxShadow: [
                  BoxShadow(
                    color: Theme.of(context).colorScheme.shadow,
                    spreadRadius: 5,
                    blurRadius: 7,
                    offset: Offset(0, 3), // changes position of shadow
                  ),
                ],
                borderRadius: BorderRadius.all(Radius.circular(10))),
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
                        child: Padding(
                          padding: EdgeInsets.only(bottom: 10),
                          child: Icon(
                            Icons.circle,
                            color: widget.book.readStatus
                                ? Colors.green
                                : Colors.orange,
                          ),
                        ),
                      ),
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: List.generate(widget.book.rating, (index) {
                          print(widget.book.rating.toString() +
                              " " +
                              value.filtered_books[widget.book.index].rating
                                  .toString());
                          return Icon(Icons.star,
                              color:
                                  Theme.of(context).colorScheme.inversePrimary);
                        }),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
