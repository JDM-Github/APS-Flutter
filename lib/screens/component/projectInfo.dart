import 'package:flutter/material.dart';

class ProjectInfoSection extends StatelessWidget {
  const ProjectInfoSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20.0),
      decoration: BoxDecoration(
        color: Colors.grey[200],
      ),
      child: const Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Project Manager: Jane Smith',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Text(
              'Current Assignment: Team A - Mobile App Development',
              style: TextStyle(fontSize: 14),
            ),
          ],
        )
      ]),
    );
  }
}
