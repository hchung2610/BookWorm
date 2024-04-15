import "package:flutter/material.dart";
import "package:practice_proj/util/book_card.dart";
import "package:practice_proj/util/dialog_box.dart";
import "drawer.dart";

class BooksPage extends StatefulWidget {
  const BooksPage({super.key});

  @override
  State<BooksPage> createState() => _HomePageState();
}

class _HomePageState extends State<BooksPage> {
  List<TextEditingController> controller_list = [
    TextEditingController(),
    TextEditingController()
  ];

  void addNewBook() {
    setState(() {
      books.add(
        Book(name: controller_list[0].text, icon: controller_list[1].text),
      );
    });
    Navigator.of(context).pop();
  }

  void addBook() {
    showDialog(
        context: context,
        builder: (context) {
          return DialogBox(
              controller_list: controller_list,
              onAdd: addNewBook,
              onCancel: () => Navigator.of(context).pop());
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Books"),
        backgroundColor: Colors.amber,
        elevation: 0,
      ),
      drawer: const CustomDrawer(),

      floatingActionButton: FloatingActionButton(
        onPressed: addBook,
        child: Icon(Icons.add),
      ),
      body:

          Expanded(
        child: GridView.count(
          crossAxisCount: 2,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
          children: List.generate(books.length, (index) {
            return BookCard(book: books[index]);
          }),
        ),
      ),
    );
  }
}
