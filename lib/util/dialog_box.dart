import "package:flutter/material.dart";
import "package:practice_proj/util/button.dart";

class DialogBox extends StatelessWidget {
/*
  final controller_Title;
  final controller_Author;
  final controller_Genre;
*/
  final controller_list;
  final VoidCallback onAdd;
  final VoidCallback onCancel;

  const DialogBox(
      {super.key,
      /*  required this.controller_Title,
      required this.controller_Author,
      required this.controller_Genre,
      */
      required this.onAdd,
      required this.onCancel,
      required this.controller_list});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Color.fromARGB(255, 112, 210, 135),
      content: Container(
        height: 270,
        width: 300,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            // User Input For Title

            TextField(
              controller: controller_list[0],
              decoration: const InputDecoration(
                  border: OutlineInputBorder(), hintText: "Name"),
            ),
            TextField(
              controller: controller_list[1],
              decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: "Icon Path Will Change Later"),
            ),

            Row(children: [
              Button(text: "Add", onPressed: onAdd),
              SizedBox(width: 8),
              Button(text: "Cancel", onPressed: onCancel)
            ])
          ],
        ),
      ),
    );
  }
}
