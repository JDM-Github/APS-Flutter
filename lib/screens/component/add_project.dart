import 'dart:convert';
import 'dart:io';

import 'package:first_project/handle_request.dart';
import 'package:first_project/screens/admin/manageProject.dart';
import 'package:first_project/screens/component/add_project_manager.dart';
import 'package:first_project/screens/component/manageProject.dart';
import 'package:first_project/screens/component/viewEmployee.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;

class AddProjectForm extends StatefulWidget {
  final List<dynamic> projectManagers;

  const AddProjectForm(this.projectManagers, {super.key});

  @override
  State<AddProjectForm> createState() => _AddProjectFormState();
}

class _AddProjectFormState extends State<AddProjectForm> {
  String selectedProjectType = 'Emergency Repair';
  String selectedClient = "RESIDENTIAL";
  final List<String> projectTypeList = ['Emergency Repair', 'Maintenance', 'New Installation'];
  final List<String> projectClient = ['RESIDENTIAL', 'GOVERNMENT', 'COMMERCIAL', 'PUBLIC SECTOR'];
  List<Map<String, dynamic>> _tasks = [];

  final TextEditingController _projectNameController = TextEditingController();
  final TextEditingController _projectLocationController = TextEditingController();
  final TextEditingController _startDateController = TextEditingController();
  final TextEditingController _endDateController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _budgetController = TextEditingController();
  final TextEditingController _clientNameController = TextEditingController();
  final TextEditingController _clientEmailController = TextEditingController();

  File? _selectedImage;
  Future<void> _pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      setState(() {
        _selectedImage = File(image.path);
      });
    }
  }

  Future<String> uploadFile(selectedFile) async {
    if (selectedFile == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select a file to upload.')),
      );
      return "";
    }

    try {
      var request = http.MultipartRequest(
          'POST', Uri.parse('https://aps-backend.netlify.app/.netlify/functions/api/file/upload-file'));
      request.files.add(await http.MultipartFile.fromPath('file', selectedFile));

      var streamedResponse = await request.send();
      var response = await http.Response.fromStream(streamedResponse);

      if (response.statusCode == 200) {
        var responseData = jsonDecode(response.body);
        if (responseData['success']) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('File uploaded: ${responseData['uploadedDocument']}')),
          );
          return responseData['uploadedDocument'];
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Upload failed: ${responseData['message']}')),
          );
        }
      } else {
        throw Exception('Failed to upload file. Status code: ${response.statusCode}');
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('An error occurred: $e')),
      );
    }
    return "";
  }

  void _submitProject(String selectedProjectManager) async {
    if (_projectNameController.text.isEmpty ||
        _projectLocationController.text.isEmpty ||
        _clientNameController.text.isEmpty ||
        _clientEmailController.text.isEmpty ||
        _budgetController.text.isEmpty ||
        selectedProjectManager.isEmpty ||
        selectedProjectType.isEmpty ||
        _startDateController.text.isEmpty ||
        _endDateController.text.isEmpty ||
        _descriptionController.text.isEmpty) {
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill in all fields')),
      );
      return;
    }

    String image = "";
    if (_selectedImage != null) {
      image = await uploadFile(_selectedImage?.path);
    }

    RequestHandler requestHandler = RequestHandler();
    try {
      Map<String, dynamic> response = await requestHandler.handleRequest(
        context,
        'projects/create-project',
        body: {
          'projectManager': selectedProjectManager,
          'projectName': _projectNameController.text,
          'projectLocation': _projectLocationController.text,
          'budget': _budgetController.text,
          'projectType': selectedProjectType,
          'projectDescription': _descriptionController.text,
          'startDate': _startDateController.text,
          'endDate': _endDateController.text,
          'clientName': _clientNameController.text,
          'clientEmail': _clientEmailController.text,
          'clientType': selectedClient,
          'projectAgreement': image,
          'task': _tasks.map((task) => jsonEncode(task)).toList(),
        },
      );
      if (response['success'] == true) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Project added successfully')),
        );
        Navigator.pop(context);
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => ManageProjectScreen()),
        );
        return;
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
  }

  

  void _addTask() {
    setState(() {
      _tasks.add({
        'name': '',
        'description': '',
        'isFinished': false
      });
    });
  }
  void _removeTask(int index) {
    setState(() {
      _tasks.removeAt(index);
    });
  }

  void _updateTask(int index, String field, String value) {
    setState(() {
      _tasks[index][field] = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    String selectedProjectManager = widget.projectManagers.isNotEmpty ? widget.projectManagers[0]['id'].toString() : '';
    dynamic userSelected = widget.projectManagers.isNotEmpty ? widget.projectManagers[0] : null;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Project'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Add Project',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _projectNameController,
                decoration: const InputDecoration(
                  labelText: 'Project Name',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _budgetController,
                decoration: const InputDecoration(
                  labelText: 'Budget',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _clientNameController,
                decoration: const InputDecoration(
                  labelText: 'Client Name',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _clientEmailController,
                decoration: const InputDecoration(
                  labelText: 'Client Email',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: selectedClient,
                items: projectClient
                    .map((type) => DropdownMenuItem(
                          value: type,
                          child: Text(type),
                        ))
                    .toList(),
                onChanged: (value) {
                  setState(() {
                    selectedClient = value!;
                  });
                },
                decoration: const InputDecoration(
                  labelText: 'Client Type',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _projectLocationController,
                decoration: const InputDecoration(
                  labelText: 'Project Location',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              GestureDetector(
                onTap: _pickImage,
                child: Container(
                  height: 300,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(12.0),
                    color: Colors.grey[200],
                  ),
                  child: _selectedImage != null
                      ? ClipRRect(
                          borderRadius: BorderRadius.circular(12.0),
                          child: Image.file(
                            _selectedImage!,
                            fit: BoxFit.cover,
                            width: double.infinity,
                          ),
                        )
                      : const Center(
                          child: Text(
                            'Add an agreement',
                            style: TextStyle(color: Colors.grey),
                          ),
                        ),
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'Tasks',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: _tasks.length,
                itemBuilder: (context, index) {
                  return Card(
                    margin: const EdgeInsets.symmetric(vertical: 8),
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          TextFormField(
                            initialValue: _tasks[index]['name'],
                            decoration: const InputDecoration(
                              labelText: 'Task Name',
                              border: OutlineInputBorder(),
                            ),
                            onChanged: (value) {
                              _updateTask(index, 'name', value);
                            },
                          ),
                          const SizedBox(height: 8),
                          TextFormField(
                            initialValue: _tasks[index]['description'],
                            decoration: const InputDecoration(
                              labelText: 'Task Description',
                              border: OutlineInputBorder(),
                            ),
                            onChanged: (value) {
                              _updateTask(index, 'description', value);
                            },
                            maxLines: 2,
                          ),
                          const SizedBox(height: 8),
                          Align(
                            alignment: Alignment.centerRight,
                            child: IconButton(
                              icon: const Icon(Icons.delete, color: Colors.red),
                              onPressed: () {
                                _removeTask(index);
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
              const SizedBox(height: 8),
              ElevatedButton(
                onPressed: _addTask,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromARGB(255, 80, 160, 170),
                ),
                child: const Text('Add Task', style: TextStyle(color: Colors.white)),
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: selectedProjectManager,
                items: widget.projectManagers.isNotEmpty
                    ? widget.projectManagers
                        .map<DropdownMenuItem<String>>((manager) => DropdownMenuItem<String>(
                              value: manager['id'].toString(),
                              child: Text('${manager['firstName']} ${manager['lastName']}'),
                            ))
                        .toList()
                    : [],
                onChanged: (value) {
                  setState(() {
                    selectedProjectManager = value!;
                    userSelected = widget.projectManagers[widget.projectManagers
                        .indexWhere((manager) => manager['id'].toString() == selectedProjectManager)];
                  });
                },
                decoration: const InputDecoration(
                  labelText: 'Assign Project Manager',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 4),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: selectedProjectManager.isNotEmpty
                      ? () {
                          Navigator.push(
                              context, MaterialPageRoute(builder: (builder) => ViewEmployeeScreen(user: userSelected)));
                        }
                      : null,
                  onLongPress: null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(255, 80, 160, 170),
                  ),
                  child: const Text('View Project Manager', style: TextStyle(color: Colors.white)),
                ),
              ),
              const SizedBox(height: 20),
              DropdownButtonFormField<String>(
                value: selectedProjectType,
                items: projectTypeList
                    .map((type) => DropdownMenuItem(
                          value: type,
                          child: Text(type),
                        ))
                    .toList(),
                onChanged: (value) {
                  setState(() {
                    selectedProjectType = value!;
                  });
                },
                decoration: const InputDecoration(
                  labelText: 'Project Type',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _startDateController,
                readOnly: true,
                decoration: const InputDecoration(
                  labelText: 'Start Date',
                  hintText: 'YYYY-MM-DD',
                  suffixIcon: Icon(Icons.calendar_today),
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
                    _startDateController.text = pickedDate.toLocal().toString().split(' ')[0];
                  }
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _endDateController,
                readOnly: true,
                decoration: const InputDecoration(
                  labelText: 'Target End Date',
                  hintText: 'YYYY-MM-DD',
                  suffixIcon: Icon(Icons.calendar_today),
                  border: OutlineInputBorder(),
                ),
                onTap: () async {
                  if (_startDateController.text.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Please select a Start Date first.')),
                    );
                    return;
                  }
                  DateTime? startDate = DateTime.tryParse(_startDateController.text);
                  DateTime? pickedDate = await showDatePicker(
                    context: context,
                    initialDate: startDate ?? DateTime.now(),
                    firstDate: startDate ?? DateTime.now(),
                    lastDate: DateTime.now().add(const Duration(days: 365 * 5)),
                  );

                  if (pickedDate != null) {
                    _endDateController.text = pickedDate.toLocal().toString().split(' ')[0];
                  }
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _descriptionController,
                decoration: const InputDecoration(
                  labelText: 'Project Description',
                  border: OutlineInputBorder(),
                ),
                maxLines: 3,
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    _submitProject(selectedProjectManager);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(255, 80, 160, 170),
                  ),
                  child: const Text('Add Project', style: TextStyle(color: Colors.white)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
