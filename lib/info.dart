import 'package:flutter/material.dart';
import 'package:flutter_application_1/chefhome.dart';
import 'package:flutter_application_1/editprofile.dart';

class PersonalInfoPage extends StatelessWidget {
  final String username;
  final String email;
  final String phoneNo;
  final String avatarurl;
  final String bio;
  final String id;
  final bool iskitchen;

  const PersonalInfoPage({
    Key? key,
    required this.username,
    required this.email,
    required this.phoneNo,
    required this.avatarurl,
    required this.bio,
    required this.id,
    required this.iskitchen,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(238, 221, 198, 1),
      appBar: AppBar(
        backgroundColor: Color.fromRGBO(238, 221, 198, 1),
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text(
          'Personal Info',
          style: TextStyle(
            color: Color.fromRGBO(50, 52, 62, 1),
            fontSize: 20,
            fontWeight: FontWeight.w400,
            fontFamily: 'Poppins',
          ),
        ),
        centerTitle: true,
        actions: [
          TextButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => EditProfilePage(
                          username: username,
                          avatarurl: avatarurl,
                          email: email,
                          phoneNo: phoneNo,
                          bio: bio,
                          id: id,
                          iskitchen: iskitchen,
                        )),
              );
            },
            child: Text(
              'EDIT',
              style: TextStyle(
                fontFamily: 'Poppins',
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            CircleAvatar(
              radius: 50,
              backgroundColor: Colors.grey,
              backgroundImage:
                  avatarurl.isNotEmpty ? NetworkImage(avatarurl) : null,
            ),
            SizedBox(height: 16),
            Text(
              username,
              style: TextStyle(
                fontFamily: 'Poppins',
                fontWeight: FontWeight.bold,
                fontSize: 18,
                color: Colors.black,
              ),
            ),
            SizedBox(height: 32),
            _buildInfoCard(
              icon: Icons.person,
              label: 'FULL NAME',
              info: username,
              iconColor: Colors.blue,
            ),
            _buildInfoCard(
              icon: Icons.email,
              label: 'EMAIL',
              info: email,
              iconColor: Colors.red,
            ),
            _buildInfoCard(
              icon: Icons.phone,
              label: 'PHONE NUMBER',
              info: phoneNo,
              iconColor: Colors.green,
            ),
            Spacer(),
            SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoCard({
    required IconData icon,
    required String label,
    required String info,
    required Color iconColor,
  }) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 8),
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Icon(icon, color: iconColor),
          SizedBox(width: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  fontFamily: 'Poppins',
                  color: Colors.black,
                  fontWeight: FontWeight.w400,
                ),
              ),
              Text(
                info,
                style: TextStyle(
                  fontFamily: 'Poppins',
                  color: Colors.black,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
