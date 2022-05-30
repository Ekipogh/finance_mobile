import 'package:finance_mobile/models/expense.dart';
import 'package:finance_mobile/models/expenseCategory.dart';
import 'package:finance_mobile/models/monthlyReport.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'monthlyReportDetailsScreen.dart';

class MonthlyReportScreen extends StatefulWidget {
  final List<Expense> expenses;
  final List<ExpenseCategory> categories;

  MonthlyReportScreen({this.expenses, this.categories});

  @override
  State<StatefulWidget> createState() => _MonthlyReportScreenState();
}

class _MonthlyReportScreenState extends State<MonthlyReportScreen>
    with AutomaticKeepAliveClientMixin<MonthlyReportScreen> {
  DateTime _date;
  String _formattedDate;
  MonthlyReport _currentReport;
  List<MonthlyReport> reports;

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    _date = DateTime.now();
    reports = [];
    setFormattedDate();
    super.initState();
    MonthlyReport.get(_date).then((value) => _currentReport = value);
  }

  void setFormattedDate() {
    DateFormat formatter = DateFormat('MMMM yyyy');
    _formattedDate = formatter.format(_date);
  }

  void setCurrentReport() {
    for (MonthlyReport report in reports) {
      if (report.date.month == _date.month && report.date.year == _date.year) {
        _currentReport = report;
        return;
      }
    }
    _currentReport = null;
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            IconButton(
                onPressed: () {
                  setState(() {
                    _date = DateTime(_date.year, _date.month - 1);
                    setFormattedDate();
                    setCurrentReport();
                  });
                },
                icon: Icon(Icons.arrow_left)),
            SizedBox(
                width: 160,
                child: TextButton(
                    onPressed: () {}, child: Text("$_formattedDate"))),
            IconButton(
                onPressed: () {
                  setState(() {
                    _date = DateTime(_date.year, _date.month + 1);
                    setFormattedDate();
                    setCurrentReport();
                  });
                },
                icon: Icon(Icons.arrow_right)),
          ],
        ),
        if (_currentReport == null)
          Center(
            child: ElevatedButton(
              child: Text("Create the report"),
              onPressed: () async {
                DateTime nowDate = DateTime.now();
                bool answer = true;
                bool isDateAfter = _date.isAfter(nowDate) ||
                    (_date.month == nowDate.month &&
                        _date.year == nowDate.year);
                if (isDateAfter) {
                  await showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: Text("Are you sure"),
                          content: SingleChildScrollView(
                            child: ListBody(
                              children: [
                                Text("Selected month is now or in the future."),
                                Text("Are you sure you want to proceed?"),
                              ],
                            ),
                          ),
                          actions: [
                            TextButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                child: Text("OK")),
                            TextButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                  answer = false;
                                },
                                child: Text("Cancel")),
                          ],
                        );
                      });
                }
                setState(() {
                  if (answer) {
                    MonthlyReport report = MonthlyReport(
                        _date);
                    reports.add(report);
                    setCurrentReport();
                    setFormattedDate();
                  }
                });
              },
            ),
          )
        else
          MonthlyReportDetailsScreen(report: _currentReport)
      ],
    );
  }
}
