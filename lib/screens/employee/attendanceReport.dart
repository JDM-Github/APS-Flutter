import 'package:first_project/screens/component/attendanceReport.dart';
import 'package:flutter/material.dart';

class AttendanceReportScreen extends StatefulWidget {
  const AttendanceReportScreen({super.key});

  @override
  _AttendanceReportScreenState createState() => _AttendanceReportScreenState();
}

class _AttendanceReportScreenState extends State<AttendanceReportScreen> {
  // Dropdown filters
  String selectedMonth = 'January';
  String selectedYear = '2024';
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
    'December'
  ];
  final List<String> years = ['2024', '2023', '2022', '2021', '2020'];

  // Sample data for attendance
  final List<Map<String, dynamic>> employeeData = [
    {'name': 'John Dave', 'present': 20, 'absent': 5, 'leave': 3},
    {'name': 'Jane Smith', 'present': 18, 'absent': 7, 'leave': 3},
    {'name': 'Michael Brown', 'present': 22, 'absent': 4, 'leave': 2},
    {'name': 'Alice Johnson', 'present': 15, 'absent': 10, 'leave': 3},
    {'name': 'Robert Wilson', 'present': 25, 'absent': 2, 'leave': 1},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Attendance Report"),
        backgroundColor: const Color.fromARGB(255, 80, 160, 170),
        foregroundColor: Colors.white,
        elevation: 5,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
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
            const AttendanceReportTable(),
            const SizedBox(height: 20),
            SaveAsCsvButton(
                employeeData: employeeData,
                month: selectedMonth,
                year: selectedYear),
          ],
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
              const Color.fromARGB(255, 80, 160, 170)
                  .withOpacity(0.1), // Start color
              const Color.fromARGB(255, 50, 130, 150)
                  .withOpacity(0.1), // End color
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
              Card(
                  child: Container(
                width: double.infinity,
                padding:
                    const EdgeInsets.symmetric(vertical: 15, horizontal: 15),
                decoration: BoxDecoration(
                  color: const Color.fromARGB(255, 80, 160, 170),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Center(
                    child: Text(
                  'Project Name',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: Colors.white,
                  ),
                )),
              )),
              const SizedBox(height: 5),
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
                              fontSize: 16,
                              color: Color.fromARGB(255, 27, 72, 78),
                            ),
                          ),
                        );
                      }).toList(),
                      onChanged: onMonthChanged,
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: const Color.fromARGB(255, 80, 160, 170)
                            .withOpacity(0.3),
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 15, vertical: 10),
                        border: OutlineInputBorder(
                          borderSide:
                              const BorderSide(color: Colors.transparent),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide:
                              const BorderSide(color: Colors.transparent),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide:
                              const BorderSide(color: Colors.transparent),
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
                                fontSize: 16,
                                color: Color.fromARGB(255, 27, 72, 78),
                              ),
                            ),
                          );
                        }).toList(),
                        onChanged: onYearChanged,
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: const Color.fromARGB(255, 80, 160, 170)
                              .withOpacity(0.3),
                          contentPadding: const EdgeInsets.symmetric(
                              horizontal: 15, vertical: 10),
                          border: OutlineInputBorder(
                            borderSide:
                                const BorderSide(color: Colors.transparent),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide:
                                const BorderSide(color: Colors.transparent),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide:
                                const BorderSide(color: Colors.transparent),
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
  final List<Map<String, dynamic>> employeeData;
  final String month;
  final String year;

  const SaveAsCsvButton({
    super.key,
    required this.employeeData,
    required this.month,
    required this.year,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        onPressed: () async {},
        icon: const Icon(Icons.save_alt, color: Colors.white),
        label: const Text('Save as CSV', style: TextStyle(color: Colors.white)),
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color.fromARGB(255, 80, 160, 170),
          padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        ),
      ),
    );
  }

  // Function to save data as CSV
  // Future<void> _saveAsCsv(BuildContext context) async {
  //   try {
  //     List<List<dynamic>> rows = [
  //       ['Name', 'Present', 'Absent', 'Leave'], // header
  //       ...employeeData.map((data) =>
  //           [data['name'], data['present'], data['absent'], data['leave']])
  //     ];

  //     String csvData = const ListToCsvConverter().convert(rows);

  //     // Get the directory to store the CSV file
  //     final directory = await getApplicationDocumentsDirectory();
  //     final path = directory.path;
  //     final file = File('$path/attendance_report_${month}_${year}.csv');

  //     // Write the CSV to the file
  //     await file.writeAsString(csvData);
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       const SnackBar(content: Text('Attendance report saved as CSV')),
  //     );
  //   } catch (e) {
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       SnackBar(content: Text('Error saving CSV: $e')),
  //     );
  //   }
  // }
}
