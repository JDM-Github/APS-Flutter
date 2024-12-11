import 'package:first_project/handle_request.dart';
import 'package:first_project/screens/employee/requestLeave.dart';
import 'package:flutter/material.dart';

// ManageLeavesScreen
class ManageLeavesScreen extends StatefulWidget {
  final dynamic users;
  const ManageLeavesScreen(this.users, {super.key});

  @override
  State<ManageLeavesScreen> createState() => _ManageLeavesScreenState();
}

class _ManageLeavesScreenState extends State<ManageLeavesScreen> {
  TextEditingController startDate = new TextEditingController();
  final List<String> _employees = ['John Doe', 'Jane Smith', 'Michael Johnson', 'Emily Davis'];

  final List<String> _leaveTypes = ['Sick Leave', 'Casual Leave', 'Annual Leave'];
  List<dynamic> _leaveRequests = [];

  String selectedProjectId = "";

  @override
  void initState() {
    super.initState();
    if (widget.users['projectId'] != null) {
      selectedProjectId = widget.users['projectId'];
      WidgetsBinding.instance.addPostFrameCallback((_) => init());
    }
  }

  Future<void> init() async {
    RequestHandler requestHandler = RequestHandler();
    try {
      Map<String, dynamic> response = await requestHandler
          .handleRequest(context, 'projects/get-all-leave-request', body: {"projectId": selectedProjectId});

      if (response['success'] == true) {
        setState(() {
          _leaveRequests = response['data'];
          print(response['data']);
        });
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

  String? _selectedEmployee;
  String? _selectedLeaveType;

  final TextEditingController _startDateController = TextEditingController();
  final TextEditingController _endDateController = TextEditingController();

  @override
  void dispose() {
    _startDateController.dispose();
    _endDateController.dispose();
    super.dispose();
  }

  Future<void> _pickDate(BuildContext context, TextEditingController controller) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      controller.text = '${picked.toLocal()}'.split(' ')[0];
    }
  }

  void _addLeaveRequest() {
    if (_selectedEmployee != null &&
        _selectedLeaveType != null &&
        _startDateController.text.isNotEmpty &&
        _endDateController.text.isNotEmpty) {
      setState(() {
        _leaveRequests.add({
          'employee': _selectedEmployee,
          'leaveType': _selectedLeaveType,
          'startDate': _startDateController.text,
          'endDate': _endDateController.text,
        });
      });
    }
    Navigator.pop(context);
  }

  void _showAddLeaveModal() {
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
                  'Add Leave Request',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),
                DropdownButtonFormField<String>(
                  value: _selectedEmployee,
                  items: _employees
                      .map((employee) => DropdownMenuItem(
                            value: employee,
                            child: Text(employee),
                          ))
                      .toList(),
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
                DropdownButtonFormField<String>(
                  value: _selectedLeaveType,
                  items: _leaveTypes
                      .map((leaveType) => DropdownMenuItem(
                            value: leaveType,
                            child: Text(leaveType),
                          ))
                      .toList(),
                  onChanged: (value) {
                    setState(() {
                      _selectedLeaveType = value;
                    });
                  },
                  decoration: const InputDecoration(
                    labelText: 'Select Leave Type',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _startDateController,
                  readOnly: true,
                  decoration: const InputDecoration(
                    labelText: 'Select Start Date',
                    border: OutlineInputBorder(),
                    suffixIcon: Icon(Icons.calendar_today),
                  ),
                  onTap: () => _pickDate(context, _startDateController),
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _endDateController,
                  readOnly: true,
                  decoration: const InputDecoration(
                    labelText: 'Select End Date',
                    border: OutlineInputBorder(),
                    suffixIcon: Icon(Icons.calendar_today),
                  ),
                  onTap: () => _pickDate(context, _endDateController),
                ),
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _addLeaveRequest,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromARGB(255, 80, 160, 170),
                    ),
                    child: const Text('Add Leave Request', style: TextStyle(color: Colors.white)),
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
      appBar: AppBar(
        title: const Text(
          'Manage Leaves',
          style: TextStyle(fontSize: 16),
        ),
        backgroundColor: const Color.fromARGB(255, 80, 160, 170),
        foregroundColor: Colors.white,
        actions: [
          IconButton(
              icon: const Icon(Icons.list_alt),
              onPressed: () =>
                  {Navigator.push(context, MaterialPageRoute(builder: (builder) => const LeaveRequestsScreen()))},
              tooltip: 'View Leave Requests'),
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: _showAddLeaveModal,
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Leave Requests',
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: _leaveRequests.isEmpty
                  ? const Center(
                      child: Text(
                        'No leave requests yet.',
                        style: TextStyle(color: Colors.grey),
                      ),
                    )
                  : ListView.separated(
                      itemCount: _leaveRequests.length,
                      separatorBuilder: (_, __) => const Divider(),
                      itemBuilder: (context, index) {
                        final leave = _leaveRequests[index];
                        return ListTile(
                          leading: const Icon(Icons.person),
                          title: Text(leave['User']['firstName'] +
                              " " +
                              leave['User']['middleName'] +
                              " " +
                              leave['User']['lastName']),
                          subtitle: Text(
                            '${leave['leaveType']} - '
                            '${DateTime.parse(leave['startDate']).toLocal().toString().split(' ')[0]} to '
                            '${DateTime.parse(leave['endDate']).toLocal().toString().split(' ')[0]}',
                          ),
                          trailing: IconButton(
                            icon: const Icon(Icons.delete, color: Colors.red),
                            onPressed: () {
                              setState(() {
                                _leaveRequests.removeAt(index);
                              });
                            },
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
