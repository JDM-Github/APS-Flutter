import 'package:first_project/handle_request.dart';
import 'package:first_project/screens/employee/attendanceReport.dart';
import 'package:flutter/material.dart';

class AdminAttendanceReportTable extends StatefulWidget {
  final String projectId;
  final String selectedMonth;
  final String selectedYear;
  const AdminAttendanceReportTable(this.projectId, this.selectedMonth, this.selectedYear, {super.key});

  @override
  State<StatefulWidget> createState() => _AdminAttendanceReportTable();
}

class _AdminAttendanceReportTable extends State<AdminAttendanceReportTable> {
  dynamic allAttendance = [];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => init());
  }

  @override
  void didUpdateWidget(covariant AdminAttendanceReportTable oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.projectId != widget.projectId || oldWidget.selectedMonth != widget.selectedMonth || oldWidget.selectedYear != widget.selectedYear) {
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
        'users/getMonthlyAttendance',
        body: {
          "projectId": widget.projectId,
          'month': convertMonthToNumber(widget.selectedMonth),
          'year': widget.selectedYear
        },
      );

      if (response['success'] == true) {
        getAllAttendance(response['data']);
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
      child: Column(children: [
        Expanded(
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
                              width: MediaQuery.of(context).size.width * 0.15,
                              child: const Text('NAME', style: TextStyle(fontSize: 12)),
                            ),
                          ),
                          DataColumn(
                            label: SizedBox(
                              width: MediaQuery.of(context).size.width * 0.11,
                              child: const Text('PRESENT', style: TextStyle(fontSize: 12)),
                            ),
                          ),
                          DataColumn(
                            label: SizedBox(
                              width: MediaQuery.of(context).size.width * 0.11,
                              child: const Text('LATE', style: TextStyle(fontSize: 12)),
                            ),
                          ),
                          DataColumn(
                            label: SizedBox(
                              width: MediaQuery.of(context).size.width * 0.11,
                              child: const Text('ABSENT', style: TextStyle(fontSize: 12)),
                            ),
                          ),
                          DataColumn(
                            label: SizedBox(
                              width: MediaQuery.of(context).size.width * 0.11,
                              child: const Text('LEAVE', style: TextStyle(fontSize: 12)),
                            ),
                          ),
                        ],
                        rows: List<Map<String, dynamic>>.from(allAttendance).map((user) {
                          return DataRow(
                            cells: [
                              DataCell(
                                SizedBox(
                                  width: MediaQuery.of(context).size.width * 0.15,
                                  child: Text(user["userName"], style: TextStyle(fontSize: 12)),
                                ),
                              ),
                              DataCell(
                                SizedBox(
                                  width: MediaQuery.of(context).size.width * 0.11,
                                  child: Text(user["present"].toString(), style: TextStyle(fontSize: 12)),
                                ),
                              ),
                              DataCell(
                                SizedBox(
                                  width: MediaQuery.of(context).size.width * 0.11,
                                  child: Text(user["late"].toString(), style: TextStyle(fontSize: 12)),
                                ),
                              ),
                              DataCell(
                                SizedBox(
                                  width: MediaQuery.of(context).size.width * 0.11,
                                  child: Text(user["absent"].toString(), style: TextStyle(fontSize: 12)),
                                ),
                              ),
                              DataCell(
                                SizedBox(
                                  width: MediaQuery.of(context).size.width * 0.11,
                                  child: Text(user["leave"].toString(), style: TextStyle(fontSize: 12)),
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
        )),
        const SizedBox(height: 10),
        SaveAsCsvButton(month: widget.selectedMonth, year: widget.selectedYear, jsonData: allAttendance),
      ]),
    ));
  }
}
