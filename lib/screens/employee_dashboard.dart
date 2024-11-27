import 'package:first_project/flutter_session.dart';
import 'package:first_project/screens/component/employeeSchedule.dart';
import 'package:first_project/screens/component/projectInfo.dart';
import 'package:first_project/screens/component/userInfo.dart';
import 'package:first_project/screens/employee/attendanceReport.dart';
import 'package:first_project/screens/employee/manageLeave.dart';
import 'package:first_project/screens/component/notification.dart';
import 'package:first_project/screens/employee/profile.dart';
import 'package:first_project/screens/employee/viewAttendance.dart';
import 'package:first_project/screens/component/viewProject.dart';
import 'package:first_project/screens/login.dart';
// import 'package:first_project/screens/employee/viewSchedule.dart';
import 'package:flutter/material.dart';

// Dashboard Screen
class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      appBar: DashboardAppBar(),
      body: DashboardBody(),
    );
  }
}

class DashboardAppBar extends StatelessWidget implements PreferredSizeWidget {
  const DashboardAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Row(
        children: [
          const Text(
            'Dashboard',
            style: TextStyle(color: Colors.white),
          ),
        ],
      ),
      automaticallyImplyLeading: false,
      backgroundColor: const Color.fromARGB(255, 80, 160, 170),
      iconTheme: const IconThemeData(color: Colors.white),
      actions: [
        IconButton(
          icon: const Icon(Icons.notifications),
          onPressed: () {
            Navigator.push(context, MaterialPageRoute(builder: (builder) => const NotificationScreen()));
          },
        ),
        IconButton(
          icon: const Icon(Icons.account_circle),
          onPressed: () {
            Navigator.push(context, MaterialPageRoute(builder: (builder) => ProfileScreen()));
          },
        ),
        IconButton(
          icon: const Icon(Icons.logout),
          onPressed: () {
            Navigator.pushReplacement(context, MaterialPageRoute(builder: (builder) => LoginScreen()));
          },
        ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

class DashboardBody extends StatelessWidget {
  const DashboardBody({super.key});

  @override
  Widget build(BuildContext context) {
    Map<String, dynamic> users = Config.get('user');
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          UserInfoSection(
            fullName: users['firstName'] + " " + users['lastName'],
            position: users['position'],
            ids: users['id'],
            profileImage: users['profileImage'],
          ),
          const ProjectInfoSection(),
          const NavigatorEmployee(),
          const Expanded(
            child: EmployeeSchedule(),
          ),
        ],
      ),
    );
  }
}

class NavigatorEmployee extends StatelessWidget {
  const NavigatorEmployee({super.key});

  @override
  Widget build(BuildContext context) {
    Map<String, dynamic> users = Config.get('user');
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              buildExpandedActionButton(
                label: 'View Attendance',
                icon: Icons.check_circle_outline,
                onPressed: () {
                  Navigator.push(
                      context, MaterialPageRoute(builder: (builder) => EmployeeViewAttendanceScreen(users: users)));
                },
              ),
              buildExpandedActionButton(
                label: 'Manage Leaves',
                icon: Icons.event_available,
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (builder) => const ManageLeavesScreen()));
                },
              ),
            ],
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              // buildExpandedActionButton(
              //   label: 'View Schedule',
              //   icon: Icons.schedule,
              //   onPressed: () {
              //     Navigator.push(
              //         context,
              //         MaterialPageRoute(
              //             builder: (builder) => ViewScheduleScreen()));
              //   },
              // ),
              buildExpandedActionButton(
                label: 'Attendance Report',
                icon: Icons.report,
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (builder) => const AttendanceReportScreen()));
                },
              ),
              buildExpandedActionButton(
                label: 'View Project',
                icon: Icons.folder,
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (builder) => ProjectDetailsScreen(project: {
                                'projectDescription': 'Develop a mobile app for e-commerce with Flutter.',
                                'Users': {'firstName': 'John', 'lastName': 'Doe'},
                                'projectLocation': 'New York, USA',
                                'startDate': DateTime(2023, 1, 15).toString(),
                                'endDate': DateTime(2024, 1, 15).toString(),
                                'projectType': 'Software Development',
                              })));
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget buildExpandedActionButton({
    required String label,
    required IconData icon,
    required VoidCallback onPressed,
    double padding = 10,
  }) {
    return Expanded(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: padding),
        child: ElevatedButton.icon(
          onPressed: onPressed,
          icon: Icon(icon, size: 20, color: Colors.white),
          label: Text(
            label,
            style: const TextStyle(fontSize: 14, color: Colors.white),
          ),
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 15),
            backgroundColor: const Color.fromARGB(255, 80, 160, 170),
            elevation: 5,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0),
            ),
          ),
        ),
      ),
    );
  }
}

