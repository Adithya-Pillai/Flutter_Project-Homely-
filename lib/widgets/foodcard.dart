import 'package:flutter/material.dart';

class FoodCard extends StatelessWidget {
  final String imageUrl;
  final String name;
  final String price;
  final String description;
  final String quantity;
  final String documentId;
  final VoidCallback onDelete;
  final VoidCallback onIncrement;

  FoodCard({
    required this.imageUrl,
    required this.name,
    required this.price,
    required this.description,
    required this.quantity,
    required this.documentId,
    required this.onDelete,
    required this.onIncrement,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 8.0),
      child: ListTile(
        leading: Image.network(imageUrl),
        title: Text(name),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(description),
            Text('Price: \Rs.${price}'),
            Text('Quantity: ${quantity}'),
          ],
        ),
        trailing: PopupMenuButton<String>(
          onSelected: (value) {
            if (value == 'delete') {
              onDelete();
            } else if (value == 'increment') {
              onIncrement();
            }
          },
          itemBuilder: (context) => [
            PopupMenuItem<String>(
              value: 'increment',
              child: Text('Increment Quantity'),
            ),
            PopupMenuItem<String>(
              value: 'delete',
              child: Text('Delete Item'),
            ),
          ],
        ),
        contentPadding: EdgeInsets.all(16.0),
      ),
    );
  }
}
