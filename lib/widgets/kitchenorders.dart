import 'package:flutter/material.dart';
import 'package:flutter_application_1/review_screen.dart';
import 'package:flutter_application_1/services/database.dart';

class KitchenOrderCard extends StatelessWidget {
  final String imageUrl;
  final String name;
  final String price;
  final String
      items; // This will now be a formatted string of item names and quantities
  final String orderId;
  final String? date;
  final String button1Text;
  final String button2Text;
  final String uid;

  const KitchenOrderCard({
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
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.network(
                    imageUrl,
                    width: 50,
                    height: 50,
                    fit: BoxFit.cover,
                  ),
                ),
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
                          fontSize: 16,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        'Total: Rs.$price',
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 14,
                        ),
                      ),
                      if (date != null)
                        Text(
                          'Date: $date',
                          style: TextStyle(
                            fontFamily: 'Poppins',
                            fontSize: 14,
                          ),
                        ),
                    ],
                  ),
                ),
                SizedBox(width: 8),
                Expanded(
                  child: Text(
                    orderId,
                    style: TextStyle(
                      color: Colors.grey,
                      fontFamily: 'Poppins',
                      fontSize: 14,
                    ),
                    textAlign: TextAlign.right,
                  ),
                ),
              ],
            ),
            SizedBox(height: 16),
            Text(
              'Items:',
              style: TextStyle(
                fontFamily: 'Poppins',
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
            ),
            SizedBox(height: 8),
            // Wrap the items text in a Column to handle long lists
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: items
                  .split(', ')
                  .map((item) => Padding(
                        padding: const EdgeInsets.only(bottom: 4.0),
                        child: Text(
                          item,
                          style: TextStyle(
                            fontFamily: 'Poppins',
                            fontSize: 14,
                            color: Colors.black87,
                          ),
                        ),
                      ))
                  .toList(),
            ),
            SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton(
                  onPressed: () {
                    if (button1Text == 'Prepared') {
                      DatabaseService().fetchUserIdByName(name).then((value) {
                        DatabaseService()
                            .moveOrderToHistory(uid, orderId, value);
                      });
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color.fromRGBO(201, 160, 112, 1),
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: Text(
                    button1Text,
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 14,
                    ),
                  ),
                ),
                OutlinedButton(
                  onPressed: () async {
                    if (button2Text == 'Cancel') {
                      DatabaseService().deleteOngoingOrderKitchen(uid, orderId);
                      DatabaseService().fetchUserIdByName(name).then((value) {
                        DatabaseService().deleteOngoingOrder(value, orderId);
                      });
                    }
                  },
                  style: OutlinedButton.styleFrom(
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: Text(
                    button2Text,
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 14,
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
