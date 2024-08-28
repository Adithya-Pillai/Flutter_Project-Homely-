import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/review_screen.dart';
import 'package:flutter_application_1/services/database.dart';

class OrderCard extends StatelessWidget {
  final String imageUrl;
  final String name;
  final String price;
  final String items;
  final String orderId;
  final String? date;
  final String button1Text;
  final String button2Text;
  final String uid;

  const OrderCard({
    required this.imageUrl,
    required this.name,
    required this.price,
    required this.items,
    required this.orderId,
    this.date,
    required this.button1Text,
    required this.button2Text,
    required this.uid,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Image.network(imageUrl,
                    width: 50, height: 50, fit: BoxFit.cover),
                SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        name,
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        'Price:Rs.$price',
                        style: TextStyle(
                          fontFamily: 'Poppins',
                        ),
                      ),
                      if (date != null)
                        Text(
                          'Date:$date',
                          style: TextStyle(
                            fontFamily: 'Poppins',
                          ),
                        ),
                      Text(
                        items,
                        style: TextStyle(
                          fontFamily: 'Poppins',
                        ),
                      ),
                    ],
                  ),
                ),
                Text(
                  orderId,
                  style: TextStyle(
                    color: Colors.grey,
                    fontFamily: 'Poppins',
                  ),
                ),
              ],
            ),
            SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton(
                  onPressed: () async {
                    final kitchenIdFuture =
                        DatabaseService().fetchKitchenIdByName(name);
                    final kid = await kitchenIdFuture;
                    if (button1Text == 'Rate') {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => ReviewScreen(
                                  kitchenId: kid,
                                )),
                      );
                    }
                  },
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Color.fromRGBO(201, 160, 112, 1)),
                  child: Text(
                    button1Text,
                    style: TextStyle(
                      fontFamily: 'Poppins',
                    ),
                  ),
                ),
                OutlinedButton(
                  onPressed: () async {
                    final kitchenIdFuture =
                        DatabaseService().fetchKitchenIdByName(name);
                    final kitchenId = await kitchenIdFuture;
                    if (button2Text == 'Cancel') {
                      DatabaseService().deleteOngoingOrder(uid, orderId);
                      DatabaseService()
                          .deleteOngoingOrderKitchen(kitchenId, orderId);
                    }
                  },
                  child: Text(
                    button2Text,
                    style: TextStyle(
                      fontFamily: 'Poppins',
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
