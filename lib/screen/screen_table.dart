import 'package:dancheck/model/api_adapter.dart';
import 'package:dancheck/model/model_timtTable.dart';
import 'package:dancheck/model/model_user.dart';
import 'package:dancheck/model/timeTableProvider.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../widget/timColumWidget.dart';

class screen_table extends StatefulWidget {
  const screen_table({Key? key}) : super(key: key);

  @override
  State<screen_table> createState() => _screen_tableState();
}

class _screen_tableState extends State<screen_table> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  List<Timetable> clsList=[];
  tableProvider prov= tableProvider();


  Future initUsers() async{
    clsList= await prov.getTable();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    initUsers();
  }


  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    double width = screenSize.width;
    double height = screenSize.height;
    return SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child:
        Column(
          children: [
            Column( //시간표
              children: [
              //SizedBox(height: height*0.18,),
              //Text('시간표',style: TextStyle(fontSize: 18,color: Colors.deepOrangeAccent),),
              SizedBox(
                height: height*0.6,
                child: ListView(
                  children: [
                    timeColumWidget(),
                  ],

                ),
              ),
              SizedBox(
                width: width*0.9,
                child: ButtonTheme(
                  minWidth: width * 0.9,
                  height: height * 0.024,
                  child: ElevatedButton(
                    onPressed: (){},
                    child: Icon(
                      Icons.arrow_forward,
                      color: Colors.white,
                      size: width * 0.08,
                    ),
                  ),
                ),
              ),
              ],
            ),
              SizedBox(
                height: 200,
                child: tableList(),
              ),
          ],
        ),
    );



  }
  Widget tableList(){
    return FutureBuilder<List<Timetable>>(
      future: prov.getTable(),
      builder: (context, snapshot) {
        final List<Timetable>? list=snapshot.data;
        print("In FutureBuilder : "+list.toString());

        if(snapshot.hasData){
          return ListView.builder(

            itemCount: list?.length,
            itemBuilder: (context,index){
              final cls=list![index];
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: Card(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        padding: EdgeInsets.all(0.8),
                        child: Column(
                          children: [
                            Text(cls.subjno.toString(),style: TextStyle(fontSize: 15)),
                            Text(cls.pronm.toString(),style: TextStyle(fontSize: 15)),
                            Text(cls.clsroom.toString(),
                                style: TextStyle(fontSize: 15)),
                          ],
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.all(0.5),
                        child: Column(
                          children: [
                            Text('NAME:' + cls.subjnm.toString(),
                                style: TextStyle(fontSize: 15)),
                            Text('DAY:' + cls.day.toString(),
                                style: TextStyle(fontSize: 15)),
                            Text('TIME:' + cls.time.toString(),
                                style: TextStyle(fontSize: 15)),

                          ],
                        ),
                      ),
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

    );
  }
}
