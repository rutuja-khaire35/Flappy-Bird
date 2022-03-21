import 'dart:async';
import 'package:flappy_bird/barrier.dart';
import 'package:flappy_bird/bird.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // bird variable
  static double birdY = 0;
  double initalPos = birdY;
  double height = 0;
  double time = 0;
  double gravity = -4.9; //how strong the gravity is
  double velocity = 1.5; //how strong the jump is
  double birdWidth = 0.1; //out of 2, 2 being the entire width of the screen
  double birdHeight = 0.1; //out of 2, 2 being the entire height of the screen
  static double barrierXone = 1;
  double barrierXtwo = barrierXone + 1.5;

// game settings
  bool gameHasStarted = false;

  //barrier variables
  static List<double> barrierX = [2, 2 + 1.5];
  static double barrierWidth = 0.5; // out of 2
  List<List<double>> barrierHeight = [
    //out of 2, where 2 is the entire height of the screen
    //[topHeight, bottomHeight]
    [0.6, 0.4],
    [0.4, 0.6],
  ];

  void startGame() {
    gameHasStarted = true;
    Timer.periodic(Duration(milliseconds: 60), (timer) {
      // a real physical jump is the same as an upside down parabola
      //so this is a simple quadratic equation
      height = gravity * time * time + velocity * time;

      setState(() {
        birdY = initalPos - height;

        barrierXone -= 0.05;
        barrierXtwo -= 0.05;
      });

      setState(() {
        if (barrierXone < -1.1) {
          barrierXone += barrierXtwo + 2.2;
        } else {
          barrierXone -= 0.05;
        }
      });

      setState(() {
        if (barrierXtwo < -1.1) {
          barrierXtwo += barrierXone + 2.2;
        } else {
          barrierXtwo -= 0.05;
        }
      });

      //check if the bird is dead
      if (birdIsDead()) {
        timer.cancel();
        _showDialog();
      }

      //keep the map moving (move barriers)
      moveMap();

      //keep the time going
      time += 0.01;
    });
  }

  void moveMap() {
    for (int i = 0; i < barrierX.length; i++) {
      //keep barrier moving
      setState(() {
        barrierX[i] -= 0.005;
      });

      //if barrier exits the left part of the screen, keep it looping
      if (barrierX[i] < 1.5) {
        barrierX[i] += 3;
      }
    }
  }

  void resetGame() {
    Navigator.pop(context); //dismisses the alert dialog
    setState(() {
      birdY = 0;
      gameHasStarted = false;
      time = 0;
      initalPos = birdY;
      barrierXone = 1;
      barrierXtwo = barrierXone + 1.5;
    });
  }

  void _showDialog() {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            backgroundColor: Colors.brown,
            title: Center(
                child: Text(
              "G A M E  O V E R",
              style: TextStyle(color: Colors.white),
            )),
            actions: [
              GestureDetector(
                onTap: resetGame,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(5),
                  child: Container(
                    padding: EdgeInsets.all(7),
                    color: Colors.white,
                    child: Text(
                      'PLAY AGAIN',
                      style: TextStyle(color: Colors.brown),
                    ),
                  ),
                ),
              )
            ],
          );
        });
  }

  void jump() {
    setState(() {
      time = 0;
      initalPos = birdY;
    });
  }

  bool birdIsDead() {
    //check if bird is hittng the top or the bottom of the screen
    if (birdY < -1 || birdY > 1) {
      return true;
    }

    //hits barrier
    //checks if bird is within x coordinate and y coordinate of barrier
    // for (int i = 0; i < barrierX.length; i++) {
    //   if (barrierX[i] <= birdWidth &&
    //       barrierX[i] + barrierWidth >= -birdWidth &&
    //       (birdY <= -1 + barrierHeight[i][0] ||
    //           birdY + birdHeight >= 1 - barrierHeight[i][1])) {
    //     return true;
    //   }
    // }

    if (barrierXone >= -1 && barrierXone <= 1) {
      if (birdY <= -0.2 || birdY >= 0.6) {
        return true;
      }
    }
    if (barrierXtwo >= -1 && barrierXtwo <= 1) {
      if (birdY <= -0.6 || birdY >= 0.2) {
        return true;
      }
    }

    // if (barrierXone >= -0.25 && barrierXone <= 0.25) {
    //     if (birdYAxis <= -0.6 || birdYAxis >= 0.2) {
    //       timer.cancel();
    //       scoreTimer.cancel();
    //       gameStarted = false;
    //       if (score > highScore) {
    //         highScore = score;
    //         await prefs.setInt(HIGH_SCORE_KEY, highScore);
    //       }
    //       setState(() {});
    //       await showLoseDialog();
    //     }
    //   }

    return false;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: gameHasStarted ? jump : startGame,
      child: Scaffold(
        body: Column(
          children: [
            Expanded(
                flex: 3,
                child: Stack(children: [
                  AnimatedContainer(
                    alignment: Alignment(0, birdY),
                    duration: Duration(milliseconds: 0),
                    color: Colors.blue,
                    child: (MyBird(birdY, barrierWidth, birdHeight)),
                  ),
                  Container(
                    alignment: Alignment(0, -0.3),
                    child: Text(
                      gameHasStarted ? '' : 'T A P  T O  P L A Y',
                      style: TextStyle(color: Colors.white, fontSize: 20),
                    ),
                  ),
                  //Bottom barrier 0
                  AnimatedContainer(
                      alignment: Alignment(barrierXone, 1.1),
                      duration: Duration(milliseconds: 0),
                      child: MyBarrier(
                          barrierX: barrierX[0],
                          barrierWidth: barrierWidth,
                          barrierHeight: barrierHeight[0][0],
                          // isThisBottomBarrier: false
                          )),
                  //Top barrier 0
                  AnimatedContainer(
                    alignment: Alignment(barrierXone, -1.1),
                    duration: Duration(milliseconds: 0),
                    child: MyBarrier(
                        barrierX: barrierX[0],
                        barrierWidth: barrierWidth,
                        barrierHeight: barrierHeight[0][1],
                        // isThisBottomBarrier: true
                        ),
                  ),
                  //Bottom barrier 1
                  AnimatedContainer(
                    alignment: Alignment(barrierXtwo, 1.1),
                    duration: Duration(milliseconds: 0),
                    child: MyBarrier(
                        barrierX: barrierX[1],
                        barrierWidth: barrierWidth,
                        barrierHeight: barrierHeight[1][0],
                        // isThisBottomBarrier: false
                        ),
                  ),
                  //Top barrier 1
                  AnimatedContainer(
                    alignment: Alignment(barrierXtwo, -1.1),
                    duration: Duration(milliseconds: 0),
                    child: MyBarrier(
                        barrierX: barrierX[1],
                        barrierWidth: barrierWidth,
                        barrierHeight: barrierHeight[1][1],
                        // isThisBottomBarrier: true
                        ),
                  ),
                ])),
            Container(
              height: 15,
              color: Colors.green,
            ),
            Expanded(
              child: Container(
                color: Colors.brown,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "SCORE",
                          style: TextStyle(color: Colors.white, fontSize: 20),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Text(
                          "0",
                          style: TextStyle(color: Colors.white, fontSize: 35),
                        ),
                      ],
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "HIGHSCORE",
                          style: TextStyle(color: Colors.white, fontSize: 20),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Text(
                          "10",
                          style: TextStyle(color: Colors.white, fontSize: 35),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
