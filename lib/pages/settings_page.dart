import 'package:flutter/material.dart';
import 'drawer.dart';
class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Settings"),
        backgroundColor: Colors.amber,
        elevation: 0,
      ),
      drawer: const CustomDrawer(),
    );
  }
}
