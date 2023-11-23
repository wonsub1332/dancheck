import 'dart:convert';
import 'package:dancheck/model/model_timtTable.dart';
import 'package:http/http.dart'as http;

import '../model/api_adapter.dart';
import '../model/model_enroll.dart';

class enrollProvider{
  Uri uri = Uri.parse('http://18.217.3.173:8000/check/time/?format=json');

  Future<Set<Timetable>> getEnroll(id) async {
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
 Future<int> delEnroll(id) async {
    print("ID = $id");
    Uri uri = Uri.parse('http://18.217.3.173:8000/check/enroll/del/$id/');
    final response = await http.get(uri);
    if (response.statusCode == 200) {
      print(response);
      return 1;
    } else {
      throw Exception('Failed to load post list');
    }
  }
  Future<String> updateEnroll(id,tt) async {
    List<Map<String, dynamic>> list=[];
    for (Timetable i in tt){
      list.add(Enroll(stuno: int.parse(id), subjno: i.subjno).toJSON());
    }

    try {
      var response = await http.post(
        Uri.parse('http://18.217.3.173:8000/check/enroll/update/'),
        headers: <String, String>{
          'Content-Type': 'application/json',
          "Referer": "http://18.217.3.173:8000"
        },
        body: jsonEncode(list),
      );
      print(response.body);
      if (response.statusCode == 201)
        return response.body;
      throw Exception('데이터 수신 실패!');
    }finally{
      print("post error");
    }
  }

}
