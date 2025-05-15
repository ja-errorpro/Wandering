import 'package:csv/csv.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'place_model.dart';

class CSVFileReader {
  final String filePath =
      'assets/csv/Taipei Main Station_attractions_1000.csv_completion.csv';

  List<List<dynamic>> data = [];
  List<PlaceModel> places = [];

  Future<void> loadCSV() async {
    final String csvString = await rootBundle.loadString(
      'assets/csv/Taipei Main Station_attractions_1000.csv_completion.csv',
    );
    List<List<dynamic>> rowsAsListOfValues = const CsvToListConverter().convert(
      csvString,
    );
    data = rowsAsListOfValues;
  }

  void convertToPlaceModel() {
    for (int i = 1; i < data.length; i++) {
      final row = data[i];
      final place = PlaceModel(
        id: row[0].toString(),
        name: row[1].toString(),
        description: row[2].toString(),
        // categories format: "['1', '2', '3']"
        categories: row[7]
            .toString()
            .replaceAll(RegExp(r"[\[\]']"), '')
            .split(','),
      );
      places.add(place);
    }
  }

  Future<List<PlaceModel>> loadAndConvert() async {
    await loadCSV();
    convertToPlaceModel();
    return places;
  }
}
