import 'package:first_project/flutter_session.dart';
import 'package:first_project/screens/component/projectInfo.dart';
import 'package:first_project/screens/component/userInfo.dart';
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

  // Controller for editable fields
  final TextEditingController addressController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  String profileImageUrl = 'https://via.placeholder.com/150'; // Placeholder image URL

  @override
  void initState() {
    super.initState();
    // Initialize controllers with existing data
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
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            UserInfoSection(
              fullName: users['firstName'] + " " + users['lastName'],
              position: users['position'],
              ids: users['id'],
              profileImage: users['profileImage'],
            ),
            const ProjectInfoSection(),
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
                decoration: BoxDecoration(color: const Color.fromARGB(255, 80, 160, 170).withOpacity(0.05)),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ProfileDetailRow('Profile ID', users['id']!),
                      ProfileDetailRow('First Name', users['firstName']!),
                      ProfileDetailRow('Middle Name', users['middleName']!),
                      ProfileDetailRow('Last Name', users['lastName']!),
                      ProfileDetailRow('Gender', users['gender']!),
                      ProfileDetailRow('Email', users['email']!),
                      ProfileDetailRow('Position', users['position'] == "" ? "NOT ASSIGNED" : users['position']),
                      ProfileDetailRow('Department', users['department']!),
                      ProfileDetailRow('Start Date', users['startDate']!),
                      ProfileDetailRow('End Date', users['endDate'] ?? "NOT SET"),
                      ProfileDetailRow('Salary', users['position'] == "" ? "NOT ASSIGNED" : users['salary']!),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Editable Fields
            Card(
              elevation: 5,
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    EditableProfileDetail(
                      label: 'Address',
                      controller: addressController,
                    ),
                    EditableProfileDetail(
                      label: 'Phone',
                      controller: phoneController,
                    ),
                  ],
                ),
              ),
            ),

            // Save Button
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _saveProfileChanges,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color.fromARGB(255, 80, 160, 170),
                minimumSize: Size(double.infinity, 50), // Full-width button
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text(
                'Save Changes',
                style: TextStyle(fontSize: 16, color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Function to show profile image picker
  void _pickProfileImage() {
    // For simplicity, using a hardcoded URL to simulate image selection.
    setState(() {
      profileImageUrl = 'https://via.placeholder.com/150/0000FF';
    });
  }

  void _saveProfileChanges() {
    setState(() {
      profileData['address'] = addressController.text;
      profileData['phone'] = phoneController.text;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Profile updated successfully!')),
    );
  }
}

class ProfileDetailRow extends StatelessWidget {
  final String label;
  final String value;

  const ProfileDetailRow(this.label, this.value, {super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            '$label:',
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          Text(
            value,
            style: const TextStyle(fontSize: 16),
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
