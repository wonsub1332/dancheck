import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../screen/screen_home.dart';

class attButton extends StatefulWidget {
  bool state;
  attButton({required this.state});
  _attButtonState createState() => _attButtonState();

}

class _attButtonState extends State<attButton> {


  @override
  Widget build(BuildContext context) {

    return Center(
      child: RawMaterialButton(
        onPressed: () {
          setState(() {
            widget.state = !widget.state;
            _showDialog();
          });
        },
        elevation: 2.0,
        fillColor: widget.state ? Color.fromARGB(255, 5, 63, 138) : Color.fromRGBO(237, 210, 170, 1.0),
        child: Icon(
          Icons.check,
          color: Colors.white,
          size: 70.0,
        ),
        padding: EdgeInsets.all(100.0),
        shape: CircleBorder(),
      ),
    );
  }
  void _showDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: new Text("Attendence Button"),
          content: new Text("CLICK"),
        );
      },
    );
  }
}
