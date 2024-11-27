import 'package:first_project/handle_request.dart';
import 'package:first_project/screens/component/add_employee.dart';
import 'package:flutter/material.dart';

class EmployeeListPage extends StatefulWidget {
  final bool notAssigned;
  final String ids;
  const EmployeeListPage({
    this.notAssigned = false,
    required this.ids,
    super.key,
  });

  @override
  State<EmployeeListPage> createState() => _EmployeeListPageState();
}

class _EmployeeListPageState extends State<EmployeeListPage> {
  List<dynamic> employees = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => init());
  }

  Future<void> init() async {
    RequestHandler requestHandler = RequestHandler();
    try {
      Map<String, dynamic> response = {};
      response = await requestHandler.handleRequest(
        context,
        'users/get-all-employees',
        body: {"notAssigned": true},
      );
      setState(() {
        isLoading = false;
      });
      if (response['success'] == true) {
        setAllEmployee(response['users']);
        // print(response['users']);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(response['message'] ?? 'Loading employee error'),
          ),
        );
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('An error occurred: $e')),
      );
    }
  }

  void setAllEmployee(List<dynamic> users) {
    setState(() {
      employees = users;
    });
  }

  void addEmployee(id) async {
    setState(() {
      isLoading = true;
    });
    RequestHandler requestHandler = RequestHandler();
    try {
      Map<String, dynamic> response = {};
      response = await requestHandler.handleRequest(
        context,
        'projects/add-project-employee',
        body: {"project_id": widget.ids, "employee_id": id},
      );
      setState(() {
        isLoading = false;
      });
      if (response['success'] == true) {
        setState(() {
          employees.removeWhere((employee) => employee['id'] == id);
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Employee has been added successfully!'),
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(response['message'] ?? 'Adding employee error'),
          ),
        );
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('An error occurred: $e')),
      );
    }
  }

  void confirmAddEmployee(BuildContext context, dynamic employee) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Are you sure?'),
          content: Text('Do you really want to add ${employee['firstName']} ${employee['lastName']} for this project?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                addEmployee(employee['id']);
              },
              child: const Text('Yes, Add'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Employee List'),
        foregroundColor: Colors.white,
        backgroundColor: const Color.fromARGB(255, 80, 160, 170),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () => {showAddEmployeeModal(context, EmployeeListPage(ids: widget.ids))},
                icon: const Icon(Icons.add, color: Colors.white),
                label: const Text('Add Employee', style: TextStyle(color: Colors.white)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromARGB(255, 80, 160, 170),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 10),
            Expanded(
              child: ListView.builder(
                itemCount: employees.length,
                itemBuilder: (context, index) {
                  final employee = employees[index];
                  return Card(
                    margin: const EdgeInsets.symmetric(vertical: 5),
                    child: ListTile(
                      title: Text(employee['firstName'] + " " + employee['lastName']),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Department: ${employee['department']}'),
                          Text('Gender: ${employee['gender']}'),
                          Text('Skills: ${employee['skills'].join(', ')}'),
                        ],
                      ),
                      trailing: IconButton(
                        icon: const Icon(Icons.add, color: Colors.blue),
                        onPressed: () => confirmAddEmployee(context, employee),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
