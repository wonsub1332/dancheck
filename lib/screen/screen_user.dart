import 'package:dancheck/provider/attendanceProvider.dart';
import 'package:dancheck/model/model_attendance.dart';
import 'package:flutter/material.dart';
import 'package:dancheck/model/model_timtTable.dart';
import 'package:dancheck/provider/timeTableProvider.dart';

import '../model/SharedData.dart';

class screen_user extends StatefulWidget {
  const screen_user({Key? key}) : super(key: key);

  @override
  State<screen_user> createState() => _screen_userState();
}

class _screen_userState extends State<screen_user> {


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Future<String> future=SharedData.getData();
    future.then((value) =>
      stuId=value
    );
    future.catchError((error)=>
      print(error)
    );
  }

  static const double marginValue = 5.0;
  static const double paddingValue = 0.28;
  List<Timetable> clsList = [];
  tableProvider prov = tableProvider();
  attendanceProvider attProv = attendanceProvider();
  late String stuId='32180879';
  bool isState=false;



  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    double width = screenSize.width;
    double height = screenSize.height;

    return ListView(
      children: [
        Padding(
          padding: const EdgeInsets.all(paddingValue),
          child: Card(
            color: Colors.blue,
              margin: EdgeInsets.all(marginValue),
              child: InkWell(
                onTap: () async {await viewTable();},
                child: SizedBox(
                  height: height*0.35,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("출석 확인",style: TextStyle(fontSize: (height*0.06),fontFamily:"SOYO",fontWeight: FontWeight.bold )),
                      Icon(Icons.playlist_add_check,size: (height*0.08)),
                    ],
                  ),
                ),
              )
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(paddingValue),
          child: Card(
              margin: EdgeInsets.all(marginValue),
              child: InkWell(
                onTap: () async{},
                child: SizedBox(
                  height: height*0.35,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("이의 신청",style: TextStyle(fontSize: (height*0.06),fontFamily:"SOYO",fontWeight: FontWeight.bold )),
                      Icon(Icons.how_to_vote,size: (height*0.08)),
                    ],
                  ),

                ),
              )
          ),
        ),
      ],
    );
  }

  Future viewTable() async{
    return showModalBottomSheet(
      context: context,
      builder: (context) {
        ValueNotifier<String> searchTermNotifier = ValueNotifier<String>("");
        return SizedBox(
          height: MediaQuery.of(context).size.height * 0.5,
          child:
                Column(
                  children: [
                    Expanded(
                      child: FutureBuilder<Set<Timetable>>(
                      future: prov.getTableID(stuId),
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
  });
  }
  Widget buildLectureWidget(Timetable cls, context){
    return Padding(
        padding: const EdgeInsets.all(2.0),
        child: ElevatedButton(
          child:
              Container(
                height: MediaQuery.of(context).size.height * 0.1,
                padding: EdgeInsets.all(0.8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.6,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(cls.subjno.toString(),
                              style: TextStyle(fontSize: 20)),
                          Text(cls.subjnm.toString(),
                              style: TextStyle(fontSize: 20)),
                        ],
                      ),
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.3,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(cls.clsroom.toString(),
                              style: TextStyle(fontSize: 20)),
                          Text(cls.pronm.toString(),
                              style: TextStyle(fontSize: 20)),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
          onPressed: ()async {
            showAtt(context,cls.subjno,cls.subjnm);
          },
        )
    );
  }
  Future showAtt(context,subjno,subjnm){
    ValueNotifier<String> searchTermNotifier = ValueNotifier<String>("");
    return showDialog(
        context: context,
        builder: (BuildContext context){
          return AlertDialog(
              content: SizedBox(
                width: MediaQuery.of(context).size.width * 0.8,
                child: Column(
                  children: [
                    Text(subjnm.toString(),style: TextStyle(fontSize: 30,fontWeight: FontWeight.bold)),
                    Expanded(
                      child: FutureBuilder<List<Attendance>>(
                        future: attProv.getAtt(stuId,subjno),

                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.done) {
                            if (snapshot.hasError) {
                              return Text("Error: ${snapshot.error}");
                            }
                            List<Attendance> allSubjects = snapshot.data!;
                            return ValueListenableBuilder<String>(
                              valueListenable: searchTermNotifier,
                              builder: (context, value, child) {
                                List<Attendance> filteredSubjects = allSubjects
                                    .where((subject) =>
                                    subject.classday.contains(value))
                                    .toList();

                                return ListView.builder(
                                  itemCount: filteredSubjects.length,
                                  itemBuilder: (context, index) {
                                    return buildAttendance(
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

                    )
                  ]
                ),
              ),
              insetPadding: EdgeInsets.fromLTRB(0, 80, 0, 80)
          );
        }
    );
  }
  Widget buildAttendance(Attendance att, context){
    return Padding(
        padding: const EdgeInsets.all(2.0),
        child: ElevatedButton(
          style: ButtonStyle(
            backgroundColor:
              att.check == 1 ? MaterialStateProperty.all(Colors.green) : MaterialStateProperty.all(Colors.red)
          ),
          child:
              Container(

                height: MediaQuery.of(context).size.height * 0.08,
                padding: EdgeInsets.all(0.8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Text("${att.classday.toString().split('/')[0]}월 "),
                    Text("${att.classday.toString().split('/')[1]}일"),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text("출석:${att.atime}"),
                        Text("퇴실:${att.rtime}"),
                      ],

                    ),
                    att.check == 1 ? const Text('출석',style: TextStyle(fontSize: 20)) : const Text('결석',style: TextStyle(fontSize: 20))
                     ],
                ),
              ),
          onPressed: ()async {

          },
        )
    );
  }

}//class close
