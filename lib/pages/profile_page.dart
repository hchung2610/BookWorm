import 'package:flutter/material.dart';
import 'package:practice_proj/util/library_model.dart';
import 'package:provider/provider.dart';
import 'drawer.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'ReadingGoalsPage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:url_launcher/url_launcher.dart';

File? _image;

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final TextEditingController _nameController = TextEditingController();

  void _redirectToFacebookGroup() async {
    const url = 'https://www.facebook.com/groups/7048925028497413';
    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url));
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  void initState() {
    super.initState();
    _loadName();
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  Future<void> _loadName() async {
    final prefs = await SharedPreferences.getInstance();
    String? savedName = prefs.getString('userName');
    if (savedName != null) {
      _nameController.text = savedName;
    }
  }

  Future<void> _saveName(String name) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('userName', name);
  }

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
          backgroundColor: Theme.of(context).colorScheme.secondary,
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
                  backgroundColor: Theme.of(context).colorScheme.surface,
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
                child: Text('Change Profile Picture',
                    style: TextStyle(
                        color: Theme.of(context).colorScheme.secondary)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).colorScheme.surface,
                ),
              ),
              const SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: TextField(
                  controller: _nameController,
                  decoration: InputDecoration(
                    labelText: 'Your Name',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    prefixIcon: Icon(Icons.person,
                        color: Theme.of(context).colorScheme.onSecondary),
                  ),
                  onSubmitted: (value) {
                    _saveName(value);
                  },
                  style: const TextStyle(
                      fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(height: 20),
              value.filtered_books.length > 1
                  ? Text(
                      'You have ' +
                          value.filtered_books.length.toString() +
                          " books in your library.",
                      style: TextStyle(
                        fontSize: 16.0,
                        color: Theme.of(context).colorScheme.onError,
                      ),
                    )
                  : Text(
                      'You have ' +
                          value.filtered_books.length.toString() +
                          " book in your library.",
                      style: TextStyle(
                        fontSize: 16.0,
                        color: Theme.of(context).colorScheme.onError,
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
                title: Text('Connect with Community',
                    style: TextStyle(fontSize: 20)),
                leading: Icon(Icons.groups, color: Colors.blue, size: 30),
                onTap: _redirectToFacebookGroup,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
