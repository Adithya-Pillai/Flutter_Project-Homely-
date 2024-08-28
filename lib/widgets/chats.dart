import 'package:flutter/material.dart';

class ChatMessage extends StatelessWidget {
  final String senderName;
  final String message;
  final String time;
  final String avatarImagePath;

  const ChatMessage({
    required this.senderName,
    required this.message,
    required this.time,
    required this.avatarImagePath,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: CircleAvatar(
        backgroundImage: AssetImage(avatarImagePath),
      ),
      title: Text(
        senderName,
        style: TextStyle(
          fontFamily: 'Poppins',
          fontWeight: FontWeight.bold,
        ),
      ),
      subtitle: Text(
        message,
        style: TextStyle(
          fontFamily: 'Poppins',
        ),
      ),
      trailing: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            time,
            style: TextStyle(
              fontFamily: 'Poppins',
            ),
          ),
          SizedBox(height: 4),
          CircleAvatar(
            radius: 10,
            backgroundColor: Colors.red,
            child: Text(
              '1',
              style: TextStyle(
                fontFamily: 'Poppins',
                color: Colors.white,
                fontSize: 12,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
