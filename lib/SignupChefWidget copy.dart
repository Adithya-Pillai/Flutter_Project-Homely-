import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_application_1/LoginpageWidget.dart';
import 'package:flutter_application_1/ChefLoginWidget.dart';
import 'package:flutter_application_1/OtpWidget.dart';
import 'package:flutter_application_1/AddNewItemScreen.dart';

class SignupchefWidget extends StatefulWidget {
  @override
  _SignupchefWidgetState createState() => _SignupchefWidgetState();
}

class _SignupchefWidgetState extends State<SignupchefWidget> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  bool _agreeToTerms = false;

  bool _validateEmail(String email) {
    final RegExp emailRegExp = RegExp(
      r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9]+\.[a-zA-Z]+",
    );
    return emailRegExp.hasMatch(email);
  }

  bool _validatePhone(String phone) {
    final RegExp phoneRegExp = RegExp(r"^[0-9]{10}$");
    return phoneRegExp.hasMatch(phone);
  }

  bool _validatePassword(String password) {
    return password.length >= 6;
  }

  void _submitForm() {
    if (_formKey.currentState?.validate() ?? false) {
      if (_agreeToTerms) {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => ChefLoginWidget()),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('You must agree to the terms and conditions')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Stack(
          children: <Widget>[
            // Background Image
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: Container(
                height: 350, // Increased height for better visibility
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage(
                        'assets/images/signup/Freecookingfoodillustrationfreedownloadfooddrinkillustrationsiconscout1.png'),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
            Center(
              child: Column(
                children: <Widget>[
                  SizedBox(
                      height:
                          250), // Adjusted to provide more space for the image
                  Container(
                    width: double.infinity,
                    decoration: const BoxDecoration(
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(30),
                        topRight: Radius.circular(30),
                      ),
                      color: Color.fromRGBO(255, 255, 255, 1),
                    ),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        children: <Widget>[
                          const SizedBox(height: 30),
                          const Text(
                            'CHEF SIGN - UP',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Color.fromRGBO(201, 160, 112, 1),
                              fontFamily: 'Poppins',
                              fontSize: 30,
                              fontWeight: FontWeight.normal,
                              decoration: TextDecoration.none,
                            ),
                          ),
                          const SizedBox(height: 20),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            child: Column(
                              children: <Widget>[
                                buildTextFormField(
                                  'Name',
                                  Icons.person,
                                  _nameController,
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Please enter your name';
                                    } else if (value.length < 6) {
                                      return 'Name must be at least 6 characters';
                                    }
                                    return null;
                                  },
                                ),
                                const SizedBox(height: 20),
                                buildTextFormField(
                                  'Phone',
                                  Icons.phone,
                                  _phoneController,
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Please enter your phone number';
                                    } else if (!_validatePhone(value)) {
                                      return 'Please enter a valid phone number';
                                    }
                                    return null;
                                  },
                                ),
                                const SizedBox(height: 20),
                                buildTextFormField(
                                  'Mail',
                                  Icons.mail,
                                  _emailController,
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Please enter your email';
                                    } else if (!_validateEmail(value)) {
                                      return 'Please enter a valid email';
                                    }
                                    return null;
                                  },
                                ),
                                const SizedBox(height: 20),
                                buildTextFormField(
                                  'Password',
                                  Icons.lock,
                                  _passwordController,
                                  obscureText: true,
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Please enter your password';
                                    } else if (!_validatePassword(value)) {
                                      return 'Password must be at least 6 characters';
                                    }
                                    return null;
                                  },
                                ),
                                const SizedBox(height: 20),
                                buildTextFormField(
                                  'Confirm Password',
                                  Icons.lock,
                                  _confirmPasswordController,
                                  obscureText: true,
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Please confirm your password';
                                    } else if (value !=
                                        _passwordController.text) {
                                      return 'Passwords do not match';
                                    }
                                    return null;
                                  },
                                ),
                                const SizedBox(height: 20),
                                Row(
                                  children: <Widget>[
                                    Checkbox(
                                      value: _agreeToTerms,
                                      onChanged: (value) {
                                        setState(() {
                                          _agreeToTerms = value ?? false;
                                        });
                                      },
                                    ),
                                    const Text(
                                      'Agree to terms and conditions',
                                      style: TextStyle(
                                        color: Color.fromRGBO(126, 138, 151, 1),
                                        fontFamily: 'Poppins',
                                        fontSize: 13,
                                        fontWeight: FontWeight.normal,
                                        decoration: TextDecoration.none,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 20),
                                GestureDetector(
                                  onTap: _submitForm,
                                  child: Container(
                                    width: double.infinity,
                                    decoration: const BoxDecoration(
                                      borderRadius: BorderRadius.all(
                                        Radius.circular(12),
                                      ),
                                      color: Color.fromRGBO(201, 160, 112, 1),
                                    ),
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 16, vertical: 14),
                                    child: const Center(
                                      child: Text(
                                        'NEXT',
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          color:
                                              Color.fromRGBO(255, 255, 255, 1),
                                          fontFamily: 'Poppins',
                                          fontSize: 16,
                                          fontWeight: FontWeight.normal,
                                          decoration: TextDecoration.none,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 20),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    const Text(
                                      'Already have an account ?',
                                      style: TextStyle(
                                        color: Color.fromRGBO(100, 105, 130, 1),
                                        fontFamily: 'Sen',
                                        fontSize: 14,
                                        fontWeight: FontWeight.normal,
                                        height: 1.7142857142857142,
                                        decoration: TextDecoration.none,
                                      ),
                                    ),
                                    const SizedBox(width: 5),
                                    GestureDetector(
                                      onTap: () {},
                                      child: const Text(
                                        'LOG IN',
                                        style: TextStyle(
                                          color: Color.fromRGBO(65, 93, 241, 1),
                                          fontFamily: 'Poppins',
                                          fontSize: 14,
                                          fontWeight: FontWeight.normal,
                                          decoration: TextDecoration.none,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Positioned(
              top: 30,
              left: 10,
              child: GestureDetector(
                onTap: () {
                  Navigator.pop(context);
                },
                child: Container(
                  width: 26,
                  height: 29,
                  decoration: const BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage('assets/images/signup/31148832.png'),
                      fit: BoxFit.fitWidth,
                    ),
                  ),
                ),
              ),
            ),
            Positioned(
              top: 120,
              left: 0,
              right: 0,
              child: Center(
                child: SvgPicture.asset(
                  'assets/images/rectangle1575.svg',
                  semanticsLabel: 'rectangle1575',
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildTextFormField(
      String labelText, IconData icon, TextEditingController controller,
      {bool obscureText = false, String? Function(String?)? validator}) {
    return TextFormField(
      controller: controller,
      obscureText: obscureText,
      decoration: InputDecoration(
        prefixIcon: Icon(icon, color: Color.fromRGBO(185, 190, 206, 1)),
        labelText: labelText,
        labelStyle: TextStyle(
          color: Color.fromRGBO(185, 190, 206, 1),
          fontFamily: 'Poppins',
          fontSize: 16,
          fontWeight: FontWeight.normal,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30.0),
          borderSide: BorderSide(
            color: Color.fromRGBO(185, 190, 206, 1),
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30.0),
          borderSide: BorderSide(
            color: Color.fromRGBO(201, 160, 112, 1),
          ),
        ),
      ),
      validator: validator,
    );
  }
}
