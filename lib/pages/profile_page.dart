import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:practice_proj/pages/books_page.dart';
import 'package:practice_proj/util/library_model.dart';
import 'package:provider/provider.dart';
import 'drawer.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'ReadingGoalsPage.dart';

File? _image;

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State {
  // Function to handle image picking
  Future<void> _pickImage() async {
    try {
      final pickedFile =
          await ImagePicker().pickImage(source: ImageSource.gallery);
      if (pickedFile != null) {
        setState(() {
          _image = File(pickedFile.path);
        });
      }
    } catch (e) {
      // Handle exceptions or errors if any
      print('Failed to pick image: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<LibraryModel>(
      builder: (context, value, child) => Scaffold(
        appBar: AppBar(
          title: const Text("Profile"),
          backgroundColor: Colors.amber,
          elevation: 0,
        ),
        drawer: const CustomDrawer(),
        body: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              Padding(
                padding: EdgeInsets.only(top: 15),
                child: CircleAvatar(
                  radius: 80,
                  backgroundColor: Colors.grey.shade300,
                  backgroundImage: _image != null ? FileImage(_image!) : null,
                  child: _image == null
                      ? Icon(Icons.camera_alt,
                          size: 80, color: Colors.grey.shade800)
                      : null,
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _pickImage,
                child: const Text('Change Profile Picture'),
              ),
              const SizedBox(height: 10),
              const Text(
                "John Smith",
                style: TextStyle(
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                'You have ' +
                    value.filtered_books.length.toString() +
                    " books in your library.",
                style: TextStyle(
                  fontSize: 16.0,
                  color: Colors.grey[800],
                ),
              ),
              const SizedBox(height: 20),
              ListTile(
                title: const Text(
                  'Reading Goals',
                  style: TextStyle(fontSize: 20),
                ),
                leading: const Icon(
                  Icons.emoji_events,
                  color: Color.fromARGB(255, 31, 154, 88),
                  size: 30,
                ),
                onTap: () {
                  // Navigate to book history page
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const ReadingGoalsPage()),
                  );
                },
              ),
              ListTile(
                title: const Text(
                  'Current Books',
                  style: TextStyle(fontSize: 20),
                ),
                leading: const Icon(
                  Icons.book,
                  color: Colors.blue,
                  size: 30,
                ),
                onTap: () {
                  // Navigate to borrowed books page
                },
              ),
              ListTile(
                title: const Text(
                  'Dark Mode',
                  style: TextStyle(fontSize: 20),
                ),
                leading: const Icon(
                  Icons.settings,
                  color: Colors.grey,
                  size: 30,
                ),
                onTap: () {
                  // Navigate to settings page
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
