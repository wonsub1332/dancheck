import 'dart:convert';
import 'model_user.dart';
import 'model_timtTable.dart';

List<User> parseUser(String reponseBody){
  final parsed= json.decode(reponseBody).cast<Map<String,dynamic>>();
  return parsed.map<User>((json)=> User.fromJson(json)).toList();
}

List<Timetable> parseTime(String reponseBody){
  final parsed= json.decode(reponseBody).cast<Map<String,dynamic>>();
  return parsed.map<Timetable>((json)=> Timetable.fromJson(json)).toList();
}

List<User> parseAtt(String reponseBody){
  final parsed= json.decode(reponseBody).cast<Map<String,dynamic>>();
  return parsed.map<User>((json)=> User.fromJson(json)).toList();
}
