import 'package:first_project/screens/verify_email.dart';
import 'package:flutter/material.dart';

class UserInfoSection extends StatelessWidget {
  final String profileImage;
  final String position;
  final String fullName;
  final String email;
  final String ids;
  final bool isVerified;
  const UserInfoSection(
      this.email,
      this.isVerified,
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
            color: Colors.black.withAlpha(51),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 35,
            backgroundImage: NetworkImage(profileImage),
            backgroundColor: Colors.white,
          ),
          SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(Icons.person, color: Colors.white70, size: 18),
                    SizedBox(width: 5),
                    Text(
                      fullName,
                      style: TextStyle(
                        fontSize: 14,
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
                      style: TextStyle(fontSize: 12, color: Colors.white70),
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
                      style: TextStyle(fontSize: 12, color: Colors.white70),
                    ),
                  ],
                ),
              ],
            )
          ),
          IconButton(
            icon: Icon(!isVerified ? Icons.error_outline : Icons.verified, color: Colors.white),
            onPressed: () {
              if (!isVerified)
              {
                Navigator.push(context, MaterialPageRoute(builder: (builder) => VerifyEmail(this.email))); 
              }
            },
          ),
        ],
        
      ),
    );
  }
}
