import 'package:flutter/material.dart';
import 'package:flutter_application_1/home.dart';
import 'package:flutter_application_1/LoginpageWidget.dart';
import 'package:flutter_application_1/services/database.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:uuid/uuid.dart'; // Import UUID package
import 'package:crypto/crypto.dart'; // Import crypto package
import 'dart:convert'; // For utf8 encoding

class SignupuserWidget extends StatefulWidget {
  @override
  _SignupuserWidgetState createState() => _SignupuserWidgetState();
}

class _SignupuserWidgetState extends State<SignupuserWidget> {
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

  String _hashPassword(String password) {
    final bytes = utf8.encode(password); // Convert password to bytes
    final digest = sha256.convert(bytes);
    return digest.toString();
  }

  Future<void> _submitForm() async {
    if (_formKey.currentState?.validate() ?? false) {
      if (_agreeToTerms) {
        final email = _emailController.text.trim();
        final password = _passwordController.text.trim();
        final hashedPassword = _hashPassword(password);
        final name = _nameController.text.trim();

        bool emailInUse = await DatabaseService().isEmailInUse(email, false);
        bool nameInUse = await DatabaseService().isNameInUse(name);

        if (emailInUse) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Email is already in use')),
          );
        } else if (nameInUse) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Name is already in use')),
          );
        } else {
          final userId = Uuid().v4(); // Generate a random user ID

          final userData = {
            'user_id': userId,
            'name': _nameController.text.trim(),
            'email': email,
            'password': hashedPassword,
            'phone_number': _phoneController.text.trim(),
            'avatarurl': '',
            'bio': '',
            'addresses': [],
            'ongoing_orders': [],
            'order_history': [],
            'notifications': [
              {
                'type': 'order_update',
                'message': 'Your order is on the way!',
              },
            ],
            'messages': [
              {
                'sender': 'support',
                'message': 'How can we help you?',
                'time': '10:30 AM',
                'avatarImagePath': 'assets/images/support_avatar.png',
              },
            ],
            'most_ordered_kitchen': [],
          };

          await DatabaseService().updateUserData(
            userId,
            name: userData['name'].toString(),
            email: userData['email'].toString(),
            password: userData['password'].toString(),
            phoneNumber: userData['phone_number'].toString(),
            avatarurl: "",
            addresses: [],
            bio: "",
            ongoingOrders: [],
            orderHistory: [],
            notifications: (userData['notifications'] as List<dynamic>?)
                ?.map((notification) => notification as Map<String, dynamic>)
                .toList(),
            messages: (userData['messages'] as List<dynamic>?)
                ?.map((message) => message as Map<String, dynamic>)
                .toList(),
          );

          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => HomeScreen(uid: userId)),
          );
        }
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
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: Container(
                height: 350,
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
                  SizedBox(height: 250),
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
                            'SIGN - UP',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Color.fromRGBO(201, 160, 112, 1),
                              fontFamily: 'Poppins',
                              fontSize: 35,
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
                                  'Email',
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
                                      onTap: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  LoginpageWidget()),
                                        );
                                      },
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
