import 'package:first_project/screens/admin/attendanceReport.dart';
import 'package:first_project/screens/admin/handleSchedule.dart';
import 'package:first_project/screens/admin/manageAttendance.dart';
import 'package:first_project/screens/admin/manageLeaveScreen.dart';
import 'package:first_project/screens/admin/manageProject.dart';
import 'package:first_project/screens/admin/projectReports.dart';
import 'package:flutter/material.dart';

class ListOfNavigation extends StatelessWidget {
  const ListOfNavigation({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'List of Navigation',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
        ),
        foregroundColor: Colors.white,
        backgroundColor: const Color.fromARGB(255, 80, 160, 170),
        elevation: 4.0,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        child: ListView(
          children: [
            _buildListTile(
              context,
              icon: Icons.check_circle_outline,
              title: 'Manage Attendance',
              destination: const ManageAttendanceScreen(),
            ),
            _buildListTile(
              context,
              icon: Icons.schedule,
              title: 'Manage Schedule',
              destination: const HandleScheduleScreen(),
            ),
            _buildListTile(
              context,
              icon: Icons.work_outline,
              title: 'Manage Project',
              destination: const ManageProjectScreen(),
            ),
            _buildListTile(
              context,
              icon: Icons.report,
              title: 'All Attendance Report',
              destination: const AdminAttendanceReportScreen(),
            ),
            _buildListTile(
              context,
              icon: Icons.add_alert,
              title: 'All Project Report',
              destination: ProjectReportsPage(),
            ),
            _buildListTile(
              context,
              icon: Icons.add_alert,
              title: 'All Project Manager Leave',
              destination: AdminManageLeavesScreen(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildListTile(
    BuildContext context, {
    required IconData icon,
    required String title,
    required Widget destination,
  }) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      child: ListTile(
        leading: Icon(
          icon,
          color: Theme.of(context).primaryColor,
        ),
        title: Text(
          title,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
        ),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (builder) => destination),
          );
        },
      ),
    );
  }
}

