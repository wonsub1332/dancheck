import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../model/model_attendance.dart';
import '../provider/attendanceProvider.dart';

class screen_save extends StatefulWidget {
  const screen_save({Key? key}) : super(key: key);

  @override
  State<screen_save> createState() => _screen_saveState();
}

class _screen_saveState extends State<screen_save> {
  final _stunoNode = FocusNode();
  final _classdayNode = FocusNode();
  final _atimeNode = FocusNode();
  final _rtimeNode = FocusNode();
  final _attNode = FocusNode();
  final _formKey = GlobalKey<FormState>();

  late Attendance att;

  int _subjno=0;
  int _stuno=0;
  String _classday='';
  String _atime='';
  String _rtime='';
  int _check=0;




  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: Form(
        key: _formKey,
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            children: [
              SizedBox(height: 100),
              TextFormField(
                decoration: InputDecoration(labelText: 'subjno'),
                textInputAction: TextInputAction.next,
                keyboardType: TextInputType.number,
                onFieldSubmitted: (_) {
                  FocusScope.of(context).requestFocus(_stunoNode);
                },
                onSaved: (value){
                  setState(() {
                    _subjno=int.parse(value!);
                  });
                },
              ),
              TextFormField(
                focusNode: _stunoNode,
                decoration: InputDecoration(labelText: 'stuno'),
                textInputAction: TextInputAction.next,
                keyboardType: TextInputType.number,
                onFieldSubmitted: (_) {
                  FocusScope.of(context).requestFocus(_classdayNode);
                },
                onSaved: (value){
                  setState(() {
                    _stuno=int.parse(value!);;
                  });
                },
              ),
              TextFormField(
                focusNode: _classdayNode,
                decoration: InputDecoration(labelText: 'classday'),
                textInputAction: TextInputAction.next,
                keyboardType: TextInputType.text,
                onFieldSubmitted: (_) {
                  FocusScope.of(context).requestFocus(_atimeNode);
                },
                onSaved: (value){
                  setState(() {
                    _classday=value as String;
                  });
                },
              ),
              TextFormField(
                focusNode: _atimeNode,
                decoration: InputDecoration(labelText: 'atime'),
                textInputAction: TextInputAction.next,
                keyboardType: TextInputType.text,
                onFieldSubmitted: (_) {
                  FocusScope.of(context).requestFocus(_rtimeNode);
                },
                onSaved: (value){
                  setState(() {
                    _atime=value as String;
                  });
                },
              ),
              TextFormField(
                focusNode: _rtimeNode,
                decoration: InputDecoration(labelText: 'rtime'),
                textInputAction: TextInputAction.next,
                keyboardType: TextInputType.text,
                onFieldSubmitted: (_) {
                  FocusScope.of(context).requestFocus(_attNode);
                },
                onSaved: (value){
                  setState(() {
                    _rtime=value as String;
                  });
                },
              ),
              TextFormField(
                focusNode: _attNode,
                decoration: InputDecoration(labelText: 'check'),
                textInputAction: TextInputAction.next,
                keyboardType: TextInputType.number,
                onSaved: (value){
                  setState(() {
                    _check=int.parse(value!);
                  });
                },
              ),
              ElevatedButton(
                onPressed: () async{
                  if (_formKey.currentState!.validate()) {
                    // validation 이 성공하면 폼 저장하기
                    _formKey.currentState!.save();
                    att= Attendance(subjno: _subjno, stuno: _stuno, classday: _classday, atime: _atime, rtime: _rtime, check: _check);
                    try {
                      attendanceProvider pro= attendanceProvider();
                      pro.postAtt(att);
                    }
                    catch(e,s){
                      print(s);
                    }
                  }
                  },
                child: Text(
                  '저장하기!',
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),)
            ],
          ),
        ),
      ),
    );
  }
}
