import 'package:first_project/screens/admin/attendanceReport.dart';
import 'package:first_project/screens/admin/handleSchedule.dart';
import 'package:first_project/screens/admin/manageAttendance.dart';
import 'package:first_project/screens/admin/manageProject.dart';
import 'package:first_project/screens/employee/attendanceReport.dart';
import 'package:flutter/material.dart';

class ListOfNavigation extends StatelessWidget {
  const ListOfNavigation({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('List of Navigation'),
        foregroundColor: Colors.white,
        backgroundColor: const Color.fromARGB(255, 80, 160, 170),
      ),
      body: ListView(
        children: [
          ListTile(
            leading: Icon(Icons.check_circle_outline),
            title: const Text('Manage Attendance'),
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (builder) => const ManageAttendanceScreen()));
            },
          ),
          
          ListTile(
            leading: Icon(Icons.schedule),
            title: const Text('Manage Schedule'),
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (builder) => const HandleScheduleScreen()));
            },
          ),
          ListTile(
            leading: Icon(Icons.work_outline),
            title: const Text('Manage Project'),
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (builder) => const ManageProjectScreen()));
            },
          ),
          ListTile(
            leading: Icon(Icons.report),
            title: const Text('All Attendance Report'),
            onTap: () {
              // 
              Navigator.push(context, MaterialPageRoute(builder: (builder) => const AdminAttendanceReportScreen()));
            },
          ),
          ListTile(
            leading: Icon(Icons.add_alert),
            title: const Text('All Project Report'),
            onTap: () {
            },
          ),
        ],
      ),
    );
  }
}
