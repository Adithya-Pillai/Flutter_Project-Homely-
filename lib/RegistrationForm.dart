import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: RegistrationForm(),
    );
  }
}

class RegistrationForm extends StatefulWidget {
  @override
  _RegistrationForm createState() => _RegistrationForm();
}

class _RegistrationForm extends State<RegistrationForm> {
  final _formKey = GlobalKey<FormState>();

  // Controllers for form fields
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _establishmentController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          decoration: BoxDecoration(
            color: Colors.white,
          ),
          child: Stack(
            children: <Widget>[
              Positioned(
                top: 0,
                left: 0,
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  height: 363,
                  decoration: BoxDecoration(
                    color: Color.fromRGBO(238, 221, 198, 1),
                  ),
                ),
              ),
              Positioned(
                top: 181,
                left: 0,
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height - 181,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(24),
                      topRight: Radius.circular(24),
                    ),
                    color: Colors.white,
                  ),
                ),
              ),
              Positioned(
                top: 246,
                left: 33,
                right: 33,
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      buildLabel('NAME'),
                      _buildTextFieldContainer('Your name', _nameController),
                      SizedBox(height: 20),
                      buildLabel('EMAIL'),
                      _buildTextFieldContainer('example@gmail.com', _emailController),
                      SizedBox(height: 20),
                      buildLabel('PHONE NUMBER'),
                      _buildTextFieldContainer('+91 XXXXXXXXXX', _phoneController),
                      SizedBox(height: 20),
                      buildLabel('ESTABLISHMENT NAME'),
                      _buildTextFieldContainer('Your Establish Name', _establishmentController),
                      SizedBox(height: 20),
                      buildLabel('PASSWORD'),
                      _buildTextFieldContainer('********', _passwordController, obscureText: true),
                      SizedBox(height: 30),
                      Center(
                        child: GestureDetector(
                          onTap: () {
                            if (_formKey.currentState!.validate()) {
                              // Form is valid, proceed further
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text('Processing Data')),
                              );
                            }
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.all(Radius.circular(12)),
                              color: Color.fromRGBO(201, 160, 112, 1),
                            ),
                            padding: EdgeInsets.symmetric(horizontal: 100, vertical: 16),
                            child: Center(
                              child: Text(
                                'NEXT',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontFamily: 'Poppins',
                                  fontSize: 16,
                                  fontWeight: FontWeight.normal,
                                ),
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
                top: 20,
                left: 16,
                child: GestureDetector(
                  onTap: () {
                    // Handle back button press
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Back button pressed')),
                    );
                  },
                  child: Container(
                    width: 42,
                    height: 42,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.all(Radius.circular(42)),
                    ),
                    child: Center(
                      child: Icon(
                        Icons.arrow_back,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ),
              ),
              Positioned(
                top: 79,
                left: 71,
                right: 71,
                child: Text(
                  'Enter Your Details',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.black,
                    fontFamily: 'Poppins',
                    fontSize: 24,
                    fontWeight: FontWeight.normal,
                  ),
                ),
              ),
              Positioned(
                top: 106,
                left: 33,
                right: 33,
                child: Text(
                  'Please provide information on your establishment',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Color.fromRGBO(127, 121, 121, 1),
                    fontFamily: 'Poppins',
                    fontSize: 12,
                    fontWeight: FontWeight.normal,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildLabel(String labelText) {
    return Padding(
      padding: const EdgeInsets.only(left: 3.0, bottom: 5.0),
      child: Text(
        labelText,
        textAlign: TextAlign.left,
        style: TextStyle(
          color: Colors.black,
          fontFamily: 'Poppins',
          fontSize: 16,
          fontWeight: FontWeight.normal,
        ),
      ),
    );
  }

  Widget _buildTextFieldContainer(String hintText, TextEditingController controller, {bool obscureText = false}) {
    return Container(
      width: double.infinity,
      height: 62,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(18)),
        color: Color.fromRGBO(240, 245, 250, 1),
      ),
      padding: EdgeInsets.symmetric(horizontal: 16),
      child: Center(
        child: TextFormField(
          controller: controller,
          obscureText: obscureText,
          decoration: InputDecoration(
            hintText: hintText,
            border: InputBorder.none,
          ),
          validator: (value) {
            if (value!.isEmpty) {
              return 'Please enter $hintText';
            }
            return null;
          },
        ),
      ),
    );
  }
}
