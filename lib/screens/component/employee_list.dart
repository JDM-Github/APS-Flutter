import 'package:first_project/handle_request.dart';
import 'package:first_project/screens/component/add_employee.dart';
import 'package:first_project/screens/component/viewEmployee.dart';
import 'package:flutter/material.dart';

class EmployeeListPage extends StatefulWidget {
  final void Function() onPop; 
  final bool notAssigned;
  final String ids;
  const EmployeeListPage({
    required this.onPop,
    this.notAssigned = false,
    required this.ids,
    super.key,
  });

  @override
  State<EmployeeListPage> createState() => _EmployeeListPageState();
}

class _EmployeeListPageState extends State<EmployeeListPage> {
  List<dynamic> employees = [];
  List<dynamic> filteredEmployees = [];
  bool isLoading = true;
  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    searchController.addListener(_filterEmployees);
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
      filteredEmployees = users;
    });
  }

  void _filterEmployees() {
    setState(() {
      filteredEmployees = employees
          .where((employee) => (employee['firstName'] + " " + employee['lastName'])
              .toLowerCase()
              .contains(searchController.text.toLowerCase()))
          .toList();
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
          _filterEmployees();
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

  // void viewEmployeeDetails(dynamic employee) {
  //   showDialog(
  //     context: context,
  //     builder: (BuildContext context) {
  //       return AlertDialog(
  //         title: Text('${employee['firstName']} ${employee['lastName']}'),
  //         content: Column(
  //           mainAxisSize: MainAxisSize.min,
  //           crossAxisAlignment: CrossAxisAlignment.start,
  //           children: [
  //             Text('Department: ${employee['department']}'),
  //             Text('Gender: ${employee['gender']}'),
  //             Text('Skills: ${employee['skills'].join(', ')}'),
  //           ],
  //         ),
  //         actions: [
  //           TextButton(
  //             onPressed: () => Navigator.of(context).pop(),
  //             child: const Text('Close'),
  //           ),
  //         ],
  //       );
  //     },
  //   );
  // }


  @override
  Widget build(BuildContext context) {
    return PopScope(
      onPopInvokedWithResult: (cont, result) {
        widget.onPop();
        },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Employee List'),
          foregroundColor: Colors.white,
          backgroundColor: const Color.fromARGB(255, 80, 160, 170),
          actions: [
            IconButton(
              icon: const Icon(Icons.restart_alt_rounded),
              onPressed: () => { Navigator.pushReplacement(context, MaterialPageRoute(builder: (builder) => EmployeeListPage(onPop: widget.onPop, ids: widget.ids)))},
            ),
            IconButton(
              icon: const Icon(Icons.add),
              onPressed: () => {showAddEmployeeModal(context, EmployeeListPage(onPop: widget.onPop, ids: widget.ids))},
            ),
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              TextField(
                controller: searchController,
                decoration: const InputDecoration(
                  labelText: 'Search',
                  prefixIcon: Icon(Icons.search),
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 10),
              Expanded(
                child: ListView.builder(
                  itemCount: filteredEmployees.length,
                  itemBuilder: (context, index) {
                    final employee = filteredEmployees[index];
                    return Card(
                      margin: const EdgeInsets.symmetric(vertical: 5),
                      child: ListTile(
                        title: Text(employee['firstName'] + " " + employee['lastName']),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Department: ${employee['department']}'),
                            Text('Gender: ${employee['gender']}'),
                            // Text('Skills: ${employee['skills'].join(', ')}'),
                          ],
                        ),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: const Icon(Icons.visibility, color: Colors.green),
                              onPressed: () => Navigator.push(context, MaterialPageRoute(
                                builder: (builder) => ViewEmployeeScreen(user: employee))),
                            ),
                            IconButton(
                              icon: const Icon(Icons.add, color: Colors.blue),
                              onPressed: () => confirmAddEmployee(context, employee),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      )
    );
  }
}
