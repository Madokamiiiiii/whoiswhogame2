import 'dart:async';
import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:whoiswhogame/helper/GroupData.dart';

void main() => runApp(WhoIsWho());

class WhoIsWho extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Who is who',
      theme: ThemeData(
        primarySwatch: Colors.green,
        primaryColor: Colors.lightGreenAccent,
      ),
      home: HomePage(title: 'Who is who'),
    );
  }
}

class HomePage extends StatefulWidget {
  HomePage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  MainScreen createState() => MainScreen();
}

class MainScreen extends State<HomePage> {
  Timer timer = Timer.periodic(Duration(seconds: 10), (timer) {});
  int tick = 0;
  GroupData group = GroupData(list: List());
  Random ran = Random();
  int personIndex = 0;
  int correctAnswered = 0;
  int totalAnswered = 0;
  bool finished = false;
  bool revealed = false;

  @override
  void initState() {
    super.initState();
    loadGroupData();
    setState(() {
      timer = Timer.periodic(Duration(seconds: 1), (timer) {
        setState(() {
          tick++;
        });

        if (tick > 10) {
          setState(() {
            tick = 0;
            revealed = true;
            timer.cancel();
          });
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 60, 130, 150),
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Container(
        padding: EdgeInsets.all(18),
        child: !finished
            ? Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Container(
                    child: CircleAvatar(
                      radius: 150,
                      backgroundImage: AssetImage(
                        'assets/images/${group.list[personIndex].imagePath}',
                      ),
                    ),
                    padding: EdgeInsets.all(3),
                    decoration: new BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                    ),
                  ),
                  revealed
                      ? Text(
                          'Time up!',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 25,
                          ),
                        )
                      : Column(children: <Widget>[
                          Text(
                            'Time left: ${10 - tick}',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 25,
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.all(10),
                          ),
                        ]),
                  AnimatedOpacity(
                    opacity: revealed ? 1.0 : 0.0,
                    duration: Duration(milliseconds: 500),
                    child: Padding(
                      padding: EdgeInsets.all(16),
                      child: Card(
                        color: Colors.deepPurple,
                        child: Padding(
                          padding: EdgeInsets.all(16.0),
                          child: Column(
                            children: <Widget>[
                              Text(
                                revealed
                                    ? '${group.list[personIndex].name}'
                                    : "",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 35,
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.all(6),
                              ),
                              Text(
                                revealed
                                    ? '${group.list[personIndex].classe}'
                                    : '',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                ),
                              ),
                              ButtonBar(
                                alignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  RaisedButton(
                                    color: Colors.deepOrange,
                                    child: Text(
                                      'Wrong',
                                      style: TextStyle(
                                        color: Colors.white,
                                      ),
                                    ),
                                    onPressed: () {
                                      if (revealed) {
                                        totalAnswered++;
                                        if (totalAnswered < 20 &&
                                            group.list.length > 0) {
                                          setState(() {
                                            personIndex =
                                                ran.nextInt(group.list.length);
                                            revealed = false;
                                          });

                                          timer = Timer.periodic(
                                              Duration(seconds: 1), (timer) {
                                            setState(() {
                                              tick++;
                                            });

                                            if (tick > 10) {
                                              setState(() {
                                                tick = 0;
                                                revealed = true;
                                                timer.cancel();
                                              });
                                            }
                                          });
                                        } else {
                                          setState(() {
                                            revealed = false;
                                            finished = true;
                                          });
                                        }
                                      }
                                    },
                                  ),
                                  RaisedButton(
                                      color: Colors.white,
                                      elevation: 0,
                                      child: Text(
                                        'Correct!',
                                        style: TextStyle(
                                          color: Colors.deepPurple,
                                        ),
                                      ),
                                      onPressed: () {
                                        if (revealed) {
                                          group.list.removeAt(personIndex);
                                          totalAnswered++;
                                          if (totalAnswered < 20 &&
                                              group.list.length > 0) {
                                            setState(() {
                                              revealed = false;
                                              personIndex = ran
                                                  .nextInt(group.list.length);

                                              timer = Timer.periodic(
                                                  Duration(seconds: 1),
                                                  (timer) {
                                                setState(() {
                                                  tick++;
                                                });
                                                if (tick > 10) {
                                                  setState(() {
                                                    tick = 0;
                                                    revealed = true;
                                                    timer.cancel();
                                                  });
                                                }
                                              });
                                            });
                                          } else {
                                            setState(() {
                                              revealed = false;
                                              finished = true;
                                            });
                                          }

                                          setState(() {
                                            correctAnswered++;
                                          });
                                        }
                                      }),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              )
            : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.all(16),
                    child: Card(
                      color: Colors.greenAccent,
                      child: Padding(
                        padding: EdgeInsets.all(16),
                        child: Column(
                          children: <Widget>[
                            Text(
                              'Game finished!',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 30,
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.all(16.0),
                            ),
                            Text(
                              'Of $totalAnswered questions you got $correctAnswered correct. ${(100 * correctAnswered / totalAnswered).round()} Points!',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            Text(
                              "Good job!",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.all(16.0),
                            ),
                            ButtonBar(
                              alignment: MainAxisAlignment.center,
                              children: <Widget>[
                                RaisedButton(
                                  color: Colors.white,
                                  elevation: 0,
                                  child: Text(
                                    'New Game!',
                                    style: TextStyle(
                                      color: Colors.deepPurple,
                                    ),
                                  ),
                                  onPressed: () {
                                    loadGroupData();
                                    setState(() {
                                      personIndex = 0;
                                      correctAnswered = 0;
                                      totalAnswered = 0;
                                      finished = false;
                                      revealed = false;
                                      timer = Timer.periodic(
                                          Duration(seconds: 1), (timer) {
                                        setState(() {
                                          tick++;
                                        });

                                        if (tick > 10) {
                                          setState(() {
                                            tick = 0;
                                            revealed = true;
                                            timer.cancel();
                                          });
                                        }
                                      });
                                    });
                                  },
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
      ),
    );
  }

  loadGroupData() async {
    String dataString = await rootBundle.loadString('assets/data.json');
    return setState(() {
      group = GroupData.fromJSON(jsonDecode(dataString));
      personIndex = ran.nextInt(group.list.length);
    });
  }
}
