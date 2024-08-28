import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_application_1/address.dart';
import 'package:flutter_application_1/chef_orderchat.dart';
import 'package:flutter_application_1/foodlist.dart';
import 'package:flutter_application_1/info.dart';
import 'package:flutter_application_1/loginas.dart';
import 'package:flutter_application_1/services/database.dart';
import 'package:flutter_application_1/widgets/loading.dart';
import 'package:flutter_application_1/widgets/revenuechart.dart';

class ChefHomeScreen extends StatefulWidget {
  final String kitchenId;

  ChefHomeScreen({Key? key, required this.kitchenId}) : super(key: key);

  @override
  _ChefHomeScreenState createState() => _ChefHomeScreenState();
}

class _ChefHomeScreenState extends State<ChefHomeScreen> {
  int _selectedIndex = 0;
  late String kitchenId;

  @override
  void initState() {
    super.initState();
    kitchenId = widget.kitchenId;
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> _widgetOptions = <Widget>[
      HomePage(kitchenId: kitchenId),
      ChatPage(),
      OrdersPage(kitchenId: kitchenId),
      ProfilePage(kitchenId: kitchenId),
    ];

    final List<PreferredSizeWidget> _appBars = [
      AppBar(
        automaticallyImplyLeading: false,
        flexibleSpace: TopWidgetHome(kitchenId: kitchenId),
        backgroundColor: Color.fromRGBO(238, 221, 198, 1),
      ),
      AppBar(
        automaticallyImplyLeading: false,
        flexibleSpace: TopWidgetChat(),
        backgroundColor: Color.fromRGBO(238, 221, 198, 1),
      ),
      AppBar(
        automaticallyImplyLeading: false,
        flexibleSpace: TopWidgetOrders(),
        backgroundColor: Color.fromRGBO(238, 221, 198, 1),
      ),
      AppBar(
        automaticallyImplyLeading: false,
        flexibleSpace: TopWidgetProfile(),
        backgroundColor: Color.fromRGBO(238, 221, 198, 1),
      ),
    ];

    void _onItemTapped(int index) {
      setState(() {
        _selectedIndex = index;
      });
    }

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: _appBars[_selectedIndex],
        body: _widgetOptions[_selectedIndex],
        backgroundColor: const Color.fromRGBO(238, 221, 198, 1),
        bottomNavigationBar: BottomNavigationBar(
          items: <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              backgroundColor: Color.fromRGBO(60, 38, 12, 1),
              icon: Icon(Icons.home),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              backgroundColor: Color.fromRGBO(60, 38, 12, 1),
              icon: Icon(Icons.chat_bubble_outline),
              label: 'Chat',
            ),
            BottomNavigationBarItem(
              backgroundColor: Color.fromRGBO(60, 38, 12, 1),
              icon: Icon(Icons.receipt),
              label: 'Orders',
            ),
            BottomNavigationBarItem(
              backgroundColor: Color.fromRGBO(60, 38, 12, 1),
              icon: Icon(Icons.person),
              label: 'Profile',
            ),
          ],
          currentIndex: _selectedIndex,
          selectedItemColor: Colors.amber[800],
          unselectedItemColor: Colors.grey,
          iconSize: 30,
          onTap: _onItemTapped,
        ),
      ),
    );
  }
}

class TopWidgetHome extends StatefulWidget {
  final String kitchenId;

  TopWidgetHome({Key? key, required this.kitchenId}) : super(key: key);

  @override
  _TopWidgetState createState() => _TopWidgetState();
}

class TopWidgetChat extends StatefulWidget {
  @override
  _TopWidgetChatState createState() => _TopWidgetChatState();
}

class _TopWidgetChatState extends State<TopWidgetChat> {
  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    return Container(
      width: screenWidth,
      padding: EdgeInsets.fromLTRB(30, 60, 30, 0),
      child: const Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Padding(
            padding: const EdgeInsets.fromLTRB(8, 15, 8, 3),
            child: const Text(
              'Messages',
              style: TextStyle(
                color: Color.fromRGBO(50, 52, 62, 1),
                fontSize: 20,
                fontWeight: FontWeight.w400,
                fontFamily: 'Poppins',
              ),
            ),
          )
        ],
      ),
    );
  }
}

class TopWidgetOrders extends StatefulWidget {
  @override
  _TopWidgetOrdersState createState() => _TopWidgetOrdersState();
}

class _TopWidgetOrdersState extends State<TopWidgetOrders> {
  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    return Container(
      width: screenWidth,
      padding: EdgeInsets.fromLTRB(30, 60, 30, 0),
      child: const Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Padding(
            padding: const EdgeInsets.fromLTRB(8, 15, 8, 3),
            child: const Text(
              'My Orders',
              style: TextStyle(
                color: Color.fromRGBO(50, 52, 62, 1),
                fontSize: 20,
                fontWeight: FontWeight.w400,
                fontFamily: 'Poppins',
              ),
            ),
          )
        ],
      ),
    );
  }
}

class TopWidgetProfile extends StatefulWidget {
  @override
  _TopWidgetProfileState createState() => _TopWidgetProfileState();
}

class _TopWidgetProfileState extends State<TopWidgetProfile> {
  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    return Container(
      width: screenWidth,
      padding: EdgeInsets.fromLTRB(30, 60, 30, 0),
      child: const Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Padding(
            padding: const EdgeInsets.fromLTRB(8, 15, 8, 3),
            child: const Text(
              'Profile',
              style: TextStyle(
                color: Color.fromRGBO(50, 52, 62, 1),
                fontSize: 20,
                fontWeight: FontWeight.w400,
                fontFamily: 'Poppins',
              ),
            ),
          )
        ],
      ),
    );
  }
}

class _TopWidgetState extends State<TopWidgetHome> {
  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    return Container(
      width: screenWidth,
      height: 56,
      margin: const EdgeInsets.fromLTRB(0, 50, 0, 0),
      child: Stack(
        children: <Widget>[
          Positioned(
            top: 7,
            right: screenWidth * 0.05,
            child: Container(
              width: 46,
              height: 46,
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/images/Home/Image2186.png'),
                  fit: BoxFit.fitWidth,
                ),
              ),
            ),
          ),
          Positioned(
            top: 8,
            left: screenWidth * 0.05,
            child: GestureDetector(
              onTap: () {
                // Provide a meaningful action here
                print('Image tapped!');
              },
              child: Container(
                width: 35,
                height: 35,
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage(
                        'assets/images/Home/Image2184.png'), // Ensure this path is correct
                    fit: BoxFit.fitWidth,
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            top: 13,
            left: screenWidth * 0.2,
            child: Text(
              'Deliver to',
              textAlign: TextAlign.left,
              style: TextStyle(
                color: Color.fromRGBO(73, 45, 28, 1),
                fontFamily: 'Poppins',
                fontSize: 12,
                fontWeight: FontWeight.bold,
                height: 1,
              ),
            ),
          ),
          Positioned(
            top: 30,
            width: 190,
            left: screenWidth * 0.2,
            child: FutureBuilder<Map<String, dynamic>?>(
              future: DatabaseService().fetchKitchenProfile(widget.kitchenId),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Text('Loading...', textAlign: TextAlign.left);
                } else if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}',
                      textAlign: TextAlign.left);
                } else {
                  var kitchenData = snapshot.data ?? {};
                  var address = kitchenData['address'] ?? {};

                  // Check if address is a map and is empty
                  if (address is! Map || address.isEmpty) {
                    return Text('Error fetching address',
                        textAlign: TextAlign.left);
                  }

                  String apartment = address['apartment'] ?? '';
                  String street = address['street'] ?? '';
                  String postCode = address['post_code'] ?? '';

                  return Text.rich(
                    TextSpan(
                      text: '$apartment, $street, $postCode',
                      style: TextStyle(
                        color: Color.fromRGBO(103, 103, 103, 1),
                        fontFamily: 'Poppins',
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                        height: 1,
                      ),
                    ),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  );
                }
              },
            ),
          ),
          Positioned(
            top: 0,
            right: screenWidth * 0.2,
            child: Container(
              width: 48,
              height: 53,
              child: Stack(
                children: <Widget>[
                  Positioned(
                    top: 8,
                    left: 0,
                    child: GestureDetector(
                      onTap: () => {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  FoodListScreen(kitchenid: widget.kitchenId)),
                        )
                      },
                      child: Container(
                        width: 45,
                        height: 45,
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image:
                                AssetImage('assets/images/Home/Image2185.png'),
                            fit: BoxFit.fitWidth,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            top: 8,
            left: screenWidth * 0.05,
            child: GestureDetector(
              onTap: () {},
              child: Container(
                width: 35,
                height: 35,
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('assets/images/Home/Image2184.png'),
                    fit: BoxFit.fitWidth,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class HomePage extends StatelessWidget {
  final String kitchenId;

  HomePage({Key? key, required this.kitchenId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Map<String, int>>(
      future: DatabaseService().fetchordersCount(kitchenId),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: Loading());
        }

        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }

        if (!snapshot.hasData) {
          return Center(child: Text('No data available'));
        }

        final data = snapshot.data!;
        final ongoingOrdersCount = data['ongoingOrdersCount'] ?? 0;
        final orderHistoryCount = data['orderHistoryCount'] ?? 0;

        return SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _buildStatCard('Running Orders',
                        ongoingOrdersCount.toString(), Colors.blue),
                    _buildStatCard('Previous Orders',
                        orderHistoryCount.toString(), Colors.grey),
                  ],
                ),
                SizedBox(height: 16),
                _buildRevenueCard(),
                SizedBox(height: 16),
                _buildReviewCard(kitchenId),
                SizedBox(height: 16),
                _buildMostOrderedItems(kitchenId),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildStatCard(String title, String count, Color color) {
    return Container(
      width: 150,
      height: 100,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            offset: Offset(0, 6),
            blurRadius: 6.0,
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            count,
            style: TextStyle(
              color: color,
              fontSize: 36,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            title,
            style: TextStyle(
              color: Colors.black54,
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRevenueCard() {
    return RevenueChart(
      revenueDataFuture: DatabaseService().fetchRevenueData(kitchenId),
    );
  }

  Widget _buildReviewCard(String kitchenId) {
    return FutureBuilder<Map<String, dynamic>>(
      future: DatabaseService().fetchKitchenData(kitchenId),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: Loading());
        }

        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }

        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Center(child: Text('No data available'));
        }

        final kitchenData = snapshot.data!;
        final rating = kitchenData['rating'] ?? 0.0;
        final reviewCount = kitchenData['numberOfReviews'] ?? 0;

        return Container(
          padding: EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
            boxShadow: [
              BoxShadow(
                color: Colors.black12,
                offset: Offset(0, 6),
                blurRadius: 6.0,
              ),
            ],
          ),
          child: Row(
            children: [
              SizedBox(width: 8),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.star, color: Colors.amber, size: 36),
                      SizedBox(width: 8),
                      Text(
                        rating.toStringAsFixed(1),
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 36,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  Text(
                    'Total $reviewCount Reviews',
                    style: TextStyle(
                      color: Colors.black54,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
              Spacer(),
              TextButton(
                onPressed: () {
                  // Implement the functionality to see all reviews
                },
                child: Text(
                  'See All Reviews',
                  style: TextStyle(
                    color: Colors.blue,
                    fontSize: 16,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildMostOrderedItems(String kitchenId) {
    return FutureBuilder<Map<String, dynamic>>(
      future: DatabaseService().fetchKitchenData(kitchenId),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: Loading());
        }

        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }

        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Center(child: Text('No data available'));
        }

        final kitchenData = snapshot.data!;
        final orderHistory =
            List<Map<String, dynamic>>.from(kitchenData['order_history'] ?? []);
        final items =
            List<Map<String, dynamic>>.from(kitchenData['items'] ?? []);

        // Calculate the total number of orders for each item
        final Map<String, int> itemOrderCount = {};
        for (var order in orderHistory) {
          for (var item in order['items'] ?? []) {
            final itemName = item['item_name'];
            final quantity = item['quantity'];
            if (itemName != null && quantity != null) {
              itemOrderCount[itemName] =
                  (itemOrderCount[itemName] ?? 0) + (quantity as int);
            }
          }
        }

        // Sort items by order count
        final sortedItems = itemOrderCount.entries.toList()
          ..sort((a, b) => b.value.compareTo(a.value));

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                'Most ordered items',
                style: TextStyle(
                  color: Colors.black87,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Poppins',
                ),
              ),
            ),
            SizedBox(height: 16),
            Container(
              height: 240,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: sortedItems.length,
                itemBuilder: (context, index) {
                  final itemName = sortedItems[index].key;
                  final itemCount = sortedItems[index].value;
                  final item = items.firstWhere(
                    (element) => element['name'] == itemName,
                    orElse: () => {
                      'name': 'Unknown',
                      'image_item': '',
                      'description': ''
                    },
                  );

                  return Container(
                    width: 160,
                    margin: EdgeInsets.only(right: 16),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Colors.white, Colors.grey[100]!],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black26,
                          blurRadius: 8,
                          offset: Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          SizedBox(
                            width: 120,
                            height: 120,
                            child: item['image_item'] != ''
                                ? Image.network(
                                    item['image_item'],
                                    fit: BoxFit.cover,
                                  )
                                : Icon(Icons.fastfood,
                                    size: 100, color: Colors.grey[700]),
                          ),
                          SizedBox(height: 8),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 8),
                            child: Text(
                              itemName,
                              style: TextStyle(
                                color: Colors.black87,
                                fontSize: 16,
                                fontFamily: 'Poppins',
                              ),
                              textAlign: TextAlign.center,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          SizedBox(height: 4),
                          Text(
                            'Orders: $itemCount',
                            style: TextStyle(
                              color: Colors.black54,
                              fontSize: 14,
                              fontFamily: 'Poppins',
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        );
      },
    );
  }
}

class FoodOrderPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Food Order Page')),
      body: Center(child: Text('Food Order Page')),
    );
  }
}

class ChatPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(children: [
      const TabBar(
        indicatorColor: Color.fromRGBO(74, 46, 29, 1),
        labelColor: Color.fromRGBO(74, 46, 29, 1),
        unselectedLabelColor: Colors.grey,
        labelStyle: TextStyle(fontWeight: FontWeight.bold),
        indicatorSize: TabBarIndicatorSize.label,
        tabs: [
          Tab(text: "Messages (3)"),
          Tab(text: "Notifications"),
        ],
      ),
      Expanded(
        child: TabBarView(
          children: [
            ChatList(),
            NotificationList(),
          ],
        ),
      ),
    ]);
  }
}

class OrdersPage extends StatelessWidget {
  final String kitchenId;

  OrdersPage({Key? key, required this.kitchenId}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Column(children: [
      const TabBar(
        indicatorColor: Color.fromRGBO(74, 46, 29, 1),
        labelColor: Color.fromRGBO(74, 46, 29, 1),
        unselectedLabelColor: Colors.grey,
        labelStyle: TextStyle(fontWeight: FontWeight.bold),
        indicatorSize: TabBarIndicatorSize.label,
        tabs: [
          Tab(text: 'Ongoing'),
          Tab(text: 'History'),
        ],
      ),
      Expanded(
        child: TabBarView(
          children: [
            ChefOngoingOrders(kitchenId: kitchenId),
            ChefHistoryOrders(kitchenId: kitchenId),
          ],
        ),
      ),
    ]);
  }
}

class ProfilePage extends StatelessWidget {
  final String kitchenId;

  ProfilePage({Key? key, required this.kitchenId}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Map<String, dynamic>?>(
      future: DatabaseService()
          .fetchKitchenProfile(kitchenId), // Replace with actual kitchen ID
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: Loading());
        } else {
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (snapshot.hasData && snapshot.data != null) {
            String kitchenName = snapshot.data!['name'] ?? 'Kitchen';
            String avatarUrl = snapshot.data!['kitchenimage'] ?? '';
            String email = snapshot.data!['email'] ?? 'Email';
            String phoneNo = snapshot.data!['phone_number'] ?? '000-000-000';
            String rating =
                (snapshot.data!['rating'] as double?)?.toString() ?? '0';
            String bio = snapshot.data!['bio'] ?? 'Homely';
            return LayoutBuilder(
              builder: (context, constraints) {
                return SingleChildScrollView(
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      minHeight: constraints.maxHeight,
                    ),
                    child: IntrinsicHeight(
                      child: Column(
                        children: [
                          SizedBox(height: 20),
                          CircleAvatar(
                            radius: 50,
                            backgroundColor: Colors.grey,
                            backgroundImage: avatarUrl.isNotEmpty
                                ? NetworkImage(avatarUrl)
                                : AssetImage(
                                        'assets/images/Profile/default_avatar.png')
                                    as ImageProvider,
                          ),
                          SizedBox(height: 16),
                          Text(
                            kitchenName,
                            style: TextStyle(
                              fontFamily: 'Poppins',
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                rating,
                                style: TextStyle(
                                  fontFamily: 'Poppins',
                                  fontSize: 16,
                                  color: Colors.black54,
                                ),
                              ),
                              Icon(Icons.star, color: Colors.amber, size: 20),
                            ],
                          ),
                          SizedBox(height: 20),
                          _buildSection(
                            context,
                            title: 'Personal Info',
                            icon: Icons.person,
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => PersonalInfoPage(
                                          username: kitchenName,
                                          avatarurl: avatarUrl,
                                          email: email,
                                          phoneNo: phoneNo,
                                          bio: bio,
                                          id: kitchenId,
                                          iskitchen: true,
                                        )),
                              );
                            },
                            iconColor: Colors.redAccent,
                          ),
                          _buildSection(
                            context,
                            title: 'Address',
                            icon: Icons.location_on,
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => KitchenAddressPage(
                                          kitchenId: kitchenId,
                                        )),
                              );
                            },
                            iconColor: Colors.red,
                          ),
                          _buildSection(
                            context,
                            title: 'Settings',
                            icon: Icons.settings,
                            onTap: () {},
                            iconColor: Colors.deepPurple,
                          ),
                          SizedBox(height: 20),
                          _buildSection(
                            context,
                            title: 'Withdrawal History',
                            icon: Icons.history,
                            onTap: () {},
                            iconColor: Colors.orange,
                          ),
                          SizedBox(height: 20),
                          _buildSection(
                            context,
                            title: 'Log Out',
                            icon: Icons.logout,
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => MainloginWidget()),
                              );
                            },
                            iconColor: Colors.red,
                          ),
                          SizedBox(height: 20),
                        ],
                      ),
                    ),
                  ),
                );
              },
            );
          } else {
            return Center(child: Text('Kitchen not found.'));
          }
        }
      },
    );
  }

  Widget _buildSection(
    BuildContext context, {
    required String title,
    required IconData icon,
    required VoidCallback onTap,
    required Color iconColor,
    String trailing = '',
  }) {
    return Container(
      color: Colors.white,
      margin: EdgeInsets.symmetric(vertical: 4, horizontal: 16),
      child: Material(
        elevation: 0,
        borderRadius: BorderRadius.circular(8),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(8),
          child: ListTile(
            leading: Icon(icon, color: iconColor),
            title: Text(
              title,
              style: TextStyle(
                fontFamily: 'Poppins',
                color: Colors.black,
                fontWeight: FontWeight.w400,
              ),
            ),
            trailing: trailing.isNotEmpty
                ? Text(
                    trailing,
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                  )
                : Icon(Icons.arrow_forward_ios, color: Colors.black),
          ),
        ),
      ),
    );
  }
}
