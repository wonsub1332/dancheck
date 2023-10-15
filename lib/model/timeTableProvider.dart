import 'dart:convert';
import 'package:dancheck/model/model_timtTable.dart';
import 'package:http/http.dart'as http;

import 'api_adapter.dart';

class tableProvider{
  Uri uri = Uri.parse('http://18.217.3.173:8000/check/time/?format=json');

  Future<List<Timetable>> getTable() async {
    final response = await http.get(uri);
    if (response.statusCode == 200) {
      final data = json.decode(utf8.decode(response.bodyBytes)) as List<dynamic>;
      print ('getTable: '+data.toString());
      return data.map<Timetable>((json) => Timetable.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load post list');
    }
  }

}