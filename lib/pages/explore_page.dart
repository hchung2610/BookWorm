
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'drawer.dart';
import '../util/book_card.dart';

class ExplorePage extends StatefulWidget {
  const ExplorePage({Key? key}) : super(key: key);

  @override
  State<ExplorePage> createState() => _ExplorePageState();
}

class _ExplorePageState extends State<ExplorePage> {
  late Future<List<Book>> futureBooks;
  final TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    futureBooks = fetchBooks("books");
  }

  Future<List<Book>> fetchBooks(String query) async {
    final url = Uri.parse('https://www.googleapis.com/books/v1/volumes?q=$query&maxResults=10&key=AIzaSyDfp3NASLl6f_tbd7zbo490R8grLqW1psk');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      if (data['totalItems'] > 0) {
        return (data['items'] as List)
            .map((item) => Book.fromJson(item['volumeInfo']))
            .toList();
      } else {
        throw Exception('No books found');
      }
    } else {
      throw Exception('Failed to load books');
    }
  }

  void updateSearchQuery(String newQuery) {
    if (newQuery.isNotEmpty) {
      setState(() {
        futureBooks = fetchBooks(newQuery);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Explore"),
        backgroundColor: Colors.amber,
        elevation: 0,
      ),
      drawer: const CustomDrawer(),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.all(10),
            child: TextField(
              controller: searchController,
              decoration: InputDecoration(
                hintText: 'Search books',
                suffixIcon: IconButton(
                  icon: Icon(Icons.search),
                  onPressed: () => updateSearchQuery(searchController.text),
                ),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(5)),
              ),
              onSubmitted: updateSearchQuery,
            ),
          ),
          Expanded(
            child: FutureBuilder<List<Book>>(
              future: futureBooks,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text("Error: ${snapshot.error}"));
                } else if (snapshot.hasData) {
                  return GridView.builder(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 10,
                      mainAxisSpacing: 10,
                      childAspectRatio: 0.7,
                    ),
                    padding: EdgeInsets.all(10),
                    itemCount: snapshot.data!.length,
                    itemBuilder: (context, index) {
                      Book book = snapshot.data![index];
                      return BookCard(
                        book: book,
                        onToggleAdded: () {
                          if (!book.isAdded) {
                            setState(() {
                              book.isAdded = true;  // Mark the book as added
                              books.add(book);      // Add the book to the global 'books' list used by BooksPage
                            });
                          }
                        },
                      );
                    },
                  );
                } else {
                  return Center(child: Text("No books available."));
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}

class Book {
  final String name;
  final String icon;
  final List<String> authors;
  final List<String> categories;
  bool isAdded;

  Book({required this.name, required this.icon, required this.authors, required this.categories, this.isAdded = false});

  factory Book.fromJson(Map<String, dynamic> json) {
    List<String> parseAuthors(json) {
      return json['authors'] != null ? List<String>.from(json['authors']) : [];
    }

    List<String> parseCategories(json) {
      return json['categories'] != null ? List<String>.from(json['categories']) : [];
    }

    return Book(
      name: json['title'] ?? 'Untitled',
      icon: json['imageLinks'] != null ? json['imageLinks']['thumbnail'] : '',
      authors: parseAuthors(json),
      categories: parseCategories(json),
      isAdded: false,
    );
  }
}


