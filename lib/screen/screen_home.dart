import 'package:dancheck/widget/attendentButton.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';


const Color activeColor = Color.fromARGB(255, 5, 63, 138);
const Color inactiveColor = Color.fromRGBO(237, 210, 170, 1.0);

class homeScreen extends StatefulWidget {
  const homeScreen({Key? key}) : super(key: key);

  @override
  State<homeScreen> createState() => _homeScreenState();
}

class _homeScreenState extends State<homeScreen> {
  //변수

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    double width = screenSize.width;
    double height = screenSize.height;

    return MaterialApp(
      home: DefaultTabController(
        length: 3,
        child: Scaffold(
          appBar: AppBar(
            title: Text('DANCHECK'),
          ),
          body: TabBarView(
            children: [
              Center(
                child: Text("list"),
              ),
              Container(
                 child: Column(
                   children: [
                     SizedBox( //여백 용
                       height: height*0.2,
                     ),
                     Row(
                       mainAxisAlignment: MainAxisAlignment.center,
                       children:[
                       Text(
                       '강의실을 찾고 있습니다',
                       style: TextStyle(
                         fontWeight: FontWeight.bold,
                         color: Colors.blueGrey
                       ),
                     ),
                     SizedBox(
                       width: width*0.05,
                     ),
                     SpinKitFadingCube(
                       color: Colors.blue, // 색상 설정
                       size: 25.0, // 크기 설정
                       duration: Duration(seconds: 2), //속도 설정
                     ),
                     ],
                     ),
                     SizedBox( //여백 용
                       height: height*0.025,
                     ),
                     attButton(state: false,),

                   ],
                 )
              ),

              Center(
                child: Text("mypage"),
              ),

            ],
          ),
          extendBodyBehindAppBar: true,

          bottomNavigationBar: Container(
            height: 70,
            padding: EdgeInsets.only(bottom: 10,top: 5),
            child: const TabBar(
              indicatorColor: Colors.blueAccent,
                indicatorSize: TabBarIndicatorSize.label,
                indicatorWeight: 2,
                labelColor: Colors.blueAccent,
                unselectedLabelColor: Colors.black38,
                tabs: [
                  Tab(
                    icon: Icon(Icons.text_snippet),
                    text: '수강목록',
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
    );
  }


}
