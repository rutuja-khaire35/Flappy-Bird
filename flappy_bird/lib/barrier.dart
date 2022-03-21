import 'package:flutter/material.dart';

class MyBarrier extends StatelessWidget {
  final barrierWidth; //out of 2, where 2 is the width of the screen
  final barrierHeight; // proportion of the screenheight
  final barrierX;
  // final bool isThisBottomBarrier;

  MyBarrier(
      {this.barrierHeight,
      this.barrierWidth,
      // required this.isThisBottomBarrier,
      this.barrierX
      });

  @override
  Widget build(BuildContext context) {
    return Container(
      // alignment: Alignment((2 * barrierX barrierWidth) / (2 - barrierWidth),
      //     isThisBottomBarrier ? 1 : -1),
      width: MediaQuery.of(context).size.width * barrierWidth / 4,
      // height: MediaQuery.of(context).size.height * 3 / 4 * barrierHeight / 2,
      // width: MediaQuery.of(context).size.width * barrierWidth / 2.5,
      height: MediaQuery.of(context).size.width * barrierHeight,
      decoration: BoxDecoration(
          color: Colors.green,
          border: Border.all(width: 4, color: Color.fromARGB(255, 3, 94, 50)),
          borderRadius: BorderRadius.circular(8)),
    );
  }
}
