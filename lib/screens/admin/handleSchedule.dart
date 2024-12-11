import 'package:first_project/handle_request.dart';
import 'package:first_project/screens/component/employeeSchedule.dart';
import 'package:flutter/material.dart';

class HandleScheduleScreen extends StatelessWidget {
  const HandleScheduleScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      appBar: HandleScheduleAppbar(),
      body: HandleScheduleBody(),
    );
  }
}

class HandleScheduleAppbar extends StatelessWidget implements PreferredSizeWidget {
  const HandleScheduleAppbar({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: const Text(
        'Manage Schedule',
        style: TextStyle(color: Colors.white, fontSize: 16),
      ),
      foregroundColor: Colors.white,
      backgroundColor: const Color.fromARGB(255, 80, 160, 170),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

class HandleScheduleBody extends StatefulWidget {
  const HandleScheduleBody({super.key});

  @override
  State<HandleScheduleBody> createState() => _HandleScheduleBodyState();
}

class _HandleScheduleBodyState extends State<HandleScheduleBody> {
  String? selectedUser;
  String? selectedProject = 'All Projects';

  List<dynamic> users = [];
  List<dynamic> projects = [];
  int updator = 0;
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
        'projects/get-all-projects',
        body: {"filter": "Active"},
      );
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
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('An error occurred: $e')),
      );
    }
  }

  Future<void> getAllEmployees() async {
    setState(() {
      selectedUser = null;
    });
    RequestHandler requestHandler = RequestHandler();
    try {
      Map<String, dynamic> response = await requestHandler.handleRequest(
        context,
        'projects/get-all-project-employee',
        body: {"id": selectedProject},
      );
      if (response['success'] == true) {
        setState(() {
          users = response['users'];
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(response['message'] ?? 'Loading all user project error'),
          ),
        );
      }
    } catch (e) {
      // ScaffoldMessenger.of(context).showSnackBar(
      //   SnackBar(content: Text('An error occurred: $e')),
      // );
      print("$e");
    }
  }

  void setAllProjects(List<dynamic> projects) {
    setState(() {
      this.projects = projects;
    });
  }

  void setSelectedProject(project) {
    setState(() {
      selectedProject = project;
    });
    getAllEmployees();
  }

  @override
  Widget build(BuildContext context) {
    // bool hasProject = selectedProject != 'All Projects';
    bool isSelectionValid = selectedUser != null && selectedProject != 'All Projects';
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Card(
            elevation: 5,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      icon: Icon(Icons.add, color: isSelectionValid ? Colors.white : Colors.white70),
                      label: Text('Add Schedule',
                          style: TextStyle(color: isSelectionValid ? Colors.white : Colors.white70)),
                      style: ElevatedButton.styleFrom(
                        disabledBackgroundColor: const Color.fromARGB(255, 80, 160, 170).withOpacity(0.8),
                        backgroundColor: const Color.fromARGB(255, 80, 160, 170),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      onLongPress: null,
                      onPressed: !isSelectionValid
                          ? null
                          : () {
                              _openAddScheduleModal(context);
                            },
                    ),
                  ),
                  const SizedBox(height: 5),
                  Row(children: [
                    Expanded(
                      child: DropdownButtonFormField<String>(
                        value: null,
                        items: projects.isNotEmpty
                            ? projects
                                .map((project) => DropdownMenuItem<String>(
                                      value: project['id'] as String,
                                      child: Text(
                                        project['projectName'],
                                        style: const TextStyle(
                                          fontWeight: FontWeight.w600,
                                          fontSize: 12,
                                          color: Color.fromARGB(255, 27, 72, 78),
                                        ),
                                      ),
                                    ))
                                .toList()
                            : [],
                        onChanged: projects.isNotEmpty
                            ? (value) {
                                setState(() {
                                  setSelectedProject(value);
                                });
                              }
                            : null,
                        hint: Text(
                          projects.isNotEmpty ? 'Select a Project' : 'No Projects Available',
                          style: const TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 12,
                            color: Color.fromARGB(255, 27, 72, 78),
                          ),
                        ),
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
                    const SizedBox(width: 5),
                    Expanded(
                      child: DropdownButtonFormField<String>(
                        value: selectedUser,
                        items: users.isNotEmpty
                            ? users
                                .map((user) => DropdownMenuItem<String>(
                                      value: user['id'],
                                      child: Text(
                                        '${user['firstName']} ${user['lastName']}',
                                        style: const TextStyle(
                                          fontWeight: FontWeight.w600,
                                          fontSize: 12,
                                          color: Color.fromARGB(255, 27, 72, 78),
                                        ),
                                      ),
                                    ))
                                .toList()
                            : [],
                        onChanged: users.isNotEmpty
                            ? (String? value) {
                                setState(() {
                                  selectedUser = value;
                                  print(value);
                                });
                              }
                            : null,
                        hint: Text(
                          users.isNotEmpty ? 'Select a User' : 'No Users Available',
                          style: const TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 12,
                            color: Color.fromARGB(255, 27, 72, 78),
                          ),
                        ),
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
                  ]),
                ],
              ),
            ),
          ),
          if (!isSelectionValid) const Center(child: Text('No user or project selected.')),
          if (isSelectionValid) Expanded(child: EmployeeSchedule(selectedUser!, updator: updator)),
        ],
      ),
    );
  }

  Future<void> addSchedule(userId, date, timeFrom, timeTo, description) async {
    RequestHandler requestHandler = RequestHandler();
    try {
      Map<String, dynamic> response = await requestHandler.handleRequest(
        context,
        'attendance/createSchedule',
        body: {"userId": userId, "date": date, "timeFrom": timeFrom, "timeTo": timeTo, "description": description},
      );
      if (response['success'] == true) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(response['message'] ?? 'Schedule created successfully.'),
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
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('An error occurred: $e')),
      );
    }
  }

  void _openAddScheduleModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return AddScheduleModal(
          selectedUser: selectedUser!,
          onSave: (date, from, to, description) {
            addSchedule(selectedUser, date, from, to, description);
          },
        );
      },
    );
  }
}

class AddScheduleModal extends StatefulWidget {
  final String selectedUser;
  final Function(String, String, String, String) onSave;

  const AddScheduleModal({
    super.key,
    required this.selectedUser,
    required this.onSave,
  });

  @override
  State<AddScheduleModal> createState() => _AddScheduleModalState();
}

class _AddScheduleModalState extends State<AddScheduleModal> {
  final TextEditingController dateController = TextEditingController();
  final TextEditingController fromController = TextEditingController();
  final TextEditingController toController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: MediaQuery.of(context).viewInsets, // Handle keyboard
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Add Schedule',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            TextFormField(
              initialValue: widget.selectedUser,
              readOnly: true,
              decoration: const InputDecoration(
                labelText: 'User',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: dateController,
              decoration: const InputDecoration(
                labelText: 'Date',
                border: OutlineInputBorder(),
                suffixIcon: Icon(Icons.calendar_today),
              ),
              readOnly: true,
              onTap: () async {
                DateTime? selectedDate = await showDatePicker(
                  context: context,
                  initialDate: DateTime.now(),
                  firstDate: DateTime.now(),
                  lastDate: DateTime.now().add(const Duration(days: 365 * 5)),
                );
                if (selectedDate != null) {
                  dateController.text = selectedDate.toLocal().toString().split(' ')[0];
                }
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              readOnly: true,
              controller: fromController,
              onTap: () async {
                TimeOfDay? pickedTime = await showTimePicker(
                  context: context,
                  initialTime: TimeOfDay.now(),
                );
                if (pickedTime != null) {
                  fromController.text = pickedTime.format(context);
                }
              },
              decoration: const InputDecoration(
                labelText: 'From (hrs)',
                border: OutlineInputBorder(),
                suffixIcon: Icon(Icons.access_time),
              ),
            ),
            const SizedBox(height: 16),
            TextFormField(
              readOnly: true,
              controller: toController,
              keyboardType: TextInputType.number,
              onTap: () async {
                TimeOfDay? pickedTime = await showTimePicker(
                  context: context,
                  initialTime: TimeOfDay.now(),
                );
                if (pickedTime != null) {
                  setState(() {
                    toController.text = pickedTime.format(context);
                  });
                }
              },
              decoration: const InputDecoration(
                labelText: 'To (hrs)',
                border: OutlineInputBorder(),
                suffixIcon: Icon(Icons.access_time),
              ),
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: descriptionController,
              decoration: const InputDecoration(
                labelText: 'Description',
                border: OutlineInputBorder(),
              ),
              maxLines: 3,
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  widget.onSave(
                    dateController.text,
                    fromController.text,
                    toController.text,
                    descriptionController.text,
                  );
                  Navigator.pop(context);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromARGB(255, 80, 160, 170),
                ),
                child: const Text('Add to Schedule'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
