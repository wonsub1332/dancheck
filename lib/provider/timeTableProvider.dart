import 'dart:convert';
import 'package:dancheck/model/model_timtTable.dart';
import 'package:http/http.dart'as http;

import '../model/api_adapter.dart';

class tableProvider{
  Uri uri = Uri.parse('http://18.217.3.173:8000/check/time/?format=json');

  Future<Set<Timetable>> getTable() async {
    final response = await http.get(uri);
    if (response.statusCode == 200) {
      final data = json.decode(utf8.decode(response.bodyBytes)) as List<dynamic>;
      print ('getTable: '+data.toString());
      return data.map<Timetable>((json) => Timetable.fromJson(json)).toSet();
    } else {
      throw Exception('Failed to load post list');
    }
  }

  Future<Set<Timetable>> getTableID(id) async {
    print("ID = $id");
    Uri uri = Uri.parse('http://18.217.3.173:8000/check/enroll/'+id+'/?format=json');
    final response = await http.get(uri);
    if (response.statusCode == 200) {
      final data = json.decode(utf8.decode(response.bodyBytes)) as List<dynamic>;
      print ('getTable: '+data.toString());
      return data.map<Timetable>((json) => Timetable.fromJson(json)).toSet();
    } else {
      throw Exception('Failed to load post list');
    }
  }

}
