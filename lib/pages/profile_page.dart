import 'package:flutter/material.dart';
import 'drawer.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State {
  File? _image;

  // Function to handle image picking
  Future<void> _pickImage() async {
    try {
      final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);
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
    return Scaffold(
      appBar: AppBar(
        title: const Text("Profile"),
        backgroundColor: Colors.amber,
        elevation: 0,
      ),
      drawer: const CustomDrawer(),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            CircleAvatar(
              radius: 80,
              backgroundColor: Colors.grey.shade300,
              backgroundImage: _image != null ? FileImage(_image!) : null,
              child: _image == null
                  ? Icon(Icons.camera_alt, size: 80, color: Colors.grey.shade800)
                  : null,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _pickImage,
              child: const Text('Change Profile Picture'),
            ),
            const SizedBox(height: 10),
            const Text(
              'Jane Doe',
              style: TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              'Member since 2019',
              style: TextStyle(
                fontSize: 16.0,
                color: Colors.grey[800],
              ),
            ),
            const SizedBox(height: 20),
            ListTile(
              title: const Text('Borrowed Books'),
              leading: const Icon(Icons.book, color: Colors.blue),
              onTap: () {
                // Navigate to borrowed books page
              },
            ),
            ListTile(
              title: const Text('Book History'),
              leading: const Icon(Icons.history, color: Colors.green),
              onTap: () {
                // Navigate to book history page
              },
            ),
            ListTile(
              title: const Text('Dark Mode'),
              leading: const Icon(Icons.settings, color: Colors.grey),
              onTap: () {
                // Navigate to settings page
              },
            ),
          ],
        ),
      ),
    );
  }
}