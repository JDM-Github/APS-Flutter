import 'package:first_project/screens/component/manageProject.dart';
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

class ManageProjectAppbar extends StatelessWidget
    implements PreferredSizeWidget {
  const ManageProjectAppbar({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: const Text(
        'Manage Project',
        style: TextStyle(color: Colors.white),
      ),
      foregroundColor: Colors.white,
      backgroundColor: const Color.fromARGB(255, 80, 160, 170),
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
  String selectedProject = 'All Projects';
  String selectedFilter = 'Daily';
  String selectedProjectType = 'Emergency Repair';
  String selectedProjectManager = 'John Doe';

  final List<String> projectList = ['All Projects', 'Project A', 'Project B'];
  final List<String> filterList = ['Daily', 'Monthly', 'Yearly'];
  final List<String> projectTypeList = [
    'Emergency Repair',
    'Maintenance',
    'New Installation'
  ];
  final List<String> projectManagers = [
    'John Doe',
    'Jane Smith',
    'Emily Johnson'
  ];

  void _updateFilter(String filter) {
    setState(() {
      selectedFilter = filter;
    });
  }

  void _showAddProjectModal() {
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
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    decoration: const InputDecoration(
                      labelText: 'Project Name',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    decoration: const InputDecoration(
                      labelText: 'Project Location',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 16),
                  DropdownButtonFormField<String>(
                    value: selectedProjectManager,
                    items: projectManagers
                        .map((manager) => DropdownMenuItem(
                              value: manager,
                              child: Text(manager),
                            ))
                        .toList(),
                    onChanged: (value) {
                      setState(() {
                        selectedProjectManager = value!;
                      });
                    },
                    decoration: const InputDecoration(
                      labelText: 'Assign Project Manager',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 16),
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
                    decoration: const InputDecoration(
                      labelText: 'Start Date',
                      hintText: 'YYYY-MM-DD',
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.datetime,
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    decoration: const InputDecoration(
                      labelText: 'Target End Date',
                      hintText: 'YYYY-MM-DD',
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.datetime,
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
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
                        Navigator.pop(context);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor:
                            const Color.fromARGB(255, 80, 160, 170),
                      ),
                      child: const Text('Add Project'),
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

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Card(
            elevation: 5,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            child: Padding(
              padding: const EdgeInsets.all(4.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 4.0),
                        child: ElevatedButton.icon(
                          onPressed: _showAddProjectModal,
                          icon: const Icon(Icons.add, color: Colors.white),
                          label: const Text('Add Project',
                              style: TextStyle(color: Colors.white)),
                          style: ElevatedButton.styleFrom(
                            backgroundColor:
                                const Color.fromARGB(255, 80, 160, 170),
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
          const Expanded(child: ManageProjectTable()),
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
              color: widget.isSelected
                  ? Colors.white
                  : const Color.fromARGB(255, 27, 72, 78),
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}
