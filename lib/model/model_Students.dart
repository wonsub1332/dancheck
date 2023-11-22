class Students {
  int id;
  String name;
  String pw;

  Students({required this.id, required this.name, required this.pw});

  Students.fromMap(Map<String, dynamic> map)
      :
        id=map['id'],
        name=map['name'],
        pw=map['pw'];

  Students.fromJson(Map<String, dynamic> json):
        id=json['id'],
        name=json['name'],
        pw=json['pw'];

  Students.toJSON(Map<String, dynamic> json):
        id=json['id'],
        name=json['name'],
        pw=json['pw'];

  Map<String, dynamic> toJSON() {
    var json= <String,dynamic>{
      'name' : name,
      'pw' : pw
    };
    if (id != null) {
      json['id'] = id;
    }

    return json;
  }


}