import 'package:first_project/screens/component/employeeTable.dart';
import 'package:flutter/material.dart';

class Project {
  final String title;
  final String description;
  final String projectManager;
  final List<String> employees;
  final double progress;
  final String location;
  final DateTime startDate;
  final DateTime endDate;
  final String projectType;

  Project({
    required this.title,
    required this.description,
    required this.projectManager,
    required this.employees,
    required this.progress,
    required this.location,
    required this.startDate,
    required this.endDate,
    required this.projectType,
  });
}

class ProjectDetailsScreen extends StatelessWidget {
  // Dummy project data
  final Project project = Project(
    title: 'Mobile App Development',
    description: 'Develop a mobile app for e-commerce with Flutter.',
    projectManager: 'John Doe',
    employees: ['Alice', 'Bob', 'Charlie', 'David'],
    progress: 75.0, // Progress in percentage
    location: 'New York, USA',
    startDate: DateTime(2023, 1, 15),
    endDate: DateTime(2024, 1, 15),
    projectType: 'Software Development',
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        foregroundColor: Colors.white,
        title: const Text('Project Details'),
        backgroundColor: const Color.fromARGB(255, 80, 160, 170),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildCard(
                title: project.title,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildDetailRow('Project Manager', project.location),
                      _buildDetailRow('Location', project.location),
                      _buildDetailRow('Start Date',
                          project.startDate.toLocal().toString().split(' ')[0]),
                      _buildDetailRow('End Date',
                          project.endDate.toLocal().toString().split(' ')[0]),
                      _buildDetailRow('Project Type', project.projectType),
                      Text(
                        project.description,
                        style: const TextStyle(
                          fontSize: 16,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const Expanded(child: AllEmployeeTable()),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        children: [
          Text(
            '$label: ',
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

  Widget _buildCard({required String title, required Widget child}) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      elevation: 4,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(12.0),
            decoration: const BoxDecoration(
              color: Color.fromARGB(255, 80, 160, 170),
              borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
            ),
            child: Text(
              title,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
          child,
        ],
      ),
    );
  }
}
