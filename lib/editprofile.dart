import 'dart:io';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_application_1/chefhome.dart';
import 'package:flutter_application_1/home.dart';
import 'package:flutter_application_1/services/database.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';

class EditProfilePage extends StatefulWidget {
  final String username;
  final String email;
  final String phoneNo;
  final String avatarurl;
  final String bio;
  final String id;
  final bool iskitchen;

  const EditProfilePage({
    Key? key,
    required this.username,
    required this.email,
    required this.phoneNo,
    required this.avatarurl,
    required this.bio,
    required this.id,
    required this.iskitchen,
  }) : super(key: key);

  @override
  _EditProfilePageState createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  late TextEditingController nameController;
  late TextEditingController emailController;
  late TextEditingController phoneController;
  late TextEditingController bioController;

  final DatabaseService _db = DatabaseService();
  File? _imageFile; // For storing the picked image
  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController(text: widget.username);
    emailController = TextEditingController(text: widget.email);
    phoneController = TextEditingController(text: widget.phoneNo);
    bioController = TextEditingController(text: widget.bio);
  }

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    phoneController.dispose();
    bioController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
      });

      // Upload image to Firebase Storage
      await _uploadImage();
    }
  }

  Future<void> _uploadImage() async {
    if (_imageFile != null) {
      try {
        final storageRef = FirebaseStorage.instance
            .ref()
            .child('avatars')
            .child('${widget.id}.jpg'); // Use widget.id

        await storageRef.putFile(_imageFile!);

        final downloadURL = await storageRef.getDownloadURL();

        if (widget.iskitchen) {
          await _db.updateKitchenData(
            widget.id,
            kitchenimage: downloadURL,
          );
        } else {
          await _db.updateUserData(
            widget.id,
            avatarurl: downloadURL,
          );
        }

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Profile picture updated successfully')),
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to upload image')),
        );
        print('Error uploading image: $e');
      }
    }
  }

  void _saveProfile() async {
    String newName = nameController.text.trim();
    String newEmail = emailController.text.trim();
    String newPhoneNo = phoneController.text.trim();
    String newBio = bioController.text.trim();
    try {
      if (widget.iskitchen) {
        final kitchen = await _db.fetchKitchenData(widget.id);
        if (kitchen == null) {
          throw 'Kitchen not found';
        }
        await _db.updateKitchenData(
          widget.id,
          name: newName,
          email: newEmail,
          phoneNumber: newPhoneNo,
          bio: newBio,
        );
      } else {
        final user = await _db.getUserData(widget.id);
        if (user == null) {
          throw 'User not found';
        }
        await _db.updateUserData(
          widget.id,
          name: newName,
          email: newEmail,
          phoneNumber: newPhoneNo,
          bio: newBio,
        );
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Profile updated successfully')),
      );
      final String id = widget.id;
      if (widget.iskitchen) {
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => ChefHomeScreen(kitchenId: id)),
        );
      } else {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => HomeScreen(uid: id)),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to update profile')),
      );
      print('Error updating profile: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(238, 221, 198, 1),
      appBar: AppBar(
        backgroundColor: Color.fromRGBO(238, 221, 198, 1),
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text(
          'Edit Profile',
          style: TextStyle(
            color: Color.fromRGBO(50, 52, 62, 1),
            fontSize: 20,
            fontWeight: FontWeight.w400,
            fontFamily: 'Poppins',
          ),
        ),
        centerTitle: true,
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  GestureDetector(
                    onTap: _pickImage,
                    child: CircleAvatar(
                      radius: constraints.maxWidth * 0.15,
                      backgroundColor: Colors.grey,
                      backgroundImage: _imageFile != null
                          ? FileImage(_imageFile!)
                          : widget.avatarurl.isNotEmpty
                              ? NetworkImage(widget.avatarurl)
                              : null,
                      child: Stack(
                        children: [
                          Align(
                            alignment: Alignment.bottomRight,
                            child: CircleAvatar(
                              backgroundColor: Colors.red,
                              radius: constraints.maxWidth * 0.05,
                              child: Icon(Icons.edit, color: Colors.white),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: constraints.maxHeight * 0.03),
                  ProfileTextField(
                    label: 'Full Name',
                    controller: nameController,
                  ),
                  SizedBox(height: constraints.maxHeight * 0.03),
                  ProfileTextField(
                    label: 'Email',
                    controller: emailController,
                  ),
                  SizedBox(height: constraints.maxHeight * 0.03),
                  ProfileTextField(
                    label: 'Phone Number',
                    controller: phoneController,
                  ),
                  SizedBox(height: constraints.maxHeight * 0.03),
                  ProfileTextField(
                    label: 'Bio',
                    controller: bioController,
                    maxLines: 3,
                  ),
                  SizedBox(height: constraints.maxHeight * 0.19),
                  ElevatedButton(
                    onPressed: _saveProfile,
                    child: Text('SAVE'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: Colors.black,
                      textStyle: TextStyle(
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.bold,
                      ),
                      padding:
                          EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

// ProfileTextField widget for reusable text field UI
class ProfileTextField extends StatelessWidget {
  final String label;
  final TextEditingController controller;
  final int maxLines;

  const ProfileTextField({
    required this.label,
    required this.controller,
    this.maxLines = 1,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(),
      ),
      maxLines: maxLines,
    );
  }
}
