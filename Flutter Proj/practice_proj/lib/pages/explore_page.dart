import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:math';

class ExplorePage extends StatefulWidget {
  const ExplorePage({Key? key}) : super(key: key);

  @override
  State<ExplorePage> createState() => _ExplorePageState();
}

class _ExplorePageState extends State<ExplorePage> {
  late Future<List<Book>> futureBooks;

  @override
  void initState() {
    super.initState();
    futureBooks = fetchBooks();
  }

  Future<List<Book>> j() async {
    final query = "books";
    final url = Uri.parse(
        'https://www.googleapis.com/books/v1/volumes?q=$query&maxResults=10&key=AIzaSyDfp3NASLl6f_tbd7zbo490R8grLqW1psk');
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Explore"),
        backgroundColor: Colors.amber,
        elevation: 0,
      ),
      drawer: Drawer(
        backgroundColor: Colors.amber,
        child: Column(
          children: [
            DrawerHeader(
                child: Column(
              children: [
                Icon(
                  Icons.menu_book,
                  size: 100,
                ),
                Text("Welcome John Smith!")
              ],
            )),
            ListTile(
              leading: Icon(Icons.home),
              title: Text("E X P L O R E"),
              onTap: () {
                Navigator.pushNamed(context, '/explore');
              },
            ),
            ListTile(
                leading: Icon(Icons.book),
                title: Text("B O O K S"),
                onTap: () {
                  Navigator.pushNamed(context, '/books');
                }),
            ListTile(
                leading: Icon(Icons.settings),
                title: Text("S E T T I N G S"),
                onTap: () {
                  Navigator.pushNamed(context, '/settings');
                }),
            ListTile(
                leading: Icon(Icons.person),
                title: Text("P R O F I L E"),
                onTap: () {
                  Navigator.pushNamed(context, '/profile');
                })
          ],
        ),
      ),
      body: FutureBuilder<List<Book>>(
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
                return Card(
                  clipBehavior: Clip.antiAlias,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Expanded(
                        child: book.icon.isNotEmpty
                            ? Image.network(
                                book.icon,
                                fit: BoxFit.cover,
                              )
                            : Icon(Icons.image_not_supported),
                      ),
                      ListTile(
                        title: Text(
                          book.name,
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 16),
                        ),
                      ),
                    ],
                  ),
                );
              },
            );
          } else {
            return Center(child: Text("No books available."));
          }
        },
      ),
    );
  }
}

class Book {
  final String name;
  final String icon;

  Book({required this.name, required this.icon});

  factory Book.fromJson(Map<String, dynamic> json) {
    return Book(
      name: json['title'] ?? 'Untitled',
      icon: json['imageLinks'] != null ? json['imageLinks']['thumbnail'] : '',
    );
  }
}
