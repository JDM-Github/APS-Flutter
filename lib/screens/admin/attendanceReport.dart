import 'package:csv/csv.dart';
import 'package:first_project/flutter_session.dart';
import 'package:first_project/handle_request.dart';
import 'package:first_project/screens/component/adminAttendanceReport.dart';
import 'package:first_project/screens/component/attendanceReport.dart';
import 'package:first_project/screens/component/employee_attendance_report.dart';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'dart:io';

class AdminAttendanceReportScreen extends StatefulWidget {
  const AdminAttendanceReportScreen({super.key});

  @override
  State<AdminAttendanceReportScreen> createState() => _AdminAttendanceReportScreenState();
}

class _AdminAttendanceReportScreenState extends State<AdminAttendanceReportScreen> {
  String selectedMonth = '';
  String selectedYear = '';
  final List<String> months = [
    'January',
    'February',
    'March',
    'April',
    'May',
    'June',
    'July',
    'August',
    'September',
    'October',
    'November',
    'December',
  ];
  final List<String> years = [];

  List<dynamic> projects = [];
  bool isLoading = true;
  String selectedProjectId = "";
  int updator = 0;


  @override
  void initState() {
    super.initState();
    final now = DateTime.now();
    selectedMonth = months[now.month - 1];
    selectedYear = now.year.toString();
    for (int i = 0; i < 5; i++) {
      years.add((now.year - i).toString());
    }
    WidgetsBinding.instance.addPostFrameCallback((_) => init()); 
  }

  Future<void> onProjectChanged(String projectId) async {
    print("TEST");
    setState(() {
      selectedProjectId = projectId;
    });
  }

  Future<void> init() async {
    RequestHandler requestHandler = RequestHandler();
    try {
      Map<String, dynamic> response = await requestHandler.handleRequest(
        context,
        'projects/get-all-projects',
        body: {"filter": "Active"},
      );
      setState(() {
        isLoading = false;
      });
      if (response['success'] == true) {
        setAllProjects(response['projects']);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(response['message'] ?? 'Loading projects error'),
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

  Future<void> setAllProjects(List<dynamic> projects) async {
    setState(() {
      this.projects = projects;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Admin Attendance Report", style: TextStyle(fontSize: 16)),
        backgroundColor: const Color.fromARGB(255, 80, 160, 170),
        foregroundColor: Colors.white,
        elevation: 5,
        actions: [
            IconButton(
              icon: const Icon(Icons.restart_alt_rounded),
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (builder) => AdminAttendanceReportScreen()),
                );
              },
            ),
          ]
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ProjectDropdown(projects, onProjectChanged: onProjectChanged),
                ],
              ),
            ),
            AttendanceFilter(
              selectedMonth: selectedMonth,
              selectedYear: selectedYear,
              months: months,
              years: years,
              onMonthChanged: (month) {
                setState(() {
                  selectedMonth = month!;
                });
              },
              onYearChanged: (year) {
                setState(() {
                  selectedYear = year!;
                });
              },
            ),
            AdminAttendanceReportTable(selectedProjectId, selectedMonth, selectedYear),
          ],
        ),
      ),
    );
  }
}


class ProjectDropdown extends StatelessWidget {
  final List<dynamic> projects;
  final Function(String) onProjectChanged;

  const ProjectDropdown(this.projects, {required this.onProjectChanged, super.key});

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<String>(
      decoration: InputDecoration(
        filled: true,
        fillColor: const Color.fromARGB(255, 80, 160, 170).withOpacity(0.3),
        contentPadding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
        border: OutlineInputBorder(
          borderSide: const BorderSide(color: Colors.transparent),
          borderRadius: BorderRadius.circular(10),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Colors.transparent),
          borderRadius: BorderRadius.circular(10),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Colors.transparent),
          borderRadius: BorderRadius.circular(10),
        ),
      ),
      items: projects.map<DropdownMenuItem<String>>((project) {
        return DropdownMenuItem<String>(
          value: project['id'].toString(),
          child: Text(project['projectName'] ?? 'Unnamed Project'),
        );
      }).toList(),
      onChanged: (value) {
        if (value != null) {
          onProjectChanged(value);
        }
      },
      hint: const Text(
        'Select a Project',
        style: TextStyle(
          fontWeight: FontWeight.w600,
          fontSize: 12,
          color: Color.fromARGB(255, 27, 72, 78),
        ),
      ),
    );
  }
}


class AttendanceFilter extends StatelessWidget {
  final String selectedMonth;
  final String selectedYear;
  final List<String> months;
  final List<String> years;
  final ValueChanged<String?> onMonthChanged;
  final ValueChanged<String?> onYearChanged;

  const AttendanceFilter({
    super.key,
    required this.selectedMonth,
    required this.selectedYear,
    required this.months,
    required this.years,
    required this.onMonthChanged,
    required this.onYearChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12.0),
          gradient: LinearGradient(
            colors: [
              const Color.fromARGB(255, 80, 160, 170).withOpacity(0.1),
              const Color.fromARGB(255, 50, 130, 150).withOpacity(0.1),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: DropdownButtonFormField<String>(
                      value: selectedMonth,
                      items: months.map((String month) {
                        return DropdownMenuItem(
                          value: month,
                          child: Text(
                            month,
                            style: const TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 12,
                              color: Color.fromARGB(255, 27, 72, 78),
                            ),
                          ),
                        );
                      }).toList(),
                      onChanged: onMonthChanged,
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: const Color.fromARGB(255, 80, 160, 170).withOpacity(0.3),
                        contentPadding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                        border: OutlineInputBorder(
                          borderSide: const BorderSide(color: Colors.transparent),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: const BorderSide(color: Colors.transparent),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide: const BorderSide(color: Colors.transparent),
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Container(
                      margin: const EdgeInsets.only(left: 10),
                      child: DropdownButtonFormField<String>(
                        value: selectedYear,
                        items: years.map((String year) {
                          return DropdownMenuItem(
                            value: year,
                            child: Text(
                              year,
                              style: const TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 12,
                                color: Color.fromARGB(255, 27, 72, 78),
                              ),
                            ),
                          );
                        }).toList(),
                        onChanged: onYearChanged,
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: const Color.fromARGB(255, 80, 160, 170).withOpacity(0.3),
                          contentPadding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                          border: OutlineInputBorder(
                            borderSide: const BorderSide(color: Colors.transparent),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: const BorderSide(color: Colors.transparent),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: const BorderSide(color: Colors.transparent),
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class SaveAsCsvButton extends StatelessWidget {
  final String month;
  final String year;
  final dynamic jsonData;

  const SaveAsCsvButton({super.key, required this.month, required this.year, required this.jsonData});

  Future<void> saveAsCSV() async {
    try {
      List<List<dynamic>> rows = [];
      if (jsonData.isNotEmpty) {
        List<String> headers = jsonData[0].keys.toList();
        rows.add(headers);

        for (var data in jsonData) {
          List<String> row = headers.map((header) => data[header].toString()).toList();
          rows.add(row);
        }
      }

      String csv = const ListToCsvConverter().convert(rows);
      String? path = await FilePicker.platform.saveFile(
        dialogTitle: 'Save CSV as',
        fileName: 'report.csv',
        type: FileType.custom,
        allowedExtensions: ['csv'],
      );

      if (path != null) {
        final file = File(path);
        await file.writeAsString(csv);
      }
    } catch (e) {
      print('Error saving CSV: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        onPressed: () async {
          await saveAsCSV();
        },
        icon: const Icon(Icons.save_alt, color: Colors.white),
        label: const Text('Save as CSV', style: TextStyle(color: Colors.white)),
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color.fromARGB(255, 80, 160, 170),
          padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        ),
      ),
    );
  }
}
