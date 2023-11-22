import 'package:crypto/crypto.dart'; // password hashing algorithms
import 'dart:convert';
import 'package:dancheck/model/model_Students.dart';
import 'package:http/http.dart'as http;

String hashPassword(String password) {
  const uniqueKey = 'hello'; // 비밀번호 추가 암호화를 위해 유니크 키 추가
  final bytes = utf8.encode(password + uniqueKey); // 비밀번호와 유니크 키를 바이트로 변환
  final hash = sha256.convert(bytes); // 비밀번호를 sha256을 통해 해시 코드로 변환
  return hash.toString();
}
// 계정 생성
Future<void> insertMember(int uid, String password, String name) async {

  final hash = hashPassword(password);
  Students stu= Students(id:uid,pw:hash,name:name);

  // DB에 유저 정보 추가
  try {

    var response = await http.post(
      Uri.parse('http://18.217.3.173:8000/check/user_save/'),
      headers: <String, String>{
        'Content-Type': 'application/json',
        "Referer": "http://18.217.3.173:8000"
      },
      body: jsonEncode(stu.toJSON()),
    );
  } catch (e) {
    print('Error : $e');
  }
}

// 로그인
Future<String?> login(int id, String password) async {
  Uri uri = Uri.parse('http://18.217.3.173:8000/check/user/'+id.toString());

  // 비밀번호 암호화
  final hash = hashPassword(password);

  // DB에 해당 유저의 아이디와 비밀번호를 확인하여 users 테이블에 있는지 확인
  final response = await http.get(uri);
  if (response.statusCode == 200) {
    Map<String, dynamic>  data = json.decode(utf8.decode(response.bodyBytes));
    print ('getTable: '+data.toString());

    if (data['pw'] == hash) {
      return data['id'].toString();
    }

  }
  // 예외처리용 에러코드 '-1' 반환
  return '-1';
}

// 유저ID 중복확인
Future<String?> confirmIdCheck(int id) async {

  Uri uri = Uri.parse('http://18.217.3.173:8000/check/user/'+id.toString());
  // ID 중복 확인
  try {
    final response = await http.get(uri);
    if (response.statusCode == 200) {
      final data = json.decode(utf8.decode(response.bodyBytes)) as List<dynamic>;
      print ('getTable: '+data.toString());
      if (data != null){
        return '1';
      }
    } else{
      return '0';
    }
  } catch (e) {
    print('Error : $e');
  }
  // 예외처리용 에러코드 '-1' 반환
  return '-1';
}