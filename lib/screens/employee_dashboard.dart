import 'package:first_project/flutter_session.dart';
import 'package:first_project/handle_request.dart';
import 'package:first_project/screens/component/employeeSchedule.dart';
import 'package:first_project/screens/component/projectInfo.dart';
import 'package:first_project/screens/component/userInfo.dart';
import 'package:first_project/screens/employee/attendanceReport.dart';
import 'package:first_project/screens/employee/employeeAttendance.dart';
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

class ConfirmTimeoutModal extends StatelessWidget {
  final VoidCallback onConfirm;

  const ConfirmTimeoutModal({super.key, required this.onConfirm});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text("Are you sure?"),
      content: const Text("Are you sure you want to timeout?"),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: const Text("Cancel"),
        ),
        ElevatedButton(
          onPressed: () {
            onConfirm();
            Navigator.of(context).pop();
          },
          child: const Text("Confirm Timeout"),
        ),
      ],
    );
  }
}



class DashboardAppBar extends StatelessWidget implements PreferredSizeWidget {
  const DashboardAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    Map<String, dynamic> users = Config.get('user');
    return AppBar(
      title: Row(
        children: [
          const Text(
            'Dashboard',
            style: TextStyle(color: Colors.white, fontSize: 16),
          ),
        ],
      ),
      automaticallyImplyLeading: false,
      backgroundColor: const Color.fromARGB(255, 80, 160, 170),
      iconTheme: const IconThemeData(color: Colors.white),
      actions: [
        IconButton(
          icon: const Icon(Icons.directions_walk),
          onPressed: () {
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return ConfirmTimeoutModal(
                  onConfirm: () async {
                    RequestHandler requestHandler = RequestHandler();
                    try {
                      Map<String, dynamic> response = await requestHandler.handleRequest(
                        context,
                        'attendance/addTimeoutAndCalculateHours',
                        body: {
                          "userId": users['id'],
                        },
                      );

                      if (response['success'] == true) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Timeout recorded and working hours calculated successfully.'),
                          ),
                        );
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(response['message'] ?? 'Failed to record timeout.'),
                          ),
                        );
                      }
                    } catch (e) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('An error occurred: $e'),
                        ),
                      );
                    }
                  },
                );
              },
            );
          },
        ),


        IconButton(
          icon: const Icon(Icons.notifications),
          onPressed: () {
            Navigator.push(context, MaterialPageRoute(builder: (builder) => NotificationScreen(users)));
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
            users['email'],
            users['isVerified'],
            fullName: users['firstName'] + " " + users['lastName'],
            position: users['position'],
            ids: users['id'],
            profileImage: users['profileImage'],
          ),
          const ProjectInfoSection(),
          NavigatorEmployee(users),
          Expanded(
            child: EmployeeSchedule(users['id'], updator: 0),
          ),
        ],
      ),
    );
  }
}

class NavigatorEmployee extends StatefulWidget {
  final dynamic users;
  const NavigatorEmployee(this.users, {super.key});

  @override
  State<StatefulWidget> createState() => _NavigatorEmployee();
}

class _NavigatorEmployee extends State<NavigatorEmployee> {
  final List<String> _leaveTypes = ['Sick Leave', 'Casual Leave', 'Annual Leave'];
  final TextEditingController reasonController = TextEditingController();
  final TextEditingController startDateController = TextEditingController();
  final TextEditingController endDateController = TextEditingController();
  String selectedLeaveType = 'Sick Leave';
  late dynamic project;
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => init());
  }

  Future<void> init() async {
    RequestHandler requestHandler = RequestHandler();
    try {
      Map<String, dynamic> response = await requestHandler.handleRequest(
        context,
        'projects/getProject',
        body: {"id": widget.users['projectId']},
      );
      if (response['success'] == true) {
        setState(() {
          project = response['project'];
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(response['message'] ?? 'Loading project error'),
          ),
        );
        project = null;
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('An error occurred: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    print(widget.users['projectId']);
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
              if (widget.users['isManager'])
                buildExpandedActionButton(
                  label: 'View Attendance',
                  icon: Icons.check_circle_outline,
                  onPressed: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (builder) => ProjectManagerAttendance(users: widget.users)));
                  },
                ),
              if (!widget.users['isManager'])
                buildExpandedActionButton(
                  label: 'Check Attendance',
                  icon: Icons.check_circle_outline,
                  onPressed: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (builder) => EmployeeAttendanceViewScreen(users: widget.users)));
                  },
                ),
              if (widget.users['isManager'])
                buildExpandedActionButton(
                  label: 'Manage Leaves',
                  icon: Icons.event_available,
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (builder) => ManageLeavesScreen(widget.users)),
                    );
                  },
                ),
              if (!widget.users['isManager'])
                buildExpandedActionButton(
                  label: 'Request Leave',
                  icon: Icons.event_available,
                  onPressed: () {
                    showModalBottomSheet(
                      context: context,
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                      ),
                      builder: (BuildContext context) {
                        return Padding(
                          padding: const EdgeInsets.all(20),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Text(
                                'Request Leave',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 20),
                              TextField(
                                controller: reasonController,
                                decoration: const InputDecoration(
                                  labelText: 'Leave Reason',
                                  border: OutlineInputBorder(),
                                ),
                                maxLines: 3,
                              ),
                              const SizedBox(height: 20),
                              DropdownButtonFormField<String>(
                                value: selectedLeaveType,
                                decoration: const InputDecoration(
                                  labelText: 'Leave Type',
                                  border: OutlineInputBorder(),
                                ),
                                onChanged: (String? newValue) {
                                  if (newValue != null) {
                                    selectedLeaveType = newValue;
                                  }
                                },
                                items: _leaveTypes.map((leaveType) {
                                  return DropdownMenuItem<String>(
                                    value: leaveType,
                                    child: Text(leaveType),
                                  );
                                }).toList(),
                              ),
                              const SizedBox(height: 20),
                              TextField(
                                controller: startDateController,
                                readOnly: true,
                                decoration: const InputDecoration(
                                  labelText: 'Start Date',
                                  border: OutlineInputBorder(),
                                ),
                                onTap: () async {
                                  DateTime? pickedDate = await showDatePicker(
                                    context: context,
                                    initialDate: DateTime.now(),
                                    firstDate: DateTime.now(),
                                    lastDate: DateTime.now().add(const Duration(days: 365 * 5)),
                                  );
                                  if (pickedDate != null) {
                                    startDateController.text = "${pickedDate.toLocal()}".split(' ')[0];
                                  }
                                },
                              ),
                              const SizedBox(height: 20),
                              TextField(
                                controller: endDateController,
                                readOnly: true,
                                decoration: const InputDecoration(
                                  labelText: 'End Date',
                                  border: OutlineInputBorder(),
                                ),
                                onTap: () async {
                                  DateTime? startDate = DateTime.tryParse(startDateController.text);
                                  DateTime? pickedDate = await showDatePicker(
                                    context: context,
                                    initialDate: startDate ?? DateTime.now(),
                                    firstDate: startDate ?? DateTime.now(),
                                    lastDate: DateTime.now().add(const Duration(days: 365 * 5)),
                                  );
                                  if (pickedDate != null) {
                                    endDateController.text = "${pickedDate.toLocal()}".split(' ')[0];
                                  }
                                },
                              ),
                              const SizedBox(height: 20),
                              ElevatedButton(
                                onPressed: () {
                                  if (widget.users['projectId'] == null) {
                                    Navigator.pop(context);
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(content: Text('Employee has not assigned in a project.')),
                                    );
                                    return;
                                  }
                                  addRequestLeave(
                                    widget.users['id'],
                                    reasonController.text,
                                    selectedLeaveType,
                                    startDateController.text,
                                    endDateController.text,
                                  );
                                  Navigator.pop(context);
                                  // ScaffoldMessenger.of(context).showSnackBar(
                                  //   const SnackBar(content: Text('Leave request submitted')),
                                  // );
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color.fromARGB(255, 80, 160, 170),
                                ),
                                child: const Text('Submit Request', style: TextStyle(color: Colors.white)),
                              ),
                            ],
                          ),
                        );
                      },
                    );
                  },
                ),
            ],
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              buildExpandedActionButton(
                label: 'Attendance Report',
                icon: Icons.report,
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (builder) => const AttendanceReportScreen()));
                },
              ),
              if (widget.users['isManager'])
                buildExpandedActionButton(
                  label: 'View Project',
                  icon: Icons.folder,
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (builder) => ProjectDetailsScreen(isAdmin: true, isManager: true, project: project)));
                  },
                ),
              if (!widget.users['isManager'])
                buildExpandedActionButton(
                  label: 'Projects',
                  icon: Icons.folder,
                  onPressed: () {
                    // Navigator
                    // ProjectDetailsScreen
                    if (widget.users['projectId'] == null) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('There is no project assigned.')),
                      );
                    } else {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (builder) => ProjectDetailsScreen(isAdmin: false, project: project)));
                    }
                  },
                ),
            ],
          ),
        ],
      ),
    );
  }

  void addRequestLeave(userId, reason, leaveType, startDate, endDate) async {
    RequestHandler requestHandler = RequestHandler();
    try {
      if (mounted) {
        Navigator.pop(context);
      }
      Map<String, dynamic> response = await requestHandler.handleRequest(
        context,
        'users/requestLeave',
        body: {'userId': userId, 'reason': reason, 'leaveType': leaveType, 'startDate': startDate, 'endDate': endDate},
      );
      if (response['success'] == true) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Successfully send a Leave Request.')),
          );
        }
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(response['message'] ?? 'Sending leave request error')),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error occurred: $e')),
        );
      }
    }
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
            style: const TextStyle(fontSize: 12, color: Colors.white),
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
