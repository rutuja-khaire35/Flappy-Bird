import 'package:flutter/material.dart';

class MyBird extends StatelessWidget {
  final birdY;
  final double birdWidth; //normal double value for width
  final double birdHeight; //out of 2, 2 being the entire height of the screem

  MyBird(this.birdY, this.birdWidth, this.birdHeight);

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment(0, (2 * birdY + birdHeight) / (2 - birdHeight)),
      child: Image.asset(
        'assets/images/bird.png',
        width: MediaQuery.of(context).size.width * birdWidth / 3,
        height: MediaQuery.of(context).size.height * 3 / 4 * birdHeight ,
        fit: BoxFit.fill,
      ),
    );
  }
}
