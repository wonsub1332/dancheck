import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:dancheck/model/model_timtTable.dart';
import 'package:dancheck/model/timeTableProvider.dart';

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
      stuid=value
    );
    future.catchError((error)=>
      print(error)
    );
  }

  static const double marginValue = 5.0;
  static const double paddingValue = 0.28;
  List<Timetable> clsList = [];
  tableProvider prov = tableProvider();
  late String stuid;
  bool isState=false;



  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        Padding(
          padding: const EdgeInsets.all(paddingValue),
          child:Card(
              margin: EdgeInsets.all(marginValue),
              child: InkWell(
                onTap: () async {await viewTable();},
                child: SizedBox(
                  height: 100,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: const[
                      Text("마이페이지"),
                      Icon(Icons.people),
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
                onTap: () async {await viewTable();},
                child: SizedBox(
                  height: 100,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: const[
                      Text("출석 확인"),
                      Icon(Icons.playlist_add_check),
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
                onTap: (){},
                child: SizedBox(
                  height: 100,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: const[
                      Text("이의신청"),
                      Icon(Icons.how_to_vote),
                    ],
                  ),

                ),
              )
          ),
        ),

        SingleChildScrollView(
          child: ExpansionPanelList(
            children: [
              ExpansionPanel(
                isExpanded:isState,
                headerBuilder: (context, isExpanded) {
                  return ListTile(
                    title: Text('sdfsdfds'),
                    onTap: (){setState(() {
                      isState=!isState;
                    });
                    },
                  );
                },
                body: ListTile(
                  title: Text("indfsdf"),

                )
              )
            ],
          ),
        )
      ],
    );
  }
  Widget textID(){
    return FutureBuilder<String>(
        future: SharedData.getData(),
        builder: (context, snapshot) {
          final String? id = snapshot.data;
          stuid=id!;
          return Text("In FutureBuilder : " + id!);
        }
    );
  }
  Future test() async{
    ValueNotifier<String> searchTermNotifier = ValueNotifier<String>("");
    return ListView.builder(
        itemBuilder:(BuildContext context,int){
          return Column(
            children: [
              Expanded(
                child: FutureBuilder<List<Timetable>>(
                  future: prov.getTableID(stuid),
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
          );
        },

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
                      child: FutureBuilder<List<Timetable>>(
                      future: prov.getTableID(stuid),
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
  });
  }
  Widget buildLectureWidget(Timetable cls, context){
    return Padding(
        padding: const EdgeInsets.all(2.0),
        child: ElevatedButton(
          child: Row(
            children: [
              Container(
                height: 50,
                padding: EdgeInsets.all(0.8),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(cls.subjno.toString(),
                        style: TextStyle(fontSize: 20)),
                    Text(cls.pronm.toString(),
                        style: TextStyle(fontSize: 20)),
                    Text(cls.clsroom.toString(),
                        style: TextStyle(fontSize: 20)),
                  ],
                ),
              ),
            ],
          ),
          onPressed: ()async {

          },
        )
    );

  }
}//class close
