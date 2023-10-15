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
  List<Timetable> clsList = [];
  tableProvider prov = tableProvider();

  List week = ['월', '화', '수', '목', '금'];
  var kColumnLength = 22;
  double kFirstColumnHeight = 20;
  double kBoxSize = 60;


  Future initUsers() async {
    clsList = await prov.getTable();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    initUsers();
  }


  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery
        .of(context)
        .size;
    double width = screenSize.width;
    double height = screenSize.height;
    return Scaffold(
      body: SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child: Column(
          children: [

                SizedBox(height: height*0.15,),
                //Text('시간표',style: TextStyle(fontSize: 18,color: Colors.deepOrangeAccent),),
                Container(
                  height: 400,
                    child: timeTableBuilder()),
          SizedBox(
            height: 200,
            child: tableList(),
          ),
        ],
      ),
    )
    );
  }

  Widget tableList() {
    return FutureBuilder<List<Timetable>>(
      future: prov.getTable(),
      builder: (context, snapshot) {
        final List<Timetable>? list = snapshot.data;
        print("In FutureBuilder : " + list.toString());

        if (snapshot.hasData) {
          return ListView.builder(

            itemCount: list?.length,
            itemBuilder: (context, index) {
              final cls = list![index];
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
                            Text(cls.subjno.toString(),
                                style: TextStyle(fontSize: 15)),
                            Text(cls.pronm.toString(),
                                style: TextStyle(fontSize: 15)),
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
        else if (snapshot.hasError) {
          return Text("${snapshot.error}에러!!");
        }
        return CircularProgressIndicator();
      },

    );
  }

  Widget timeTableBuilder() {
    return Container(
      height: kColumnLength / 2 * kBoxSize + kColumnLength,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey),
        borderRadius: BorderRadius.circular(12),
      ),

      child: SingleChildScrollView(
    child: Column(
    mainAxisSize: MainAxisSize.min,
    children: [
    SizedBox(
    height: (kColumnLength / 2 * kBoxSize) + kFirstColumnHeight,
    child: Row(
    children: [
    buildTimeColumn(),
    ...buildDayColumn(0),
    ...buildDayColumn(1),
    ...buildDayColumn(2),
    ...buildDayColumn(3),
    ...buildDayColumn(4),
    ],
    ),
    ),
    ],
    ),)

    );
  }
  List<Widget> buildDayColumn(int index) {
    return [
      const VerticalDivider(
        color: Colors.grey,
        width: 0,
      ),
      Expanded(
        flex: 4,
        child: Stack(
          children: [
            Column(
              children: [
                SizedBox(
                  height: 20,
                  child: Text(
                    '${week[index]}',
                  ),
                ),
                ...List.generate(
                  kColumnLength,
                      (index) {
                    if (index % 2 == 0) {
                      return const Divider(
                        color: Colors.grey,
                        height: 0,
                      );
                    }
                    return SizedBox(
                      height: kBoxSize,
                      child: Container(),
                    );
                  },
                ),
              ],
            )
          ],
        ),
      ),
    ];
  }



  Expanded buildTimeColumn() {
    return Expanded(
      child: Column(
        children: [
          SizedBox(
            height: kFirstColumnHeight,
          ),
          ...List.generate(
            kColumnLength,
                (index) {
              if (index % 2 == 0) {
                return const Divider(
                  color: Colors.grey,
                  height: 0,
                );
              }
              return SizedBox(
                height: kBoxSize,
                child: Center(child: Text('${index ~/ 2 + 9}')),
              );
            },
          ),
        ],
      ),
    );
  }
  


}