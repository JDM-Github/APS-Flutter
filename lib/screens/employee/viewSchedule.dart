import 'package:flutter/material.dart';

class ViewScheduleScreen extends StatefulWidget {
  const ViewScheduleScreen({super.key});

  @override
  _ViewScheduleScreenState createState() => _ViewScheduleScreenState();
}

class _ViewScheduleScreenState extends State<ViewScheduleScreen> {
  final List<Map<String, String>> schedules = [
    {
      'task': 'Task 1',
      'date': '2024-11-10',
      'start': '09:00 AM',
      'end': '12:00 PM',
    },
    {
      'task': 'Task 2',
      'date': '2024-11-12',
      'start': '01:00 PM',
      'end': '03:00 PM',
    },
    {
      'task': 'Task 3',
      'date': '2024-11-15',
      'start': '10:00 AM',
      'end': '01:00 PM',
    },
  ];

  String filterStatus = 'All'; // Default filter is "All"

  @override
  Widget build(BuildContext context) {
    List<Map<String, String>> filteredSchedules = schedules.where((schedule) {
      final endDate = DateTime.parse(schedule['date']!);
      final currentDate = DateTime.now();
      final isFinished = currentDate.isAfter(endDate);

      if (filterStatus == 'All') {
        return true;
      } else if (filterStatus == 'Completed' && isFinished) {
        return true;
      } else if (filterStatus == 'Pending' && !isFinished) {
        return true;
      }
      return false;
    }).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'My Schedule',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: const Color.fromARGB(255, 80, 160, 170),
        iconTheme: const IconThemeData(color: Colors.white),
        actions: [
          PopupMenuButton<String>(
            onSelected: (value) {
              setState(() {
                filterStatus = value;
              });
            },
            itemBuilder: (BuildContext context) {
              return ['All', 'Pending', 'Completed'].map((status) {
                return PopupMenuItem<String>(
                  value: status,
                  child: Text(status),
                );
              }).toList();
            },
            icon: const Icon(Icons.filter_list, color: Colors.white),
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: filteredSchedules.length,
        itemBuilder: (context, index) {
          final schedule = filteredSchedules[index];
          final endDate = DateTime.parse(schedule['date']!);
          final currentDate = DateTime.now();
          final isFinished = currentDate.isAfter(endDate);

          // Alternate colors for each schedule
          bool isEven = index % 2 == 0;

          return Container(
            color: isEven
                ? Colors.grey.shade100
                : Colors.white, // Alternating colors
            child: Column(
              children: [
                ListTile(
                  title: Text(schedule['task']!),
                  subtitle: Text(schedule['date']!),
                  trailing: Icon(
                    isFinished ? Icons.check_circle : Icons.pending,
                    color: isFinished ? Colors.green : Colors.orange,
                  ),
                  onTap: () {
                    _showScheduleDetails(context, schedule, isFinished);
                  },
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  void _showScheduleDetails(
      BuildContext context, Map<String, String> schedule, bool isFinished) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (BuildContext context) {
        return Container(
          padding: const EdgeInsets.all(16),
          width: double.infinity, // Full width
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Schedule Details',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              Text('Task: ${schedule['task']}'),
              Text('Date: ${schedule['date']}'),
              Text('Start Time: ${schedule['start']}'),
              Text('End Time: ${schedule['end']}'),
              const SizedBox(height: 16),

              // Status message based on completion
              if (isFinished)
                const Text(
                  'This schedule has been completed.',
                  style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.green),
                )
              else
                const Text(
                  'This schedule is still pending.',
                  style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.orange),
                ),
              const SizedBox(height: 16),

              // Action Button
              // ElevatedButton(
              //   onPressed: () {
              //     Navigator.pop(context);
              //     ScaffoldMessenger.of(context).showSnackBar(
              //       SnackBar(
              //           content: Text(isFinished
              //               ? 'Schedule Completed'
              //               : 'Schedule Accepted'))),
              //     );
              //   },
              //   style: ElevatedButton.styleFrom(
              //     backgroundColor: isFinished ? Colors.green : Colors.blue,
              //     padding: const EdgeInsets.symmetric(vertical: 12),
              //     shape: RoundedRectangleBorder(
              //       borderRadius: BorderRadius.circular(12),
              //     ),
              //   ),
              //   child: Text(isFinished ? 'Completed' : 'Accept Schedule'),
              // ),
            ],
          ),
        );
      },
    );
  }
}
