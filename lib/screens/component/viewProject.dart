import 'package:first_project/flutter_session.dart';
import 'package:first_project/screens/component/employee_list.dart';
import 'package:first_project/screens/component/employeeTable.dart';
import 'package:flutter/material.dart';

class ProjectDetailsScreen extends StatefulWidget {
  final Map<String, dynamic> project;
  final bool isAdmin;
  final bool isManager;

  const ProjectDetailsScreen({
    this.isAdmin = true,
    this.isManager = false,
    required this.project,
    super.key,
  });

  @override
  State<ProjectDetailsScreen> createState() => _ProjectDetailsScreenState();
}

class _ProjectDetailsScreenState extends State<ProjectDetailsScreen> {

// class ProjectDetailsScreen extends StatelessWidget {
int counter = 1;
  late Map<String, dynamic> project;
  late bool isAdmin;
//   const ProjectDetailsScreen({this.isAdmin = true, required this.project, super.key});

  @override
  void initState() {
    super.initState();
    project = widget.project;
    isAdmin = widget.isAdmin;
    // WidgetsBinding.instance.addPostFrameCallback((_) => init());
  }

  void updateList()
  {
    setState(() {
      counter++;
    });
    print(counter);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // This will be triggered when dependencies change
    // You can access the context or other inherited widgets here
    print("didChangeDependencies called");

    // For example, fetching data from a provider (assuming you are using Provider)
    // final someData = Provider.of<MyData>(context);

    // If something depends on the context or inherited widgets, trigger actions here
  }

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
                  counter: counter
                )),
              if (isAdmin && widget.isManager)
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton.icon(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (builder) => EmployeeListPage(onPop: updateList, ids: project['id'], notAssigned: true)));
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
