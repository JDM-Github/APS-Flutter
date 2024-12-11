import 'package:first_project/handle_request.dart';
import 'package:first_project/screens/component/viewProject.dart';
import 'package:flutter/material.dart';

// class ManageProjectTable extends StatelessWidget {
//   const ManageProjectTable({super.key});

class ManageProjectTable extends StatefulWidget {
  final String selectedFilter;
  const ManageProjectTable(this.selectedFilter, {super.key});

  @override
  State<ManageProjectTable> createState() => _ManageProjectTableState();
}

class _ManageProjectTableState extends State<ManageProjectTable> {
  List<dynamic> projects = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => init());
  }

  @override
  void didUpdateWidget(covariant ManageProjectTable oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.selectedFilter != widget.selectedFilter) {
      WidgetsBinding.instance.addPostFrameCallback((_) => init());
    }
  }

  Future<void> init() async {
    RequestHandler requestHandler = RequestHandler();
    try {
      Map<String, dynamic> response = await requestHandler.handleRequest(
        context,
        'projects/get-all-projects',
        body: {"filter": widget.selectedFilter},
      );
      setState(() {
        isLoading = false;
      });
      if (response['success'] == true) {
        setAllProjects(response['projects']);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(response['message'] ?? 'Loading projects error'),
          ),
        );
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('An error occurred: $e')),
      );
    }
  }

  void setAllProjects(List<dynamic> projects) {
    setState(() {
      this.projects = projects;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 0.0, vertical: 10.0),
      child: Card(
        elevation: 5,
        color: Colors.white,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(vertical: 10),
              decoration: const BoxDecoration(
                color: Color.fromARGB(255, 80, 160, 170),
                borderRadius: BorderRadius.vertical(top: Radius.circular(12.0)),
              ),
              child: const Center(
                child: Text(
                  'All Projects',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            LayoutBuilder(
              builder: (context, constraints) {
                return SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: SizedBox(
                    width: constraints.maxWidth,
                    child: isLoading
                        ? const Center(child: Text("Loading all projects"))
                        : projects.isEmpty
                            ? const Center(child: Text("There are no projects"))
                            : DataTable(
                                headingRowHeight: 30,
                                headingTextStyle: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Color.fromARGB(255, 80, 160, 170),
                                ),
                                dataTextStyle: const TextStyle(fontSize: 12),
                                headingRowColor: WidgetStateProperty.all(
                                  const Color.fromARGB(255, 80, 160, 170).withOpacity(0.1),
                                ),
                                columns: [
                                  DataColumn(
                                    label: SizedBox(
                                      width: MediaQuery.of(context).size.width * 0.30,
                                      child: const Center(child: Text('Project Name')),
                                    ),
                                  ),
                                  DataColumn(
                                    label: SizedBox(
                                      width: MediaQuery.of(context).size.width * 0.35,
                                      child: const Center(child: Text('Action')),
                                    ),
                                  ),
                                ],
                                rows: projects.map<DataRow>((project) {
                                  return DataRow(
                                    cells: [
                                      DataCell(SizedBox(
                                          width: MediaQuery.of(context).size.width * 0.25,
                                          child: Text(project['projectName']))),
                                      DataCell(
                                        SizedBox(
                                            width: MediaQuery.of(context).size.width * 0.4,
                                            child: ElevatedButton(
                                              onPressed: () {
                                                Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                        builder: (builder) => ProjectDetailsScreen(project: project)));
                                              },
                                              style: ElevatedButton.styleFrom(
                                                padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 10),
                                                backgroundColor: const Color.fromARGB(255, 80, 160, 170),
                                              ),
                                              child: const Text(
                                                'View',
                                                style: TextStyle(color: Colors.white),
                                              ),
                                            )),
                                      ),
                                    ],
                                  );
                                }).toList(),
                              ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
