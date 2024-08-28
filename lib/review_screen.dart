import 'package:flutter/material.dart';
import 'package:flutter_application_1/services/database.dart';
import 'package:flutter_application_1/widgets/loading.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ReviewScreen extends StatefulWidget {
  final String kitchenId;

  ReviewScreen({required this.kitchenId});

  @override
  _ReviewScreenState createState() => _ReviewScreenState();
}

class _ReviewScreenState extends State<ReviewScreen> {
  late Future<Map<String, dynamic>?> _kitchenData;
  double _newRating = 1;

  @override
  void initState() {
    super.initState();
    _kitchenData = DatabaseService().fetchKitchenProfile(widget.kitchenId);
  }

  Future<void> _submitReview(double rating) async {
    try {
      final CollectionReference kitchensCollection =
          FirebaseFirestore.instance.collection('kitchens');
      final kitchenData = await _kitchenData;
      if (kitchenData == null) return;

      final currentRating = kitchenData['rating'] as double? ?? 0.0;
      final numberOfReviews = (kitchenData['numberOfReviews'] as int?) ?? 0;
      if (numberOfReviews == 0) {
        await kitchensCollection.doc(widget.kitchenId).update({
          'rating': rating,
          'numberOfReviews': 1,
        });
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('Review submitted')));
        return;
      } else {
        final newRating = ((currentRating) + rating) / 2;

        await kitchensCollection.doc(widget.kitchenId).update({
          'rating': newRating,
          'numberOfReviews': numberOfReviews + 1,
        });

        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('Review submitted')));
      }
    } catch (e) {
      print('Error submitting review: $e');
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Error submitting review')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        title: Text('Review', style: TextStyle(color: Colors.black)),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: FutureBuilder<Map<String, dynamic>?>(
        future: _kitchenData,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: Loading());
          }

          if (snapshot.hasError || !snapshot.hasData) {
            return Center(child: Text('Error fetching kitchen data'));
          }

          final kitchenData = snapshot.data!;
          final kitchenName = kitchenData['name'] ?? 'Kitchen';
          final kitchenRating = kitchenData['rating'] ?? 0.0;
          final kitchenImage = kitchenData['kitchenimage'] ?? '';

          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  padding: EdgeInsets.all(16.0),
                  color: Color(0xFFF5E0C3),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        'Hope you like your Home-cooked meal!',
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 8),
                      Text(
                        'Please provide your valuable feedback',
                        style: TextStyle(color: Colors.grey),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 16),
                Expanded(
                  child: ListView(
                    children: [
                      ReviewItem(
                        title: kitchenName,
                        initialRating: kitchenRating,
                        imagePath: kitchenImage,
                        onRatingUpdate: (rating) {
                          setState(() {
                            _newRating = rating;
                          });
                        },
                      ),
                    ],
                  ),
                ),
                Center(
                  child: ElevatedButton(
                    onPressed: () {
                      _submitReview(_newRating);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFFCB997E),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      padding:
                          EdgeInsets.symmetric(horizontal: 48, vertical: 12),
                    ),
                    child: Text('SUBMIT'),
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

class ReviewItem extends StatelessWidget {
  final String title;
  final double initialRating;
  final String imagePath;
  final ValueChanged<double> onRatingUpdate;

  ReviewItem({
    required this.title,
    required this.initialRating,
    required this.imagePath,
    required this.onRatingUpdate,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              image: DecorationImage(
                image: NetworkImage(imagePath),
                fit: BoxFit.cover,
              ),
            ),
          ),
          SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 4),
                Text('Nice'),
                SizedBox(height: 8),
                RatingBar.builder(
                  initialRating: initialRating,
                  minRating: 1,
                  direction: Axis.horizontal,
                  allowHalfRating: true,
                  itemCount: 5,
                  itemPadding: EdgeInsets.symmetric(horizontal: 2.0),
                  itemBuilder: (context, _) => Icon(
                    Icons.star,
                    color: Colors.amber,
                  ),
                  onRatingUpdate: onRatingUpdate,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
