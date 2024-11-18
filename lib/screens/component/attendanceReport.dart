import 'package:flutter/material.dart';

class AttendanceReportTable extends StatelessWidget {
  const AttendanceReportTable({super.key});

  @override
  Widget build(BuildContext context) {
    return Expanded(
        child: Padding(
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
                  'Attendance Report',
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
                      headingRowHeight: 40,
                      headingTextStyle: const TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Color.fromARGB(255, 80, 160, 170),
                      ),
                      dataTextStyle: const TextStyle(fontSize: 14),
                      headingRowColor: WidgetStateProperty.all(
                        const Color.fromARGB(255, 80, 160, 170)
                            .withOpacity(0.1),
                      ),
                      columnSpacing: 20,
                      columns: [
                        DataColumn(
                            label: SizedBox(
                          width: MediaQuery.of(context).size.width * 0.25,
                          child: const SizedBox(child: Text('NAME')),
                        )),
                        DataColumn(
                            label: SizedBox(
                          width: MediaQuery.of(context).size.width * 0.11,
                          child: const SizedBox(child: Text('PRESENT')),
                        )),
                        DataColumn(
                            label: SizedBox(
                          width: MediaQuery.of(context).size.width * 0.11,
                          child: const SizedBox(child: Text('ABSENT')),
                        )),
                        DataColumn(
                            label: SizedBox(
                          width: MediaQuery.of(context).size.width * 0.11,
                          child: const SizedBox(child: Text('LEAVE')),
                        )),
                      ],
                      rows: [
                        DataRow(
                          cells: [
                            DataCell(SizedBox(
                                width: MediaQuery.of(context).size.width * 0.25,
                                child: const Text('John Dave Pega'))),
                            DataCell(SizedBox(
                                width: MediaQuery.of(context).size.width * 0.15,
                                child: const Text('23'))),
                            DataCell(SizedBox(
                                width: MediaQuery.of(context).size.width * 0.15,
                                child: const Text('23'))),
                            DataCell(SizedBox(
                                width: MediaQuery.of(context).size.width * 0.15,
                                child: const Text('12'))),
                          ],
                        ),
                        // Add more rows as needed
                      ],
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    ));
  }
}
