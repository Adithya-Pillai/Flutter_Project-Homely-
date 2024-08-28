import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_application_1/models/kitchen.dart';
import 'package:flutter_application_1/widgets/foodcard.dart';
import 'package:flutter_application_1/widgets/kitchenorders.dart';
import 'package:flutter_application_1/widgets/orders.dart';
import 'package:flutter_application_1/models/category.dart';
import 'package:intl/intl.dart';

class DatabaseService {
  final CollectionReference usersCollection =
      FirebaseFirestore.instance.collection('users');
  final CollectionReference kitchensCollection =
      FirebaseFirestore.instance.collection('kitchens');

  Future<QuerySnapshot> getTopRatedKitchens() async {
    return await kitchensCollection
        .orderBy('rating', descending: true)
        .limit(5)
        .get();
  }

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<DocumentSnapshot> getUserData(String uid) async {
    return await usersCollection.doc(uid).get();
  }

  Future<List<OrderCard>> getOngoingOrdersForUser(String userId) async {
    try {
      // Get the user document reference
      DocumentReference userDocRef = usersCollection.doc(userId);

      // Get the snapshot of the user document
      DocumentSnapshot userSnapshot = await userDocRef.get();

      // Extract the ongoing orders list from the user document
      List<Map<String, dynamic>> ongoingOrders =
          List<Map<String, dynamic>>.from(userSnapshot['ongoing_orders'] ?? []);

      // Get timestamp from user document
      Timestamp timestamp = userSnapshot['timestamp'];

      // Map each ongoing order to an OrderCard instance
      List<OrderCard> orderCards = ongoingOrders.map((order) {
        num totalQuantity = 0;
        List<Map<String, dynamic>> items =
            List<Map<String, dynamic>>.from(order['items'] ?? []);
        items.forEach((item) {
          totalQuantity += item['quantity'] ?? 0;
        });

        // Format timestamp to display date
        DateTime date = timestamp.toDate();

        return OrderCard(
          imageUrl: order['imageUrl'] ?? '',
          name: order['kitchen_name'] ?? '',
          price: order['price'] ?? '',
          items: totalQuantity.toString() ?? '',
          orderId: order['order_id'] ?? '',
          button1Text: order['button1Text'] ?? '',
          button2Text: order['button2Text'] ?? '',
          date: '${date.day}/${date.month}/${date.year}',
          uid: userId, // Format as needed
        );
      }).toList();

      return orderCards;
    } catch (e) {
      print('Error getting ongoing orders: $e');
      return [];
    }
  }

  Future<List<KitchenOrderCard>> getOrdersForKitchen(
      String kitchenId, String type) async {
    if (type == 'Ongoing') {
      try {
        // Get the kitchen document reference
        DocumentReference kitchenDocRef = kitchensCollection.doc(kitchenId);

        // Get the snapshot of the kitchen document
        DocumentSnapshot kitchenSnapshot = await kitchenDocRef.get();

        // Extract the ongoing orders list from the kitchen document
        List<Map<String, dynamic>> ongoingOrders =
            List<Map<String, dynamic>>.from(
                kitchenSnapshot['ongoing_orders'] ?? []);

        // Extract items list from the kitchen document
        List<Map<String, dynamic>> kitchenItems =
            List<Map<String, dynamic>>.from(kitchenSnapshot['items'] ?? []);

        // Create a map for quick item lookup
        Map<String, Map<String, dynamic>> itemMap = {
          for (var item in kitchenItems) item['name']: item
        };

        // Map each ongoing order to a KitchenOrderCard instance
        List<KitchenOrderCard> orderCards = ongoingOrders.map((order) {
          List<String> itemDetails = [];
          List<Map<String, dynamic>> items =
              List<Map<String, dynamic>>.from(order['items'] ?? []);

          items.forEach((item) {
            final itemName = item['item_name'];
            final quantity = item['quantity'];
            if (itemName != null && quantity != null) {
              final kitchenItem = itemMap[itemName];
              final itemDescription =
                  kitchenItem?['description'] ?? 'No description';
              itemDetails.add('$itemName ($quantity) - $itemDescription');
            }
          });

          // Format timestamp to display date
          DateTime date = DateTime.parse(order['date']);

          return KitchenOrderCard(
            imageUrl: order['imageUrl'] ?? '',
            name: order['customer_name'] ?? '',
            price: order['price'] ?? '',
            items: itemDetails.join(', '),
            orderId: order['order_id'] ?? '',
            button1Text: order['button1Text'] ?? '',
            button2Text: order['button2Text'] ?? '',
            date: '${date.day}/${date.month}/${date.year}',
            uid: kitchenId, // Kitchen ID used as UID
          );
        }).toList();

        return orderCards;
      } catch (e) {
        print('Error getting ongoing orders: $e');
        return [];
      }
    } else {
      try {
        // Get the kitchen document reference
        DocumentReference kitchenDocRef = kitchensCollection.doc(kitchenId);

        // Get the snapshot of the kitchen document
        DocumentSnapshot kitchenSnapshot = await kitchenDocRef.get();

        // Extract the ongoing orders list from the kitchen document
        List<Map<String, dynamic>> ongoingOrders =
            List<Map<String, dynamic>>.from(
                kitchenSnapshot['order_history'] ?? []);

        // Extract items list from the kitchen document
        List<Map<String, dynamic>> kitchenItems =
            List<Map<String, dynamic>>.from(kitchenSnapshot['items'] ?? []);

        // Create a map for quick item lookup
        Map<String, Map<String, dynamic>> itemMap = {
          for (var item in kitchenItems) item['name']: item
        };

        // Map each ongoing order to a KitchenOrderCard instance
        List<KitchenOrderCard> orderCards = ongoingOrders.map((order) {
          List<String> itemDetails = [];
          List<Map<String, dynamic>> items =
              List<Map<String, dynamic>>.from(order['items'] ?? []);

          items.forEach((item) {
            final itemName = item['item_name'];
            final quantity = item['quantity'];
            if (itemName != null && quantity != null) {
              final kitchenItem = itemMap[itemName];
              final itemDescription =
                  kitchenItem?['description'] ?? 'No description';
              itemDetails.add('$itemName ($quantity) - $itemDescription');
            }
          });

          // Format timestamp to display date
          DateTime date = DateTime.parse(order['date']);

          return KitchenOrderCard(
            imageUrl: order['imageUrl'] ?? '',
            name: order['customer_name'] ?? '',
            price: order['price'] ?? '',
            items: itemDetails.join(', '),
            orderId: order['order_id'] ?? '',
            button1Text: order['button1Text'] ?? '',
            button2Text: order['button2Text'] ?? '',
            date: '${date.day}/${date.month}/${date.year}',
            uid: kitchenId, // Kitchen ID used as UID
          );
        }).toList();

        return orderCards;
      } catch (e) {
        print('Error getting history orders: $e');
        return [];
      }
    }
  }

  Future<List<Map<String, dynamic>>> getFoodList(
      String kitchenId, Function(String) onDelete) async {
    try {
      // Fetch the specific kitchen document
      DocumentSnapshot kitchenDoc = await FirebaseFirestore.instance
          .collection('kitchens')
          .doc(kitchenId)
          .get();

      if (!kitchenDoc.exists) {
        print('Kitchen document not found');
        return [];
      }

      // Get the items list from the kitchen document
      List items = kitchenDoc['items'] ?? [];

      // Map each item to a Map containing necessary data for FoodCard
      List<Map<String, dynamic>> foodItems = items.map((item) {
        return {
          'imageUrl': item['image_item'] ?? '',
          'name': item['name'] ?? '',
          'price': item['price']?.toString() ?? 'N/A',
          'description': item['description'] ?? '',
          'quantity': item['quantity']?.toString() ?? '0',
          'documentId': item['item_id'] ?? '',
        };
      }).toList();

      return foodItems;
    } catch (e) {
      print('Error getting food list: $e');
      return [];
    }
  }

  Future<Map<String, int>> fetchordersCount(String id) async {
    try {
      // Get the kitchen document reference
      DocumentReference kitchenDocRef = kitchensCollection.doc(id);

      // Get the snapshot of the kitchen document
      DocumentSnapshot kitchenSnapshot = await kitchenDocRef.get();

      // Check if the document exists
      if (!kitchenSnapshot.exists) {
        print('Kitchen document does not exist');
        return {
          'ongoingOrdersCount': 0,
          'orderHistoryCount': 0,
        };
      }

      // Extract the ongoing orders list from the kitchen document
      List<dynamic> ongoingOrders = kitchenSnapshot.get('ongoing_orders') ?? [];
      List<dynamic> historyOrders = [];
      try {
        historyOrders = kitchenSnapshot.get('order_history') ?? [];
      } catch (e) {
        // Handle the case where 'order_history' doesn't exist in the document
        print('order_history does not exist: $e');
        historyOrders = []; // Default to an empty list
      }
      // Return the counts of ongoing orders and order history
      return {
        'ongoingOrdersCount': ongoingOrders.length,
        'orderHistoryCount': historyOrders.length,
      };
    } catch (e) {
      print('Error getting orders count: $e');
      return {
        'ongoingOrdersCount': 0,
        'orderHistoryCount': 0,
      };
    }
  }

  Future<String> fetchAddress(String Id, String addressType) async {
    try {
      // Fetch user and kitchen documents
      DocumentSnapshot userSnapshot = await usersCollection.doc(Id).get();
      DocumentSnapshot kitchenSnapshot = await kitchensCollection.doc(Id).get();

      if (userSnapshot.exists) {
        // Get addresses from user document
        List<dynamic> addresses = userSnapshot['addresses'] ?? [];
        Map<String, dynamic>? address = addresses.firstWhere(
          (addr) => addr['type'] == addressType,
          orElse: () => null,
        );

        if (address != null) {
          // Return formatted string
          String apartment = address['apartment'] ?? '';
          String addressLine = address['address'] ?? '';
          return '$apartment, $addressLine';
        } else {
          return 'Address type $addressType not found';
        }
      } else if (kitchenSnapshot.exists) {
        // Return address from kitchen document
        return kitchenSnapshot['address'] ?? 'Address not found';
      } else {
        return 'Document does not exist';
      }
    } catch (e) {
      print('Error fetching address: $e');
      return 'Error fetching address';
    }
  }

  Future<bool> isNameInUse(String name) async {
    try {
      // Query Firestore for both the 'users' and 'kitchens' collections
      final QuerySnapshot userResult = await _firestore
          .collection('users') // User collection
          .where('name', isEqualTo: name)
          .get();

      final QuerySnapshot kitchenResult = await _firestore
          .collection('kitchens') // Kitchen collection
          .where('name', isEqualTo: name)
          .get();

      // Check if any documents were returned in either collection
      return userResult.docs.isNotEmpty || kitchenResult.docs.isNotEmpty;
    } catch (e) {
      // Handle potential errors
      print('Error checking name in use: $e');
      return false;
    }
  }

  Future<bool> isEmailInUse(String email, bool isKitchen) async {
    try {
      // Determine the collection to query based on the isKitchen flag
      String collectionName = isKitchen ? 'kitchens' : 'users';

      // Query the appropriate Firestore collection
      final QuerySnapshot result = await _firestore
          .collection(collectionName)
          .where('email', isEqualTo: email)
          .get();

      // Check if any documents were returned
      return result.docs.isNotEmpty;
    } catch (e) {
      // Handle potential errors
      print('Error checking email in use: $e');
      return false;
    }
  }

  Future<String> fetchUserName(String userId) async {
    try {
      DocumentSnapshot userSnapshot = await usersCollection.doc(userId).get();
      if (userSnapshot.exists) {
        return userSnapshot['name'] ??
            'Name not found'; // Assuming 'name' is the field name in Firestore
      } else {
        return 'User document does not exist';
      }
    } catch (e) {
      print('Error fetching user name: $e');
      return 'Error fetching user name';
    }
  }

  Future<String> fetchImageurluser(String userId) async {
    try {
      DocumentSnapshot userSnapshot = await usersCollection.doc(userId).get();
      if (userSnapshot.exists) {
        return userSnapshot['avatarurl'] ??
            'https://firebasestorage.googleapis.com/v0/b/homely-project-8be33.appspot.com/o/placeholder_images%2Fhomely_logo.jpeg?alt=media&token=9089f046-ad45-48c3-8ad6-b3f30c3ee7a5';
      } else {
        return 'User document does not exist';
      }
    } catch (e) {
      print('Error fetching user image: $e');
      return 'https://firebasestorage.googleapis.com/v0/b/homely-project-8be33.appspot.com/o/placeholder_images%2Fhomely_logo.jpeg?alt=media&token=9089f046-ad45-48c3-8ad6-b3f30c3ee7a5';
    }
  }

  Future<String> fetchKitchenName(String kitchenId) async {
    try {
      DocumentSnapshot kitchenSnapshot =
          await kitchensCollection.doc(kitchenId).get();

      if (kitchenSnapshot.exists) {
        return kitchenSnapshot['name'] ?? 'Name not found';
      } else {
        return 'Kitchen document does not exist';
      }
    } catch (e) {
      print('Error fetching kitchen name: $e');
      return 'Error fetching kitchen name';
    }
  }

  Future<String> fetchImageurlkitchen(String kitchenId) async {
    try {
      DocumentSnapshot kitchenSnapshot =
          await kitchensCollection.doc(kitchenId).get();

      if (kitchenSnapshot.exists) {
        return kitchenSnapshot['kitchenimage'] ??
            'https://firebasestorage.googleapis.com/v0/b/homely-project-8be33.appspot.com/o/placeholder_images%2Fhomely_logo.jpeg?alt=media&token=9089f046-ad45-48c3-8ad6-b3f30c3ee7a5';
      } else {
        return 'Kitchen document does not exist';
      }
    } catch (e) {
      print('Error fetching kitchen image: $e');
      return 'https://firebasestorage.googleapis.com/v0/b/homely-project-8be33.appspot.com/o/placeholder_images%2Fhomely_logo.jpeg?alt=media&token=9089f046-ad45-48c3-8ad6-b3f30c3ee7a5';
    }
  }

  Future<String> fetchKitchenIdByName(String kitchenName) async {
    try {
      QuerySnapshot querySnapshot = await kitchensCollection
          .where('name', isEqualTo: kitchenName)
          .limit(1) // Assuming kitchen names are unique, limiting to one result
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        DocumentSnapshot kitchenSnapshot = querySnapshot.docs.first;
        return kitchenSnapshot
            .id; // Returns the document ID, which is the kitchen ID
      } else {
        return 'Kitchen not found';
      }
    } catch (e) {
      print('Error fetching kitchen ID: $e');
      return 'Error fetching kitchen ID';
    }
  }

  Future<Map<String, dynamic>?> fetchUserProfile(String userId) async {
    try {
      DocumentSnapshot userSnapshot = await usersCollection.doc(userId).get();
      if (userSnapshot.exists) {
        return userSnapshot.data()
            as Map<String, dynamic>?; // Return user data as a Map
      } else {
        print('User document for ID $userId does not exist.');
        return null;
      }
    } catch (e) {
      print('Error fetching user profile: $e');
      return null;
    }
  }

  Future<Map<String, dynamic>?> fetchKitchenProfile(String kitchenId) async {
    try {
      DocumentSnapshot kitchenSnapshot =
          await kitchensCollection.doc(kitchenId).get();
      if (kitchenSnapshot.exists) {
        return kitchenSnapshot.data()
            as Map<String, dynamic>?; // Return kitchen data as a Map
      } else {
        print('Kitchen document for ID $kitchenId does not exist.');
        return null;
      }
    } catch (e) {
      print('Error fetching kitchen profile: $e');
      return null;
    }
  }

  Future<List<OrderCard>> getHistoryOrdersForUser(String userId) async {
    try {
      // Get the user document reference
      DocumentReference userDocRef = usersCollection.doc(userId);

      // Get the snapshot of the user document
      DocumentSnapshot userSnapshot = await userDocRef.get();

      // Extract the ongoing orders list from the user document
      List<Map<String, dynamic>> historyOrders =
          List<Map<String, dynamic>>.from(userSnapshot['order_history'] ?? []);

      // Get timestamp from user document
      Timestamp timestamp = userSnapshot['timestamp'];

      // Map each ongoing order to an OrderCard instance
      List<OrderCard> orderCards = historyOrders.map((order) {
        num totalQuantity = 0;
        List<Map<String, dynamic>> items =
            List<Map<String, dynamic>>.from(order['items'] ?? []);
        items.forEach((item) {
          totalQuantity += item['quantity'] ?? 0;
        });

        // Format timestamp to display date
        DateTime date = timestamp.toDate();

        return OrderCard(
          imageUrl: order['imageUrl'] ?? '',
          name: order['kitchen_name'] ?? '',
          price: order['price'] ?? '',
          items: totalQuantity.toString() ?? '',
          orderId: order['order_id'] ?? '',
          button1Text: order['button1Text'] ?? '',
          button2Text: order['button2Text'] ?? '',
          date: '${date.day}/${date.month}/${date.year}',
          uid: userId, // Format as needed
        );
      }).toList();

      return orderCards;
    } catch (e) {
      print('Error getting ongoing orders: $e');
      return [];
    }
  }

  Future<String> fetchUserIdByName(String username) async {
    try {
      QuerySnapshot querySnapshot = await usersCollection
          .where('name', isEqualTo: username)
          .limit(1) // Assuming kitchen names are unique, limiting to one result
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        DocumentSnapshot userSnapshot = querySnapshot.docs.first;
        return userSnapshot
            .id; // Returns the document ID, which is the kitchen ID
      } else {
        return 'User not found';
      }
    } catch (e) {
      print('Error fetching User ID: $e');
      return 'Error fetching User ID';
    }
  }

  Future<void> deleteOngoingOrder(String userId, String orderId) async {
    try {
      // Reference to the user document
      DocumentReference userDocRef = usersCollection.doc(userId);

      // Get the user document snapshot
      DocumentSnapshot userSnapshot = await userDocRef.get();

      // Retrieve ongoing orders list from the user document
      List<dynamic> ongoingOrders = userSnapshot['ongoing_orders'];

      // Remove the order with matching orderId from the list
      ongoingOrders.removeWhere((order) => order['order_id'] == orderId);

      // Update the user document with the modified ongoing orders list
      await userDocRef.update({
        'ongoing_orders': ongoingOrders,
      });

      print('Order $orderId deleted successfully');
    } catch (e) {
      print('Error deleting order: $e');
      throw e; // Propagate the error for handling elsewhere
    }
  }

  Future<void> deleteOngoingOrderKitchen(
      String kitchenId, String orderId) async {
    try {
      DocumentReference kitchenDocRef =
          FirebaseFirestore.instance.collection('kitchens').doc(kitchenId);

      // Fetch the kitchen document snapshot
      DocumentSnapshot kitchenSnapshot = await kitchenDocRef.get();
      if (!kitchenSnapshot.exists) {
        throw Exception("Kitchen does not exist");
      }

      // Get the ongoing orders and items from the kitchen snapshot
      List<dynamic> ongoingOrders =
          List<dynamic>.from(kitchenSnapshot['ongoing_orders'] ?? []);
      List<dynamic> kitchenItems =
          List<dynamic>.from(kitchenSnapshot['items'] ?? []);

      // Find the order to delete
      Map<String, dynamic>? orderToDelete;
      for (var order in ongoingOrders) {
        if (order['order_id'] == orderId) {
          orderToDelete = order;
          break;
        }
      }

      if (orderToDelete == null) {
        print('Order $orderId not found');
        return;
      }

      // Remove the order from ongoing_orders
      ongoingOrders.removeWhere((order) => order['order_id'] == orderId);

      // Update item quantities in the kitchen's items
      for (var item in orderToDelete['items']) {
        String itemName = item['item_name'];
        int itemQuantity = item['quantity'];

        // Find the item in kitchenItems and update its quantity
        for (var kitchenItem in kitchenItems) {
          if (kitchenItem['name'] == itemName) {
            kitchenItem['quantity'] += itemQuantity;
            break;
          }
        }
      }

      // Update the kitchen document with the modified orders and items
      await kitchenDocRef.update({
        'ongoing_orders': ongoingOrders,
        'items': kitchenItems,
      });

      print('Order $orderId deleted successfully and item quantities updated');
    } catch (e) {
      print('Error deleting order: $e');
      throw e; // Propagate the error for handling elsewhere
    }
  }

  Future<void> moveOrderToHistory(
      String kitchenId, String orderId, String userId) async {
    final FirebaseFirestore firestore = FirebaseFirestore.instance;

    try {
      print(
          'Searching for order with orderId: $orderId in kitchen: $kitchenId and user: $userId');

      // Reference to the kitchens and users collection
      DocumentReference kitchenDocRef =
          firestore.collection('kitchens').doc(kitchenId);
      DocumentReference userDocRef = firestore.collection('users').doc(userId);

      // Get the kitchen document snapshot
      DocumentSnapshot kitchenSnapshot = await kitchenDocRef.get();
      // Get the user document snapshot
      DocumentSnapshot userSnapshot = await userDocRef.get();

      if (kitchenSnapshot.exists &&
          kitchenSnapshot['ongoing_orders'] != null &&
          userSnapshot.exists &&
          userSnapshot['ongoing_orders'] != null) {
        // Retrieve the list of ongoing orders from kitchen and user
        List<dynamic> kitchenOngoingOrders = kitchenSnapshot['ongoing_orders'];
        List<dynamic> userOngoingOrders = userSnapshot['ongoing_orders'];

        Map<String, dynamic>? kitchenOrderData;
        Map<String, dynamic>? userOrderData;

        // Find the order in kitchen's ongoing orders
        for (var order in kitchenOngoingOrders) {
          if (order['order_id'] == orderId) {
            kitchenOrderData = Map<String, dynamic>.from(order);
            break;
          }
        }

        // Find the order in user's ongoing orders
        for (var order in userOngoingOrders) {
          if (order['order_id'] == orderId) {
            userOrderData = Map<String, dynamic>.from(order);
            break;
          }
        }

        if (kitchenOrderData != null && userOrderData != null) {
          print('Order data found in both kitchen and user ongoing orders');

          // Update the order status to 'finished'
          kitchenOrderData['status'] = 'finished';
          kitchenOrderData['button1Text'] = 'Message';
          kitchenOrderData['button2Text'] = 'Bill';
          userOrderData['status'] = 'finished';
          userOrderData['button1Text'] = 'Rate';
          userOrderData['button2Text'] = 'Re-order';

          List<dynamic> kitchenOrderHistory;
          try {
            kitchenOrderHistory =
                List<dynamic>.from(kitchenSnapshot.get('order_history'));
          } catch (e) {
            // Field doesn't exist, initialize an empty list
            kitchenOrderHistory = [];
          }

// Retrieve or initialize the order_history collection for the user
          List<dynamic> userOrderHistory;
          try {
            userOrderHistory =
                List<dynamic>.from(userSnapshot.get('order_history'));
          } catch (e) {
            // Field doesn't exist, initialize an empty list
            userOrderHistory = [];
          }

          // Add the order to the order_history collection in the kitchen and user documents
          kitchenOrderHistory.add(kitchenOrderData);
          userOrderHistory.add(userOrderData);

          // Remove the order from ongoing_orders in both kitchen and user
          kitchenOngoingOrders
              .removeWhere((order) => order['order_id'] == orderId);
          userOngoingOrders
              .removeWhere((order) => order['order_id'] == orderId);

          // Update Firestore with the modified ongoing_orders and order_history lists for both kitchen and user
          await kitchenDocRef.update({
            'ongoing_orders': kitchenOngoingOrders,
            'order_history': kitchenOrderHistory,
          });

          await userDocRef.update({
            'ongoing_orders': userOngoingOrders,
            'order_history': userOrderHistory,
          });

          print(
              'Order moved to history successfully for both kitchen and user');
        } else {
          print('Order not found in either kitchen or user ongoing orders');
        }
      } else {
        print(
            'Kitchen or user document does not exist or no ongoing orders found');
      }
    } catch (e) {
      print('Error moving order to history: $e');
    }
  }

  Future<List<Map<String, dynamic>>> fetchCategoryDishes(
      String category) async {
    try {
      // Fetch all kitchen documents
      QuerySnapshot querySnapshot =
          await _firestore.collection('kitchens').get();

      List<Map<String, dynamic>> dishes = [];

      // Iterate over each kitchen document
      for (var doc in querySnapshot.docs) {
        // Get the kitchen ID
        String kitchenId = doc.id;

        // Ensure doc.data() is not null and check if the items field exists and is a list
        final data = doc.data() as Map<String, dynamic>?; // Cast to Map
        if (data != null &&
            data.containsKey('items') &&
            data['items'] is List) {
          List items = data['items'];

          // Filter items based on category_id and include kitchen_id
          for (var item in items) {
            if (item['category_id'] == category) {
              // Add kitchen_id to each dish's data
              item['kitchen_id'] = kitchenId;
              dishes.add(item);
            }
          }
        } else {
          print('Missing or invalid "items" field in document: $kitchenId');
        }
      }

      print(dishes); // For debugging purposes
      return dishes;
    } catch (e) {
      print('Error fetching category dishes: $e');
      return [];
    }
  }

  Future<List<FlSpot>> fetchRevenueData(String kitchenId) async {
    try {
      DocumentReference kitchenDocRef =
          FirebaseFirestore.instance.collection('kitchens').doc(kitchenId);
      DocumentSnapshot kitchenSnapshot = await kitchenDocRef.get();

      List<Map<String, dynamic>> orderHistory = List<Map<String, dynamic>>.from(
          kitchenSnapshot['order_history'] ?? []);

      // Get the current month start and end dates
      DateTime now = DateTime.now();
      DateTime startOfMonth = DateTime(now.year, now.month, 1);
      DateTime endOfMonth = DateTime(now.year, now.month + 1, 0);

      // Map to hold revenue sums for each day of the current month
      Map<int, double> dailyRevenue = {};

      for (var order in orderHistory) {
        DateTime date = DateTime.parse(order['date']);
        if (date.isAfter(startOfMonth.subtract(Duration(days: 1))) &&
            date.isBefore(endOfMonth.add(Duration(days: 1)))) {
          int dayOfMonth = date.day;
          double revenue = double.parse(order['price']);

          // Accumulate revenue for each day
          if (dailyRevenue.containsKey(dayOfMonth)) {
            dailyRevenue[dayOfMonth] = dailyRevenue[dayOfMonth]! + revenue;
          } else {
            dailyRevenue[dayOfMonth] = revenue;
          }
        }
      }

      // Convert daily revenue to FlSpot list
      List<FlSpot> spots = [];
      dailyRevenue.forEach((day, revenue) {
        double x = day.toDouble(); // Use day of the month as x value
        double y = revenue;
        spots.add(FlSpot(x, y));
      });

      // Sort spots by day (x-axis)
      spots.sort((a, b) => a.x.compareTo(b.x));

      return spots;
    } catch (e) {
      print('Error fetching revenue data: $e');
      return [];
    }
  }

  Future<Map<String, dynamic>> fetchKitchenData(String kitchenId) async {
    try {
      DocumentSnapshot kitchenSnapshot = await FirebaseFirestore.instance
          .collection('kitchens')
          .doc(kitchenId)
          .get();
      return kitchenSnapshot.data() as Map<String, dynamic>;
    } catch (e) {
      print('Error fetching kitchen data: $e');
      return {};
    }
  }

  Future<void> updateUserData(
    String uid, {
    String? name,
    String? email,
    String? password,
    String? phoneNumber,
    String? avatarurl,
    String? bio,
    List<Map<String, dynamic>>? addresses,
    List<Map<String, dynamic>>? ongoingOrders,
    List<Map<String, dynamic>>? orderHistory,
    List<Map<String, dynamic>>? notifications,
    List<Map<String, dynamic>>? messages,
    List<Map<String, dynamic>>? mostOrderedItems,
  }) async {
    try {
      Map<String, dynamic> data = {};

      if (name != null) data['name'] = name;
      if (email != null) data['email'] = email;
      if (password != null) data['password'] = password;
      if (phoneNumber != null) data['phone_number'] = phoneNumber;
      if (avatarurl != null) data['avatarurl'] = avatarurl;
      if (bio != null) data['bio'] = bio;
      if (addresses != null) data['addresses'] = addresses;
      if (notifications != null) data['notifications'] = notifications;
      if (messages != null) data['messages'] = messages;
      if (mostOrderedItems != null) {
        data['most_ordered_items'] = mostOrderedItems;
      }

      // Add timestamp directly to the data object
      data['timestamp'] = FieldValue.serverTimestamp();

      // Handle ongoing orders and order history separately
      if (ongoingOrders != null && ongoingOrders.isNotEmpty) {
        data['ongoing_orders'] = ongoingOrders;
      }

      if (orderHistory != null && orderHistory.isNotEmpty) {
        data['order_history'] = orderHistory;
      }

      await usersCollection.doc(uid).set(data, SetOptions(merge: true));
      print('User data updated successfully');
    } catch (e) {
      print('Failed to update user data: $e');
      rethrow;
    }
  }

  Future<void> updateKitchenData(
    String kitchenId, {
    String? name,
    String? email,
    String? password,
    String? phoneNumber,
    double? rating,
    String? subtitle,
    String? kitchenimage,
    String? bio,
    String? address,
    List<Map<String, dynamic>>? ongoingOrders,
    List<Map<String, dynamic>>? orderHistory,
    List<Map<String, dynamic>>? notifications,
    List<Map<String, dynamic>>? messages,
    List<Map<String, dynamic>>? items,
  }) async {
    try {
      Map<String, dynamic> data = {};

      if (name != null) data['name'] = name;
      if (email != null) data['email'] = email;
      if (password != null) data['password'] = password;
      if (phoneNumber != null) data['phone_number'] = phoneNumber;
      if (rating != null) data['rating'] = rating;
      if (subtitle != null) data['subtitle'] = subtitle;
      if (kitchenimage != null) data['kitchenimage'] = kitchenimage;
      if (bio != null) data['bio'] = bio;
      if (address != null) data['address'] = address;
      if (notifications != null) data['notifications'] = notifications;
      if (messages != null) data['messages'] = messages;
      if (items != null) data['items'] = items;

      // Add timestamp directly to the data object
      data['timestamp'] = FieldValue.serverTimestamp();

      // Handle ongoing orders and order history separately
      if (ongoingOrders != null && ongoingOrders.isNotEmpty) {
        data['ongoing_orders'] = ongoingOrders;
      }

      if (orderHistory != null && orderHistory.isNotEmpty) {
        data['order_history'] = orderHistory;
      }

      await kitchensCollection
          .doc(kitchenId)
          .set(data, SetOptions(merge: true));
      print('Kitchen data updated successfully');
    } catch (e) {
      print('Failed to update kitchen data: $e');
      rethrow;
    }
  }

  Future<List<Kitchen>> fetchKitchensFromFirestore() async {
    List<Kitchen> kitchens = [];

    try {
      QuerySnapshot querySnapshot =
          await FirebaseFirestore.instance.collection('kitchens').get();

      for (var doc in querySnapshot.docs) {
        Map<String, dynamic> kitchenData = doc.data() as Map<String, dynamic>;

        // Retrieve the kitchen ID
        String kid = doc.id;

        // Ensure that the fields are of the expected types
        List<Map<String, dynamic>> ongoingOrders =
            kitchenData['ongoing_orders'] is List
                ? List<Map<String, dynamic>>.from(kitchenData['ongoing_orders'])
                : [];
        List<Map<String, dynamic>> orderHistory =
            kitchenData['order_history'] is List
                ? List<Map<String, dynamic>>.from(kitchenData['order_history'])
                : [];
        List<Map<String, dynamic>> notifications =
            kitchenData['notifications'] is List
                ? List<Map<String, dynamic>>.from(kitchenData['notifications'])
                : [];
        List<Map<String, dynamic>> messages = kitchenData['messages'] is List
            ? List<Map<String, dynamic>>.from(kitchenData['messages'])
            : [];
        List<Map<String, dynamic>> items = kitchenData['items'] is List
            ? List<Map<String, dynamic>>.from(kitchenData['items'])
            : [];

        // Check if address is a map and handle it accordingly
        String address = kitchenData['address'] is Map<String, dynamic>
            ? kitchenData['address']['formatted'] ?? 'Unknown Address'
            : kitchenData['address'] ?? '';

        kitchens.add(Kitchen(
          kid: kid,
          name: kitchenData['name'] ?? 'Unnamed Kitchen',
          email: kitchenData['email'] ?? '',
          phoneNumber: kitchenData['phone_number'] ?? '',
          rating: (kitchenData['rating'] ?? 0.0) is num
              ? (kitchenData['rating'] as num).toDouble()
              : 0.0,
          subtitle: kitchenData['subtitle'] ?? '',
          kitchenImage: kitchenData['kitchenimage'] ??
              'https://firebasestorage.googleapis.com/v0/b/homely-project-8be33.appspot.com/o/placeholder_images%2Fhomely_logo.jpeg?alt=media&token=9089f046-ad45-48c3-8ad6-b3f30c3ee7a5',
          bio: kitchenData['bio'] ?? '',
          address: address,
          ongoingOrders: ongoingOrders,
          orderHistory: orderHistory,
          notifications: notifications,
          messages: messages,
          items: items,
        ));
      }

      // Sort kitchens by rating in descending order
      kitchens.sort((a, b) => b.rating.compareTo(a.rating));

      return kitchens;
    } catch (e) {
      print('Error fetching kitchens: $e');
      return []; // Return an empty list if there's an error
    }
  }
}

class KitchenService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Future<Map<String, dynamic>> fetchKitchenData(String kitchenId) async {
    DocumentSnapshot doc =
        await _db.collection('kitchens').doc(kitchenId).get();
    return doc.data() as Map<String, dynamic>;
  }
}
