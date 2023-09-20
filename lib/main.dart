import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../screen/screen_login.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _myAppState();
}

class _myAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'DANCHECK',
      home: loginScreen(),
    );
  }
}
