import 'package:first_project/screens/component/employeeSchedule.dart';
import 'package:first_project/screens/component/userInfo.dart';
import 'package:flutter/material.dart';

class ViewEmployeeScreen extends StatelessWidget {
  final Map<String, dynamic> user;

  const ViewEmployeeScreen({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Employee Details'),
        backgroundColor: const Color.fromARGB(255, 80, 160, 170),
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            UserInfoSection(
                profileImage: user['profileImage'],
                position: user['position'],
                fullName: '${user['firstName'][0]}${user['lastName'][0]}',
                ids: user['id']),

            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.1),
                    spreadRadius: 1,
                    blurRadius: 8,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (user['isManager'])
                    Text(
                      'THE PROJECT MANAGER',
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Color.fromARGB(255, 80, 160, 170),
                      ),
                    ),
                  if (!user['isManager'])
                    Text(
                      'Project Manager: ${(user['projectManager'] == '') ? 'NO PROJECT MANAGER' : user['projectManager']}',
                      style: const TextStyle(fontSize: 16),
                    ),
                  const SizedBox(height: 10),
                  Text(
                    'Email: ${user['email']}',
                    style: const TextStyle(fontSize: 16),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    'Department: ${user['department']}',
                    style: const TextStyle(fontSize: 16),
                  ),
                  Wrap(
                    spacing: 8.0,
                    children: (user['skills'] as List)
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
                ],
              ),
            ),
            const SizedBox(height: 5),

            // Status Section
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.1),
                    spreadRadius: 1,
                    blurRadius: 8,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Status:',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Color.fromARGB(255, 80, 160, 170),
                    ),
                  ),
                  Text(
                    user['is_deactivated'] ? "Inactive" : "Active",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: user['is_deactivated'] ? Colors.red : Colors.green,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 500,
              child: const EmployeeSchedule(),
            )
          ],
        ),
      ),
    );
  }
}
