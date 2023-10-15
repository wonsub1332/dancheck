class Timetable {
  int subjno; // 과목코드
  String subjnm; // 과목명
  String pronm; //교수님 이름
  String day; // 수업 요일
  String time; // 수업 시간
  String clsroom; // 강의실

  Timetable({required this.subjno,required this.subjnm,required this.pronm, required this.day, required this.time, required this.clsroom });

  Timetable.fromMap(Map<String, dynamic> map)
      :
        subjno = map['subjno'],
        subjnm = map['subjnm'],
        pronm = map['pronm'],
        day = map['day'],
        time = map['time'],
        clsroom = map['clsroom'];

  Timetable.fromJson(Map<String, dynamic> json):
        subjno = json['subjno'],
        subjnm = json['subjnm'],
        pronm = json['pronm'],
        day = json['day'],
        time = json['time'],
        clsroom = json['clsroom'];



}