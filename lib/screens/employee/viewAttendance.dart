import 'package:flutter/material.dart';

// EmployeeViewAttendance Screen
class EmployeeViewAttendanceScreen extends StatefulWidget {
  const EmployeeViewAttendanceScreen({super.key});

  @override
  State<EmployeeViewAttendanceScreen> createState() =>
      _EmployeeViewAttendanceScreenState();
}

abstract class Employee {
  String employeeName;
  String timeIn;
  String timeOut;
  String place;

  Employee({
    required this.employeeName,
    required this.timeIn,
    required this.timeOut,
    required this.place,
  });
}

class AttendedEmployee implements Employee {
  @override
  String employeeName;

  @override
  String timeIn;

  @override
  String timeOut;

  @override
  String place;

  AttendedEmployee({
    required this.employeeName,
    required this.timeIn,
    required this.timeOut,
    required this.place,
  });
}

class _EmployeeViewAttendanceScreenState
    extends State<EmployeeViewAttendanceScreen> {
  final List<String> _employees = [
    'John Doe',
    'Jane Smith',
    'Michael Johnson',
    'Emily Davis'
  ];

  final List<AttendedEmployee> _attendedEmployees = [];

  String? _selectedEmployee;
  final TextEditingController _timeInController = TextEditingController();
  final TextEditingController _timeOutController = TextEditingController();
  final TextEditingController _placeController = TextEditingController();

  void _addAttendance() {
    if (_selectedEmployee != null) {
      final isEmployeeAlreadyAdded = _attendedEmployees.any(
        (employee) => employee.employeeName == _selectedEmployee,
      );
      if (!isEmployeeAlreadyAdded) {
        setState(() {
          _attendedEmployees.add(
            AttendedEmployee(
              employeeName: _selectedEmployee!,
              timeIn: _timeInController.text.isNotEmpty
                  ? _timeInController.text
                  : '08:00 AM',
              timeOut: _timeOutController.text.isNotEmpty
                  ? _timeOutController.text
                  : '05:00 PM',
              place: _placeController.text.isNotEmpty
                  ? _placeController.text
                  : 'Office',
            ),
          );
        });
      }
    }

    _timeInController.clear();
    _timeOutController.clear();
    _placeController.clear();
    Navigator.pop(context);
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
                DropdownButtonFormField<String>(
                  value: _selectedEmployee,
                  items: _employees.map((employee) {
                    return DropdownMenuItem(
                      value: employee,
                      child: Text(employee),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      _selectedEmployee = value;
                    });
                  },
                  decoration: const InputDecoration(
                    labelText: 'Select Employee',
                    border: OutlineInputBorder(),
                  ),
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
                TextFormField(
                  readOnly: true,
                  controller: _timeOutController,
                  onTap: () async {
                    TimeOfDay? pickedTime = await showTimePicker(
                      context: context,
                      initialTime: TimeOfDay.now(),
                    );
                    if (pickedTime != null) {
                      setState(() {
                        _timeOutController.text = pickedTime.format(context);
                      });
                    }
                  },
                  decoration: const InputDecoration(
                    labelText: 'Time Out',
                    border: OutlineInputBorder(),
                    suffixIcon: Icon(Icons.access_time),
                  ),
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _placeController,
                  decoration: const InputDecoration(
                    labelText: 'Place',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _addAttendance,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromARGB(255, 80, 160, 170),
                    ),
                    child: const Text('Add to Attendance',
                        style: TextStyle(color: Colors.white)),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const EmployeeViewAttendanceAppBar(),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: _showAddAttendanceModal,
                icon: const Icon(Icons.add, color: Colors.white),
                label: const Text('Add Attendance',
                    style: TextStyle(color: Colors.white)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromARGB(255, 80, 160, 170),
                ),
              ),
            ),
            const SizedBox(height: 24),
            // Title
            const Text(
              'Attended Employees',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Expanded(
              child: _attendedEmployees.isEmpty
                  ? const Center(
                      child: Text(
                        'No attendance records yet.',
                        style: TextStyle(fontSize: 16, color: Colors.grey),
                      ),
                    )
                  : ListView.separated(
                      itemCount: _attendedEmployees.length,
                      separatorBuilder: (_, __) => const Divider(),
                      itemBuilder: (context, index) {
                        return buildAttendedEmployeeTile(context, index);
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildAttendedEmployeeTile(BuildContext context, int index) {
    return Card(
      elevation: 3,
      margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 12),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        leading: const CircleAvatar(
          backgroundColor: Color.fromARGB(255, 80, 160, 170),
          child: Icon(Icons.person, color: Colors.white),
        ),
        title: Text(
          _attendedEmployees[index].employeeName,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
            color: Color.fromARGB(255, 27, 72, 78),
          ),
        ),
        subtitle: Text(
          'Time In: ${_attendedEmployees[index].timeIn} - Time Out: ${_attendedEmployees[index].timeOut}\nPlace: ${_attendedEmployees[index].place}',
          style: const TextStyle(fontSize: 14, color: Colors.grey),
        ),
        trailing: IconButton(
          icon: const Icon(Icons.remove_circle_outline, color: Colors.red),
          onPressed: () {
            setState(() {
              _attendedEmployees.removeAt(index);
            });
          },
        ),
      ),
    );
  }
}

class EmployeeViewAttendanceAppBar extends StatelessWidget
    implements PreferredSizeWidget {
  const EmployeeViewAttendanceAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: const Text('Employee View Attendance'),
      foregroundColor: Colors.white,
      backgroundColor: const Color.fromARGB(255, 80, 160, 170),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
