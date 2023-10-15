import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import './screen_home.dart';

class loginScreen extends StatelessWidget {
  const loginScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    double width = screenSize.width;
    double height = screenSize.height;
    TextEditingController IDcontroller = TextEditingController();
    TextEditingController PWcontroller = TextEditingController();

    return Scaffold(
      appBar: AppBar(
        title: Text('DANCHECK'),
      ),
      body: Container(
        padding: EdgeInsets.all(width*0.024),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
            'images/DCHECK_logo_gif.gif',
            width: width*0.5,
            ),
            TextField(
              controller: IDcontroller,
              autofocus: true,
              decoration: InputDecoration(labelText: 'Enter ID'),
              keyboardType: TextInputType.emailAddress,
            ),
            TextField(
              controller: PWcontroller,
              decoration:
              InputDecoration(labelText: 'Enter password'),
              keyboardType: TextInputType.text,
              obscureText: true, // 비밀번호 안보이도록 하는 것
            ),

            SizedBox(
              width: width*0.9,
              child: ButtonTheme(
                  minWidth: width * 0.9,
                  height: height * 0.024,
                  child: ElevatedButton(
                    onPressed: (){
                      Navigator.push(context, MaterialPageRoute(builder: (context) => homeScreen(),));
                    },
                    child: Icon(
                      Icons.arrow_forward,
                      color: Colors.white,
                      size: width * 0.08,
                    ),
                    ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

