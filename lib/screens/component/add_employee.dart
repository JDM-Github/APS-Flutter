import 'package:first_project/handle_request.dart';
import 'package:flutter/material.dart';

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
  String selectedDepartment = '';
  List<String> genders = ['Male', 'Female'];
  List<String> departments = ['Operations', 'Sales', 'Emergency Repair', 'Maintenance', 'New Installation'];

  List<String> skills = [
    'Plumbing Expertise',
    'Pipe Fitting',
    'Drainage Systems',
    'Emergency Repairs',
    'Water Heater Installation',
    'Leak Detection',
    'Technical Knowledge',
    'Customer Service',
    'Problem Solving',
    'Time Management',
    'Safety Awareness',
    'Tool Operation'
  ];
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
                value: null,
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
                    if (firstNameController.text.trim().isEmpty ||
                        lastNameController.text.trim().isEmpty ||
                        middleInitialController.text.trim().isEmpty ||
                        selectedGender == '' ||
                        emailController.text.trim().isEmpty ||
                        passwordController.text.trim().isEmpty ||
                        selectedDepartment == '' ||
                        selectedSkills.isEmpty) {
                      Navigator.pop(context);
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Please fill in all the required fields.')),
                      );
                    }

                    widget.onSave(
                        firstNameController.text,
                        lastNameController.text,
                        middleInitialController.text,
                        selectedGender,
                        emailController.text,
                        passwordController.text,
                        selectedDepartment,
                        selectedSkills,
                        isProjectManager);
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

void showAddEmployeeModal(BuildContext context, Widget page) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    builder: (BuildContext context) {
      return AddEmployee(
        onSave: (firstName, lastName, middleInitial, selectedGender, email, password, selectedDepartment,
            selectedSkills, isProjectManager) async {
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
                MaterialPageRoute(builder: (context) => page),
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
