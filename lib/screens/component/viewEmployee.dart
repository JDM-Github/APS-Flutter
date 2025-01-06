import 'package:first_project/handle_request.dart';
import 'package:first_project/screens/component/employeeSchedule.dart';
import 'package:first_project/screens/component/userInfo.dart';
import 'package:flutter/material.dart';

class ViewEmployeeScreen extends StatefulWidget {
  final Map<String, dynamic> user;

  const ViewEmployeeScreen({super.key, required this.user});

  @override
  State<StatefulWidget> createState() => _ViewEmployeeScreen();
}

class _ViewEmployeeScreen extends State<ViewEmployeeScreen> {
  int updator = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Employee Details',
          style: TextStyle(fontSize: 16),
        ),
        backgroundColor: const Color.fromARGB(255, 80, 160, 170),
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            tooltip: 'Edit Skills & Position',
            onPressed: () {
              showAddEmployeeModal();
            },
          ),
          IconButton(
            icon: const Icon(Icons.star),
            tooltip: 'Make Project Manager',
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text('Are you sure?'),
                  content: const Text('Do you want to make this employee a Project Manager?'),
                  actions: [
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: const Text('Cancel'),
                    ),
                    TextButton(
                      onPressed: () {
                        makeEmployeeProjectManager();
                      },
                      child: const Text('Yes'),
                    ),
                  ],
                ),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.info),
            tooltip: 'View Qualifications',
            onPressed: () {
              final startDate = DateTime.parse(widget.user['startDate']);
              final currentDate = DateTime.now();
              final monthsEmployed = (currentDate.year - startDate.year) * 12 + (currentDate.month - startDate.month);
              final hasLeadershipSkill = (widget.user['skills'] as List).contains('Leadership');
              final isQualified = monthsEmployed >= 6 && hasLeadershipSkill;
              final feedback = <String>[];
              if (monthsEmployed < 6) {
                feedback.add('- Only employed for $monthsEmployed months. At least 6 months required.');
              }
              if (!hasLeadershipSkill) {
                feedback.add('- Does not possess Leadership skills.');
              }
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text('Qualification Check'),
                  content: Text(
                    isQualified
                        ? 'This employee is qualified to be a Project Manager!'
                        : 'This employee does not meet the qualifications to be a Project Manager:\n\n${feedback.join('\n')}',
                  ),
                  actions: [
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: const Text('Close'),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            UserInfoSection(
              widget.user['email'],
              widget.user['isVerified'],
                profileImage: widget.user['profileImage'],
                position: widget.user['position'],
                fullName: '${widget.user['firstName']} ${widget.user['lastName']}',
                ids: widget.user['id']),

            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.1),
                    spreadRadius: 1,
                    blurRadius: 8,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (widget.user['isManager'])
                    Text(
                      'THE PROJECT MANAGER',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Color.fromARGB(255, 80, 160, 170),
                      ),
                    ),
                  if (!widget.user['isManager'])
                    Text(
                      'Project Manager: ${(widget.user['projectManager'] == '') ? 'NO PROJECT MANAGER' : widget.user['projectManager']}',
                      style: const TextStyle(fontSize: 12),
                    ),
                  const SizedBox(height: 10),
                  Text(
                    'Email: ${widget.user['email']}',
                    style: const TextStyle(fontSize: 12),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    'Department: ${widget.user['department']}',
                    style: const TextStyle(fontSize: 12),
                  ),
                  Wrap(
                    spacing: 8.0,
                    children: (widget.user['skills'] as List)
                        .map((skill) => Chip(
                              side: BorderSide.none,
                              backgroundColor: const Color.fromARGB(255, 80, 160, 170),
                              label: Text(
                                skill,
                                style: const TextStyle(color: Colors.white, fontSize: 12),
                              ),
                            ))
                        .toList(),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 5),

            // Status Section
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.1),
                    spreadRadius: 1,
                    blurRadius: 8,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Status:',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: Color.fromARGB(255, 80, 160, 170),
                    ),
                  ),
                  Text(
                    widget.user['is_deactivated'] ? "Inactive" : "Active",
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: widget.user['is_deactivated'] ? Colors.red : Colors.green,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 500,
              child: EmployeeSchedule(widget.user['id'], updator: updator),
            )
          ],
        ),
      ),
    );
  }

  void makeEmployeeProjectManager() async {
    RequestHandler requestHandler = RequestHandler();
    try {
      if (mounted) {
        Navigator.pop(context);
      }
      Map<String, dynamic> response = await requestHandler.handleRequest(
        context,
        'users/makeProjectManager',
        body: {
          'userId': widget.user['id'],
        },
      );
      if (response['success'] == true) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Employee is now a Project Manager!')),
          );
          setState(() => widget.user['isManager'] = true);
        }
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(response['message'] ?? 'Making employee project manager error')),
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

  void showAddEmployeeModal() {
    showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        builder: (BuildContext context) {
          return EditSkillsAndPosition(
            initialPosition: widget.user['position'] ?? '',
            initialSkills: List<String>.from(widget.user['skills'] ?? []),
            onSave: (position, skills, newSkill) async {
              final updatedPosition = position;
              final updatedSkills = skills;

              RequestHandler requestHandler = RequestHandler();
              try {
                Map<String, dynamic> response = await requestHandler.handleRequest(
                  context,
                  'users/updatePositionSkills',
                  body: {
                    'userId': widget.user['id'],
                    'position': updatedPosition,
                    'skills': updatedSkills,
                  },
                );
                if (response['success'] == true) {
                  if (mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Employee updated successfully!')),
                    );
                    setState(() {
                      widget.user['position'] = updatedPosition;
                      widget.user['skills'] = updatedSkills;
                    });
                  }
                } else {
                  if (mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text(response['message'] ?? 'Updating employee error')),
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
            },
          );
        });
  }
}

class EditSkillsAndPosition extends StatefulWidget {
  final String initialPosition;
  final List<String> initialSkills;
  final Function(dynamic, dynamic, dynamic) onSave;

  const EditSkillsAndPosition({
    super.key,
    required this.initialPosition,
    required this.initialSkills,
    required this.onSave,
  });

  @override
  State<EditSkillsAndPosition> createState() => _EditSkillsAndPositionState();
}

class _EditSkillsAndPositionState extends State<EditSkillsAndPosition> {
  late TextEditingController positionController;
  late TextEditingController newSkillController;
  late List<String> skills;
  late List<String> selectedSkills;

  @override
  void initState() {
    super.initState();
    positionController = TextEditingController(text: widget.initialPosition);
    newSkillController = TextEditingController();
    skills = List<String>.from(widget.initialSkills);
    selectedSkills = List<String>.from(widget.initialSkills);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        left: 20,
        right: 20,
        top: 20,
        bottom: MediaQuery.of(context).viewInsets.bottom + 20,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Edit Skills & Position',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 20),
          TextField(
            controller: positionController,
            decoration: const InputDecoration(
              labelText: 'Position',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 20),
          Wrap(
            spacing: 8,
            children: skills.map((skill) {
              final isSelected = selectedSkills.contains(skill);
              return FilterChip(
                label: Text(skill),
                selected: isSelected,
                onSelected: (selected) {
                  setState(() {
                    if (selected) {
                      selectedSkills.add(skill);
                    } else {
                      selectedSkills.remove(skill);
                    }
                  });
                },
                selectedColor: Colors.blue.withOpacity(0.3),
                backgroundColor: Colors.grey.withOpacity(0.3),
              );
            }).toList(),
          ),
          const SizedBox(height: 20),
          TextField(
            controller: newSkillController,
            decoration: InputDecoration(
              labelText: 'Add New Skill',
              border: const OutlineInputBorder(),
              suffixIcon: IconButton(
                icon: const Icon(Icons.add),
                onPressed: () {
                  final newSkill = newSkillController.text.trim();
                  if (newSkill.isNotEmpty) {
                    setState(() {
                      skills.add(newSkill);
                    });
                    newSkillController.clear();
                  }
                },
              ),
            ),
          ),
          const SizedBox(height: 20),
          Align(
            alignment: Alignment.centerRight,
            child: ElevatedButton(
              onPressed: () {
                widget.onSave(positionController.text, selectedSkills, newSkillController.text);
                Navigator.of(context).pop();
              },
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                backgroundColor: const Color.fromARGB(255, 80, 160, 170),
                elevation: 5,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
              ),
              child: const Text(
                'Save',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
