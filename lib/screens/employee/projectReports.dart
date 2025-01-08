import 'package:first_project/handle_request.dart';
import 'package:flutter/material.dart';

class ProjectReportsPage extends StatefulWidget {
  final String projectId;
  const ProjectReportsPage(this.projectId, {super.key});

  @override
  State<ProjectReportsPage> createState() => _ProjectReportsPage();
}

class _ProjectReportsPage extends State<ProjectReportsPage> {
  dynamic projectReports = [];

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
        'projects/get-project-report',
        body: {"projectId": widget.projectId},
      );
      if (response['success'] == true) {
        setState(() {
          projectReports = response["reports"] ?? [];
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(response['message'] ?? 'Loading project reports error'),
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
        title: const Text('Project Reports'),
        backgroundColor: const Color.fromARGB(255, 80, 160, 170),
        foregroundColor: Colors.white,
      ),
      body: ListView.builder(
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
