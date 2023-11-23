import 'dart:convert';

class Attendance {
  int subjno; // 과목코드
  int stuno; // 학생번호
  String classday; //출석일
  String atime; // 도착시간
  String rtime; // 퇴실시간
  int check; // 출석 여부


  Attendance({required this.subjno,required this.stuno, required this.classday,required this.atime, required this.rtime, required this.check });

  Attendance.fromMap(Map<String, dynamic> map)
      :
        subjno = map['subjno'],
        stuno = map['stuno'],
        classday = map['classday'],
        atime = map['atime'],
        rtime = map['rtime'],
        check= map['attendance_check'];

  Attendance.fromJson(Map<String, dynamic> json):
        subjno = json['subjno'],
        stuno = json['stuno'],
        classday = json['classday'],
        atime = json['atime'],
        rtime = json['rtime'],
        check= json['attendance_check'];


  Map<String, dynamic> toMap() {
    var map= <String,dynamic>{
      'stuno': stuno,
      'classday' : classday,
      'atime' : atime,
      'rtime' : rtime,
      'attendance_check' : check
    };
    if (subjno != null) {
      map['subjno'] = subjno;
    }

    return map;
  }
  Map<String, dynamic> toJSON() {
    var json= <String,dynamic>{
      'stuno': stuno,
      'classday' : classday,
      'atime' : atime,
      'rtime' : rtime,
      'attendance_check' : check
    };
    if (subjno != null) {
      json['subjno'] = subjno;
    }

    return json;
  }
}