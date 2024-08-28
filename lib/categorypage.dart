import 'package:flutter/material.dart';
import 'package:flutter_application_1/RestaurantViewScreen.dart';
import 'package:flutter_application_1/services/database.dart';
import 'package:flutter_application_1/widgets/loading.dart';

class CategoryDishesScreen extends StatefulWidget {
  final String category;
  final String userId;

  const CategoryDishesScreen(
      {Key? key, required this.category, required this.userId})
      : super(key: key);

  @override
  _CategoryDishesScreenState createState() => _CategoryDishesScreenState();
}

class _CategoryDishesScreenState extends State<CategoryDishesScreen> {
  late Future<List<Map<String, dynamic>>> _dishesFuture;
  final DatabaseService _firestoreService = DatabaseService();

  @override
  void initState() {
    super.initState();
    _dishesFuture = _firestoreService.fetchCategoryDishes(widget.category);
  }

  final Color backgroundColor = Color(0xFFF5E6C9);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: backgroundColor,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.brown),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text(
          widget.category,
          style: const TextStyle(
            color: Color.fromRGBO(50, 52, 62, 1),
            fontSize: 20,
            fontWeight: FontWeight.w400,
            fontFamily: 'Poppins',
          ),
        ),
        centerTitle: true,
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: _dishesFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: Loading());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No dishes available'));
          }

          final dishes = snapshot.data!;

          return Container(
            color: backgroundColor,
            padding: const EdgeInsets.all(16.0),
            child: GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                childAspectRatio: 0.75,
              ),
              itemCount: dishes.length,
              itemBuilder: (context, index) {
                final dish = dishes[index];
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => RestaurantViewScreen(
                                kitchenId: dish['kitchen_id'],
                                userId: widget.userId,
                              )),
                    );
                  },
                  child: Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16.0),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(16.0),
                          child: Image.network(
                            dish['image_item'] ??
                                'https://firebasestorage.googleapis.com/v0/b/homely-project-8be33.appspot.com/o/placeholder_images%2Fhomely_logo.jpeg?alt=media&token=9089f046-ad45-48c3-8ad6-b3f30c3ee7a5',
                            height: 120,
                            width: double.infinity,
                            fit: BoxFit.cover,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                dish['name'] ?? 'Dish Name',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.brown,
                                ),
                              ),
                              Text(
                                dish['description'] ??
                                    'Description not available',
                                style: TextStyle(color: Colors.brown),
                              ),
                              Text(
                                'Rs. ${dish['price'] ?? '0'}/-',
                                style: TextStyle(color: Colors.brown),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
