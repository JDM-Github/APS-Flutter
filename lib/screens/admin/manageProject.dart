import 'package:first_project/handle_request.dart';
import 'package:first_project/screens/component/add_project_manager.dart';
import 'package:first_project/screens/component/manageProject.dart';
import 'package:first_project/screens/component/viewEmployee.dart';
import 'package:flutter/material.dart';

class ManageProjectScreen extends StatelessWidget {
  const ManageProjectScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      appBar: ManageProjectAppbar(),
      body: ManageProjectBody(),
    );
  }
}

class ManageProjectAppbar extends StatelessWidget implements PreferredSizeWidget {
  const ManageProjectAppbar({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: const Text(
        'Manage Project',
        style: TextStyle(color: Colors.white, fontSize: 16),
      ),
      foregroundColor: Colors.white,
      backgroundColor: const Color.fromARGB(255, 80, 160, 170),
      actions: [
        IconButton(
          icon: const Icon(Icons.restart_alt_rounded),
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (builder) => ManageProjectScreen()),
            );
          },
        ),
      ]
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

class ManageProjectBody extends StatefulWidget {
  const ManageProjectBody({super.key});

  @override
  State<ManageProjectBody> createState() => _ManageProjectBodyState();
}

class _ManageProjectBodyState extends State<ManageProjectBody> {
  String selectedFilter = 'Active';
  String selectedProjectType = 'Emergency Repair';
  String selectedClient = "RESIDENTIAL";

  final List<String> projectTypeList = ['Emergency Repair', 'Maintenance', 'New Installation'];
  final List<String> projectClient = ['RESIDENTIAL', 'GOVERNMENT', 'COMMERCIAL', 'PUBLIC SECTOR'];
  List<dynamic> projectManagers = [];
  bool isLoading = true;

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
        'users/get-all-manager',
        body: {"doesNotHaveProject": true},
      );
      setState(() {
        isLoading = false;
      });
      if (response['success'] == true) {
        setAllProjectManager(response['managers'] ?? {});
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(response['message'] ?? 'Loading project managers error'),
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

  void setAllProjectManager(List<dynamic> users) {
    setState(() {
      projectManagers = users;
    });
  }

  void _updateFilter(String filter) {
    setState(() {
      selectedFilter = filter;
    });
  }

  final TextEditingController _projectNameController = TextEditingController();
  final TextEditingController _projectLocationController = TextEditingController();
  final TextEditingController _startDateController = TextEditingController();
  final TextEditingController _endDateController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _budgetController = TextEditingController();
  final TextEditingController _clientNameController = TextEditingController();
  final TextEditingController _clientEmailController = TextEditingController();

  void _showAddProjectModal() {
    String selectedProjectManager = projectManagers.isNotEmpty ? projectManagers[0]['id'].toString() : '';
    dynamic userSelected = projectManagers.isNotEmpty ? projectManagers[0] : null;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (BuildContext context) {
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
                  DropdownButtonFormField<String>(
                    value: selectedProjectManager,
                    items: projectManagers.isNotEmpty
                        ? projectManagers
                            .map<DropdownMenuItem<String>>((manager) => DropdownMenuItem<String>(
                                  value: manager['id'].toString(),
                                  child: Text('${manager['firstName']} ${manager['lastName']}'),
                                ))
                            .toList()
                        : [],
                    onChanged: (value) {
                      setState(() {
                        selectedProjectManager = value!;
                        userSelected = projectManagers[projectManagers
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
                              Navigator.push(context,
                                  MaterialPageRoute(builder: (builder) => ViewEmployeeScreen(user: userSelected)));
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
      },
    );
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
          'clientType': selectedClient
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
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 4.0),
                        child: ElevatedButton.icon(
                          // onPressed: () => {_showAddAttendanceModal(employees)},

                          icon: const Icon(Icons.add, color: Colors.white),
                          label: const Text('Add Project Manager', style: TextStyle(color: Colors.white, fontSize: 12)),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color.fromARGB(255, 80, 160, 170),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          onPressed: () {
                            showAddProjectManagerModal(context, ManageProjectScreen());
                          },
                        ),
                      ),
                    ),
                  ]),
                  Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4.0),
                      child: ElevatedButton.icon(
                        onPressed: _showAddProjectModal,
                        icon: const Icon(Icons.add, color: Colors.white),
                        label: const Text('Add Project', style: TextStyle(color: Colors.white, fontSize: 12)),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color.fromARGB(255, 80, 160, 170),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                      ),
                    ),
                    FilterToggleButton(
                      label: 'Active',
                      isSelected: selectedFilter == 'Active',
                      onPressed: () => _updateFilter('Active'),
                    ),
                  ]),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      FilterToggleButton(
                        label: 'Completed',
                        isSelected: selectedFilter == 'Completed',
                        onPressed: () => _updateFilter('Completed'),
                      ),
                      FilterToggleButton(
                        label: 'Cancelled',
                        isSelected: selectedFilter == 'Cancelled',
                        onPressed: () => _updateFilter('Cancelled'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          Expanded(child: ManageProjectTable(selectedFilter)),
        ],
      ),
    );
  }
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
