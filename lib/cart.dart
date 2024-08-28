import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:flutter_application_1/cartprovider.dart';
import 'package:flutter_application_1/payment1.dart';
import 'package:get/get.dart';

class FoodOrderPage extends StatefulWidget {
  final String kitchenId;
  final String userId;

  const FoodOrderPage({Key? key, required this.kitchenId, required this.userId})
      : super(key: key);

  @override
  _FoodOrderPageState createState() => _FoodOrderPageState();
}

class _FoodOrderPageState extends State<FoodOrderPage> {
  @override
  Widget build(BuildContext context) {
    final cartProvider = Provider.of<CartProvider>(context);

    double totalAmount = cartProvider.cartItems.fold(
      0,
      (previousValue, item) =>
          previousValue + (item.productPrice * item.productCartQuantity),
    );

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromRGBO(238, 221, 198, 1),
        elevation: 0,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: Color(0xFF3a3737),
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Center(
          child: Text(
            "Cart",
            style: TextStyle(
              color: Color(0xFF3a3737),
              fontWeight: FontWeight.w600,
              fontSize: 20,
              fontFamily: 'Poppins',
            ),
          ),
        ),
        systemOverlayStyle: SystemUiOverlayStyle.dark,
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          double screenWidth = constraints.maxWidth;
          double screenHeight = constraints.maxHeight;

          return Container(
            color: Color.fromRGBO(238, 221, 198, 1),
            padding: EdgeInsets.all(screenWidth * 0.03), // Dynamic padding
            child: ListView(
              children: <Widget>[
                // Center the section title to fix alignment
                Center(
                  child: SectionTitle(
                    title: "Your Food Cart",
                    screenWidth: screenWidth,
                  ),
                ),
                SizedBox(
                    height: screenHeight * 0.02), // Dynamic vertical spacing

                ...cartProvider.cartItems.map((item) {
                  return CartItemWidget(
                    item: item,
                    screenWidth: screenWidth,
                    onRemove: () {
                      if (item.productCartQuantity > 0) {
                        cartProvider.updateQuantity(
                            item.productName, item.productCartQuantity - 1);
                      }
                    },
                    onAdd: () {
                      if (item.productCartQuantity <
                          item.productStockQuantity) {
                        cartProvider.updateQuantity(
                            item.productName, item.productCartQuantity + 1);
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content:
                                Text('Cannot add more than available stock'),
                          ),
                        );
                      }
                    },
                  );
                }).toList(),

                SizedBox(height: screenHeight * 0.02),
                PromoCodeWidget(screenWidth: screenWidth),
                SizedBox(height: screenHeight * 0.02),
                TotalCalculationWidget(
                  cartItems: cartProvider.cartItems,
                  screenWidth: screenWidth,
                ),
                SizedBox(height: screenHeight * 0.02),
                SectionTitle(
                  title: "Payment Method",
                  screenWidth: screenWidth,
                ),
                SizedBox(height: screenHeight * 0.02),
                PaymentMethodWidget(
                  screenWidth: screenWidth,
                  cartItems: cartProvider.cartItems,
                  kitchenId: widget.kitchenId,
                  total: totalAmount,
                  userId: widget.userId,
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class SectionTitle extends StatelessWidget {
  final String title;
  final double screenWidth;

  SectionTitle({required this.title, required this.screenWidth});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: screenWidth * 0.01),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 20,
          color: Color(0xFF3a3a3b),
          fontWeight: FontWeight.w600,
          fontFamily: 'Poppins',
        ),
      ),
    );
  }
}

class PaymentMethodWidget extends StatelessWidget {
  final double screenWidth;
  final List<CartItem> cartItems;
  final String kitchenId;
  final double total;
  final String userId;

  PaymentMethodWidget({
    required this.screenWidth,
    required this.cartItems,
    required this.kitchenId,
    required this.total,
    required this.userId,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: screenWidth * 0.15,
      decoration: BoxDecoration(boxShadow: [
        BoxShadow(
          color: Color(0xFFfae3e2).withOpacity(0.1),
          spreadRadius: 1,
          blurRadius: 1,
          offset: Offset(0, 1),
        ),
      ]),
      child: GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => Androidlarge21Widget(
                cartItems: cartItems,
                kitchenId: kitchenId,
                total: total,
                userId: userId,
              ),
            ),
          );
        },
        child: Card(
          color: Colors.white,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(5.0),
          ),
          child: Container(
            alignment: Alignment.center,
            padding: EdgeInsets.symmetric(
              horizontal: screenWidth * 0.03,
              vertical: screenWidth * 0.01,
            ),
            child: Row(
              children: <Widget>[
                Image.asset(
                  "assets/images/Home/credit.png",
                  width: screenWidth * 0.12,
                  height: screenWidth * 0.12,
                ),
                SizedBox(width: screenWidth * 0.02),
                Text(
                  "Go to Payment",
                  style: TextStyle(
                    fontSize: screenWidth * 0.04,
                    color: Color(0xFF3a3a3b),
                    fontWeight: FontWeight.w400,
                    fontFamily: 'Poppins',
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class TotalCalculationWidget extends StatelessWidget {
  final List<CartItem> cartItems;
  final double screenWidth;

  TotalCalculationWidget({required this.cartItems, required this.screenWidth});

  @override
  Widget build(BuildContext context) {
    double total = cartItems.fold(
      0,
      (previousValue, item) =>
          previousValue + (item.productPrice * item.productCartQuantity),
    );

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(boxShadow: [
        BoxShadow(
          color: Color(0xFFfae3e2).withOpacity(0.1),
          spreadRadius: 1,
          blurRadius: 1,
          offset: Offset(0, 1),
        ),
      ]),
      child: Card(
        color: Colors.white,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(5.0),
        ),
        child: Container(
          padding: EdgeInsets.symmetric(
              horizontal: screenWidth * 0.03, vertical: screenWidth * 0.01),
          child: Column(
            children: <Widget>[
              SizedBox(height: screenWidth * 0.015),
              ...cartItems.map((item) {
                return CalculationRow(
                  itemName: item.productName,
                  itemPrice:
                      "Rs. ${(item.productPrice * item.productCartQuantity).toStringAsFixed(2)}",
                  screenWidth: screenWidth,
                  onRemove: () {
                    final cartProvider =
                        Provider.of<CartProvider>(context, listen: false);
                    if (item.productCartQuantity > 0) {
                      cartProvider.updateQuantity(
                          item.productName, item.productCartQuantity - 1);
                    }
                  },
                  onAdd: () {
                    final cartProvider =
                        Provider.of<CartProvider>(context, listen: false);
                    if (item.productCartQuantity < item.productStockQuantity) {
                      cartProvider.updateQuantity(
                          item.productName, item.productCartQuantity + 1);
                    }
                  },
                );
              }).toList(),
              SizedBox(height: screenWidth * 0.015),
              CalculationRow(
                itemName: "Total",
                itemPrice: "Rs. ${total.toStringAsFixed(2)}",
                isTotal: true,
                screenWidth: screenWidth,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class CalculationRow extends StatelessWidget {
  final String itemName;
  final String itemPrice;
  final bool isTotal;
  final double screenWidth;
  final VoidCallback? onRemove;
  final VoidCallback? onAdd;

  CalculationRow({
    required this.itemName,
    required this.itemPrice,
    required this.screenWidth,
    this.isTotal = false,
    this.onRemove,
    this.onAdd,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: screenWidth * 0.005),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Text(
            itemName,
            style: TextStyle(
              fontSize: isTotal ? screenWidth * 0.05 : screenWidth * 0.035,
              color: Color(0xFF3a3a3b),
              fontWeight: isTotal ? FontWeight.bold : FontWeight.w400,
              fontFamily: 'Poppins',
            ),
          ),
          if (!isTotal) ...[
            Row(
              children: [
                IconButton(
                  icon: Icon(Icons.remove, size: screenWidth * 0.035),
                  onPressed: onRemove,
                ),
                Text(
                  itemPrice,
                  style: TextStyle(
                    fontSize: screenWidth * 0.035,
                    color: Color(0xFF3a3a3b),
                    fontWeight: FontWeight.w400,
                    fontFamily: 'Poppins',
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.add, size: screenWidth * 0.035),
                  onPressed: onAdd,
                ),
              ],
            )
          ] else ...[
            Text(
              itemPrice,
              style: TextStyle(
                fontSize: screenWidth * 0.05,
                color: Color(0xFF3a3a3b),
                fontWeight: FontWeight.bold,
                fontFamily: 'Poppins',
              ),
            ),
          ]
        ],
      ),
    );
  }
}

class PromoCodeWidget extends StatelessWidget {
  final double screenWidth;

  PromoCodeWidget({required this.screenWidth});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: screenWidth * 0.15,
      decoration: BoxDecoration(boxShadow: [
        BoxShadow(
          color: Color(0xFFfae3e2).withOpacity(0.1),
          spreadRadius: 1,
          blurRadius: 1,
          offset: Offset(0, 1),
        ),
      ]),
      child: Card(
        color: Colors.white,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(5.0),
        ),
        child: Container(
          padding: EdgeInsets.symmetric(
              horizontal: screenWidth * 0.03, vertical: screenWidth * 0.01),
          child: TextField(
            decoration: InputDecoration(
              contentPadding:
                  EdgeInsets.symmetric(horizontal: screenWidth * 0.03),
              border: InputBorder.none,
              hintText: "Enter Promo Code",
              hintStyle: TextStyle(
                fontSize: screenWidth * 0.04,
                color: Color(0xFF3a3a3b),
                fontFamily: 'Poppins',
              ),
              suffixIcon: MaterialButton(
                onPressed: () {},
                color: Color.fromRGBO(255, 115, 0, 1),
                child: Text(
                  "Apply",
                  style: TextStyle(
                    color: Colors.white,
                    fontFamily: 'Poppins',
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class CartItemWidget extends StatelessWidget {
  final CartItem item;
  final double screenWidth;
  final VoidCallback onRemove;
  final VoidCallback onAdd;

  CartItemWidget({
    required this.item,
    required this.screenWidth,
    required this.onRemove,
    required this.onAdd,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: screenWidth * 0.03),
      child: Card(
        child: Row(
          children: [
            Image.network(
              item.productImage,
              height: screenWidth * 0.25,
              width: screenWidth * 0.25,
              fit: BoxFit.cover,
            ),
            SizedBox(width: screenWidth * 0.03),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.productName,
                    style: TextStyle(
                      fontSize: screenWidth * 0.045,
                      fontWeight: FontWeight.w600,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    "Price: Rs. ${item.productPrice}",
                    style: TextStyle(fontSize: screenWidth * 0.04),
                  ),
                  Text(
                    "Quantity: ${item.productCartQuantity}",
                    style: TextStyle(fontSize: screenWidth * 0.04),
                  ),
                ],
              ),
            ),
            Row(
              children: [
                IconButton(icon: Icon(Icons.remove), onPressed: onRemove),
                IconButton(icon: Icon(Icons.add), onPressed: onAdd),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
