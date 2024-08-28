import 'package:flutter/material.dart';
import 'package:flutter_application_1/services/database.dart';
import 'package:flutter_application_1/widgets/chats.dart';
import 'package:flutter_application_1/widgets/kitchenorders.dart';
import 'package:flutter_application_1/widgets/loading.dart';
import 'package:flutter_application_1/widgets/orders.dart';

class ChefOngoingOrders extends StatelessWidget {
  final String kitchenId;

  const ChefOngoingOrders({Key? key, required this.kitchenId})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<KitchenOrderCard>>(
      future: DatabaseService().getOrdersForKitchen(kitchenId, 'Ongoing'),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: Loading());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Center(child: Text('No ongoing orders found.'));
        } else {
          return ListView.builder(
            itemCount: snapshot.data!.length,
            itemBuilder: (context, index) {
              return snapshot.data![index];
            },
          );
        }
      },
    );
  }
}

class ChefHistoryOrders extends StatelessWidget {
  final String
      kitchenId; // Changed to 'kitchenId' to align with 'ChefOngoingOrders'

  const ChefHistoryOrders({Key? key, required this.kitchenId})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<KitchenOrderCard>>(
      future: DatabaseService().getOrdersForKitchen(kitchenId, 'History'),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: Loading());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Center(child: Text('No previous orders found.'));
        } else {
          return ListView.builder(
            itemCount: snapshot.data!.length,
            itemBuilder: (context, index) {
              return snapshot.data![index];
            },
          );
        }
      },
    );
  }
}

class NotificationList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListView(children: []);
  }
}

class ChatList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        ChatMessage(
          senderName: 'Swathi Shetty',
          message: 'Yes dear thank you for your review',
          time: '19:37',
          avatarImagePath: 'assets/images/Chat/chat1.png',
        ),
        ChatMessage(
          senderName: 'Pooja Sharma',
          message: 'Ok 😊',
          time: '19:37',
          avatarImagePath: 'assets/images/Chat/chat2.png',
        ),
        ChatMessage(
          senderName: 'Priya Dev',
          message: 'Superb food aunty',
          time: '19:37',
          avatarImagePath: 'assets/images/Chat/chat3.png',
        ),
        ChatMessage(
          senderName: 'Rameshwari M',
          message: 'Paneer recipe pls?',
          time: '19:37',
          avatarImagePath: 'assets/images/Chat/chat4.png',
        ),
      ],
    );
  }
}
