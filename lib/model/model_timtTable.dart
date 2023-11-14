import 'dart:convert';

class Timetable {
  int subjno; // 과목코드
  String subjnm; // 과목명
  String pronm; //교수님 이름
  List<String> day; // 수업 요일
  List<String> start_t; // 수업 시간
  List<String> end_t; // 수업 시간
  String clsroom; // 강의실
  String beaconid;
  List<String> att_t; // 수업 시간
  List<String> out_t;

  Timetable({required this.subjno,required this.subjnm,required this.pronm, required this.day, required this.start_t, required this.clsroom,required this.beaconid,required this.end_t,required this.att_t, required this.out_t });

  Timetable.fromMap(Map<String, dynamic> map)
      :
        subjno = map['subjno'],
        subjnm = map['subjnm'],
        pronm = map['pronm'],
        day = map['day'].split(','),
        start_t = map['start_t'].split(','),
        clsroom = map['clsroom'],
        beaconid = map['beaconid'],
        end_t = map['end_t'].split(','),
        att_t=  map['att_t'].split(','),
        out_t= map['out_t'].split(',');

  Timetable.fromJson(Map<String, dynamic> json):
        subjno = json['subjno'],
        subjnm = json['subjnm'],
        pronm = json['pronm'],
        day = json['day'].split(','),
        start_t = json['start_t'].split(','),
        clsroom = json['clsroom'],
        beaconid = json['beaconid'],
        end_t = json['end_t'].split(','),
        att_t=  json['att_t'].split(','),
        out_t= json['out_t'].split(',');


  Map<String, dynamic> toMap() {
    var map= <String,dynamic>{
      'subjnm': subjnm,
      'pronm' :pronm,
      'day' :day,
      'start_t' : start_t,
      'clsroom' : clsroom,
      'beaconid' : beaconid,
      'end_t':end_t,
      'att_t':att_t,
      'out_t':out_t,
    };
    if (subjno != null) {
      map['subjno'] = subjno;
    }

    return map;
  }
}