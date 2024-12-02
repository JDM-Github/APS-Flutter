import 'package:first_project/handle_request.dart';
import 'package:flutter/material.dart';
// import 'dart:math';

class EmployeeAttendanceViewScreen extends StatefulWidget {
  final dynamic users;
  const EmployeeAttendanceViewScreen({this.users, super.key});

  @override
  State<EmployeeAttendanceViewScreen> createState() => _EmployeeAttendanceViewScreenState();
}

class _EmployeeAttendanceViewScreenState extends State<EmployeeAttendanceViewScreen> {
  bool isAttendanceSet = false;
  // final List<AttendedEmployee> _attendedEmployees = [];
  dynamic allAttendance = [];

  @override
  void initState() {
    super.initState();
    // _generateFakeData();
    WidgetsBinding.instance.addPostFrameCallback((_) => init());
  }

  Future<void> init() async {
    RequestHandler requestHandler = RequestHandler();
    try {
      Map<String, dynamic> response = await requestHandler.handleRequest(
        context,
        'users/getAllAttendance',
        body: {"userId": widget.users['id']},
      );

      if (response['success'] == true) {
        getAllAttendance(response['attendance']);
        // print(response['attendance']);
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
    return Scaffold(
      appBar: const EmployeeAttendanceViewAppBar(),
      body: Padding(
        padding: const EdgeInsets.all(0.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: allAttendance.isEmpty
                  ? const Center(
                      child: Text(
                        'No attendance records yet.',
                        style: TextStyle(fontSize: 14, color: Colors.grey),
                      ),
                    )
                  : ListView.builder(
                      itemCount: allAttendance.length,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 0.0),
                          child: buildAttendedEmployeeTile(context, index),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildAttendedEmployeeTile(BuildContext context, int index) {
    final employee = allAttendance[index];
    Color statusColor;

    if (employee['isPresent']) {
      statusColor = Colors.green;
    } else if (employee['isAbsent']) {
      statusColor = Colors.red;
    } else if (employee['isOnLeave']) {
      statusColor = Colors.orange;
    } else {
      statusColor = Colors.grey;
    }

    return Container(
      color: statusColor.withOpacity(0.2),
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'In: ${employee['timeIn']} - Out: ${employee['timeOut']}',
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: Color.fromARGB(255, 27, 72, 78),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Place: ${employee['place']}',
            style: const TextStyle(
              fontSize: 12,
              color: Colors.grey,
            ),
          ),
        ],
      ),
    );
  }
}

class EmployeeAttendanceViewAppBar extends StatelessWidget implements PreferredSizeWidget {
  const EmployeeAttendanceViewAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: const Text('Employee View Attendance'),
      foregroundColor: Colors.white,
      backgroundColor: const Color.fromARGB(255, 80, 160, 170),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
