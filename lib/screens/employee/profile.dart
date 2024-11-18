import 'package:first_project/screens/component/projectInfo.dart';
import 'package:first_project/screens/employee_dashboard.dart';
import 'package:flutter/material.dart';

class ProfileScreen extends StatefulWidget {
  ProfileScreen({Key? key}) : super(key: key);

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
            // Profile Image
            const UserInfoSection(),
            const ProjectInfoSection(),
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
                      ProfileDetailRow('Profile ID', profileData['profileId']!),
                      ProfileDetailRow('First Name', profileData['firstName']!),
                      ProfileDetailRow('Middle Name', profileData['middleName']!),
                      ProfileDetailRow('Last Name', profileData['lastName']!),
                      ProfileDetailRow('Gender', profileData['gender']!),
                      ProfileDetailRow('Email', profileData['email']!),
                      ProfileDetailRow('Position', profileData['position']!),
                      ProfileDetailRow('Department', profileData['department']!),
                      ProfileDetailRow('Start Date', profileData['startDate']!),
                      ProfileDetailRow('End Date', profileData['endDate']!),
                      ProfileDetailRow('Salary', profileData['salary']!),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Editable Fields
            Card(
              elevation: 4,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    EditableProfileDetail(
                      label: 'Address',
                      controller: addressController,
                    ),
                    const SizedBox(height: 16),
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
                backgroundColor: Colors.blue,
                minimumSize: Size(double.infinity, 50), // Full-width button
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text(
                'Save Changes',
                style: TextStyle(fontSize: 16),
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

  // Function to save the changes
  void _saveProfileChanges() {
    // Save the changes and show a success message
    setState(() {
      profileData['address'] = addressController.text;
      profileData['phone'] = phoneController.text;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Profile updated successfully!')),
    );
  }
}

// Reusable Widget to display profile details
class ProfileDetailRow extends StatelessWidget {
  final String label;
  final String value;

  const ProfileDetailRow(this.label, this.value, {Key? key}) : super(key: key);

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
        Text(
          label,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
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
