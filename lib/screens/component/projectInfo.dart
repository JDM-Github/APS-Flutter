import 'package:first_project/flutter_session.dart';
import 'package:flutter/material.dart';

class ProjectInfoSection extends StatelessWidget {
  const ProjectInfoSection({super.key});

  @override
  Widget build(BuildContext context) {
    Map<String, dynamic> users = Config.get('user');
    return Container(
      padding: const EdgeInsets.all(20.0),
      decoration: BoxDecoration(
        color: Colors.grey[200],
      ),
      child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (users['isManager'])
              Text(
                'THE PROJECT MANAGER',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Color.fromARGB(255, 80, 160, 170),
                ),
              ),
            if (!users['isManager'])
              Text(
                'Project Manager: ${(users['projectManager'] == '') ? 'NO PROJECT MANAGER' : users['projectManager']}',
                style: const TextStyle(fontSize: 12),
              ),
            const SizedBox(height: 10),
            const Text(
              'Current Assignment: Team A - Mobile App Development',
              style: TextStyle(fontSize: 12),
            ),
          ],
        )
      ]),
    );
  }
}
