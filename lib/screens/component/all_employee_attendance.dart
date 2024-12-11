import 'package:first_project/handle_request.dart';
import 'package:flutter/material.dart';

class AllEmployeeAttended extends StatefulWidget {
  final String selectedFilter;
  final String projectId;
  final int updator;
  const AllEmployeeAttended({this.projectId = "", super.key, required this.selectedFilter, required this.updator});

  @override
  State<AllEmployeeAttended> createState() => _AllEmployeeAttended();
}

class _AllEmployeeAttended extends State<AllEmployeeAttended> {
  List<dynamic> employees = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => init());
  }

  @override
  void didUpdateWidget(covariant AllEmployeeAttended oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.projectId != widget.projectId ||
        oldWidget.selectedFilter != widget.selectedFilter ||
        oldWidget.updator != widget.updator) {
      WidgetsBinding.instance.addPostFrameCallback((_) => init());
    }
  }

  Future<void> init() async {
    RequestHandler requestHandler = RequestHandler();
    try {
      Map<String, dynamic> response = {};
      response = await requestHandler.handleRequest(
        context,
        'attendance/getAllEmployeesAttendanceVar',
        body: {
          'id': widget.projectId,
          'isPresent': widget.selectedFilter == 'Present',
          'isAbsent': widget.selectedFilter == 'Absent',
          'isOnLeave': widget.selectedFilter == 'Leave',
        },
      );
      setState(() {
        isLoading = false;
      });
      if (response['success'] == true) {
        setAllEmployee(response['users']);
        print(response['users']);
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
                color: Color.fromARGB(255, 80, 160, 170),
                borderRadius: BorderRadius.vertical(top: Radius.circular(12.0)),
              ),
              child: const Center(
                child: Text(
                  'Employee Attended',
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
                    child: DataTable(
                      headingRowHeight: 30,
                      headingTextStyle: const TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Color.fromARGB(255, 80, 160, 170),
                      ),
                      dataTextStyle: const TextStyle(fontSize: 12),
                      headingRowColor: WidgetStateProperty.all(
                        const Color.fromARGB(255, 80, 160, 170).withOpacity(0.1),
                      ),
                      columns: [
                        DataColumn(
                          label: SizedBox(
                            width: MediaQuery.of(context).size.width * 0.30,
                            child: const Center(child: Text('Employee')),
                          ),
                        ),
                        DataColumn(
                          label: SizedBox(
                            width: MediaQuery.of(context).size.width * 0.35,
                            child: const Center(child: Text('Action')),
                          ),
                        ),
                      ],
                      rows: employees.map<DataRow>((employee) {
                        final fullName = "${employee['firstName']} ${employee['lastName']}";
                        return DataRow(
                          cells: [
                            DataCell(
                              SizedBox(
                                width: MediaQuery.of(context).size.width * 0.25,
                                child: Text(fullName),
                              ),
                            ),
                            DataCell(
                              SizedBox(
                                width: MediaQuery.of(context).size.width * 0.4,
                                child: ElevatedButton(
                                  onPressed: () {
                                    // Replace with your action
                                    print('Viewing details for ${employee['id']}');
                                  },
                                  style: ElevatedButton.styleFrom(
                                    padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 10),
                                    backgroundColor: const Color.fromARGB(255, 80, 160, 170),
                                  ),
                                  child: const Text(
                                    'View',
                                    style: TextStyle(color: Colors.white),
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
