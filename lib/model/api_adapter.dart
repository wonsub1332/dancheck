import 'dart:convert';
import 'model_Students.dart';
import 'model_timtTable.dart';

List<Students> parseUser(String reponseBody){
  final parsed= json.decode(reponseBody).cast<Map<String,dynamic>>();
  return parsed.map<Students>((json)=> Students.fromJson(json)).toList();
}

List<Timetable> parseTime(String reponseBody){
  final parsed= json.decode(reponseBody).cast<Map<String,dynamic>>();
  return parsed.map<Timetable>((json)=> Timetable.fromJson(json)).toList();
}

List<Students> parseAtt(String reponseBody){
  final parsed= json.decode(reponseBody).cast<Map<String,dynamic>>();
  return parsed.map<Students>((json)=> Students.fromJson(json)).toList();
}
