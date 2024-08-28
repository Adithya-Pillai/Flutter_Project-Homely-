import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_application_1/cart.dart';
import 'package:flutter_application_1/cartprovider.dart';
import 'package:flutter_application_1/widgets/loading.dart';
import 'package:provider/provider.dart';

class RestaurantViewScreen extends StatefulWidget {
  final String kitchenId;
  final String userId;

  const RestaurantViewScreen(
      {Key? key, required this.kitchenId, required this.userId})
      : super(key: key);

  @override
  _RestaurantViewScreenState createState() => _RestaurantViewScreenState();
}

class _RestaurantViewScreenState extends State<RestaurantViewScreen> {
  late Future<DocumentSnapshot<Map<String, dynamic>>> _kitchenFuture;
  List<Map<String, dynamic>> items = [];
  String selectedCategory = 'All';

  @override
  void initState() {
    super.initState();
    _kitchenFuture = _fetchKitchenData();
  }

  Future<DocumentSnapshot<Map<String, dynamic>>> _fetchKitchenData() async {
    try {
      return await FirebaseFirestore.instance
          .collection('kitchens')
          .doc(widget.kitchenId)
          .get();
    } catch (e) {
      print('Error fetching kitchen data: $e');
      rethrow;
    }
  }

  final Color backgroundColor = Color(0xFFF5E6C9);

  void addToCart(CartItem item) {
    final cartProvider = Provider.of<CartProvider>(context, listen: false);
    final cartItem = cartProvider.cartItems.firstWhere(
      (i) => i.productName == item.productName,
      orElse: () => CartItem(
        productName: item.productName,
        productPrice: item.productPrice,
        productImage: item.productImage,
        productStockQuantity: item.productStockQuantity,
        productCartQuantity: 0,
        productDescription: item.productDescription,
      ),
    );

    if (cartItem.productCartQuantity < item.productStockQuantity) {
      cartProvider.addItem(item);
      setState(() {}); // Force the UI to update after adding to the cart
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Cannot add more than available stock'),
        ),
      );
    }
  }

  void selectCategory(String category) {
    setState(() {
      selectedCategory = category;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: backgroundColor,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.brown),
          onPressed: () {
            Provider.of<CartProvider>(context, listen: false).clearCart();
            Navigator.pop(context);
          },
        ),
        title: const Text(
          'Restaurant View',
          style: TextStyle(
            color: Color.fromRGBO(50, 52, 62, 1),
            fontSize: 20,
            fontWeight: FontWeight.w400,
            fontFamily: 'Poppins',
          ),
        ),
        centerTitle: true,
        actions: [
          Padding(
            padding: EdgeInsets.fromLTRB(0, 0, 20, 0),
            child: GestureDetector(
              onTap: () => {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => FoodOrderPage(
                          kitchenId: widget.kitchenId, userId: widget.userId)),
                )
              },
              child: Stack(
                children: [
                  Container(
                    width: 45,
                    height: 45,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage('assets/images/Home/Image2185.png'),
                        fit: BoxFit.fitWidth,
                      ),
                    ),
                  ),
                  Consumer<CartProvider>(
                    builder: (context, cartProvider, child) {
                      return Positioned(
                        right: 0,
                        child: cartProvider.cartItems.isEmpty
                            ? SizedBox.shrink()
                            : Container(
                                padding: EdgeInsets.all(4),
                                decoration: BoxDecoration(
                                  color: Colors.red,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                constraints: BoxConstraints(
                                  minWidth: 20,
                                  minHeight: 20,
                                ),
                                child: Center(
                                  child: Text(
                                    '${cartProvider.cartItems.length}',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 12,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      body: FutureBuilder<DocumentSnapshot<Map<String, dynamic>>>(
        future: _kitchenFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: Loading());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          if (!snapshot.hasData || snapshot.data == null) {
            return Center(child: Text('No data available'));
          }

          final kitchenData = snapshot.data!.data()!;
          items = List<Map<String, dynamic>>.from(kitchenData['items'] ?? []);

          // Extract unique category IDs
          Set<String> uniqueCategories =
              items.map((item) => item['category_id'].toString()).toSet();

          return Container(
            color: backgroundColor,
            child: ListView(
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(8.0),
                        child: Image.network(
                          kitchenData['kitchenimage'] ??
                              'https://firebasestorage.googleapis.com/v0/b/homely-project-8be33.appspot.com/o/placeholder_images%2Fhomely_logo.jpeg?alt=media&token=9089f046-ad45-48c3-8ad6-b3f30c3ee7a5',
                          height: MediaQuery.of(context).size.height * 0.3,
                          width: double.infinity,
                          fit: BoxFit.cover,
                        ),
                      ),
                      SizedBox(height: 16),
                      Text(
                        kitchenData['name'] ?? 'Restaurant Name',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.brown,
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                        kitchenData['bio'] ?? 'Description not available',
                        style: TextStyle(fontSize: 14, color: Colors.brown),
                      ),
                      SizedBox(height: 16),
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: [
                          GestureDetector(
                            onTap: () => selectCategory('All'),
                            child: Chip(
                              label: Text('All'),
                              backgroundColor: selectedCategory == 'All'
                                  ? Colors.red
                                  : Colors.grey[200],
                              labelStyle: TextStyle(
                                color: selectedCategory == 'All'
                                    ? Colors.white
                                    : Colors.black,
                              ),
                            ),
                          ),
                          ...uniqueCategories.map((category) {
                            return GestureDetector(
                              onTap: () => selectCategory(category),
                              child: Chip(
                                label: Text(category),
                                backgroundColor: selectedCategory == category
                                    ? Colors.red
                                    : Colors.grey[200],
                                labelStyle: TextStyle(
                                  color: selectedCategory == category
                                      ? Colors.white
                                      : Colors.black,
                                ),
                              ),
                            );
                          }).toList(),
                        ],
                      ),
                      SizedBox(height: 16),
                      Text(
                        selectedCategory,
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.brown,
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Column(
                    children: items.map((item) {
                      if (selectedCategory == 'All' ||
                          item['category_id'].toString() == selectedCategory) {
                        final stockQuantity =
                            (item['quantity'] as num?)?.toInt() ?? 0;
                        final itemName = item['name'] ?? 'Item Name';
                        final itemImage = item['image_item'] ??
                            'https://firebasestorage.googleapis.com/v0/b/homely-project-8be33.appspot.com/o/placeholder_images%2Fhomely_logo.jpeg?alt=media&token=9089f046-ad45-48c3-8ad6-b3f30c3ee7a5';
                        final itemPrice = (item['price'] is double)
                            ? item['price'] as double
                            : double.tryParse(item['price'].toString()) ?? 0.0;

                        final itemDescription =
                            item['description'] ?? 'Description not available';

                        final cartItem = CartItem(
                          productName: itemName,
                          productPrice: itemPrice,
                          productImage: itemImage,
                          productStockQuantity: stockQuantity,
                          productCartQuantity: 0,
                          productDescription: itemDescription,
                        );

                        return Card(
                          margin: EdgeInsets.fromLTRB(0, 8, 8, 0),
                          child: ListTile(
                            contentPadding: EdgeInsets.symmetric(
                                horizontal: 8, vertical: 8),
                            leading: SizedBox(
                              width: 60,
                              height: 60,
                              child: Image.network(
                                itemImage,
                                fit: BoxFit.cover,
                              ),
                            ),
                            title: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  itemName,
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.brown,
                                  ),
                                ),
                                SizedBox(height: 4),
                                Text(
                                  stockQuantity > 0
                                      ? 'Stock: $stockQuantity'
                                      : 'Out of Stock',
                                  style: TextStyle(
                                    color: stockQuantity > 0
                                        ? Colors.brown
                                        : Colors.red,
                                    fontSize: 14,
                                    fontWeight: stockQuantity > 0
                                        ? FontWeight.normal
                                        : FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  '\Rs.${itemPrice.toStringAsFixed(2)}',
                                  style: TextStyle(color: Colors.brown),
                                ),
                                SizedBox(height: 4),
                                Text(
                                  itemDescription,
                                  style: TextStyle(
                                    color: Colors.grey[600],
                                    fontSize: 12,
                                  ),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            ),
                            trailing: SizedBox(
                              width: 96,
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  IconButton(
                                    icon: Icon(Icons.remove, color: Colors.red),
                                    onPressed: () {
                                      Provider.of<CartProvider>(context,
                                              listen: false)
                                          .removeItem(itemName);
                                    },
                                  ),
                                  Expanded(
                                    child: Consumer<CartProvider>(
                                      builder: (context, cartProvider, child) {
                                        final cartItem =
                                            cartProvider.cartItems.firstWhere(
                                          (item) =>
                                              item.productName == itemName,
                                          orElse: () => CartItem(
                                            productName: itemName,
                                            productPrice: itemPrice,
                                            productImage: itemImage,
                                            productStockQuantity: stockQuantity,
                                            productCartQuantity: 0,
                                            productDescription: itemDescription,
                                          ),
                                        );
                                        final quantity =
                                            cartItem.productCartQuantity;
                                        return Text(
                                          '$quantity',
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: Colors.brown,
                                          ),
                                        );
                                      },
                                    ),
                                  ),
                                  IconButton(
                                    icon: Icon(Icons.add, color: Colors.green),
                                    onPressed: () {
                                      if (cartItem.productCartQuantity <=
                                          stockQuantity) addToCart(cartItem);
                                    },
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      } else {
                        return SizedBox.shrink();
                      }
                    }).toList(),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
