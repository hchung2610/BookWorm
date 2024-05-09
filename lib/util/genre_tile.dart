import 'package:flutter/material.dart';

class GenreTile extends StatelessWidget {
  final String name;
  final bool checked;
  Function(bool?)? onChanged;
  GenreTile(
      {super.key,
      required this.name,
      required this.checked,
      required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(5),
      child: Container(
        padding: EdgeInsets.all(10),
        child: Row(
          children: [
            Checkbox(
              value: checked,
              onChanged: onChanged,
              activeColor: Theme.of(context).colorScheme.tertiary,
            ),
            Text(name)
          ],
        ),
        decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.primary,
            borderRadius: BorderRadius.circular(10)),
      ),
    );
  }
}
