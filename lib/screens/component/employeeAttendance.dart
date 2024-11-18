import 'package:flutter/material.dart';

class EmployeeAttendance extends StatelessWidget {
  const EmployeeAttendance({super.key});

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
                  'Your Schedule',
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
                    child: DataTable(
                      headingRowHeight: 30,
                      headingTextStyle: const TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Color.fromARGB(255, 80, 160, 170),
                      ),
                      dataTextStyle: const TextStyle(fontSize: 14),
                      headingRowColor: WidgetStateProperty.all(
                        const Color.fromARGB(255, 80, 160, 170)
                            .withOpacity(0.1),
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
                      rows: [
                        DataRow(
                          cells: [
                            DataCell(SizedBox(
                                width: MediaQuery.of(context).size.width * 0.25,
                                child: const Text('John Dave Pega'))),
                            DataCell(
                              SizedBox(
                                  width:
                                      MediaQuery.of(context).size.width * 0.4,
                                  child: ElevatedButton(
                                    onPressed: () {
                                      _showEventDetails(
                                        context,
                                        'Mobile App Development',
                                        'Design Review',
                                        'Mon-Fri, 9 AM - 5 PM',
                                      );
                                    },
                                    style: ElevatedButton.styleFrom(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 50, vertical: 10),
                                      backgroundColor: const Color.fromARGB(
                                          255, 80, 160, 170),
                                    ),
                                    child: const Text(
                                      'View',
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  )),
                            ),
                          ],
                        ),
                      ],
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

  void _showEventDetails(
      BuildContext context, String projectName, String eventName, String time) {
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
