
import "package:flutter/material.dart";
import "../util/book_card.dart";
import "../util/dialog_box.dart";
import "drawer.dart";
import '../util/global_books.dart';
import "explore_page.dart";


class BooksPage extends StatefulWidget {
  @override
  _BooksPageState createState() => _BooksPageState();
}

class _BooksPageState extends State<BooksPage> {

  bool _filterFavorites = false; // An example filter criteria

  List<Book> get filteredBooks {
    // Apply filter criteria to books list
    return books.where((book) => book.isAdded).toList(); // Adjust according to your filter criteria
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("My Books"),
        backgroundColor: Colors.amber,
        actions: [
          IconButton(
            icon: Icon(Icons.filter_list),
            onPressed: _showFilterDialog,
          ),
        ],
      ),
      drawer: const CustomDrawer(),
      body: GridView.builder(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
          childAspectRatio: 0.7,
        ),
        itemCount: filteredBooks.length, // Assumes 'books' is a global list of added books
        itemBuilder: (context, index) {
          // Only display books that have been marked as added
          if (books[index].isAdded) {
            return BookCard(
              book: filteredBooks[index],
              onToggleAdded: () {
                // This would toggle the added state and remove from the global list
                setState(() {
                  filteredBooks[index].isAdded = !filteredBooks[index].isAdded;
                  books = books.where((book) => book.isAdded).toList(); // Filter the books list
                });
              },
            );
          } else {
            return Container(); // Return an empty container for books not added
          }
        },
      ),
    );
  }

  void _showFilterDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Filter Books'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Example: filter by whether a book is marked as favorite
              CheckboxListTile(
                value: _filterFavorites,
                onChanged: (bool? value) {
                  if (value != null) {
                    setState(() {
                      _filterFavorites = value;
                    });
                  }
                  Navigator.pop(context); // Close the dialog
                },
                title: Text('Favorites only'),
              ),
              // Add more filtering options here
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context); // Close the dialog
              },
              child: Text('Close'),
            ),
          ],
        );
      },
    );
  }


  @override
  void setState(fn) {
    if (mounted) {
      super.setState(fn);
    }
  }

}

