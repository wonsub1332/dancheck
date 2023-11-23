class Enroll {
  int stuno;
  int subjno;
  String grade="0";

  Enroll({required this.stuno, required this.subjno});

  Enroll.fromMap(Map<String, dynamic> map)
      :
        stuno=map['stuno'],
        subjno=map['subjno'],
        grade=map['grade'];

  Enroll.fromJson(Map<String, dynamic> json):
        stuno=json['stuno'],
        subjno=json['subjno'],
        grade=json['grade'];

  Map<String, dynamic> toJSON() {
    var json= <String,dynamic>{
      'stuno' : stuno,
      'subjno' : subjno,
      'grade' :grade
    };
    return json;
  }


}