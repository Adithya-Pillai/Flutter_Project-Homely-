import 'package:flutter/material.dart';
import 'package:flutter_application_1/cartprovider.dart';
import 'package:flutter_application_1/congratulations.dart';
import 'package:flutter_application_1/payment2.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_application_1/services/database.dart';
import 'package:flutter_application_1/widgets/loading.dart';

class Androidlarge21Widget extends StatefulWidget {
  final List<CartItem> cartItems;
  final String kitchenId;
  final double total;
  final String userId;

  const Androidlarge21Widget({
    Key? key,
    required this.cartItems,
    required this.kitchenId,
    required this.total,
    required this.userId,
  }) : super(key: key);

  @override
  _Androidlarge21WidgetState createState() => _Androidlarge21WidgetState();
}

class _Androidlarge21WidgetState extends State<Androidlarge21Widget> {
  bool _showUPIInput = false;
  bool _isLoading = false; // New variable to manage loading state

  void _toggleUPIInput() {
    setState(() {
      _showUPIInput = !_showUPIInput;
    });
  }

  Future<void> _navigateToCongratulationsPage() async {
    setState(() {
      _isLoading = true; // Show the loader
    });

    try {
      // Fetch kitchen and user names asynchronously
      final kitchenNameFuture =
          DatabaseService().fetchKitchenName(widget.kitchenId);
      final userNameFuture = DatabaseService().fetchUserName(widget.userId);
      final kitchenimageUrlFuture =
          DatabaseService().fetchImageurlkitchen(widget.kitchenId);
      final userimageUrlFuture =
          DatabaseService().fetchImageurluser(widget.userId);

      // Wait for both futures to complete
      final kitchenName = await kitchenNameFuture;
      final userName = await userNameFuture;
      final kitchenUrl = await kitchenimageUrlFuture;
      final userUrl = await userimageUrlFuture;

      // Generate a unique order ID using the current timestamp
      final orderId = DateTime.now().millisecondsSinceEpoch.toString();

      // Prepare the order data for the kitchen
      final orderDataKitchen = {
        'order_id': orderId,
        'status': 'ongoing',
        'items': widget.cartItems
            .map((item) => {
                  'item_name': item.productName,
                  'quantity': item.productCartQuantity,
                })
            .toList(),
        'imageUrl': userUrl,
        'customer_name': userName,
        'price': '${widget.total.toStringAsFixed(2)}',
        'date': DateTime.now().toIso8601String(),
        'button1Text': 'Prepared',
        'button2Text': 'Cancel',
      };

      // Prepare the order data for the user
      final orderData = {
        'order_id': orderId,
        'status': 'ongoing',
        'items': widget.cartItems
            .map((item) => {
                  'item_name': item.productName,
                  'quantity': item.productCartQuantity,
                })
            .toList(),
        'imageUrl': kitchenUrl,
        'kitchen_name': kitchenName,
        'price': '${widget.total.toStringAsFixed(2)}',
        'date': DateTime.now().toIso8601String(),
        'button1Text': 'Track',
        'button2Text': 'Cancel',
      };

      // Firestore transaction to update user and kitchen order and items
      await FirebaseFirestore.instance.runTransaction((transaction) async {
        // Reference to kitchen and user documents
        DocumentReference kitchenDocRef = FirebaseFirestore.instance
            .collection('kitchens')
            .doc(widget.kitchenId);
        DocumentReference userDocRef =
            FirebaseFirestore.instance.collection('users').doc(widget.userId);

        // Fetch the current data for the kitchen
        DocumentSnapshot kitchenSnapshot = await transaction.get(kitchenDocRef);

        if (!kitchenSnapshot.exists) {
          throw Exception("Kitchen does not exist");
        }

        // Get the kitchen's items
        List<dynamic> kitchenItems =
            List<dynamic>.from(kitchenSnapshot['items'] ?? []);

        // Loop through cart items and update the quantities in the kitchen's items
        for (var cartItem in widget.cartItems) {
          String itemName = cartItem.productName;
          int orderedQuantity = cartItem.productCartQuantity;

          // Find the corresponding item in the kitchen's items and update its quantity
          for (var kitchenItem in kitchenItems) {
            if (kitchenItem['name'] == itemName) {
              kitchenItem['quantity'] -=
                  orderedQuantity; // Decrease the quantity
              if (kitchenItem['quantity'] < 0) {
                kitchenItem['quantity'] =
                    0; // Ensure quantity doesn't go below zero
              }
              break;
            }
          }
        }

        // Update the kitchen's ongoing orders and items in Firestore
        transaction.update(kitchenDocRef, {
          'ongoing_orders': FieldValue.arrayUnion([orderDataKitchen]),
          'items':
              kitchenItems, // Update the items with the modified quantities
        });

        // Update the user's ongoing orders in Firestore
        transaction.update(userDocRef, {
          'ongoing_orders': FieldValue.arrayUnion([orderData]),
        });
      });

      // Navigate to the Congratulations page
      Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => CongratulationsPage(userId: widget.userId)),
      );
    } catch (e) {
      print('Error navigating to Congratulations page: $e');
      // Optionally, handle the error by showing a message to the user
    } finally {
      setState(() {
        _isLoading = false; // Hide the loader
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final screenWidth = mediaQuery.size.width;
    final screenHeight = mediaQuery.size.height;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromRGBO(238, 221, 198, 1),
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text(
          'Payment',
          style: TextStyle(
            color: Color.fromRGBO(50, 52, 62, 1),
            fontSize: 20,
            fontWeight: FontWeight.w400,
            fontFamily: 'Poppins',
          ),
        ),
        centerTitle: true,
      ),
      backgroundColor: Color(0xFFEEE0C6),
      body: _isLoading
          ? Center(
              child: Loading(),
            )
          : SingleChildScrollView(
              padding: EdgeInsets.symmetric(
                horizontal: screenWidth * 0.05,
                vertical: screenHeight * 0.03,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: screenHeight * 0.03),
                  Text(
                    'You are almost there...Choose your payment method',
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: screenWidth * 0.07,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  SizedBox(height: screenHeight * 0.03),
                  paymentMethodItem(
                      context, 'Visa', 'assets/images/payment1/visa.png'),
                  GestureDetector(
                    onTap: _toggleUPIInput,
                    child: paymentMethodItem(context, 'UPI Payment',
                        'assets/images/payment1/upi.png'),
                  ),
                  if (_showUPIInput) ...[
                    SizedBox(height: screenHeight * 0.02),
                    TextField(
                      decoration: InputDecoration(
                        labelText: 'Enter UPI ID',
                        border: OutlineInputBorder(),
                      ),
                      keyboardType: TextInputType.emailAddress,
                    ),
                  ],
                  SizedBox(height: screenHeight * 0.02),
                  GestureDetector(
                    onTap: _navigateToCongratulationsPage,
                    child: paymentMethodItem(context, 'Cash on Delivery',
                        'assets/images/payment1/cash.png'),
                  ),
                  SizedBox(height: screenHeight * 0.03),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Total',
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: screenWidth * 0.045,
                          color: Color(0xFF5B645F),
                        ),
                      ),
                      Row(
                        children: [
                          Image.asset(
                            'assets/images/payment1/rupee.png',
                            width: screenWidth * 0.06,
                            height: screenWidth * 0.06,
                            semanticLabel: 'currency_rupee',
                          ),
                          SizedBox(width: screenWidth * 0.01),
                          Text(
                            '${widget.total.toStringAsFixed(2)}',
                            style: TextStyle(
                              fontFamily: 'Poppins',
                              fontSize: screenWidth * 0.045,
                              color: Color(0xFF5B645F),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  SizedBox(height: screenHeight * 0.03),
                ],
              ),
            ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: ElevatedButton(
        onPressed: _navigateToCongratulationsPage,
        style: ElevatedButton.styleFrom(
          backgroundColor: Color(0xFFC9A070),
          padding: EdgeInsets.symmetric(
            vertical: screenHeight * 0.02,
            horizontal: screenWidth * 0.1,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        child: Text(
          'PAY & CONFIRM YOUR ORDER',
          style: TextStyle(
            fontFamily: 'Poppins',
            fontSize: screenWidth * 0.045,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  Widget paymentMethodItem(BuildContext context, String title, String asset) {
    final mediaQuery = MediaQuery.of(context);
    final screenWidth = mediaQuery.size.width;

    return Padding(
      padding: EdgeInsets.symmetric(vertical: screenWidth * 0.02),
      child: GestureDetector(
        onTap: () {
          if (title == 'Visa') {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const CardDetailsPage()),
            );
          } else if (title == 'UPI Payment') {
            _toggleUPIInput();
          } else if (title == 'Cash on Delivery') {
            _navigateToCongratulationsPage();
          }
        },
        child: Row(
          children: [
            Image.asset(
              asset,
              width: screenWidth * 0.09,
              height: screenWidth * 0.09,
            ),
            SizedBox(width: screenWidth * 0.04),
            Expanded(
              child: Text(
                title,
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: screenWidth * 0.045,
                  color: Color(0xFF1F1F1F),
                ),
              ),
            ),
            Icon(Icons.arrow_forward_ios, size: screenWidth * 0.04),
          ],
        ),
      ),
    );
  }
}
