import 'package:first_project/handle_request.dart';
import 'package:first_project/screens/component/viewEmployee.dart';
import 'package:flutter/material.dart';

class AllEmployeeTable extends StatefulWidget {
  final String projectId;
  const AllEmployeeTable({this.projectId = "", super.key});

  @override
  State<AllEmployeeTable> createState() => _AllEmployeeTableState();
}

class _AllEmployeeTableState extends State<AllEmployeeTable> {
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
      if (widget.projectId == "") {
        response = await requestHandler.handleRequest(
          context,
          'users/get-all-employees',
          body: {},
        );
      } else {
        response = await requestHandler.handleRequest(
          context,
          'users/get-all-project-employee',
          body: {"id": widget.projectId},
        );
      }
      setState(() {
        isLoading = false;
      });
      if (response['success'] == true) {
        print(response['users']);
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
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 0.0, vertical: 10.0),
      child: Card(
        elevation: 5,
        color: Colors.white,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(vertical: 10),
              decoration: const BoxDecoration(
                color: const Color.fromARGB(255, 80, 160, 170),
                borderRadius: BorderRadius.vertical(top: Radius.circular(12.0)),
              ),
              child: const Center(
                child: Text(
                  'List of all Employee',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            LayoutBuilder(
              builder: (context, constraints) {
                return SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: SizedBox(
                    width: constraints.maxWidth,
                    child: isLoading
                        ? const Center(
                            child: Text(
                              "Loading all employees",
                              style: TextStyle(fontSize: 12), // Smaller font size
                            ),
                          )
                        : employees.isEmpty
                            ? const Center(
                                child: Text(
                                  "There are no employees",
                                  style: TextStyle(fontSize: 12), // Smaller font size
                                ),
                              )
                            : DataTable(
                                columnSpacing: 2,
                                headingRowHeight: 30,
                                headingTextStyle: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12, // Adjusted font size
                                  color: Color.fromARGB(255, 80, 160, 170),
                                ),
                                dataTextStyle: const TextStyle(fontSize: 12), // Adjusted font size
                                headingRowColor: WidgetStateProperty.all(
                                  const Color.fromARGB(255, 80, 160, 170).withOpacity(0.1),
                                ),
                                columns: [
                                  DataColumn(
                                    label: SizedBox(
                                      width: MediaQuery.of(context).size.width * 0.20,
                                      child: const Center(
                                        child: Text(
                                          'Name',
                                          style: TextStyle(fontSize: 12), // Smaller font size
                                        ),
                                      ),
                                    ),
                                  ),
                                  DataColumn(
                                    label: SizedBox(
                                      width: MediaQuery.of(context).size.width * 0.20,
                                      child: const Center(
                                        child: Text(
                                          'View',
                                          style: TextStyle(fontSize: 12), // Smaller font size
                                        ),
                                      ),
                                    ),
                                  ),
                                  DataColumn(
                                    label: SizedBox(
                                      width: MediaQuery.of(context).size.width * 0.20,
                                      child: const Center(
                                        child: Text(
                                          'Action',
                                          style: TextStyle(fontSize: 12), // Smaller font size
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                                rows: employees.map<DataRow>((user) {
                                  final isDeactivated = user['is_deactivated'] ?? false;
                                  return DataRow(
                                    cells: [
                                      DataCell(
                                        SizedBox(
                                          width: MediaQuery.of(context).size.width * 0.4,
                                          child: Text(
                                            "${user['lastName']}, ${user['firstName']}",
                                            style: const TextStyle(fontSize: 12), // Smaller font size
                                          ),
                                        ),
                                      ),
                                      DataCell(
                                        SizedBox(
                                          width: MediaQuery.of(context).size.width * 0.20,
                                          child: ElevatedButton(
                                            onPressed: () {
                                              Navigator.push(
                                                context,
                                                PageRouteBuilder(
                                                  pageBuilder: (context, animation, secondaryAnimation) {
                                                    return ViewEmployeeScreen(user: user);
                                                  },
                                                  transitionsBuilder: (context, animation, secondaryAnimation, child) {
                                                    const begin = Offset(1.0, 0.0);
                                                    const end = Offset.zero;
                                                    const curve = Curves.easeInOut;
                                                    var tween =
                                                        Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
                                                    var offsetAnimation = animation.drive(tween);
                                                    return SlideTransition(position: offsetAnimation, child: child);
                                                  },
                                                ),
                                              );
                                            },
                                            style: ElevatedButton.styleFrom(
                                              padding: const EdgeInsets.symmetric(vertical: 8), // Adjusted padding
                                              backgroundColor: const Color.fromARGB(255, 80, 160, 170),
                                            ),
                                            child: const Text(
                                              'View',
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 12, // Smaller font size
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                      DataCell(
                                        SizedBox(
                                          width: MediaQuery.of(context).size.width * 0.20,
                                          child: ElevatedButton(
                                            onPressed: () {
                                              // Handle Deactivate/Activate button click
                                              // toggleUserStatus(user);
                                            },
                                            style: ElevatedButton.styleFrom(
                                              padding: const EdgeInsets.symmetric(vertical: 8), // Adjusted padding
                                              backgroundColor: widget.projectId != "" || isDeactivated
                                                  ? (widget.projectId != "" ? Colors.red : Colors.green)
                                                  : Colors.red,
                                            ),
                                            child: Text(
                                              widget.projectId == ""
                                                  ? (isDeactivated ? "ACTIVATE" : "DEACTIVATE")
                                                  : "REMOVE",
                                              style: const TextStyle(
                                                color: Colors.white,
                                                fontSize: 12, // Smaller font size
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  );
                                }).toList(),
                              ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
