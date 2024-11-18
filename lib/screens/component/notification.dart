import 'package:flutter/material.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  @override
  _NotificationScreenState createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  final List<Map<String, dynamic>> notifications = [
    {
      'title': 'New Task Assigned',
      'message': 'You have been assigned a new task: Design the home screen.',
      'date': '2024-11-14',
      'read': false,
    },
    {
      'title': 'Meeting Reminder',
      'message': 'Your meeting with the project manager starts at 3 PM.',
      'date': '2024-11-14',
      'read': false,
    },
    {
      'title': 'Project Deadline',
      'message': 'The deadline for the project is next week.',
      'date': '2024-11-12',
      'read': true,
    },
  ];

  void _showNotificationDetails(Map<String, dynamic> notification) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(notification['title']),
          content: Text(notification['message']),
          actions: [
            TextButton(
              onPressed: () {
                setState(() {
                  notification['read'] = true;
                });
                Navigator.pop(context);
              },
              child: const Text('Mark as Read'),
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
        title: const Text('Notifications'),
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
              title: Text(notification['title']),
              subtitle: Text(notification['message']),
              trailing: Icon(
                notification['read']
                    ? Icons.check_circle
                    : Icons.radio_button_unchecked,
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
