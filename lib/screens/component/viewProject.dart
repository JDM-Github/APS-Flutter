import 'package:first_project/flutter_session.dart';
import 'package:first_project/screens/component/employee_list.dart';
import 'package:first_project/screens/component/employeeTable.dart';
import 'package:flutter/material.dart';

class ProjectDetailsScreen extends StatelessWidget {
  final Map<String, dynamic> project;
  final bool isAdmin;
  const ProjectDetailsScreen({this.isAdmin = true, required this.project, super.key});

  @override
  Widget build(BuildContext context) {
    print(isAdmin);
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
                title: project['projectType'],
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildDetailRow(
                          'Project Manager', '${project['Users']['firstName']} ${project['Users']['lastName']}'),
                      _buildDetailRow('Client Name', project['clientName']),
                      _buildDetailRow('Client Email', project['clientEmail']),
                      _buildDetailRow('Client Type', project['clientType']),
                      _buildDetailRow('Budget', project['budget']),
                      _buildDetailRow('Location', project['projectLocation']),
                      _buildDetailRow('Start Date', project['startDate']),
                      _buildDetailRow('End Date', project['endDate']),
                      _buildDetailRow('Project Type', project['projectType']),
                      Text(
                        project['projectDescription'],
                        style: const TextStyle(
                          fontSize: 16,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              if (isAdmin)
                Expanded(
                    child: AllEmployeeTable(
                  projectId: project['id'],
                )),
              if (isAdmin)
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton.icon(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (builder) => EmployeeListPage(ids: project['id'], notAssigned: true)));
                    },
                    icon: const Icon(Icons.add, color: Colors.white),
                    label: const Text('Add Employee', style: TextStyle(color: Colors.white)),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromARGB(255, 80, 160, 170),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                )
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
