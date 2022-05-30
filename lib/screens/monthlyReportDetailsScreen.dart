import 'package:finance_mobile/models/monthlyReport.dart';
import 'package:flutter/material.dart';


class MonthlyReportDetailsScreen extends StatelessWidget {
  final MonthlyReport report;

  MonthlyReportDetailsScreen({this.report});

  @override
  Widget build(BuildContext context) {
    return Table(
      children: [
        TableRow(children: [
          TableCell(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                "Category",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ),
          TableCell(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                "Total",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ),
          TableCell(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                "Previous Month",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ),
          TableCell(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                "Year round monthly average",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ]),
        for (var entry in report.data.entries)
          TableRow(children: [
            TableCell(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(entry.key.name),
              ),
            ),
            TableCell(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(entry.value[0].toString()),
              ),
            ),
            TableCell(
              child: Container(
                color: (entry.value[1] > 0)
                    ? Colors.deepOrangeAccent
                    : Colors.lightGreen,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    entry.value[1].toString(),
                  ),
                ),
              ),
            ),
            TableCell(
              child: Container(
                color: (entry.value[2] > 0)
                    ? Colors.deepOrangeAccent
                    : Colors.lightGreen,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    entry.value[2].toString(),
                  ),
                ),
              ),
            )
          ])
      ],
    );
  }
}