import 'package:flutter/material.dart';

class UserInfoSection extends StatelessWidget {
  final String profileImage;
  final String position;
  final String fullName;
  final String ids;
  const UserInfoSection(
      {super.key, this.profileImage = "assets/user.png", this.position = "", this.fullName = "", this.ids = ""});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 15.0, horizontal: 15.0),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color.fromARGB(255, 80, 160, 170),
            Color.fromARGB(255, 40, 120, 130),
          ],
        ),
        borderRadius: BorderRadius.circular(12.0),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 35,
            backgroundImage: AssetImage(profileImage),
            backgroundColor: Colors.white,
          ),
          SizedBox(width: 15),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(Icons.person, color: Colors.white70, size: 18),
                  SizedBox(width: 5),
                  Text(
                    fullName,
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 8),
              Row(
                children: [
                  Icon(Icons.work_outline, color: Colors.white70, size: 18),
                  SizedBox(width: 5),
                  Text(
                    position == '' ? "NONE" : position,
                    style: TextStyle(fontSize: 14, color: Colors.white70),
                  ),
                ],
              ),
              SizedBox(height: 8),
              Row(
                children: [
                  Icon(Icons.badge, color: Colors.white70, size: 18),
                  SizedBox(width: 5),
                  Text(
                    'ID: $ids',
                    style: TextStyle(fontSize: 14, color: Colors.white70),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
