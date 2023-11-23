import 'dart:io';

import 'package:dancheck/model/api_adapter.dart';
import 'package:dancheck/model/model_timtTable.dart';
import 'package:dancheck/model/model_Students.dart';
import 'package:dancheck/provider/enrollProvider.dart';
import 'package:dancheck/provider/timeTableProvider.dart';
import 'package:dancheck/screen/screen_home.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'dart:math';
import '../model/SharedData.dart';
import '../model/db.dart';
import '../widget/timColumWidget.dart';

class screen_table extends StatefulWidget {

  const screen_table({required this.arguments,Key? key,}) : super(key: key);
  final String arguments;
  @override
  State<screen_table> createState() => _screen_tableState();
}

class _screen_tableState extends State<screen_table> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  Set<Timetable> clsList = {};
  tableProvider prov = tableProvider();

  List week = ['월', '화', '수', '목', '금'];
  var kColumnLength = 22;
  double kFirstColumnHeight = 20;
  double kBoxSize = 60;
  Set<Timetable> selectedLectures={};
  String? stuId;

  @override
  void initState() {
    // TODO: implement initState
    String id=widget.arguments;
    stuId=id;
    Future f=prov.getTableID(id);
    f.then((value) {
      selectedLectures = value;
      setState((){
        print('setState 호출');
      });
    });
    super.initState();
  }
  
  Future<void> setInData() async {
    selectedLectures =await DatabaseHelper.instance.getTimetable();
  }



  @override
  Widget build(BuildContext context) {


    Size screenSize = MediaQuery
        .of(context)
        .size;
    double width = screenSize.width;
    double height = screenSize.height;
    return ListView(
        children:[SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Column(
            children: [

              //Text('시간표',style: TextStyle(fontSize: 18,color: Colors.deepOrangeAccent),),

              Container(
                  height: height*0.5,
                  child: timeTableBuilder()
              ),
              SizedBox(
                height: height*0.3,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: SizedBox(
                        height: 80,
                        width: screenSize.width*0.95,
                        child: ElevatedButton(onPressed: () async {
                          await addLecture();
                        }, child: Text('강의 추가 하기',style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),)),
                      ),
                    ),
                    SizedBox(
                      height: 80,
                      width: screenSize.width*0.95,
                      child: ElevatedButton(onPressed: () async {
                        await update(context,stuId);
                      }, child: Text('시간표 업로드',style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),)),
                    ),
                  ],
                ),
              )




            ],
          ),
        )]
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
    String currentDay = week[index];
    List<Widget> lecturesForTheDay = [];
    Color randcolor=Colors.blue;

    for (var lecture in selectedLectures) {
      print("lecture : "+lecture.subjnm);
      for (int i = 0; i < lecture.day.length; i++) {

        double top = kFirstColumnHeight + (double.parse(lecture.start_t[i])/2.0) * kBoxSize;
        double height = ((double.parse(lecture.end_t[i]) - double.parse(lecture.start_t[i]))/2.0) * kBoxSize;

        if (lecture.day[i] == currentDay) {
          lecturesForTheDay.add(
            Positioned(
              top: top,
              left: 0,
              child: Stack(children: [
                GestureDetector(
                  onTap: () {
                    setState(() {
                      selectedLectures.remove(lecture);
                      DatabaseHelper.instance.remove(lecture);
                      //setTimetableLength();
                    });
                  },
                  child: Container(
                    width: MediaQuery.of(context).size.width / 5,
                    height: height,
                    decoration: const BoxDecoration(
                      color:Colors.deepOrange,
                      borderRadius: BorderRadius.all(Radius.circular(2)),
                    ),
                    child: Text(
                      "${lecture.subjnm}\n${lecture.clsroom}",
                      style: const TextStyle(color: Colors.white, fontSize: 12),
                    ),
                  ),
                ),
              ]),
            ),
          );
        }
      }
    }

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
                  kColumnLength.toInt(),
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
            ),
            ...lecturesForTheDay, // 현재 요일에 해당하는 모든 강의를 Stack에 추가
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

  Future addLecture(){
    return showModalBottomSheet(
      context: context,
      builder: (context) {
        ValueNotifier<String> searchTermNotifier =
        ValueNotifier<String>("");
        return SizedBox(
          height: MediaQuery.of(context).size.height * 0.5,
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        onChanged: (value) =>
                        searchTermNotifier.value = value,
                        decoration: const InputDecoration(
                          labelText: '과목명',
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: FutureBuilder<Set<Timetable>>(
                  future: prov.getTable(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState ==
                        ConnectionState.done) {
                      if (snapshot.hasError) {
                        return Text("Error: ${snapshot.error}");
                      }

                      Set<Timetable> allSubjects = snapshot.data!;

                      return ValueListenableBuilder<String>(
                        valueListenable: searchTermNotifier,
                        builder: (context, value, child) {
                          List<Timetable> filteredSubjects = allSubjects
                              .where((subject) =>
                              subject.subjnm.contains(value))
                              .toList();

                          return ListView.builder(
                            itemCount: filteredSubjects.length,
                            itemBuilder: (context, index) {
                              return buildLectureWidget(
                                  filteredSubjects[index], context);
                            },
                          );
                        },
                      );
                    } else {
                      return const Center(
                          child: CircularProgressIndicator());
                    }
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget buildLectureWidget(Timetable cls, context){
    return Padding(
        padding: const EdgeInsets.all(8.0),
        child: ElevatedButton(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                width: MediaQuery.of(context).size.width*0.2,
                padding: EdgeInsets.all(0.08),
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
                width: MediaQuery.of(context).size.width*0.6,
                padding: EdgeInsets.all(0.08),
                child: Column(
                  children: [
                    Text(cls.subjnm.toString(),
                        style: TextStyle(fontSize: 15)),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(cls.day.toString(),
                            style: TextStyle(fontSize: 15)),
                        Text(cls.start_t.toString()+' '+cls.end_t.toString(),
                            style: TextStyle(fontSize: 15)),
                      ],
                    )


                  ],
                ),
              ),
            ],
          ),
          onPressed: ()async {
            selectedLectures.add(cls);
            setState((){
              print('setState 호출');
              selectedLectures.add(cls);
              DatabaseHelper.instance.add_raw(cls);
            });
          },
        )
    );

  }

  Future update(context,id){
    ValueNotifier<String> searchTermNotifier = ValueNotifier<String>("");
    enrollProvider enrollProv=enrollProvider();
    enrollProv.delEnroll(id);
    enrollProv.updateEnroll(id, selectedLectures);
    return showDialog(
        context: context,
        builder: (BuildContext context){
          return AlertDialog(
              content: SizedBox(
                height: MediaQuery.of(context).size.height*0.038,
                child: Column(
                  children: const[
                    Text("업로드 완료",style: TextStyle(fontFamily: "SOYO",fontWeight: FontWeight.bold,fontSize: 20)),
                  ],
                ),
              ),
              insetPadding: EdgeInsets.fromLTRB(0, 80, 0, 80)
          );
        }
    );
  }





}