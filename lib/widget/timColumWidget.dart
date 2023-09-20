import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class timeColumWidget extends StatelessWidget {
  List week = ['월', '화', '수', '목', '금'];
  var columnLength = 22;
  double columnHeight = 20;
  double boxSize = 52;

  timeColumWidget({Key? key}) : super(key: key);


  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(10),
      child: Row(
        children: [
          buildTimeColumn(),
          ...buildDayColumn(0),
          ...buildDayColumn(1),
          ...buildDayColumn(2),
          ...buildDayColumn(3),
          ...buildDayColumn(4),
          cls(),
        ],
      ),
    );
  }
  Expanded buildTimeColumn() {
    return Expanded(
      child: Column(
        children: [
          SizedBox(
            height: columnHeight,
          ),
          ...List.generate(
            columnLength,
                (index) {
              if (index % 2 == 0) {
                return const Divider(
                  color: Colors.grey,
                  height: 0,
                );
              }
              return SizedBox(
                height: boxSize,
                child: Center(child: Text('${index ~/ 2 + 9}')),
              );
            },
          ),
        ],
      ),
    );
  }

  List<Widget>   buildDayColumn(index) {

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
                  columnLength,
                      (index) {
                    if (index % 2 == 0) {
                      return const Divider(
                        color: Colors.grey,
                        height: 0,
                      );
                    }
                    return SizedBox(
                      height: boxSize,
                      child: Container(),
                    );
                  },
                ),
              ],
            )
          ],
        ),
      ),
    ];
  }
  Widget cls(){
    return Positioned(
      child: Container(
        color: Colors.green,
      ),
      top: columnHeight + boxSize / 2,
      height: boxSize + boxSize * 0.5,
      width: 100,
    );
  }
}
