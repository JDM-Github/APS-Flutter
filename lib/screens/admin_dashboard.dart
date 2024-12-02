import 'package:first_project/flutter_session.dart';
import 'package:first_project/screens/admin/company.dart';
import 'package:first_project/screens/admin/handleSchedule.dart';
import 'package:first_project/screens/admin/manageAttendance.dart';
import 'package:first_project/screens/admin/manageProject.dart';
import 'package:first_project/screens/component/add_employee.dart';
import 'package:first_project/screens/component/employeeTable.dart';
import 'package:first_project/screens/component/notification.dart';
import 'package:first_project/screens/login.dart';
import 'package:flutter/material.dart';

// Dashboard Screen
class AdminDashboardScreen extends StatelessWidget {
  const AdminDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      appBar: AdminAppbar(),
      body: DashboardBody(),
    );
  }
}

class AdminAppbar extends StatelessWidget implements PreferredSizeWidget {
  const AdminAppbar({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: const Text(
        'Admin Dashboard',
        style: TextStyle(
          color: Colors.white,
          fontSize: 16,
        ),
      ),
      automaticallyImplyLeading: false,
      foregroundColor: Colors.white,
      backgroundColor: const Color.fromARGB(255, 80, 160, 170),
      actions: [
        IconButton(
          icon: const Icon(Icons.person_add),
          onPressed: () {
            showAddEmployeeModal(context, AdminDashboardScreen());
          },
        ),
        IconButton(
          icon: const Icon(Icons.notifications),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (builder) => NotificationScreen()),
            );
          },
        ),
        IconButton(
          icon: const Icon(Icons.logout),
          onPressed: () {
            Config.set('isAdmin', false);
            if (Navigator.canPop(context)) {
              Navigator.pop(context);
            } else {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (builder) => LoginScreen()),
              );
            }
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
    return const Padding(
      padding: EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AdminUserInfoSection(),
          NavigatorEmployee(),
          Expanded(
            child: AllEmployeeTable(),
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
                label: 'Attendance',
                icon: Icons.check_circle_outline,
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (builder) => const ManageAttendanceScreen()));
                },
              ),
              buildExpandedActionButton(
                label: 'Schedule',
                icon: Icons.schedule,
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (builder) => const HandleScheduleScreen()));
                },
              ),
            ],
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              buildExpandedActionButton(
                label: 'Project',
                icon: Icons.work_outline,
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (builder) => const ManageProjectScreen()));
                },
              ),
              buildExpandedActionButton(
                label: 'Company',
                icon: Icons.business,
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (builder) => const CompanyScreen()));
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
          icon: Icon(icon, size: 18, color: Colors.white),
          label: Text(
            label,
            style: const TextStyle(
              fontSize: 10,
              color: Colors.white,
            ),
          ),
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
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

class AdminUserInfoSection extends StatelessWidget {
  const AdminUserInfoSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 15.0, horizontal: 15.0),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color.fromARGB(255, 80, 160, 170),
            Color.fromARGB(255, 40, 120, 130),
          ],
        ),
        borderRadius: BorderRadius.circular(12.0),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: const Row(
        children: [
          CircleAvatar(
            radius: 35,
            backgroundImage: AssetImage('assets/logo.png'),
            backgroundColor: Colors.white,
          ),
          SizedBox(width: 15),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(Icons.person, color: Colors.white70, size: 18),
                  SizedBox(width: 5),
                  Text(
                    'ADMINISTRATOR',
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 8),
              Row(
                children: [
                  Icon(Icons.badge, color: Colors.white70, size: 18),
                  SizedBox(width: 5),
                  Text(
                    'ID: 1245345',
                    style: TextStyle(fontSize: 14, color: Colors.white70),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class ProjectInfoSection extends StatelessWidget {
  const ProjectInfoSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20.0),
      decoration: BoxDecoration(
        color: Colors.grey[200],
      ),
      child: const Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Project Manager: Jane Smith',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Text(
              'Current Assignment: Team A - Mobile App Development',
              style: TextStyle(fontSize: 14),
            ),
          ],
        )
      ]),
    );
  }
}
