//import 'package:dancheck/screen/screen_timeTable.dart';
import 'package:dancheck/screen/screen_login.dart';
import 'package:dancheck/screen/screen_user.dart';
import 'package:dancheck/widget/attendentButton.dart';
import 'package:date_format/date_format.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:timer_builder/timer_builder.dart';
import '../model/model_attendance.dart';
import '../screen/screen_table.dart';
import '../screen/screen_save.dart';
import '../screen/screen_bluetooth.dart';
import '../model/SharedData.dart';


import '../widget/timColumWidget.dart';


const Color activeColor = Color.fromARGB(255, 5, 63, 138);
const Color inactiveColor = Color.fromRGBO(237, 210, 170, 1.0);

class homeScreen extends StatefulWidget{
  homeScreen({Key? key}) : super(key: key);

  @override
  State<homeScreen> createState() => _homeScreenState();
}

class _homeScreenState extends State<homeScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final arguments = ModalRoute.of(context)!.settings.arguments;

    Size screenSize = MediaQuery.of(context).size;
    double width = screenSize.width;
    double height = screenSize.height;
    bool classroomEQ = false;
    late Attendance att;

    int _subjno=0;
    int _stuno=0;
    String _classday='';
    String _atime='';
    String _rtime='';
    int _check=0;

    return WillPopScope(
        onWillPop: ()  {
      return Future(() => false); //뒤로가기 막음
    },
    child :MaterialApp(
      home: DefaultTabController(
        length: 3,
        child: Scaffold(
          appBar: CupertinoNavigationBar(
            middle: const Text('DCHECK'),
            leading: Text("ID:$arguments",style: TextStyle(fontWeight: FontWeight.bold)),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                // 로그아웃 기능
                CupertinoButton(
                  padding: EdgeInsets.zero,
                  child: const Icon(
                    Icons.logout,
                    size: 30,
                  ),
                  onPressed: () {
                    showCupertinoModalPopup<void>(
                      context: context,
                      builder: (BuildContext context) => CupertinoAlertDialog(
                        title: const Text('알림'),
                        content: const Text('로그아웃하시겠습니까?'),
                        actions: <CupertinoDialogAction>[
                          CupertinoDialogAction(
                            isDefaultAction: true,
                            onPressed: () => Navigator.pop(context),
                            child: const Text('아니오'),
                          ),
                          CupertinoDialogAction(
                            isDestructiveAction: true,
                            onPressed: () async {
                              SharedPreferences prefs =
                              await SharedPreferences.getInstance();
                              await prefs.remove('token');
                              await SharedData.delData();
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (builder) => LoginMainPage(),
                                ),
                              );
                            },
                            child: Text('예'),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
          body: TabBarView(
            children: [

              Container(
                child: screen_table(arguments: arguments.toString(),),
              ),
              Container(
                 child: Column(
                   mainAxisAlignment: MainAxisAlignment.center,
                   children: [
                     SizedBox( height: height*0.2,),//여백용

                     classroomText(width,classroomEQ),

                     SizedBox( height: height*0.025,),//여백용
                     //attButton(state: false,)
                     Text(arguments.toString()),

                     Container(
                       padding: EdgeInsets.all(30),
                       child:
                         TimerBuilder.periodic(
                         const Duration(seconds: 1),
                         builder: (context) {
                           return Text(
                             formatDate(DateTime.now(), [hh, ':', nn, ':', ss, ' ', am]),
                             style: const TextStyle(
                               fontSize: 25,
                               fontWeight: FontWeight.w600,
                             ),
                           );
                         },
                       ),
                     ),

                     IconButton(
                         onPressed: (){
                           showDialog(
                               context: context,
                               builder: (BuildContext context){
                                 return AlertDialog(
                                   content: SizedBox(
                                     height: 90,
                                     child: Column(
                                     children: const [
                                       Text("도움말",style: TextStyle(fontWeight: FontWeight.bold),),
                                       Text(""),
                                       Text("비콘을 찾게 된다면"),
                                       Text("출석 버튼이 활성화 됩니다."),
                                     ],
                                   ),
                                   ),
                                   insetPadding: EdgeInsets.fromLTRB(0, 80, 0, 80)
                                 );
                               }
                           );
                         },
                         icon: Icon(Icons.help),
                     )
                     ,
                   ],
                 )
              ), // 메인 홈 화면

              Center(
                child: screen_user(id: arguments.toString(),) //마이페이지
                        //screen_save()
              ),

            ],
          ),
          extendBodyBehindAppBar: true,

          bottomNavigationBar: Container(
            height: height*0.15,
            padding: EdgeInsets.only(bottom: 10,top: 5),
            child: const TabBar(
              indicatorColor: Colors.blueAccent,
                indicatorSize: TabBarIndicatorSize.label,
                indicatorWeight: 2,
                labelColor: Colors.blueAccent,
                unselectedLabelColor: Colors.black38,
                tabs: [
                  Tab(
                    icon: Icon(Icons.schedule),
                    text: '시간표',
                  ),
                  Tab(
                    icon: Icon(Icons.home),
                    text: '홈',
                  ),
                  Tab(
                      icon: Icon(Icons.people),
                      text: '마이페이지',
                  )
                ]
            ),
          ),
        ),
      ),
    )
    );
  }
//widget
  Widget classroomText(double width,bool classroomEQ){
    if (classroomEQ == true) {
      return SizedBox(
          child: Text(
            '제 2공학관 524호',
            style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.blueGrey
            ),
          )
      );
    }

    else {
      return SizedBox( // 강의실을 찾고 있습니다 !! 강의실 이름으로 변경 시켜야 한다.
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              '강의실을 찾고 있습니다',
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.blueGrey
              ),
            ),
            SizedBox(
              width: width * 0.05,
            ),
            SpinKitFadingCube(
              color: Colors.blue, // 색상 설정
              size: 25.0, // 크기 설정
              duration: Duration(seconds: 2), //속도 설정
            ),
          ],
        ),
      );
    }
  }

}
