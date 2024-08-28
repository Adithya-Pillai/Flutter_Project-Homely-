import 'package:flutter/material.dart';

class AboutUsScreen extends StatefulWidget {
  @override
  _AboutUsScreenState createState() => _AboutUsScreenState();
}

class _AboutUsScreenState extends State<AboutUsScreen> {
  final List<String> images = [
    'assets/images/aboutus/charvi.jpg',
    'assets/images/aboutus/Pillai.jpg',
    'assets/images/aboutus/aditi.jpg',
    'assets/images/aboutus/akash.jpg',
  ];

  final List<String> names = [
    'Adikar Charvi Sree Teja\n1BM22CS012',
    'Adithya Pillai\n1BM22CS013',
    'Aditi C\n1BM22CS014',
    'Akash K S\n1BM22CS028',
  ];

  int currentIndex = 0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Future.delayed(Duration(seconds: 4), () {
        _autoScroll();
      });
    });
  }

  void _autoScroll() {
    if (mounted) {
      setState(() {
        currentIndex = (currentIndex + 1) % images.length;
      });
      Future.delayed(Duration(seconds: 2), _autoScroll);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFEEDDC6), // Background color added
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: Colors.black),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        title: Text(
          'About Us',
          style: TextStyle(color: Colors.black),
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16.0),
              child: Text(
                'MEET THE TEAM',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Poppins',
                  color: Colors.brown[700], // Enhancing the title color
                ),
              ),
            ),
            Container(
              decoration: BoxDecoration(
                color: Colors.brown[300],
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 10,
                    offset: Offset(0, 5),
                  ),
                ],
              ),
              height: 300,
              margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: Center(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20.0),
                  child: Stack(
                    children: [
                      _buildImage(images[currentIndex]),
                      Positioned(
                        bottom: 0,
                        left: 0,
                        right: 0,
                        child: Container(
                          color: Colors.black.withOpacity(0.6),
                          padding: EdgeInsets.symmetric(vertical: 10.0),
                          child: Text(
                            names[currentIndex],
                            style: TextStyle(
                              fontFamily: 'Poppins',
                              fontSize: 16,
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                children: [
                  Text(
                    'Welcome to “Homely”! We’re delighted to be your go-to spot for cozy, home-cooked meals delivered right to your door. We know there’s something truly special about the comfort and joy of a home-cooked meal, and that’s why we’ve teamed up with amazing home chefs from your very own community.\n\nEach meal is crafted with love, using fresh, locally sourced ingredients that make every bite a little taste of home. Whether you\'re in the mood for a hearty dinner, a light lunch, or anything in between, we’ve got you covered.\n\nOur mission is simple: to bring the warmth and care of home-cooked meals to your table, so every meal feels like a comforting moment to savor. We’re here to make your dining experience as personal and delightful as possible.',
                    style: TextStyle(
                      fontSize: 16,
                      height: 1.6,
                      color: Colors.brown[800], // Text color enhancement
                      fontFamily: 'Poppins',
                    ),
                    textAlign: TextAlign.justify,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildImage(String path) {
    return Image.asset(
      path,
      width: 200, // Increased the image size for better visibility
      height: 250,
      fit: BoxFit.cover,
      errorBuilder: (context, error, stackTrace) {
        return Container(
          width: 200,
          height: 250,
          color: Colors.grey[400], // Grey fallback color
          child: Center(
            child: Icon(
              Icons.broken_image,
              size: 50,
              color: Colors.white,
            ),
          ),
        );
      },
    );
  }
}
