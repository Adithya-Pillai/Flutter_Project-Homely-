import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/chefhome.dart';
import 'package:image_picker/image_picker.dart'; // Import image_picker package
import 'package:cloud_firestore/cloud_firestore.dart'; // Import Firestore package
import 'dart:io';
import 'foodlist.dart';

class AddNewItemScreen extends StatefulWidget {
  final String kitchenid;

  AddNewItemScreen({required this.kitchenid});
  @override
  _AddNewItemScreenState createState() => _AddNewItemScreenState();
}

class _AddNewItemScreenState extends State<AddNewItemScreen> {
  final Color backgroundColor = Color(0xFFEEDDC6);
  final Color bottomBarColor = Color(0xFF3C260C);
  String? _selectedCategory;
  XFile? _selectedImage; // Variable to store the selected image

  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _quantityController = TextEditingController();
  final TextEditingController _nameController =
      TextEditingController(); // Controller for item name
  final TextEditingController _descriptionController =
      TextEditingController(); // Controller for description

  final ImagePicker _picker = ImagePicker(); // Instance of ImagePicker
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  void _resetSelections() {
    setState(() {
      _selectedCategory = null;
      _selectedImage = null;
      _nameController.clear();
      _priceController.clear();
      _quantityController.clear();
      _descriptionController.clear();
    });
  }

  void _toggleSelection(String category) {
    setState(() {
      if (_selectedCategory == category) {
        _selectedCategory = null;
      } else {
        _selectedCategory = category;
      }
    });
  }

  Color _getChipColor(String category) {
    if (_selectedCategory == category) {
      return Colors.brown[400]!;
    } else {
      return Colors.brown[100]!;
    }
  }

  Future<void> _pickImage() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    setState(() {
      _selectedImage = image;
    });
  }

  Future<void> _submitItem() async {
    print("Submit button pressed");

    String itemId = DateTime.now().millisecondsSinceEpoch.toString();
    String itemName = _nameController.text.trim();
    String description = _descriptionController.text.trim();

    if (itemName.isEmpty ||
        _priceController.text.isEmpty ||
        _quantityController.text.isEmpty ||
        _selectedCategory == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please fill out all fields.')),
      );
      return;
    }

    String? imageUrl;
    if (_selectedImage == null) print("Empty");
    if (_selectedImage != null) {
      try {
        Reference ref =
            FirebaseStorage.instance.ref().child('item_images/$itemId');
        await ref.putFile(File(_selectedImage!.path));
        imageUrl = await ref.getDownloadURL();
        print('Image URL: $imageUrl'); // Debug print
      } catch (e) {
        print('Error uploading image: $e');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error uploading image.')),
        );
        return;
      }
    }

    try {
      DocumentReference kitchenRef =
          _firestore.collection('kitchens').doc(widget.kitchenid);
      DocumentSnapshot kitchenDoc = await kitchenRef.get();
      List<dynamic> items = List.from(kitchenDoc['items']);

      bool itemFound = false;
      for (var item in items) {
        if (item['item_id'] == itemId) {
          item['quantity'] = (item['quantity'] ?? 0) + 1;
          itemFound = true;
          break;
        }
      }

      if (!itemFound) {
        items.add({
          'item_id': itemId,
          'name': itemName,
          'price': double.tryParse(_priceController.text) ?? 0.0,
          'category_id': _selectedCategory,
          'description': description,
          'quantity': int.tryParse(_quantityController.text) ?? 0,
          'image_item': imageUrl ?? 'assets/images/default_image.png',
        });
      }

      await kitchenRef.update({'items': items});
      print('Item submitted successfully!');

      Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => ChefHomeScreen(
                  kitchenId: widget.kitchenid,
                )),
      );
    } catch (e) {
      print('Error submitting item: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error submitting item.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: backgroundColor,
        elevation: 0,
        automaticallyImplyLeading: false, // Remove back arrow
        title: Text('Add New Items', style: TextStyle(color: Colors.brown)),
        actions: [
          TextButton(
            onPressed: _resetSelections,
            child: Text(
              'RESET',
              style: TextStyle(color: Colors.brown),
            ),
          ),
        ],
      ),
      body: Container(
        color: backgroundColor,
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ListTile(
                title: Text('ITEM NAME',
                    style: TextStyle(fontSize: 16, color: Colors.brown)),
                subtitle: TextField(
                  controller: _nameController,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.white,
                    hintText: 'Idli/Dosa/...',
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
              ListTile(
                title: Text('UPLOAD PHOTO',
                    style: TextStyle(fontSize: 16, color: Colors.brown)),
                subtitle: GestureDetector(
                  onTap: _pickImage,
                  child: Container(
                    width: 100,
                    height: 100,
                    color: Colors.grey[200],
                    child: Center(
                      child: _selectedImage == null
                          ? Icon(Icons.add,
                              color: Color.fromARGB(255, 231, 185, 130))
                          : Image.file(File(_selectedImage!.path),
                              fit: BoxFit.cover),
                    ),
                  ),
                ),
              ),
              ListTile(
                title: Text('Details',
                    style: TextStyle(fontSize: 16, color: Colors.brown)),
                subtitle: Row(
                  children: [
                    Expanded(
                      flex: 2,
                      child: TextField(
                        controller: _priceController,
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: Colors.white,
                          border: OutlineInputBorder(),
                          hintText: 'Enter price',
                        ),
                        keyboardType:
                            TextInputType.numberWithOptions(decimal: true),
                      ),
                    ),
                    SizedBox(width: 16),
                    Expanded(
                      flex: 1,
                      child: TextField(
                        controller: _quantityController,
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: Colors.white,
                          border: OutlineInputBorder(),
                          hintText: 'Qty',
                        ),
                        keyboardType: TextInputType.number,
                      ),
                    ),
                  ],
                ),
              ),
              ListTile(
                title: Text('Category',
                    style: TextStyle(fontSize: 16, color: Colors.brown)),
                subtitle: Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    _buildSelectableChip(
                        'South Indian', 'assets/images/icons/peppers.png'),
                    _buildSelectableChip(
                        'North Indian', 'assets/images/icons/chicken.png'),
                    _buildSelectableChip(
                        'Snacks', 'assets/images/icons/walnut.png'),
                    _buildSelectableChip(
                        'Beverages', 'assets/images/icons/beverages.jpg'),
                    _buildSelectableChip(
                        'Sweets', 'assets/images/icons/sweets.png'),
                  ],
                ),
              ),
              ListTile(
                title: Text('Description',
                    style: TextStyle(fontSize: 16, color: Colors.brown)),
                subtitle: TextField(
                  controller: _descriptionController,
                  maxLines: 1,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
              Center(
                child: ElevatedButton(
                  onPressed: _submitItem,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red, // Background color
                    foregroundColor: Colors.white, // Text color
                    padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: Text('Submit', style: TextStyle(fontSize: 16)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSelectableChip(String label, String iconPath) {
    return GestureDetector(
      onTap: () => _toggleSelection(label),
      child: Chip(
        label: Text(label),
        backgroundColor: _getChipColor(label),
        avatar: Image.asset(iconPath, width: 24, height: 24),
      ),
    );
  }
}
