import 'package:first_project/handle_request.dart';
import 'package:flutter/material.dart';

class NotificationScreen extends StatefulWidget {
  final dynamic users;
  const NotificationScreen(this.users, {super.key});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  // final List<Map<String, dynamic>> notifications = [
  //   {
  //     'title': 'New Task Assigned',
  //     'message': 'You have been assigned a new task: Design the home screen.',
  //     'date': '2024-11-14',
  //     'read': false,
  //   },
  //   {
  //     'title': 'Meeting Reminder',
  //     'message': 'Your meeting with the project manager starts at 3 PM.',
  //     'date': '2024-11-14',
  //     'read': false,
  //   },
  //   {
  //     'title': 'Project Deadline',
  //     'message': 'The deadline for the project is next week.',
  //     'date': '2024-11-12',
  //     'read': true,
  //   },
  // ];

  List<dynamic> notifications = [];

  @override
  void initState() {
    super.initState();
    if (widget.users != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) => init());
    }
  }

  Future<void> init() async {
    RequestHandler requestHandler = RequestHandler();
    try {
      Map<String, dynamic> response = await requestHandler.handleRequest(
        context,
        'users/getAllNotification',
        body: {"userId": widget.users['id']},
      );
      if (response['success'] == true) {
        setState(() => notifications = response['notifications']);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(response['message'] ?? 'Loading schedules error'),
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('An error occurred: $e')),
      );
    }
  }

  void _showNotificationDetails(Map<String, dynamic> notification) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            notification['title'],
            style: const TextStyle(fontSize: 14),
          ),
          content: Text(
            notification['message'],
            style: const TextStyle(fontSize: 12),
          ),
          actions: [
            TextButton(
              onPressed: () {
                setState(() {
                  notification['read'] = true;
                });
                Navigator.pop(context);
              },
              child: const Text(
                'Mark as Read',
                style: TextStyle(fontSize: 12),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Notifications',
          style: TextStyle(fontSize: 16), // Smaller font size
        ),
        backgroundColor: const Color.fromARGB(255, 80, 160, 170),
        foregroundColor: Colors.white,
      ),
      body: ListView.builder(
        itemCount: notifications.length,
        itemBuilder: (context, index) {
          final notification = notifications[index];
          return Card(
            margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
            elevation: 4,
            child: ListTile(
              onTap: () => _showNotificationDetails(notification),
              title: Text(
                notification['title'],
                style: const TextStyle(
                  fontSize: 14, // Smaller font size
                  fontWeight: FontWeight.w600,
                ),
              ),
              subtitle: Text(
                notification['message'],
                style: const TextStyle(fontSize: 12), // Smaller font size
              ),
              trailing: Icon(
                notification['read'] ? Icons.check_circle : Icons.radio_button_unchecked,
                color: notification['read'] ? Colors.green : Colors.blue,
              ),
              tileColor: notification['read']
                  ? const Color.fromARGB(255, 255, 255, 255)
                  : const Color.fromARGB(255, 223, 254, 255),
            ),
          );
        },
      ),
    );
  }
}
