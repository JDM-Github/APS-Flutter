import 'dart:convert';
import 'dart:io';

import 'package:first_project/screens/employee/projectReports.dart';
import 'package:http/http.dart' as http;

import 'package:first_project/flutter_session.dart';
import 'package:first_project/handle_request.dart';
import 'package:first_project/screens/admin/manageProject.dart';
import 'package:first_project/screens/component/employee_list.dart';
import 'package:first_project/screens/component/employeeTable.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ProjectDetailsScreen extends StatefulWidget {
  final Map<String, dynamic> project;
  final bool isAdmin;
  final bool isManager;

  const ProjectDetailsScreen({
    this.isAdmin = true,
    this.isManager = false,
    required this.project,
    super.key,
  });

  @override
  State<ProjectDetailsScreen> createState() => _ProjectDetailsScreenState();
}

class _ProjectDetailsScreenState extends State<ProjectDetailsScreen> {
  int counter = 1;
  late Map<String, dynamic> project;
  late bool isAdmin;
  @override
  void initState() {
    super.initState();
    project = widget.project;
    isAdmin = widget.isAdmin;
  }

  void updateList() {
    setState(() {
      counter++;
    });
    print(counter);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    print("didChangeDependencies called");
  }

  Future<void> cancelProject() async {
    RequestHandler requestHandler = RequestHandler();
    try {
      Map<String, dynamic> response = await requestHandler.handleRequest(
        context,
        'projects/cancel-project',
        body: {
          "projectId": widget.project['id'],
        },
      );
      if (response['success'] == true) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Project cancelled successfully')),
        );
        Navigator.pop(context);
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (builder) => ManageProjectScreen()));
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(response['message'] ?? 'Cancelling project error'),
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('An error occurred: $e')),
      );
    }
  }

  Future<void> completeProject() async {
    RequestHandler requestHandler = RequestHandler();
    try {
      Map<String, dynamic> response = await requestHandler.handleRequest(
        context,
        'projects/complete-project',
        body: {
          "projectId": widget.project['id'],
        },
      );
      if (response['success'] == true) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Project completed successfully')),
        );
        Navigator.pop(context);
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (builder) => ManageProjectScreen()));
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(response['message'] ?? 'Completing project error'),
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('An error occurred: $e')),
      );
    }
  }

  Future<void> updateTask() async {
    RequestHandler requestHandler = RequestHandler();
    try {
      Map<String, dynamic> response = await requestHandler.handleRequest(
        context,
        'projects/update-task-project',
        body: {
          "projectId": widget.project['id'],
          "task": widget.project['task']
        },
      );
      if (response['success'] == true) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Project task updated successfully')),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(response['message'] ?? 'Updating project error'),
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('An error occurred: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    print(widget.project);
    return Scaffold(
      appBar: AppBar(
        foregroundColor: Colors.white,
        title: const Text('Project Details'),
        backgroundColor: const Color.fromARGB(255, 80, 160, 170),
        actions: [
          if (widget.isManager && widget.project['status'] == 'Active')
            IconButton(
              icon: const Icon(Icons.report),
              tooltip: 'Project Report',
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ProjectReportsPage(project["id"]),
                  ),
                );
              },
            ),
          if (widget.isManager && widget.project['status'] == 'Active')
            IconButton(
              icon: const Icon(Icons.add),
              tooltip: 'Add Project Report',
              onPressed: () {
                showModalBottomSheet(
                  context: context,
                  isScrollControlled: true,
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
                  ),
                  builder: (BuildContext context) {
                    return Padding(
                      padding: EdgeInsets.only(
                        bottom: MediaQuery.of(context).viewInsets.bottom,
                        left: 16.0,
                        right: 16.0,
                        top: 16.0,
                      ),
                      child: AddProjectReportForm(
                        projectId: widget.project['id'],
                      ),
                    );
                  },
                );
              },
            ),
          if (isAdmin && widget.project['status'] == 'Active')
            IconButton(
              icon: const Icon(Icons.edit),
              tooltip: 'Edit Project Details',
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => EditProjectDetailsScreen(project: project),
                  ),
                );
              },
            ),
          if (isAdmin && widget.project['status'] == 'Active')
            IconButton(
              icon: const Icon(Icons.cancel),
              tooltip: 'Cancel Project',
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: const Text('Cancel Project'),
                    content: const Text('Are you sure you want to cancel this project?'),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text('No'),
                      ),
                      TextButton(
                        onPressed: () {
                          cancelProject();
                          Navigator.pop(context);
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Project cancelled successfully')),
                          );
                        },
                        child: const Text('Yes'),
                      ),
                    ],
                  ),
                );
              },
            ),
          if (isAdmin && widget.project['status'] == 'Active')
            IconButton(
              icon: const Icon(Icons.check_circle),
              tooltip: 'Complete Project',
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: const Text('Complete Project'),
                    content: const Text('Mark this project as completed?'),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text('No'),
                      ),
                      TextButton(
                        onPressed: () {
                          completeProject();
                        },
                        child: const Text('Yes'),
                      ),
                    ],
                  ),
                );
              },
            ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Padding(
            padding: const EdgeInsets.all(5.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildCard(
                  title: project['projectType'],
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildDetailRow(
                          'Project Manager', '${project['Users']['firstName']} ${project['Users']['lastName']}'),
                      _buildDetailRow('Client Name', project['clientName']),
                      _buildDetailRow('Client Email', project['clientEmail']),
                      _buildDetailRow('Client Type', project['clientType']),
                      _buildDetailRow('Budget', project['budget']),
                      _buildDetailRow('Location', project['projectLocation']),
                      _buildDetailRow('Start Date', project['startDate']),
                      _buildDetailRow('End Date', project['endDate']),
                    ],
                  ),
                  onInfoTap: () {
                    showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: const Text('Project Description'),
                        content: Text(project['projectDescription']),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(context),
                            child: const Text('Close'),
                          ),
                        ],
                      ),
                    );
                  },
                  status: project['status'],
                ),
                const SizedBox(height: 16),
                const Text(
                  'Project Agreement',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => FullscreenImageView(imageUrl: project['projectAgreement']),
                      ),
                    );
                  },
                  child: Container(
                    height: 200,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey),
                      borderRadius: BorderRadius.circular(12.0),
                      color: Colors.grey[200],
                    ),
                    child: project['projectAgreement'] != null
                        ? ClipRRect(
                            borderRadius: BorderRadius.circular(12.0),
                            child: Image.network(
                              project['projectAgreement'],
                              fit: BoxFit.cover,
                            ),
                          )
                        : const Center(
                            child: Text(
                              'No agreement uploaded',
                              style: TextStyle(color: Colors.grey),
                            ),
                          ),
                  ),
                ),
                const SizedBox(height: 16),
                const Text(
                  'Tasks',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                SizedBox(
                  height: 300,
                  child: ListView.builder(
                    itemCount: project['task'].length,
                    itemBuilder: (context, index) {
                      final task = jsonDecode(project['task'][index]);
                      bool isChecked = task['isFinished'] ?? false;

                      return Card(
                        margin: const EdgeInsets.symmetric(vertical: 8),
                        child: Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Task Name: ${task['name']}',
                                          style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 14,
                                          ),
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          'Description: ${task['description']}',
                                          style: const TextStyle(fontSize: 13),
                                        ),
                                      ],
                                    ),
                                  ),
                                  if (widget.isManager)
                                    Checkbox(
                                      value: task['isFinished'],
                                      onChanged: (value) async {
                                        setState(() {
                                          task['isFinished'] = !task['isFinished'];
                                          widget.project['task'][index] = jsonEncode(task);
                                        });

                                        updateTask();
                                      },
                                    ),

                                ],
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 16),
                if (isAdmin || widget.isManager)
                  SizedBox(
                    height: 500,
                    child: AllEmployeeTable(
                      projectId: project['id'],
                      counter: counter,
                      readOnly: widget.project["status"] == "Active",
                    ),
                  ),
                if ((isAdmin) && widget.project["status"] == "Active")
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton.icon(
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (builder) =>
                                    EmployeeListPage(onPop: updateList, ids: project['id'], notAssigned: true)));
                      },
                      icon: const Icon(Icons.add, color: Colors.white),
                      label: const Text('Add Employee', style: TextStyle(color: Colors.white)),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color.fromARGB(255, 80, 160, 170),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                  )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCard({
    required String title,
    required Widget child,
    required VoidCallback onInfoTap,
    required String status, // Add status parameter
  }) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      elevation: 4,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
            decoration: const BoxDecoration(
              color: Color.fromARGB(255, 80, 160, 170),
              borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(width: 8),
                    if (status == 'Completed') const Icon(Icons.verified, color: Colors.white, size: 18),
                    if (status == 'Canceled') const Icon(Icons.cancel, color: Colors.white, size: 18),
                  ],
                ),
                IconButton(
                  icon: const Icon(Icons.info_outline, color: Colors.white),
                  onPressed: onInfoTap,
                  tooltip: 'View Details',
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: child,
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.info_outline, size: 18, color: Colors.grey[700]),
          const SizedBox(width: 8),
          Expanded(
            child: RichText(
              text: TextSpan(
                text: '$label: ',
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
                children: [
                  TextSpan(
                    text: value,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.normal,
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class EditProjectDetailsScreen extends StatefulWidget {
  final Map<String, dynamic> project;

  const EditProjectDetailsScreen({required this.project, super.key});

  @override
  State<EditProjectDetailsScreen> createState() => _EditProjectDetailsScreenState();
}

class _EditProjectDetailsScreenState extends State<EditProjectDetailsScreen> {
  final List<String> projectClient = ['RESIDENTIAL', 'GOVERNMENT', 'COMMERCIAL', 'PUBLIC SECTOR'];
  String selectedClient = "RESIDENTIAL";

  final _formKey = GlobalKey<FormState>();

  late TextEditingController _clientNameController;
  late TextEditingController _clientEmailController;
  late TextEditingController _clientTypeController;
  late TextEditingController _budgetController;
  late TextEditingController _locationController;
  late TextEditingController _endDateController;
  late TextEditingController _descriptionController;

  @override
  void initState() {
    super.initState();
    selectedClient = widget.project['clientType'];
    _clientNameController = TextEditingController(text: widget.project['clientName']);
    _clientEmailController = TextEditingController(text: widget.project['clientEmail']);
    _clientTypeController = TextEditingController(text: widget.project['clientType']);
    _budgetController = TextEditingController(text: widget.project['budget']);
    _locationController = TextEditingController(text: widget.project['projectLocation']);
    _endDateController = TextEditingController(text: widget.project['endDate']);
    _descriptionController = TextEditingController(text: widget.project['projectDescription']);
  }

  @override
  void dispose() {
    _clientNameController.dispose();
    _clientEmailController.dispose();
    _clientTypeController.dispose();
    _budgetController.dispose();
    _locationController.dispose();
    _endDateController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> editProject(String clientName, String clientEmail, String clientType, String budget, String location,
      String endDate, String description) async {
    RequestHandler requestHandler = RequestHandler();
    try {
      Map<String, dynamic> response = await requestHandler.handleRequest(
        context,
        'projects/edit-project',
        body: {
          "clientName": clientName,
          "clientEmail": clientEmail,
          "clientType": clientType,
          "budget": budget,
          "projectLocation": location,
          "endDate": endDate,
          "projectDescription": description,
          "projectId": widget.project['id'],
        },
      );
      if (response['success'] == true) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Project details updated successfully')),
        );
        Navigator.pop(context);
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (builder) => ManageProjectScreen()));
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(response['message'] ?? 'Updating details error'),
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('An error occurred: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Project Details'),
        foregroundColor: Colors.white,
        backgroundColor: const Color.fromARGB(255, 80, 160, 170),
        elevation: 4.0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              _buildTextField(_clientNameController, 'Client Name', 'Enter client name'),
              _buildTextField(_clientEmailController, 'Client Email', 'Enter client email',
                  keyboardType: TextInputType.emailAddress),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: DropdownButtonFormField<String>(
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
              ),
              _buildTextField(_budgetController, 'Project Budget', 'Enter project budget',
                  keyboardType: TextInputType.number),
              _buildTextField(_locationController, 'Location', 'Enter location'),
              TextFormField(
                controller: _endDateController,
                readOnly: true,
                decoration: const InputDecoration(
                  labelText: 'End Date',
                  hintText: 'Select end date',
                  border: OutlineInputBorder(),
                ),
                onTap: () async {
                  DateTime? pickedDate = await showDatePicker(
                    context: context,
                    initialDate: _endDateController.text.isNotEmpty
                        ? DateTime.parse(_endDateController.text)
                        : DateTime.now(),
                    firstDate: DateTime(2000), 
                    lastDate: DateTime(2101),
                  );
                  if (pickedDate != null) {
                    setState(() {
                      _endDateController.text = "${pickedDate.toLocal()}".split(' ')[0];
                    });
                  }
                },
              ),

              // _buildTextField(_endDateController, 'End Date', 'Enter end date', keyboardType: TextInputType.datetime),
              _buildTextField(_descriptionController, 'Description', 'Enter project description', maxLines: 3),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        foregroundColor: Colors.white,
        backgroundColor: const Color.fromARGB(255, 80, 160, 170),
        child: const Icon(Icons.save),
        onPressed: () {
          if (_formKey.currentState?.validate() ?? false) {
            // Map<String, dynamic> updatedProject = {
            //   'clientName': _clientNameController.text,
            //   'clientEmail': _clientEmailController.text,
            //   'clientType': selectedClient,
            //   'budget': _budgetController.text,
            //   'projectLocation': _locationController.text,
            //   'endDate': _endDateController.text,
            //   'projectDescription': _descriptionController.text,
            // };

            editProject(_clientNameController.text, _clientEmailController.text, selectedClient, _budgetController.text,
                _locationController.text, _endDateController.text, _descriptionController.text);
          }
        },
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String label, String hintText,
      {TextInputType keyboardType = TextInputType.text, int maxLines = 1}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextFormField(
        controller: controller,
        keyboardType: keyboardType,
        maxLines: maxLines,
        decoration: InputDecoration(
          labelText: label,
          hintText: hintText,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: const Color.fromARGB(255, 80, 160, 170), width: 2),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: const Color.fromARGB(255, 80, 160, 170), width: 2),
          ),
        ),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'This field cannot be empty';
          }
          return null;
        },
      ),
    );
  }
}

class AddProjectReportForm extends StatefulWidget {
  final String projectId;

  const AddProjectReportForm({required this.projectId, super.key});

  @override
  State<AddProjectReportForm> createState() => _AddProjectReportFormState();
}

class _AddProjectReportFormState extends State<AddProjectReportForm> {
  final _formKey = GlobalKey<FormState>();
  String? _title;
  String? _description;
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

  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      String image = "";
      if (_selectedImage != null) {
        image = await uploadFile(_selectedImage?.path);
      }

      RequestHandler requestHandler = RequestHandler();
      try {
        Map<String, dynamic> response = await requestHandler.handleRequest(
          context,
          'projects/add-project-report',
          body: {
            "title": _title,
            "description": _description,
            "projectId": widget.projectId,
            "image": image,
          },
        );

        if (response['success'] == true) {
          Navigator.pop(context);
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Project report added successfully')),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(response['message'] ?? 'Failed to update profile.')),
          );
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('An error occurred: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Add Project Report',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            TextFormField(
              decoration: const InputDecoration(
                labelText: 'Title',
                border: OutlineInputBorder(),
              ),
              validator: (value) => value == null || value.isEmpty ? 'Please enter a title' : null,
              onSaved: (value) => _title = value,
            ),
            const SizedBox(height: 16),
            TextFormField(
              decoration: const InputDecoration(
                labelText: 'Description',
                border: OutlineInputBorder(),
              ),
              maxLines: 4,
              validator: (value) => value == null || value.isEmpty ? 'Please enter a description' : null,
              onSaved: (value) => _description = value,
            ),
            const SizedBox(height: 16),
            GestureDetector(
              onTap: _pickImage,
              child: Container(
                height: 200,
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
                          'Tap to select an image',
                          style: TextStyle(color: Colors.grey),
                        ),
                      ),
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromARGB(255, 80, 160, 170),
                ),
                onPressed: _submitForm,
                child: const Text(
                  'Submit',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
