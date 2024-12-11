import 'package:first_project/handle_request.dart';
import 'package:first_project/screens/component/all_employee_attendance.dart';
// import 'package:first_project/screens/component/employeeAttendance.dart';
import 'package:flutter/material.dart';

class ManageAttendanceScreen extends StatelessWidget {
  const ManageAttendanceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const ManageAttendanceAppbar(),
      body: ManageAttendanceBody(),
    );
  }
}

class ManageAttendanceAppbar extends StatelessWidget implements PreferredSizeWidget {
  const ManageAttendanceAppbar({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: const Text(
        'Manage Attendance',
        style: TextStyle(color: Colors.white, fontSize: 16),
      ),
      foregroundColor: Colors.white,
      backgroundColor: const Color.fromARGB(255, 80, 160, 170),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

class ManageAttendanceBody extends StatefulWidget {
  const ManageAttendanceBody({super.key});

  @override
  State<ManageAttendanceBody> createState() => _ManageAttendanceBodyState();
}

class _ManageAttendanceBodyState extends State<ManageAttendanceBody> {
  String selectedFilter = 'Present';

  List<dynamic> projects = [];
  bool isLoading = true;
  String selectedProjectId = "";
  int updator = 0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => init());
  }

  Future<void> onProjectChanged(String projectId) async {
    setState(() {
      selectedProjectId = projectId;
    });
    await initEmployees();
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
        await initEmployees();
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

  List<dynamic> employees = [];
  Future<void> initEmployees() async {
    RequestHandler requestHandler = RequestHandler();
    try {
      Map<String, dynamic> response = {};
      response = await requestHandler.handleRequest(
        context,
        'attendance/getAllEmployeesAttendance',
        body: {
          'id': selectedProjectId,
        },
      );
      setState(() {
        isLoading = false;
      });
      if (response['success'] == true) {
        setAllEmployee(response['users']);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(response['message'] ?? 'Loading employee error'),
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

  void setAllEmployee(List<dynamic> users) {
    setState(() {
      employees = users;
    });
  }

  Future<void> _updateFilter(String filter) async {
    setState(() {
      selectedFilter = filter;
    });
    await initEmployees();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Card(
              elevation: 5,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              child: Padding(
                padding: const EdgeInsets.all(4.0),
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
                    Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 4.0),
                        child: ElevatedButton.icon(
                          onPressed: () => {_showAddAttendanceModal(employees)},
                          icon: const Icon(Icons.add, color: Colors.white),
                          label: const Text('Add Attendance', style: TextStyle(color: Colors.white, fontSize: 12)),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color.fromARGB(255, 80, 160, 170),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 4.0),
                          child: ElevatedButton.icon(
                            onPressed: () => {_setAllAttendance(employees)},
                            icon: const Icon(Icons.select_all, color: Colors.white),
                            label:
                                const Text('Set All Attendance', style: TextStyle(color: Colors.white, fontSize: 12)),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color.fromARGB(255, 80, 160, 170),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ]),
                    Row(
                      children: [
                        FilterToggleButton(
                          label: 'Present',
                          isSelected: selectedFilter == 'Present',
                          onPressed: () => _updateFilter('Present'),
                        ),
                        FilterToggleButton(
                          label: 'Absent',
                          isSelected: selectedFilter == 'Absent',
                          onPressed: () => _updateFilter('Absent'),
                        ),
                        FilterToggleButton(
                          label: 'Leave',
                          isSelected: selectedFilter == 'Leave',
                          onPressed: () => _updateFilter('Leave'),
                        ),
                      ],
                    )
                  ],
                ),
              )),
          Expanded(
              child:
                  AllEmployeeAttended(projectId: selectedProjectId, selectedFilter: selectedFilter, updator: updator)),
        ],
      ),
    );
  }

  final TextEditingController _timeInController = TextEditingController();
  final TextEditingController _timeOutController = TextEditingController();
  final TextEditingController _placeController = TextEditingController();
  String status = 'Present';

  void _showAddAttendanceModal(List<dynamic> employees) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (BuildContext context) {
        String? selectedEmployeeId;

        return Padding(
          padding: MediaQuery.of(context).viewInsets,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: StatefulBuilder(
              builder: (BuildContext context, StateSetter setState) {
                return Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Add Attendance',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    DropdownButtonFormField<String>(
                      decoration: const InputDecoration(
                        labelText: 'Select Employee',
                        border: OutlineInputBorder(),
                      ),
                      items: employees.map<DropdownMenuItem<String>>((employee) {
                        return DropdownMenuItem<String>(
                          value: employee['id'].toString(),
                          child: Text(
                            '${employee['firstName']} ${employee['lastName']}',
                          ),
                        );
                      }).toList(),
                      onChanged: (value) async {
                        setState(() {
                          selectedEmployeeId = value;
                        });
                      },
                      hint: const Text('Choose an Employee'),
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      readOnly: true,
                      controller: _timeInController,
                      onTap: () async {
                        TimeOfDay? pickedTime = await showTimePicker(
                          context: context,
                          initialTime: TimeOfDay.now(),
                        );
                        if (pickedTime != null) {
                          setState(() {
                            _timeInController.text = pickedTime.format(context);
                          });
                        }
                      },
                      decoration: const InputDecoration(
                        labelText: 'Time In',
                        border: OutlineInputBorder(),
                        suffixIcon: Icon(Icons.access_time),
                      ),
                    ),
                    const SizedBox(height: 16),
                    // TextFormField(
                    //   readOnly: true,
                    //   controller: _timeOutController,
                    //   onTap: () async {
                    //     TimeOfDay? pickedTime = await showTimePicker(
                    //       context: context,
                    //       initialTime: TimeOfDay.now(),
                    //     );
                    //     if (pickedTime != null) {
                    //       setState(() {
                    //         _timeOutController.text = pickedTime.format(context);
                    //       });
                    //     }
                    //   },
                    //   decoration: const InputDecoration(
                    //     labelText: 'Time Out',
                    //     border: OutlineInputBorder(),
                    //     suffixIcon: Icon(Icons.access_time),
                    //   ),
                    // ),
                    TextFormField(
                      controller: _placeController,
                      decoration: const InputDecoration(
                        labelText: 'Place',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 16),
                    DropdownButtonFormField<String>(
                      value: status,
                      decoration: const InputDecoration(
                        labelText: 'Status',
                        border: OutlineInputBorder(),
                      ),
                      onChanged: (newValue) {
                        setState(() {
                          status = newValue!;
                        });
                      },
                      items: ['Present', 'Absent', 'Leave'].map((String statusOption) {
                        return DropdownMenuItem<String>(
                          value: statusOption,
                          child: Text(statusOption),
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 16),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          if (selectedEmployeeId != null) {
                            Navigator.pop(context);
                            setAttendance(selectedEmployeeId, _timeInController.text, _timeOutController.text,
                                _placeController.text, status);
                          } else {
                            Navigator.pop(context);
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Please select an employee'),
                              ),
                            );
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color.fromARGB(255, 80, 160, 170),
                        ),
                        child: const Text(
                          'Add to Attendance',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        );
      },
    );
  }

  Future<void> setAttendance(userId, timeIn, timeOut, place, status) async {
    RequestHandler requestHandler = RequestHandler();
    try {
      Map<String, dynamic> response = await requestHandler.handleRequest(
        context,
        'attendance/createAttendance',
        body: {"userId": userId, "timeIn": timeIn, "place": place, "status": status},
      );
      setState(() {
        isLoading = false;
      });
      if (response['success'] == true) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(response['message'] ?? 'Attendance created successfully.'),
          ),
        );
        setState(() {
          updator++;
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(response['message'] ?? 'Adding attendance error'),
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

  _setAllAttendance(List employees) {}
}

class FilterToggleButton extends StatefulWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onPressed;

  const FilterToggleButton({
    super.key,
    required this.label,
    required this.isSelected,
    required this.onPressed,
  });

  @override
  State<FilterToggleButton> createState() => _FilterToggleButtonState();
}

class _FilterToggleButtonState extends State<FilterToggleButton> {
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4.0),
        child: ElevatedButton(
          onPressed: widget.onPressed,
          style: ElevatedButton.styleFrom(
            backgroundColor: widget.isSelected
                ? const Color.fromARGB(255, 80, 160, 170)
                : const Color.fromARGB(255, 80, 160, 170).withOpacity(0.3),
            padding: const EdgeInsets.symmetric(vertical: 12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          child: Text(
            widget.label,
            style: TextStyle(
                color: widget.isSelected ? Colors.white : const Color.fromARGB(255, 27, 72, 78),
                fontWeight: FontWeight.bold,
                fontSize: 12),
          ),
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
