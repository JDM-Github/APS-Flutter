import 'package:first_project/handle_request.dart';
import 'package:first_project/screens/component/viewEmployee.dart';
import 'package:flutter/material.dart';

class AllEmployeeTable extends StatefulWidget {
  const AllEmployeeTable({super.key});

  @override
  State<AllEmployeeTable> createState() => _AllEmployeeTableState();
}

class _AllEmployeeTableState extends State<AllEmployeeTable> {
  List<dynamic> employees = [];
  bool isLoading = true;

  // @override
  // void initState() {
  //   super.initState();
  //   init();
  // }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => init());
  }

  Future<void> init() async {
    RequestHandler requestHandler = RequestHandler();
    try {
      Map<String, dynamic> response = await requestHandler.handleRequest(
        context,
        'users/get-all-employees',
        body: {},
      );
      isLoading = false;
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
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('An error occurred: $e')),
      );
      print(e);
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
                    fontSize: 18,
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
                        ? const Center(child: Text("Loading all employees"))
                        : employees.isEmpty
                            ? const Center(child: Text("There are no employees"))
                            : DataTable(
                                columnSpacing: 2,
                                headingRowHeight: 30,
                                headingTextStyle: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Color.fromARGB(255, 80, 160, 170),
                                ),
                                dataTextStyle: const TextStyle(fontSize: 14),
                                headingRowColor: WidgetStateProperty.all(
                                  const Color.fromARGB(255, 80, 160, 170).withOpacity(0.1),
                                ),
                                columns: [
                                  DataColumn(
                                    label: SizedBox(
                                      width: MediaQuery.of(context).size.width * 0.20,
                                      child: const Center(child: Text('Name')),
                                    ),
                                  ),
                                  DataColumn(
                                    label: SizedBox(
                                      width: MediaQuery.of(context).size.width * 0.20,
                                      child: const Center(child: Text('View')),
                                    ),
                                  ),
                                  DataColumn(
                                    label: SizedBox(
                                      width: MediaQuery.of(context).size.width * 0.20,
                                      child: const Center(child: Text('Action')),
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
                                          child: Text("${user['lastName']}, ${user['firstName']}"),
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
                                              padding: const EdgeInsets.symmetric(vertical: 10),
                                              backgroundColor: const Color.fromARGB(255, 80, 160, 170),
                                            ),
                                            child: const Text(
                                              'View',
                                              style: TextStyle(color: Colors.white),
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
                                              padding: const EdgeInsets.symmetric(vertical: 10),
                                              backgroundColor: isDeactivated
                                                  ? Colors.green
                                                  : Colors.red, // Red for Deactivated, Green for Active
                                            ),
                                            child: Text(
                                              isDeactivated ? "ACTIVATE" : "DEACTIVATE",
                                              style: const TextStyle(color: Colors.white),
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

  void _showEventDetails(BuildContext context, String projectName, String eventName, String time) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Event Details'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Project Name: $projectName'),
              const SizedBox(height: 10),
              Text('Event Name: $eventName'),
              const SizedBox(height: 10),
              Text('Time: $time'),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Close'),
            ),
          ],
        );
      },
    );
  }
}
