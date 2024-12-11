import 'package:first_project/handle_request.dart';
import 'package:flutter/material.dart';

class EmployeeAttendanceReportTable extends StatefulWidget {
  final Map<String, dynamic> users;
  final String selectedMonth;
  final String selectedYear;
  const EmployeeAttendanceReportTable(this.users, this.selectedMonth, this.selectedYear, {super.key});

  @override
  State<StatefulWidget> createState() => _EmployeeAttendanceReportTable();
}

class _EmployeeAttendanceReportTable extends State<EmployeeAttendanceReportTable> {
  dynamic allAttendance = [];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => init());
  }

  @override
  void didUpdateWidget(covariant EmployeeAttendanceReportTable oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.selectedMonth != widget.selectedMonth || oldWidget.selectedYear != widget.selectedYear) {
      WidgetsBinding.instance.addPostFrameCallback((_) => init());
    }
  }

  int convertMonthToNumber(String month) {
    const months = {
      "January": 1,
      "February": 2,
      "March": 3,
      "April": 4,
      "May": 5,
      "June": 6,
      "July": 7,
      "August": 8,
      "September": 9,
      "October": 10,
      "November": 11,
      "December": 12,
    };

    return months[month] ?? 0;
  }

  Future<void> init() async {
    RequestHandler requestHandler = RequestHandler();
    try {
      Map<String, dynamic> response = await requestHandler.handleRequest(
        context,
        'users/getAllAttendance',
        body: {
          "userId": widget.users['id'],
          'month': convertMonthToNumber(widget.selectedMonth),
          'year': widget.selectedYear
        },
      );

      if (response['success'] == true) {
        getAllAttendance(response['attendance']);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(response['message'] ?? 'Loading project managers error'),
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('An error occurred: $e')),
      );
    }
  }

  void getAllAttendance(List<dynamic> attendance) {
    setState(() {
      allAttendance = attendance;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Padding(
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
                    'Attendance Report',
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
                        headingRowHeight: 40,
                        headingTextStyle: const TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Color.fromARGB(255, 80, 160, 170),
                        ),
                        dataTextStyle: const TextStyle(fontSize: 12),
                        headingRowColor: WidgetStateProperty.all(
                          const Color.fromARGB(255, 80, 160, 170).withOpacity(0.1),
                        ),
                        columnSpacing: 20,
                        columns: [
                          DataColumn(
                            label: SizedBox(
                              width: MediaQuery.of(context).size.width * 0.25,
                              child: const Text('DAY'),
                            ),
                          ),
                          DataColumn(
                            label: SizedBox(
                              width: MediaQuery.of(context).size.width * 0.11,
                              child: const Text('PRESENT'),
                            ),
                          ),
                          DataColumn(
                            label: SizedBox(
                              width: MediaQuery.of(context).size.width * 0.11,
                              child: const Text('ABSENT'),
                            ),
                          ),
                          DataColumn(
                            label: SizedBox(
                              width: MediaQuery.of(context).size.width * 0.11,
                              child: const Text('LEAVE'),
                            ),
                          ),
                        ],
                        rows: allAttendance.map<DataRow>((attendance) {
                          return DataRow(
                            cells: [
                              DataCell(SizedBox(
                                width: MediaQuery.of(context).size.width * 0.25,
                                child: Text(attendance['date'].split('T')[0]),
                              )),
                              DataCell(SizedBox(
                                width: MediaQuery.of(context).size.width * 0.15,
                                child: Text(attendance['isPresent'] ? 'Yes' : 'No'),
                              )),
                              DataCell(SizedBox(
                                width: MediaQuery.of(context).size.width * 0.15,
                                child: Text(attendance['isAbsent'] ? 'Yes' : 'No'),
                              )),
                              DataCell(SizedBox(
                                width: MediaQuery.of(context).size.width * 0.15,
                                child: Text(attendance['isOnLeave'] ? 'Yes' : 'No'),
                              )),
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
      ),
    );
  }
}
