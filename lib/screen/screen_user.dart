import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class screen_user extends StatefulWidget {
  const screen_user({Key? key}) : super(key: key);

  @override
  State<screen_user> createState() => _screen_userState();
}

class _screen_userState extends State<screen_user> {
  static const double marginValue = 5.0;
  static const double paddingValue = 0.28;
  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        Padding(
          padding: const EdgeInsets.all(paddingValue),
          child: Card(
            margin: EdgeInsets.all(marginValue),
            child: SizedBox(
              height: 50,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: const[
                  Text("마이페이지"),
                  Icon(Icons.people),
                ],
              ),
            )
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(paddingValue),
          child: Card(
              margin: EdgeInsets.all(marginValue),
              child: SizedBox(
                height: 50,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: const[
                    Text("출석 확인"),
                    Icon(Icons.playlist_add_check),
                  ],
                ),
              )
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(paddingValue),
          child: Card(
              margin: EdgeInsets.all(marginValue),
              child: SizedBox(
                height: 50,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: const[
                    Text("이의신청"),
                    Icon(Icons.how_to_vote),
                  ],
                ),
              )
          ),
        ),
      ],
    );
  }
}
