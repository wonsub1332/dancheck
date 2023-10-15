class User {
  int id;
  String name;
  String email;

  User({required this.id, required this.name, required this.email});

  User.fromMap(Map<String, dynamic> map)
      :
        id=map['id'],
        name=map['name'],
        email=map['email'];

  User.fromJson(Map<String, dynamic> json):
        id=json['id'],
        name=json['name'],
        email=json['email'];



}