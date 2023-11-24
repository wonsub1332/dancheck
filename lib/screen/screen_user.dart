import 'package:dancheck/provider/attendanceProvider.dart';
import 'package:dancheck/model/model_attendance.dart';
import 'package:flutter/material.dart';
import 'package:dancheck/model/model_timtTable.dart';
import 'package:dancheck/provider/timeTableProvider.dart';

import '../model/SharedData.dart';

class screen_user extends StatefulWidget {
  screen_user({required this.id ,Key? key}) : super(key: key);
  String id;
  @override
  State<screen_user> createState() => _screen_userState();
}

class _screen_userState extends State<screen_user> {

  final _formKey = GlobalKey<FormState>();

  late Attendance att;

  String _exception="";


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    String ii=widget.id;
    stuId=ii;
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
                onTap: () async{ viewExcept();},
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
  //===============================================================================

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

  Future viewExcept() async{
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
                                return buildLectureToE(
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
  Widget buildLectureToE(Timetable cls, context){
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
            showPop(context,cls.subjno,cls.subjnm);
          },
        )
    );
  }
  Future showPop(context,subjno,subjnm){
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
                                      return buildAttToExcept(
                                          filteredSubjects[index],subjnm,subjno, context);
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
  Widget buildAttToExcept(Attendance att,subjnm,subjno, context){
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
              showForm(context,att,subjnm,subjno);
          },
        )
    );
  }
  Future showForm(context,att,subjnm,subjno){
    double width=MediaQuery.of(context).size.width;
    double height=MediaQuery.of(context).size.height;
    return showDialog(
        context: context,
        builder: (BuildContext context){
          return AlertDialog(
              content: SizedBox(
                width: width * 0.8,
                height: height * 0.4,
                child: Form(
                  key: _formKey,
                  child: Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(1.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(subjno.toString(),style: TextStyle(fontSize: (width*0.06),fontFamily:"SOYO"),),
                              Text(subjnm,style: TextStyle(fontSize: (width*0.06),fontFamily:"SOYO" ),),

                            ],
                          ),
                        ),

                        TextFormField(
                          maxLines: 6,
                          decoration:
                            InputDecoration(
                              enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.green,)
                              ),
                            ),
                          textInputAction: TextInputAction.next,
                          keyboardType: TextInputType.number,
                          onSaved: (value){
                            setState(() {
                              _exception=value!;
                            });
                          },
                        ),

                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.7,
                          child: ElevatedButton(
                            onPressed: () async{
                              if (_formKey.currentState!.validate()) {
                                // validation 이 성공하면 폼 저장하기
                                _formKey.currentState!.reset();
                                Navigator.pop(context);
                                showDialog(
                                    context: context,
                                    builder: (context) {
                                      return AlertDialog(
                                        content: Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                                          children: [
                                            Text("이의 신청 완료",style: TextStyle(fontSize: (width*0.06),fontFamily:"SOYO",fontWeight: FontWeight.bold ),),
                                            Icon(Icons.how_to_vote_rounded)
                                          ],
                                        ),
                                      );
                                    },
                                );

                              }
                            },
                            child: Text(
                              '이의신청 하기',
                              style: TextStyle(
                                color: Colors.white,
                              ),
                            ),),
                        )
                      ],
                    ),
                  ),
                )
              ),
              insetPadding: EdgeInsets.fromLTRB(0, 80, 0, 80)
          );
        }
    );
  }



}//class close
