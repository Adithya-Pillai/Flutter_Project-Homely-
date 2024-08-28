import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_application_1/services/database.dart';
import 'package:flutter_application_1/widgets/foodcard.dart';
import 'package:flutter_application_1/widgets/loading.dart';
import 'AddNewItemScreen.dart';

class FoodListScreen extends StatefulWidget {
  final String kitchenid;

  FoodListScreen({required this.kitchenid});

  @override
  _FoodListScreenState createState() => _FoodListScreenState();
}

class _FoodListScreenState extends State<FoodListScreen> {
  Future<void> _deleteItem(String documentIdFieldValue) async {
    try {
      // Fetch all kitchen documents
      QuerySnapshot querySnapshot =
          await FirebaseFirestore.instance.collection('kitchens').get();

      // Iterate over each kitchen document
      for (var doc in querySnapshot.docs) {
        String kitchenId = doc.id; // Use the document ID as the kitchen ID
        List items = List.from(doc['items']); // Make a copy of the items list

        // Find and remove the item with the specified ID
        items.removeWhere((item) => item['item_id'] == documentIdFieldValue);

        // Update the document with the modified items list
        await FirebaseFirestore.instance
            .collection('kitchens')
            .doc(kitchenId)
            .update({'items': items});
      }
      print('Item deleted successfully');
      setState(() {}); // Refresh the list after deletion
    } catch (e) {
      print('Error deleting item: $e');
    }
  }

  Future<void> _incrementQuantity(String documentIdFieldValue) async {
    try {
      // Fetch all kitchen documents
      QuerySnapshot querySnapshot =
          await FirebaseFirestore.instance.collection('kitchens').get();

      // Iterate over each kitchen document
      for (var doc in querySnapshot.docs) {
        String kitchenId = doc.id; // Use the document ID as the kitchen ID
        List items = List.from(doc['items']); // Make a copy of the items list

        // Find the item with the specified ID and increment its quantity
        bool itemFound = false;
        for (var item in items) {
          if (item['item_id'] == documentIdFieldValue) {
            // Increment the quantity
            item['quantity'] = (item['quantity'] ?? 0) + 1;
            itemFound = true;
            break;
          }
        }

        if (itemFound) {
          // Update the document with the modified items list
          await FirebaseFirestore.instance
              .collection('kitchens')
              .doc(kitchenId)
              .update({'items': items});

          print('Item quantity incremented successfully');
        }
      }
      setState(() {}); // Refresh the list after incrementing
    } catch (e) {
      print('Error incrementing quantity: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('My Food List'),
        backgroundColor: Color(0xFFEEDDC6),
        automaticallyImplyLeading: false,
      ),
      body: Container(
        color: Color(0xFFEEDDC6),
        child: FutureBuilder<List<Map<String, dynamic>>>(
          future: DatabaseService().getFoodList(widget.kitchenid, _deleteItem),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              print("Error in snapshot: ${snapshot.error}");
              return Center(
                child: Text('Error: ${snapshot.error}'),
              );
            }

            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: const Loading(),
              );
            }

            if (!snapshot.hasData || snapshot.data!.isEmpty) {
              print("Snapshot data is empty");
              return Center(
                child: Text('No items found'),
              );
            }

            // Display the list of FoodCards
            return ListView.builder(
              padding: EdgeInsets.all(16.0),
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                final item = snapshot.data![index];
                return FoodCard(
                  imageUrl: item['imageUrl'],
                  name: item['name'],
                  price: item['price'],
                  description: item['description'],
                  quantity: item['quantity'],
                  documentId: item['documentId'],
                  onDelete: () => _deleteItem(item['documentId']),
                  onIncrement: () => _incrementQuantity(item['documentId']),
                );
              },
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) =>
                    AddNewItemScreen(kitchenid: widget.kitchenid)),
          );
        },
        child: Icon(Icons.add),
        backgroundColor: Color.fromARGB(255, 231, 185, 130),
      ),
    );
  }
}
