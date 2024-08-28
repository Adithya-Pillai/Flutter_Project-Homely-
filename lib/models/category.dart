import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Category {
  final String label;
  final String imagePath;
  final String description;

  Category({
    required this.label,
    required this.imagePath,
    required this.description,
  });
}

Future<List<Category>> getCategoriesFromFirestore() async {
  List<Category> categories = [];

  try {
    QuerySnapshot querySnapshot =
        await FirebaseFirestore.instance.collection('categories').get();

    querySnapshot.docs.forEach((doc) {
      Map<String, dynamic> categoryDetails =
          doc.data() as Map<String, dynamic>; // Explicit cast
      String label = doc.id; // Assuming the category label is the document ID
      String imagePath = categoryDetails['image'];
      String description = categoryDetails['description'];

      categories.add(Category(
        label: label,
        imagePath: imagePath,
        description: description,
      ));
    });

    return categories;
  } catch (e) {
    print('Error getting categories: $e');
    return [];
  }
}
