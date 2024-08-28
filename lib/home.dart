import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_application_1/aboutus.dart';
import 'package:flutter_application_1/address.dart';
import 'package:flutter_application_1/cart.dart';
import 'package:flutter_application_1/info.dart';
import 'package:flutter_application_1/loginas.dart';
import 'package:flutter_application_1/order_chat.dart';
import 'package:flutter_application_1/services/database.dart';
import 'package:flutter_application_1/widgets/categories.dart';
import 'package:flutter_application_1/widgets/chats.dart';
import 'package:flutter_application_1/widgets/kitchencard.dart';
import 'dart:math' as math;
import 'package:flutter_application_1/widgets/loading.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key, required this.uid}) : super(key: key);
  final String uid;

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  List<Widget> _getWidgetOptions() {
    return <Widget>[
      HomePage(userId: widget.uid),
      ChatPage(),
      OrdersPage(userId: widget.uid),
      ProfilePage(userId: widget.uid),
    ];
  }

  List<PreferredSizeWidget> _getAppBars() {
    return [
      AppBar(
        automaticallyImplyLeading: false,
        flexibleSpace: TopWidgetHome(uid: widget.uid),
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
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: _getAppBars()[_selectedIndex],
        body: _getWidgetOptions()[_selectedIndex],
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
          onTap: (index) {
            setState(() {
              _selectedIndex = index;
            });
          },
        ),
      ),
    );
  }
}

class TopWidgetHome extends StatefulWidget {
  const TopWidgetHome({Key? key, required this.uid}) : super(key: key);
  final String uid;
  @override
  _TopWidgetState createState() => _TopWidgetState();
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
            child: FutureBuilder<String>(
              future: DatabaseService().fetchAddress(widget.uid, 'Home'),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Text('Loading...', textAlign: TextAlign.left);
                } else if (snapshot.hasError) {
                  return Text('Error', textAlign: TextAlign.left);
                } else {
                  return Text.rich(
                    TextSpan(
                      text: snapshot.data ?? '',
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

class HomePage extends StatelessWidget {
  final String userId;

  const HomePage({Key? key, required this.userId}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(238, 221, 198, 1),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                FutureBuilder<String>(
                  future: DatabaseService()
                      .fetchUserName(userId), // Replace with actual user ID
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Loading(); // Placeholder while loading
                    } else {
                      if (snapshot.hasError) {
                        return Text('Error: ${snapshot.error}');
                      } else {
                        String username = snapshot.data ?? 'User';
                        return Text(
                          'Hey $username',
                          style: TextStyle(
                            color: Color.fromRGBO(50, 52, 62, 1),
                            fontFamily: 'Poppins',
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        );
                      }
                    }
                  },
                ),
                SizedBox(height: 16.0),
                TextField(
                  decoration: InputDecoration(
                    prefixIcon: const Icon(Icons.search),
                    hintText: 'Search dishes, kitchens',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                  ),
                ),
                const SizedBox(height: 24.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'All Categories',
                      style: TextStyle(
                        color: Color.fromRGBO(50, 52, 62, 1),
                        fontSize: 20,
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    TextButton(
                      onPressed: () {},
                      child: Row(
                        children: [
                          const Text(
                            'See All',
                            style: TextStyle(
                              fontFamily: 'Poppins',
                              fontWeight: FontWeight.w400,
                              color: Colors.black,
                            ),
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          Image.asset(
                            'assets/images/Home/vector1.png',
                            scale: 1.5,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8.0),
                Categories(userId: userId),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Top Rated Kitchens',
                      style: TextStyle(
                        color: Color.fromRGBO(50, 52, 62, 1),
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Poppins',
                      ),
                    ),
                    TextButton(
                      onPressed: () {},
                      child: Row(
                        children: [
                          const Text(
                            'See All',
                            style: TextStyle(
                              fontFamily: 'Poppins',
                              fontWeight: FontWeight.w400,
                              color: Colors.black,
                            ),
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          Image.asset(
                            'assets/images/Home/vector1.png',
                            scale: 1.5,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8.0),
                TopRatedKitchenList(userId: userId),
              ],
            ),
          ),
        ),
      ),
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
  final String userId;

  const OrdersPage({Key? key, required this.userId}) : super(key: key);
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
            OngoingOrders(
              userId: userId,
            ),
            HistoryOrders(
              userId: userId,
            ),
          ],
        ),
      ),
    ]);
  }
}

class ProfilePage extends StatelessWidget {
  final String userId;

  const ProfilePage({Key? key, required this.userId}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Map<String, dynamic>?>(
      future: DatabaseService()
          .fetchUserProfile(userId), // Replace with actual user ID
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: Loading()); // Placeholder while loading
        } else {
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (snapshot.hasData && snapshot.data != null) {
            String username = snapshot.data!['name'] ?? 'User';
            String avatarurl = snapshot.data!['avatarurl'] ?? '';
            String email = snapshot.data!['email'] ?? 'Email';
            String phoneNo = snapshot.data!['phone_number'] ?? '000-000-000';
            String bio = snapshot.data!['bio'] ?? 'Homely';

            return LayoutBuilder(
              builder: (context, constraints) {
                return SingleChildScrollView(
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      minHeight: constraints.maxHeight,
                    ),
                    child: IntrinsicHeight(
                      child: InkWell(
                        onTap: () {
                          // Navigate to personal info page
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => PersonalInfoPage(
                                      username: username,
                                      avatarurl: avatarurl,
                                      email: email,
                                      phoneNo: phoneNo,
                                      bio: bio,
                                      id: userId,
                                      iskitchen: false,
                                    )),
                          );
                        },
                        child: Column(
                          children: [
                            SizedBox(height: 20),
                            CircleAvatar(
                              radius: 50,
                              backgroundColor: Colors.grey,
                              backgroundImage: avatarurl.isNotEmpty
                                  ? NetworkImage(avatarurl)
                                  : null,
                            ),
                            SizedBox(height: 16),
                            Text(
                              username,
                              style: TextStyle(
                                fontFamily: 'Poppins',
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                            SizedBox(height: 16),
                            _buildSection(
                              context,
                              title: 'Personal Info',
                              icon: Icons.person,
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => PersonalInfoPage(
                                            username: username,
                                            avatarurl: avatarurl,
                                            email: email,
                                            phoneNo: phoneNo,
                                            bio: bio,
                                            id: userId,
                                            iskitchen: false,
                                          )),
                                );
                              },
                              iconColor: Colors.blue,
                            ),
                            _buildSection(
                              context,
                              title: 'Addresses',
                              icon: Icons.location_on,
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => MyAddressPage(
                                            id: userId,
                                          )),
                                );
                              },
                              iconColor: Colors.red,
                            ),
                            _buildSection(
                              context,
                              title: 'Order Tracking',
                              icon: Icons.track_changes,
                              onTap: () {},
                              iconColor: Colors.orange,
                            ),
                            SizedBox(height: 16),
                            _buildSection(
                              context,
                              title: 'About Us',
                              icon: Icons.shopping_cart,
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => AboutUsScreen()),
                                );
                              },
                              iconColor: Colors.green,
                            ),
                            _buildSection(
                              context,
                              title: 'Most Ordered',
                              icon: Icons.favorite,
                              onTap: () {},
                              iconColor: Colors.pink,
                            ),
                            _buildSection(
                              context,
                              title: 'Notifications',
                              icon: Icons.notifications,
                              onTap: () {},
                              iconColor: Colors.amber,
                            ),
                            _buildSection(
                              context,
                              title: 'Payment Method',
                              icon: Icons.payment,
                              onTap: () {},
                              iconColor: Colors.purple,
                            ),
                            SizedBox(height: 16),
                            _buildSection(
                              context,
                              title: 'Settings',
                              icon: Icons.settings,
                              onTap: () {},
                              iconColor: Colors.grey,
                            ),
                            _buildSection(
                              context,
                              title: 'Log-out',
                              icon: Icons.logout,
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => MainloginWidget()),
                                );
                              },
                              iconColor: Colors.redAccent,
                            ),
                            SizedBox(height: 16),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
            );
          } else {
            return Center(child: Text('User not found.'));
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
  }) {
    return Container(
      color: Colors.white,
      margin: EdgeInsets.symmetric(vertical: 4, horizontal: 16),
      child: Material(
        elevation: 0, // Initial elevation (no shadow)
        borderRadius: BorderRadius.circular(8),
        child: InkWell(
          onTap: onTap,
          onHighlightChanged: (isTapped) {
            // Change shadow elevation when tapped
            MaterialStateProperty.resolveWith<double>(
              (Set<MaterialState> states) {
                if (states.contains(MaterialState.pressed)) {
                  return 10; // Elevation when pressed
                }
                return 0; // Elevation when not pressed
              },
            );
          },
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
            trailing: Icon(Icons.arrow_forward_ios, color: Colors.black),
          ),
        ),
      ),
    );
  }
}
