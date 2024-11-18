import 'package:first_project/handle_request.dart';
import 'package:first_project/screens/admin/company.dart';
import 'package:first_project/screens/admin/handleSchedule.dart';
import 'package:first_project/screens/admin/manageAttendance.dart';
import 'package:first_project/screens/admin/manageProject.dart';
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
        style: TextStyle(color: Colors.white),
      ),
      automaticallyImplyLeading: false,
      foregroundColor: Colors.white,
      backgroundColor: const Color.fromARGB(255, 80, 160, 170),
      actions: [
        IconButton(
          icon: const Icon(Icons.person_add),
          onPressed: () {
            showAddEmployeeModal(context);
          },
        ),
        IconButton(
          icon: const Icon(Icons.notifications),
          onPressed: () {
            Navigator.push(context, MaterialPageRoute(builder: (builder) => NotificationScreen()));
          },
        ),
        IconButton(
          icon: const Icon(Icons.logout),
          onPressed: () {
            if (Navigator.canPop(context)) {
              Navigator.pop(context);
            } else {
              Navigator.pushReplacement(context, MaterialPageRoute(builder: (builder) => LoginScreen()));
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

// User Info Section
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

class AddEmployee extends StatefulWidget {
  final Function(String, String, String, String, String, String, String, List, bool) onSave;

  const AddEmployee({
    super.key,
    required this.onSave,
  });

  @override
  _AddEmployeeModalState createState() => _AddEmployeeModalState();
}

class _AddEmployeeModalState extends State<AddEmployee> {
  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController middleInitialController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  String selectedGender = 'Male';
  String selectedDepartment = 'IT';
  List<String> genders = ['Male', 'Female', 'Other'];
  List<String> departments = ['IT', 'HR', 'Finance', 'Operations', 'Sales'];

  List<String> skills = ['Leadership', 'Communication', 'Teamwork', 'Problem Solving', 'Time Management', 'Adaptability', 'Creativity', 'Work Ethic', 'Critical Thinking', 'Flexibility'];
  List<String> selectedSkills = [];
  bool isProjectManager = false;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: MediaQuery.of(context).viewInsets,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Add Employee',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: firstNameController,
                decoration: const InputDecoration(
                  labelText: 'First Name',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: lastNameController,
                decoration: const InputDecoration(
                  labelText: 'Last Name',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: middleInitialController,
                decoration: const InputDecoration(
                  labelText: 'Middle Initial',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: selectedGender,
                items: genders
                    .map((gender) => DropdownMenuItem(
                          value: gender,
                          child: Text(gender),
                        ))
                    .toList(),
                onChanged: (value) {
                  setState(() {
                    selectedGender = value!;
                  });
                },
                decoration: const InputDecoration(
                  labelText: 'Gender',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: emailController,
                decoration: const InputDecoration(
                  labelText: 'Email',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: passwordController,
                decoration: const InputDecoration(
                  labelText: 'Password',
                  border: OutlineInputBorder(),
                ),
                obscureText: true,
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: selectedDepartment,
                items: departments
                    .map((dept) => DropdownMenuItem(
                          value: dept,
                          child: Text(dept),
                        ))
                    .toList(),
                onChanged: (value) {
                  setState(() {
                    selectedDepartment = value!;
                  });
                },
                decoration: const InputDecoration(
                  labelText: 'Department',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'Skills',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Wrap(
                spacing: 8.0,
                runSpacing: 4.0,
                children: skills.map((skill) {
                  final bool isSelected = selectedSkills.contains(skill);
                  return FilterChip(
                    label: Text(skill),
                    selected: isSelected,
                    onSelected: (bool selected) {
                      setState(() {
                        if (selectedSkills.contains(skill)) {
                          selectedSkills.remove(skill);
                        } else {
                          selectedSkills.add(skill);
                        }
                      });
                    },
                  );
                }).toList(),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  const Text(
                    'Is Project Manager',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Switch(
                    value: isProjectManager,
                    onChanged: (bool value) {
                      setState(() {
                        isProjectManager = value;
                      });
                    },
                  ),
                ],
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    widget.onSave(firstNameController.text, lastNameController.text, middleInitialController.text, selectedGender, emailController.text, passwordController.text, selectedDepartment,
                        selectedSkills, isProjectManager);
                    Navigator.pop(context);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(255, 80, 160, 170),
                  ),
                  child: const Text(
                    'Save Employee',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

void showAddEmployeeModal(BuildContext context) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    builder: (BuildContext context) {
      return AddEmployee(
        onSave: (firstName, lastName, middleInitial, selectedGender, email, password, selectedDepartment, selectedSkills, isProjectManager) async {
          RequestHandler requestHandler = RequestHandler();
          try {
            Map<String, dynamic> response = await requestHandler.handleRequest(
              context,
              'users/create-user',
              body: {
                'firstName': firstName,
                'lastName': lastName,
                'middleName': middleInitial,
                'gender': selectedGender,
                'email': email,
                'password': password,
                'department': selectedDepartment,
                'skills': selectedSkills,
                'isManager': isProjectManager
              },
            );
            if (response['success'] == true) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Employee added successfully')),
              );
              Navigator.pop(context);
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const AdminDashboardScreen()),
              );
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(response['message'] ?? 'Adding employee error')),
              );
            }
          } catch (e) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('An error occurred: $e')),
            );
          }
        },
      );
    },
  );
}
