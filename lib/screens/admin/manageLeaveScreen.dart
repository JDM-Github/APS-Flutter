import 'package:first_project/handle_request.dart';
import 'package:first_project/screens/employee/requestLeave.dart';
import 'package:flutter/material.dart';

// AdminManageLeavesScreen
class AdminManageLeavesScreen extends StatefulWidget {
  const AdminManageLeavesScreen({super.key});

  @override
  State<AdminManageLeavesScreen> createState() => _AdminManageLeavesScreenState();
}

class _AdminManageLeavesScreenState extends State<AdminManageLeavesScreen> {
  List<dynamic> _leaveRequests = [];

  @override
  void initState() {
    super.initState();
      WidgetsBinding.instance.addPostFrameCallback((_) => init());
  }

  Future<void> init() async {
    RequestHandler requestHandler = RequestHandler();
    try {
      Map<String, dynamic> response = await requestHandler
          .handleRequest(context, 'projects/get-admin-all-leave-request', body: {});

      if (response['success'] == true) {
        setState(() {
          _leaveRequests = response['data'];
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
                          trailing: leave['accepted'] || leave['denied']
                              ? const Icon(Icons.check_circle, color: Colors.green)
                              : IconButton(
                                  icon: const Icon(Icons.info, color: Colors.blue),
                                  onPressed: () => _showLeaveDetails(context, leave, index),
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

  void _showLeaveDetails(BuildContext context, Map<String, dynamic> leave, int index) {
    if (leave['accepted'] || leave['denied']) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('This leave request is already ${leave['accepted'] ? "accepted" : "rejected"}.')),
      );
      return;
    }

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Leave Details for ${leave['User']['firstName']} ${leave['User']['lastName']}'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Leave Type: ${leave['leaveType']}'),
            const SizedBox(height: 8),
            Text(
                'Dates: ${DateTime.parse(leave['startDate']).toLocal().toString().split(' ')[0]} to ${DateTime.parse(leave['endDate']).toLocal().toString().split(' ')[0]}'),
            const SizedBox(height: 8),
            Text('Reason: ${leave['reason']}'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _updateLeaveStatus(index, 'Rejected');
            },
            child: const Text('Reject', style: TextStyle(color: Colors.red)),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _updateLeaveStatus(index, 'Accepted');
            },
            child: const Text('Accept', style: TextStyle(color: Colors.green)),
          ),
        ],
      ),
    );
  }

  void _updateLeaveStatus(int index, String status) async {
    if (_leaveRequests[index]['accepted'] || _leaveRequests[index]['denied']) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content:
                Text('This leave request is already ${_leaveRequests[index]['accepted'] ? "accepted" : "rejected"}.')),
      );
      return;
    }

    try {
      final response = await RequestHandler().handleRequest(
        context,
        'users/updateLeaveRequest',
        body: {
          'leaveId': _leaveRequests[index]['id'],
          'accepted': status == 'Accepted',
          'denied': status == 'Rejected',
        },
      );

      if (response['success'] == true) {
        setState(() {
          _leaveRequests[index]['accepted'] = status == 'Accepted';
          _leaveRequests[index]['denied'] = status == 'Rejected';
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Leave request has been $status.')),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to update leave request.')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('An error occurred: $e')),
      );
    }
  }
}
