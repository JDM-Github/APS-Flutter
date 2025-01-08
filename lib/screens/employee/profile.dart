import 'dart:convert';
import 'package:first_project/screens/employee_dashboard.dart';
import 'package:http/http.dart' as http;

import 'package:first_project/flutter_session.dart';
import 'package:first_project/handle_request.dart';
import 'package:first_project/screens/component/projectInfo.dart';
import 'package:first_project/screens/component/userInfo.dart';
import 'package:first_project/screens/employee/modals/update_profile.dart';
import 'package:flutter/material.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  // Sample data for the user profile
  final Map<String, String> profileData = {
    'profileId': '12345',
    'firstName': 'John',
    'middleName': 'Michael',
    'lastName': 'Doe',
    'gender': 'Male',
    'email': 'john.doe@example.com',
    'phone': '123-456-7890',
    'address': '123 Main St, City, Country',
    'position': 'Software Engineer',
    'department': 'Development',
    'startDate': '2022-01-01',
    'endDate': '2023-01-01',
    'salary': '\$80,000',
  };

  final TextEditingController addressController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  String profileImageUrl = 'https://via.placeholder.com/150';

  @override
  void initState() {
    super.initState();
    addressController.text = profileData['address'] ?? '';
    phoneController.text = profileData['phone'] ?? '';
  }

  @override
  Widget build(BuildContext context) {
    Map<String, dynamic> users = Config.get('user');
    addressController.text = users['location'];
    phoneController.text = users['phoneNumber'];
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        foregroundColor: Colors.white,
        backgroundColor: const Color.fromARGB(255, 80, 160, 170),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () {
              _showEditModal(users, context);
            },
            tooltip: 'Edit Profile',
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            UserInfoSection(
              users['email'],
              users['isVerified'],
              fullName: users['firstName'] + " " + users['lastName'],
              position: users['position'],
              ids: users['id'],
              profileImage: users['profileImage'],
            ),
            Card(
              elevation: 5,
              child: Padding(
                padding: EdgeInsets.all(10.0),
                child: Wrap(
                  spacing: 8.0,
                  children: (users['skills'] as List)
                      .map((skill) => Chip(
                            side: BorderSide.none,
                            backgroundColor: const Color.fromARGB(255, 80, 160, 170),
                            label: Text(
                              skill,
                              style: const TextStyle(color: Colors.white),
                            ),
                          ))
                      .toList(),
                ),
              ),
            ),
            const SizedBox(height: 5),
            Card(
              elevation: 4,
              child: Container(
                decoration: BoxDecoration(color: const Color.fromARGB(255, 80, 160, 170).withAlpha(10)),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ProfileDetailRow(label: 'Profile ID', value: users['id']!, icon: Icons.account_circle),
                      ProfileDetailRow(label: 'First Name', value: users['firstName']!, icon: Icons.person),
                      ProfileDetailRow(label: 'Middle Name', value: users['middleName']!, icon: Icons.person_add),
                      ProfileDetailRow(label: 'Last Name', value: users['lastName']!, icon: Icons.person),
                      ProfileDetailRow(label: 'Gender', value: users['gender']!, icon: Icons.accessibility),
                      ProfileDetailRow(label: 'Email', value: users['email']!, icon: Icons.email),
                      ProfileDetailRow(label: 'Location', value: users['location']!, icon: Icons.location_on),
                      ProfileDetailRow(label: 'Phone Number', value: users['phoneNumber']!, icon: Icons.phone),
                      ProfileDetailRow(
                          label: 'Position',
                          value: users['position'] == "" ? "NOT ASSIGNED" : users['position'],
                          icon: Icons.work),
                      ProfileDetailRow(label: 'Department', value: users['department']!, icon: Icons.business),
                      ProfileDetailRow(label: 'Start Date', value: users['startDate']!, icon: Icons.calendar_today),
                      ProfileDetailRow(
                          label: 'End Date', value: users['endDate'] ?? "NOT SET", icon: Icons.calendar_today),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Future<String> uploadFile(selectedFile) async {
    if (selectedFile == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select a file to upload.')),
      );
      return "";
    }

    try {
      var request = http.MultipartRequest(
          'POST', Uri.parse('https://aps-backend.netlify.app/.netlify/functions/api/file/upload-file'));
      request.files.add(await http.MultipartFile.fromPath('file', selectedFile));

      var streamedResponse = await request.send();
      var response = await http.Response.fromStream(streamedResponse);

      if (response.statusCode == 200) {
        var responseData = jsonDecode(response.body);
        if (responseData['success']) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('File uploaded: ${responseData['uploadedDocument']}')),
          );
          return responseData['uploadedDocument'];
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Upload failed: ${responseData['message']}')),
          );
        }
      } else {
        throw Exception('Failed to upload file. Status code: ${response.statusCode}');
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('An error occurred: $e')),
      );
    }
    return "";
  }

  Future<void> updateAndSave(dynamic user, dynamic selectedImage, dynamic updatedUser) async {
    String uploadedFile = "";
    if (selectedImage != null) {
      uploadedFile = await uploadFile(selectedImage.path);
    }
    RequestHandler requestHandler = RequestHandler();
    try {
      Map<String, dynamic> response = await requestHandler.handleRequest(
        context,
        'users/updateProfile',
        body: {
          "profile": selectedImage != null ? "" : user['profileImage'],
          "userId": user['id'],
          "address": updatedUser["location"],
          "phone": updatedUser["phone"],
        },
      );

      if (response['success'] == true) {
        setState(() {
          profileData['address'] = updatedUser["location"];
          profileData['phone'] = updatedUser["phone"];
          profileData['profileImage'] = uploadedFile;

          Map<String, dynamic> users = Config.get("user");
          users['location'] = updatedUser["location"];
          users['phoneNumber'] = updatedUser["phone"];
          users['profileImage'] = uploadedFile;
          Config.set("user", users);
        });
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Profile updated successfully!')),
        );
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (builder) => DashboardScreen()));
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(response['message'] ?? 'Failed to update profile.')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('An error occurred: $e')),
      );
    }
  }

  void _showEditModal(dynamic user, BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => EditProfileModal(
          user: user,
          onSave: (selectedImage, updatedUser) async {
            updateAndSave(user, selectedImage, updatedUser);
          }),
    );
  }

}

class ProfileDetailRow extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;

  const ProfileDetailRow({
    required this.label,
    required this.value,
    this.icon = Icons.info_outline,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: Row(
        children: [
          Icon(icon, size: 18, color: Colors.grey),
          const SizedBox(width: 8.0),
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '$label:',
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 14,
                    color: Colors.black87,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class EditableProfileDetail extends StatelessWidget {
  final String label;
  final TextEditingController controller;

  const EditableProfileDetail({
    required this.label,
    required this.controller,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          decoration: InputDecoration(
            border: const OutlineInputBorder(),
            hintText: 'Enter $label',
          ),
        ),
      ],
    );
  }
}
