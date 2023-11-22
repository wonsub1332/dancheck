import 'package:shared_preferences/shared_preferences.dart';

class SharedData{
  static void updateID(String id)async{
    final SharedPreferences pref = await SharedPreferences.getInstance();
    pref.setString('id', id);
  }
  static Future<String> getData() async{
    final SharedPreferences pref = await SharedPreferences.getInstance();
    String id="";
    try{
      id =pref.getString("id")!;
    }
    catch(e){}
    return id;
    }
  static Future<void> delData() async{
    final SharedPreferences pref = await SharedPreferences.getInstance();
    try{
      pref.remove('id');
    }
    catch(e){}
  }

}