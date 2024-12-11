import 'package:first_project/handle_request.dart';
import 'package:flutter/material.dart';

class EmployeeSchedule extends StatefulWidget {
  final String selectedUser;
  final int updator;
  const EmployeeSchedule(this.selectedUser, {super.key, required this.updator});

  @override
  State<EmployeeSchedule> createState() => _HandleScheduleBodyState();
}

class _HandleScheduleBodyState extends State<EmployeeSchedule> {
  List<dynamic> schedules = [];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => init());
  }

  @override
  void didUpdateWidget(covariant EmployeeSchedule oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.selectedUser != widget.selectedUser || oldWidget.updator != widget.updator) {
      WidgetsBinding.instance.addPostFrameCallback((_) => init());
    }
  }

  Future<void> init() async {
    RequestHandler requestHandler = RequestHandler();
    try {
      Map<String, dynamic> response = await requestHandler.handleRequest(
        context,
        'attendance/getAllSchedule',
        body: {"userId": widget.selectedUser},
      );
      if (response['success'] == true) {
        setState(() => schedules = response['schedules']);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(response['message'] ?? 'Loading schedules error'),
          ),
        );
      }
    } catch (e) {
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
              child: const Center(
                child: Text(
                  'Employee Schedule',
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
                      columnSpacing: 0,
                      columns: [
                        DataColumn(
                          label: SizedBox(
                            width: MediaQuery.of(context).size.width * 0.1,
                            child: const Center(child: Text('Date', style: TextStyle(fontSize: 12))),
                          ),
                        ),
                        DataColumn(
                          label: SizedBox(
                            width: MediaQuery.of(context).size.width * 0.1,
                            child: const Center(child: Text('From', style: TextStyle(fontSize: 12))),
                          ),
                        ),
                        DataColumn(
                          label: SizedBox(
                            width: MediaQuery.of(context).size.width * 0.1,
                            child: const Center(child: Text('To', style: TextStyle(fontSize: 12))),
                          ),
                        ),
                        DataColumn(
                          label: SizedBox(
                            width: MediaQuery.of(context).size.width * 0.2,
                            child: const Center(child: Text('Description', style: TextStyle(fontSize: 12))),
                          ),
                        ),
                      ],
                      rows: schedules.map((attendance) {
                        String formattedDate = DateTime.parse(attendance['date']).toLocal().toString().split(' ')[0];
                        String formattedTimeIn = attendance['timeIn'];
                        String formattedTimeOut = attendance['timeOut'];

                        return DataRow(
                          cells: [
                            DataCell(
                                SizedBox(width: MediaQuery.of(context).size.width * 0.2, child: Text(formattedDate))),
                            DataCell(
                                SizedBox(width: MediaQuery.of(context).size.width * 0.2, child: Text(formattedTimeIn))),
                            DataCell(SizedBox(
                                width: MediaQuery.of(context).size.width * 0.2, child: Text(formattedTimeOut))),
                            DataCell(
                              SizedBox(
                                width: MediaQuery.of(context).size.width * 0.20,
                                child: ElevatedButton(
                                  onPressed: () {
                                    showDescriptionDialog(context, attendance['description']);
                                  },
                                  style: ElevatedButton.styleFrom(
                                    padding: const EdgeInsets.symmetric(vertical: 10),
                                    backgroundColor: const Color.fromARGB(255, 80, 160, 170),
                                  ),
                                  child: const Text(
                                    'VIEW',
                                    style: TextStyle(color: Colors.white, fontSize: 12),
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

  void showDescriptionDialog(BuildContext context, String description) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Description"),
          content: Text(description),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: const Text("Close"),
            ),
          ],
        );
      },
    );
  }
}
