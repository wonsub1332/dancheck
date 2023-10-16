import 'package:dancheck/model/api_adapter.dart';
import 'package:dancheck/model/model_timtTable.dart';
import 'package:dancheck/model/model_user.dart';
import 'package:dancheck/model/timeTableProvider.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:math';
import '../widget/timColumWidget.dart';

class screen_test extends StatefulWidget {
  const screen_test({Key? key}) : super(key: key);

  @override
  State<screen_test> createState() => _screen_testState();
}

class _screen_testState extends State<screen_test> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  List<Timetable> clsList = [];
  tableProvider prov = tableProvider();

  List week = ['월', '화', '수', '목', '금'];
  var kColumnLength = 22;
  double kFirstColumnHeight = 20;
  double kBoxSize = 60;
  List<Timetable> selectedLectures=[];


  Future initUsers() async {
    clsList = await prov.getTable();
  }
  static Color randomOpaqueColor() {
    return Color(Random().nextInt(0xffffffff)).withAlpha(0xff);
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    initUsers();
  }

  int setTimetableLength(){
    return 0;
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
                height: 80,
                width: screenSize.width*0.95,
                child: ElevatedButton(onPressed: () async {
                  await addLecture();
                }, child: Text('강의 추가 하기',style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),)),
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
                            Text('TIME:' + cls.start_t.toString(),
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
    String currentDay = week[index];
    List<Widget> lecturesForTheDay = [];
    Color randcolor=Colors.blue;

    for (var lecture in selectedLectures) {
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
                      //setTimetableLength();
                      randcolor=randomOpaqueColor();
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
                child: FutureBuilder<List<Timetable>>(
                  future: prov.getTable(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState ==
                        ConnectionState.done) {
                      if (snapshot.hasError) {
                        return Text("Error: ${snapshot.error}");
                      }

                      List<Timetable> allSubjects = snapshot.data!;

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
                  Text('Start:' + cls.start_t.toString()+'End :'+cls.end_t.toString(),
                      style: TextStyle(fontSize: 15)),

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
          });
        },
      )
    );

  }



}