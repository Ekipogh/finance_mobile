import 'package:csv/csv.dart';
import 'package:file_picker_cross/file_picker_cross.dart';
import 'package:flutter/material.dart';

class ImportScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: ElevatedButton(
          child: Text("Pick CSV file"),
          onPressed: () async {
            final FilePickerCross pickerCross =
                await FilePickerCross.importFromStorage(fileExtension: "csv");
            if (pickerCross != null) {
              List<List<dynamic>> rows =
                  const CsvToListConverter().convert(pickerCross.toString());
              for (var row in rows) {
                List<String> dateParsed = row[0].split(".");
                DateTime date = DateTime(num.tryParse(dateParsed[2]),
                    num.tryParse(dateParsed[1]), num.tryParse(dateParsed[0]));
                double amount = row[1];
                String categoryName = row[2];
              }
            }
          },
        ),
      ),
    );
  }
}
