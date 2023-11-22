import 'dart:convert';
import 'package:dancheck/model/model_Students.dart';
import 'package:http/http.dart'as http;

import 'api_adapter.dart';

class stuProvider{
  Uri uri = Uri.parse('http://18.217.3.173:8000/check/user/?format=json');

  Future<List<Students>> getUser() async {
    final response = await http.get(uri);
    if (response.statusCode == 200) {
      final data = json.decode(utf8.decode(response.bodyBytes)) as List<dynamic>;
      print ('getUser: '+data.toString());
      return data.map<Students>((json) => Students.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load post list');
    }
  }

}