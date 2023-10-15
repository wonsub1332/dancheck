import 'package:dancheck/model/api_adapter.dart';
import 'package:dancheck/model/model_user.dart';
import 'package:dancheck/model/userProvider.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class screen_timeTable extends StatefulWidget {
  const screen_timeTable({Key? key}) : super(key: key);

  @override
  State<screen_timeTable> createState() => _screen_timeTableState();
}

class _screen_timeTableState extends State<screen_timeTable> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  List<User> users=[];
  userProvider up= userProvider();


  Future initUsers() async{
    users= await up.getUser();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    initUsers();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child:
            FutureBuilder<List<User>>(
              future: up.getUser(),
                builder: (context, snapshot) {
                  final List<User>? users=snapshot.data;
                  print("In FutureBuilder : "+users.toString());

                  if(snapshot.hasData){
                    return ListView.builder(
                        itemCount: users?.length,
                        itemBuilder: (context,index){
                          final user=users![index];
                          return Padding(
                              padding: const EdgeInsets.all(8.0),
                            child: Card(
                              child: Column(
                                children: [
                                  Text('ID:' + user.id.toString(),
                                      style: TextStyle(fontSize: 20)),
                                  Text('NAME:' + user.name.toString(),
                                      style: TextStyle(fontSize: 20)),
                                  Text('EMAIL:' + user.email.toString(),
                                      style: TextStyle(fontSize: 20)),
                                ],
                              ),
                            ),
                          );
                        },
                    );
                  }
                  else if (snapshot.hasError){
                    return Text("${snapshot.error}에러!!");
                  }
                  return CircularProgressIndicator();
                },

            )
        ),
    );



  }
}

