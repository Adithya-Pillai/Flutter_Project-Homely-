import 'package:flutter/foundation.dart';

class CartProvider with ChangeNotifier {
  final List<CartItem> _cartItems = [];

  List<CartItem> get cartItems => _cartItems;

  void addItem(CartItem item) {
    final index =
        _cartItems.indexWhere((i) => i.productName == item.productName);
    if (index != -1) {
      if (_cartItems[index].productCartQuantity < item.productStockQuantity) {
        _cartItems[index].productCartQuantity++;
      }
    } else {
      _cartItems.add(CartItem(
        productName: item.productName,
        productPrice: item.productPrice,
        productImage: item.productImage,
        productStockQuantity: item.productStockQuantity,
        productCartQuantity:
            1, // Set initial quantity to 1 when adding first time
        productDescription: item.productDescription,
      ));
    }
    notifyListeners();
  }

  void removeItem(String productName) {
    final index = _cartItems.indexWhere((i) => i.productName == productName);
    if (index != -1) {
      if (_cartItems[index].productCartQuantity > 0) {
        _cartItems[index].productCartQuantity--;
        notifyListeners();
      }
      if (_cartItems[index].productCartQuantity == 0) {
        _cartItems.removeAt(index);
        notifyListeners();
      }
    }
  }

  void updateQuantity(String itemName, int quantity) {
    final index =
        _cartItems.indexWhere((cartItem) => cartItem.productName == itemName);
    if (index != -1) {
      _cartItems[index].productCartQuantity = quantity;
      if (_cartItems[index].productCartQuantity <= 0) {
        _cartItems.removeAt(index);
      }
      notifyListeners();
    }
  }

  double get totalPrice {
    return _cartItems.fold(
      0.0,
      (sum, item) => sum + (item.productPrice * item.productCartQuantity),
    );
  }

  void clearCart() {
    _cartItems.clear();
    notifyListeners();
  }
}

class CartItem {
  final String productName;
  final double productPrice;
  final String productImage;
  final int productStockQuantity;
  int productCartQuantity;
  final String productDescription;

  CartItem({
    required this.productName,
    required this.productPrice,
    required this.productImage,
    required this.productStockQuantity,
    required this.productCartQuantity,
    required this.productDescription,
  });
}
