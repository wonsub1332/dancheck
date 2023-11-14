import 'dart:convert';
import 'package:dancheck/model/model_attendance.dart';
import 'package:http/http.dart'as http;

import 'api_adapter.dart';

class attendanceProvider{
  Uri uri = Uri.parse('http://18.217.3.173:8000/check/attendance/?format=json');

  Future<List<Attendance>> getAtt() async {
    final response = await http.get(uri);
    if (response.statusCode == 200) {
      final data = json.decode(utf8.decode(response.bodyBytes)) as List<dynamic>;
      print ('getTable: '+data.toString());
      return data.map<Attendance>((json) => Attendance.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load post list');
    }
  }
  Future<String> postAtt(Attendance att) async {
    try {
      var response = await http.post(
        Uri.parse('http://18.217.3.173:8000/check/post/'),
        headers: <String, String>{
          'Content-Type': 'application/json',
          "Referer": "http://18.217.3.173:8000"
        },
        body: jsonEncode(att.toJSON()),
      );
      print(response.body);
      if (response.statusCode == 200)
        return response.body;
      throw Exception('데이터 수신 실패!');
    }finally{
      print("post error");
    }


  }

}
