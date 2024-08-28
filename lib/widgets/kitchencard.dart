import 'package:flutter/material.dart';
import 'package:flutter_application_1/RestaurantViewScreen.dart';
import 'package:flutter_application_1/cartprovider.dart';
import 'package:flutter_application_1/models/kitchen.dart';
import 'package:flutter_application_1/review_screen.dart';
import 'package:flutter_application_1/services/database.dart';
import 'package:flutter_application_1/widgets/loading.dart';
import 'package:provider/provider.dart';

class TopRatedKitchenList extends StatelessWidget {
  final String userId;
  TopRatedKitchenList({required this.userId});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Kitchen>>(
      future: DatabaseService().fetchKitchensFromFirestore(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: Loading());
        }

        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }

        List<Kitchen>? kitchens = snapshot.data;

        if (kitchens == null || kitchens.isEmpty) {
          return Center(child: Text('No kitchens found.'));
        }

        return Padding(
          padding: const EdgeInsets.fromLTRB(8, 0, 8, 8),
          child: SingleChildScrollView(
            child: Column(
              children: kitchens.map((kitchen) {
                return TopRatedKitchenCard(kitchen: kitchen, userId: userId);
              }).toList(),
            ),
          ),
        );
      },
    );
  }
}

class TopRatedKitchenCard extends StatelessWidget {
  final Kitchen kitchen;
  final String userId;

  const TopRatedKitchenCard(
      {Key? key, required this.kitchen, required this.userId})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Provider.of<CartProvider>(context, listen: false).clearCart();
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => RestaurantViewScreen(
                    kitchenId: kitchen.kid,
                    userId: userId,
                  )),
        );
      },
      child: Card(
        margin: const EdgeInsets.symmetric(vertical: 8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Image.network(
              kitchen.kitchenImage,
              width: double.infinity,
              height: 200,
              fit: BoxFit.cover,
            ),
            ListTile(
              title: Text(
                kitchen.name,
                style: const TextStyle(
                  color: Color.fromRGBO(50, 52, 62, 1),
                  fontSize: 20,
                  fontWeight: FontWeight.w400,
                  fontFamily: 'Poppins',
                ),
              ),
              subtitle: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      kitchen.subtitle,
                      style: const TextStyle(
                        fontFamily: 'Poppins',
                        color: Color.fromRGBO(160, 165, 186, 1),
                      ),
                    ),
                  ),
                  Row(
                    children: [
                      Text(
                        kitchen.rating.toStringAsFixed(1),
                        style: const TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 16,
                          color: Color.fromRGBO(50, 52, 62, 1),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(width: 4),
                      const Icon(
                        Icons.star,
                        color: Colors.amber,
                        size: 18,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
