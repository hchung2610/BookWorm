import "package:flutter/material.dart";

class BookTile extends StatelessWidget {
  final String Title;
  final String Author;
  final String Genre;

  /* Need another parameter to take in the picture that we get from the API*/

  BookTile(
      {super.key,
      required this.Title,
      required this.Author,
      required this.Genre});

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: EdgeInsets.only(top: 25, left: 25, right: 25),
        child: Container(
          padding: EdgeInsets.all(25),
          child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
            Text(
              Title,
            ),
            Text(
              Author,
            ),
            Text(
              Genre,
            ),
          ]),
          decoration: BoxDecoration(
              color: Colors.amberAccent,
              borderRadius: BorderRadius.circular(10)),
        ));
  }
}
