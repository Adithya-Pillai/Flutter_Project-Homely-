import 'package:flutter/material.dart';
import 'package:flutter_application_1/ChefLoginWidget.dart';
import 'package:flutter_application_1/LoginPageWidget.dart';
import 'package:geolocator/geolocator.dart';

class MainloginWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;
    var textScaleFactor =
        screenSize.width / 375; // Assuming a base width of 375

    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          width: screenSize.width,
          height: screenSize.height,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: Color.fromRGBO(238, 221, 198, 1),
          ),
          child: Stack(
            children: <Widget>[
              Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.only(top: screenSize.height * 0.03),
                      child: Text(
                        'LOGIN AS',
                        style: TextStyle(
                          color: Colors.black,
                          fontFamily: 'Poppins',
                          fontSize: 35 * textScaleFactor,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    SizedBox(height: screenSize.height * 0.04),
                    InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => LoginpageWidget()),
                        );
                      },
                      child: CircleAvatar(
                        radius: screenSize.width * 0.27,
                        backgroundImage:
                            AssetImage('assets/images/loginas/customer.png'),
                        backgroundColor: Colors.transparent,
                      ),
                    ),
                    SizedBox(height: screenSize.height * 0.02),
                    Text(
                      'CUSTOMER',
                      style: TextStyle(
                        color: Colors.black,
                        fontFamily: 'Poppins',
                        fontSize: 25 * textScaleFactor,
                        fontWeight: FontWeight.normal,
                      ),
                    ),
                    SizedBox(height: screenSize.height * 0.04),
                    InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => ChefLoginWidget()),
                        );
                      },
                      child: CircleAvatar(
                        radius: screenSize.width * 0.27,
                        backgroundImage:
                            AssetImage('assets/images/loginas/chef.png'),
                        backgroundColor: Colors.transparent,
                      ),
                    ),
                    SizedBox(height: screenSize.height * 0.02),
                    Text(
                      'CHEF',
                      style: TextStyle(
                        color: Colors.black,
                        fontFamily: 'Poppins',
                        fontSize: 25 * textScaleFactor,
                        fontWeight: FontWeight.normal,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
