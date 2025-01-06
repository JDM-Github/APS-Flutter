import 'dart:math';

import 'package:first_project/handle_request.dart';
import 'package:first_project/screens/component/viewEmployee.dart';
import 'package:first_project/screens/verify_email.dart';
import 'package:flutter/material.dart';

class AllEmployeeTable extends StatefulWidget {
  final String projectId;
  final int counter;
  const AllEmployeeTable({this.projectId = "", this.counter=0, super.key});

  @override
  State<AllEmployeeTable> createState() => _AllEmployeeTableState();
}

class _AllEmployeeTableState extends State<AllEmployeeTable> {
  List<dynamic> employees = [];
  List<dynamic> allUsers = [];
  bool isLoading = true;
  bool isVerified = true;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => init());
  }

  @override
  void didUpdateWidget(covariant AllEmployeeTable oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.projectId != widget.projectId ||
        oldWidget.counter != widget.counter) {
      WidgetsBinding.instance.addPostFrameCallback((_) => init());
    }
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
        setState(() {
          allUsers = response['users'];
        });
        setAllEmployee(allUsers);
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
      if (isVerified) {
        employees = users.where((user) => user['isVerified'] == true).toList();
      } else {
        employees = users.where((user) => user['isVerified'] == false).toList();
      }
    });
  }

  void setActiveDeactive(id) async {
    RequestHandler requestHandler = RequestHandler();
    try {
      Map<String, dynamic> response = {};
      response = await requestHandler.handleRequest(
        context,
        'users/set-active-deactive',
        body: {'id': id},
      );
      setState(() {
        isLoading = false;
      });
      if (response['success'] == true) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(response['message'] ?? 'Account has been updated.'),
          ),
        );
        init();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(response['message'] ?? 'Updating employee error'),
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
                color: Color.fromARGB(255, 80, 160, 170),
                borderRadius: BorderRadius.vertical(top: Radius.circular(12.0)),
              ),
              child: SizedBox(
                height: 25,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        ((isVerified) ? 'All Verified Employees' : "All Not Verified Employees"),
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          setState(() {
                            isVerified = !isVerified;
                            setAllEmployee(allUsers);
                            // init();
                          });
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 0),
                          minimumSize: const Size(0, 50),
                          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                        ),
                        child: Text(
                          ((isVerified) ? 'All Not Verified' : "All Verified"),
                          style: TextStyle(fontSize: 10, color: Colors.black38),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: isLoading
                    ? const Center(
                        child: Text(
                          "Loading all employees",
                          style: TextStyle(fontSize: 12),
                        ),
                      )
                    : employees.isEmpty
                        ? const Center(
                            child: Text(
                              "There are no employees",
                              style: TextStyle(fontSize: 12),
                            ),
                          )
                        : DataTable(
                            columnSpacing: 2,
                            headingRowHeight: 30,
                            headingTextStyle: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 12,
                              color: Color.fromARGB(255, 80, 160, 170),
                            ),
                            dataTextStyle: const TextStyle(fontSize: 12),
                            headingRowColor: WidgetStateProperty.all(
                              const Color.fromARGB(255, 80, 160, 170).withOpacity(0.1),
                            ),
                            columns: [
                              DataColumn(
                                label: SizedBox(
                                  width: MediaQuery.of(context).size.width * 0.35,
                                  child: Text(
                                    'Name',
                                    style: TextStyle(fontSize: 12),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              ),
                              DataColumn(
                                label: SizedBox(
                                  width: MediaQuery.of(context).size.width * 0.1,
                                  child: Text(
                                    'View',
                                    style: TextStyle(fontSize: 12),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              ),
                              DataColumn(
                                label: SizedBox(
                                  width: MediaQuery.of(context).size.width * 0.1,
                                  child: Text(
                                    'Action',
                                    style: TextStyle(fontSize: 12),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              ),
                            ],
                            rows: employees.map<DataRow>((user) {
                              final isDeactivated = user['is_deactivated'] ?? false;
                              return DataRow(
                                cells: [
                                  DataCell(
                                    Text(
                                      "${user['lastName']}, ${user['firstName']}",
                                      style: TextStyle(fontSize: 12),
                                    ),
                                  ),
                                  DataCell(
                                    ElevatedButton(
                                      onPressed: () {
                                        if (!isVerified) {
                                          Navigator.push(context,
                                              MaterialPageRoute(builder: (builder) => VerifyEmail(user['email'])));
                                        } else {
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
                                        }
                                      },
                                      style: ElevatedButton.styleFrom(
                                        padding: const EdgeInsets.symmetric(vertical: 8),
                                        backgroundColor: const Color.fromARGB(255, 80, 160, 170),
                                      ),
                                      child: SizedBox(
                                        width: 30,
                                        child: Text(
                                          (isVerified) ? 'View' : "Verify",
                                          style: TextStyle(color: Colors.white, fontSize: 12),
                                        ),
                                      ),
                                    ),
                                  ),
                                  DataCell(
                                    ElevatedButton(
                                      onPressed: () {
                                        setActiveDeactive(user['id']);
                                      },
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: isDeactivated ? Colors.green : Colors.red,
                                      ),
                                      child: Text(
                                        isDeactivated
                                            ? "ACTIVATE"
                                            : isVerified
                                                ? "DEACTIVATE"
                                                : "DELETE",
                                        style: const TextStyle(color: Colors.white, fontSize: 12),
                                      ),
                                    ),
                                  ),
                                ],
                              );
                            }).toList(),
                          ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
