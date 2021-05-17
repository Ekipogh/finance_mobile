import 'package:flutter/material.dart';

void main() {
  runApp(FinanceApp());
}

class FinanceApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primaryColor: Colors.blue[300],
      ),
      home: Scaffold(
        appBar: AppBar(
          title: Text("Finance"),
        ),
        body: ListView(
          children: [
            _expenseTile("17.06.2021", "Groceries", "300 R"),
            _expenseTile("18.06.2021", "Taxi", "500 R"),
            _expenseTile("19.06.2021", "Drinks", "600 R"),
          ],
        ),
      ),
    );
  }

  Widget _expenseTile(String date, String category, String amount) {
    return ListTile(
      leading: Text(amount),
      title: Text(category),
      subtitle: Text(date),
      trailing: Icon(Icons.more_vert),
    );
  }
}
