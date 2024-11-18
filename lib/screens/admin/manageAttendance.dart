import 'package:first_project/screens/component/employeeAttendance.dart';
import 'package:flutter/material.dart';

class ManageAttendanceScreen extends StatelessWidget {
  const ManageAttendanceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      appBar: ManageAttendanceAppbar(),
      body: ManageAttendanceBody(),
    );
  }
}

class ManageAttendanceAppbar extends StatelessWidget
    implements PreferredSizeWidget {
  const ManageAttendanceAppbar({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: const Text(
        'Manage Attendance',
        style: TextStyle(color: Colors.white),
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
  String selectedFilter = 'Daily';

  void _updateFilter(String filter) {
    setState(() {
      selectedFilter = filter;
    });
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
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
              child: Padding(
                padding: const EdgeInsets.all(4.0),
                child: Column(
                  children: [
                    Card(
                      elevation: 4,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ProjectDropdown(),
                        ],
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 4.0),
                          child: ElevatedButton.icon(
                            onPressed: _showAddAttendanceModal,
                            icon: const Icon(Icons.add, color: Colors.white),
                            label: const Text('Add Attendance',
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
                          label: 'Daily',
                          isSelected: selectedFilter == 'Daily',
                          onPressed: () => _updateFilter('Daily'),
                        ),
                        FilterToggleButton(
                          label: 'Monthly',
                          isSelected: selectedFilter == 'Monthly',
                          onPressed: () => _updateFilter('Monthly'),
                        ),
                        FilterToggleButton(
                          label: 'Yearly',
                          isSelected: selectedFilter == 'Yearly',
                          onPressed: () => _updateFilter('Yearly'),
                        ),
                      ],
                    ),
                  ],
                ),
              )),
          const Expanded(child: EmployeeAttendance()),
        ],
      ),
    );
  }

  void _showAddAttendanceModal() {
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
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Add Attendance',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),
                TextFormField(
                  decoration: const InputDecoration(
                    labelText: 'Employee Name',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 16),
                TextFormField(
                  decoration: const InputDecoration(
                    labelText: 'Time In',
                    border: OutlineInputBorder(),
                    suffixIcon: Icon(Icons.access_time),
                  ),
                ),
                const SizedBox(height: 16),
                TextFormField(
                  decoration: const InputDecoration(
                    labelText: 'Time Out',
                    border: OutlineInputBorder(),
                    suffixIcon: Icon(Icons.access_time),
                  ),
                ),
                const SizedBox(height: 16),
                TextFormField(
                  decoration: const InputDecoration(
                    labelText: 'Place',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromARGB(255, 80, 160, 170),
                    ),
                    child: const Text('Add to Attendance'),
                  ),
                ),
              ],
            ),
          ),
        );
      },
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

class ProjectDropdown extends StatelessWidget {
  const ProjectDropdown({super.key});

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<String>(
      decoration: InputDecoration(
        filled: true,
        fillColor: const Color.fromARGB(255, 80, 160, 170).withOpacity(0.3),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
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
      items: const [
        DropdownMenuItem(
          value: 'Project 1',
          child: Text('Project 1'),
        ),
        DropdownMenuItem(
          value: 'Project 2',
          child: Text('Project 2'),
        ),
        DropdownMenuItem(
          value: 'Project 3',
          child: Text('Project 3'),
        ),
      ],
      onChanged: (value) {},
      hint: const Text(
        'Select a Project',
        style: TextStyle(
          fontWeight: FontWeight.w600,
          fontSize: 16,
          color: Color.fromARGB(255, 27, 72, 78),
        ),
      ),
    );
  }
}
