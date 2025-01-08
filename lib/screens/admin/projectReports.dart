import 'package:first_project/handle_request.dart';
import 'package:first_project/screens/admin/attendanceReport.dart';
import 'package:flutter/material.dart';

class ProjectReportsPage extends StatefulWidget {
  const ProjectReportsPage({super.key});

  @override
  State<ProjectReportsPage> createState() => _ProjectReportsPage();
}

class _ProjectReportsPage extends State<ProjectReportsPage> {
  String? selectedProjectId;
  String selectedFilter = "Active";
  dynamic projectReports = [];
  dynamic projects = [];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => init());
  }

  Future<void> setAllProjects(dynamic projects) async {
    setState(() {
      this.projects = projects;
    });
  }

  Future<void> init() async {
    setState(() {
      projectReports = [];
      projects = [];
    });
    
    RequestHandler requestHandler = RequestHandler();
    try {
      Map<String, dynamic> response = await requestHandler.handleRequest(
        context,
        'projects/get-all-projects-projects',
        body: {"projectId": selectedProjectId, "status": selectedFilter},
      );
      if (response['success'] == true) {
        setState(() {
          projectReports = response["reports"] ?? [];
          projects = response['projects'] ?? [];
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

  Future<void> onProjectChanged(String projectId) async {
    setState(() {
      selectedProjectId = projectId;
    });
    init();
  }

  void _updateFilter(String filter) {
    setState(() {
      selectedFilter = filter;
    });
    init();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Project Reports'),
        backgroundColor: const Color.fromARGB(255, 80, 160, 170),
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ProjectDropdown(projects, onProjectChanged: onProjectChanged),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
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
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.all(8.0),
                itemCount: projectReports.length,
                itemBuilder: (context, index) {
                  final report = projectReports[index];
                  return Card(
                    elevation: 6,
                    margin: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 12.0),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16.0),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          decoration: const BoxDecoration(
                            color: Color.fromARGB(255, 80, 160, 170),
                            borderRadius: BorderRadius.vertical(top: Radius.circular(16.0)),
                          ),
                          padding: const EdgeInsets.all(12.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                report['titleReport'] ?? 'Unnamed Project',
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                              Text(
                                report['createdAt'] ?? '',
                                style: const TextStyle(
                                  fontSize: 14,
                                  color: Colors.white70,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                report['description'] ?? 'No Description Available',
                                style: const TextStyle(
                                  fontSize: 14,
                                  color: Colors.black87,
                                ),
                              ),
                              const SizedBox(height: 12),
                              if (report['uploadedPicture'] != null && report['uploadedPicture'].isNotEmpty)
                                GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => FullscreenImageView(
                                          imageUrl: report['uploadedPicture'],
                                        ),
                                      ),
                                    );
                                  },
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(12.0),
                                    child: Image.network(
                                      report['uploadedPicture'],
                                      fit: BoxFit.cover,
                                      height: 200,
                                      width: double.infinity,
                                    ),
                                  ),
                                )
                              else
                                const Text(
                                  'No Image Available',
                                  style: TextStyle(color: Colors.grey),
                                ),
                            ],
                          ),
                        ),
                      ],
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

class FullscreenImageView extends StatelessWidget {
  final String imageUrl;

  const FullscreenImageView({required this.imageUrl, super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
      ),
      body: Center(
        child: Hero(
          tag: imageUrl,
          child: InteractiveViewer(
            child: Image.network(
              imageUrl,
              fit: BoxFit.contain,
            ),
          ),
        ),
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
