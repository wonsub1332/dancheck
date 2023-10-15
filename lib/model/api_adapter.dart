import 'dart:convert';
import 'model_user.dart';

List<User> parseUser(String reponseBody){
  final parsed= json.decode(reponseBody).cast<Map<String,dynamic>>();
  return parsed.map<User>((json)=> User.fromJson(json)).toList();
}

List<User> parseTime(String reponseBody){
  final parsed= json.decode(reponseBody).cast<Map<String,dynamic>>();
  return parsed.map<User>((json)=> User.fromJson(json)).toList();
}