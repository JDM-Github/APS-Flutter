import 'package:flutter/material.dart';

class EmployeeSchedule extends StatelessWidget {
  const EmployeeSchedule({super.key});

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
                  'Employee Schedule',
                  style: TextStyle(
                    fontSize: 18,
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
                    child: DataTable(
                      headingRowHeight: 30,
                      headingTextStyle: const TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Color.fromARGB(255, 80, 160, 170),
                      ),
                      dataTextStyle: const TextStyle(fontSize: 14),
                      headingRowColor: WidgetStateProperty.all(
                        const Color.fromARGB(255, 80, 160, 170)
                            .withOpacity(0.1),
                      ),
                      columnSpacing: 0,
                      columns: [
                        DataColumn(
                          label: SizedBox(
                            width: MediaQuery.of(context).size.width * 0.1,
                            child: const Center(child: Text('Date')),
                          ),
                        ),
                        DataColumn(
                          label: SizedBox(
                            width: MediaQuery.of(context).size.width * 0.1,
                            child: const Center(child: Text('From')),
                          ),
                        ),
                        DataColumn(
                          label: SizedBox(
                            width: MediaQuery.of(context).size.width * 0.1,
                            child: const Center(child: Text('To')),
                          ),
                        ),
                        DataColumn(
                          label: SizedBox(
                            width: MediaQuery.of(context).size.width * 0.2,
                            child: const Center(child: Text('Description')),
                          ),
                        ),
                      ],
                      rows: [
                        DataRow(
                          cells: [
                            DataCell(SizedBox(
                                width: MediaQuery.of(context).size.width * 0.2,
                                child: const Text('06/16/2004'))),
                            DataCell(SizedBox(
                                width: MediaQuery.of(context).size.width * 0.2,
                                child: const Text('8:00AM'))),
                            DataCell(SizedBox(
                                width: MediaQuery.of(context).size.width * 0.2,
                                child: const Text('9:00AM'))),
                            DataCell(
                              SizedBox(
                                width: MediaQuery.of(context).size.width * 0.20,
                                child: ElevatedButton(
                                  onPressed: () {
                                    showDescriptionDialog(
                                        context, "This is the description text. Pass your description here.");
                                  },
                                  style: ElevatedButton.styleFrom(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 10),
                                    backgroundColor:
                                        const Color.fromARGB(255, 80, 160, 170),
                                  ),
                                  child: const Text(
                                    'VIEW',
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
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

  void showDescriptionDialog(BuildContext context, String description) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Description"),
          content: Text(description),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: const Text("Close"),
            ),
          ],
        );
      },
    );
  }


}
