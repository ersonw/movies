import 'dart:async';
import 'package:flutter/material.dart';
import 'package:movies/global.dart';
import 'package:movies/HomePage.dart';

import 'BottomAppBar.dart';

class SplashPage extends StatefulWidget {
  SplashPage({Key? key, required this.validTime}) : super(key: key);
  int validTime;

  @override
  SplashScreenState createState() => SplashScreenState();
}

class SplashScreenState extends State<SplashPage> {
  late Timer _timer;

  @override
  void initState() {
    super.initState();
    Global.MainContext = context;
    // Timer(const Duration(milliseconds: 500), (){
    //   _next();
    // });
    _timer = Timer.periodic(
        const Duration(seconds: 1),
        (Timer timer) => {
              setState(() {
                if (widget.validTime < 1) {
                  _next();
                } else {
                  widget.validTime = widget.validTime - 1;
                }
              })
            });
  }

  @override
  Widget build(BuildContext context) {

    return Container(
      // color: Colors.transparent,
      decoration: BoxDecoration(
        color: Colors.black,
        image: DecorationImage(
          image: NetworkImage(
              Global.profile.config.bootImage),
          fit: BoxFit.cover,
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Container(
                child: ElevatedButton(
                  style: ButtonStyle(backgroundColor: MaterialStateProperty.all(Colors.white38)),
                  onPressed: () => _next(),
                  child: Text('[${widget.validTime}] 跳过',style: const TextStyle(color: Colors.black),),
                ),
                margin: const EdgeInsets.only(top: 50, right: 10),
              )
            ],
          )
        ],
      ),
    );
  }
  void _next(){
    _timer.cancel();
    Navigator.pushReplacement(context,
        MaterialPageRoute(builder: (context) => BottomAppBarState()));
  }
  String formatTime(int timeNum) {
    return timeNum < 10 ? "0" + timeNum.toString() : timeNum.toString();
  }

  String constructFirstTime(int seconds) {
    int hour = seconds ~/ 3600;
    int minute = seconds % 3600 ~/ 60;
    int second = seconds % 60;
    return formatTime(hour) +
        "," +
        formatTime(minute) +
        ":" +
        formatTime(second);
  }

  String constructTime(int seconds) {
    int minute = seconds % 3600 ~/ 60;
    int second = seconds % 60;
    return formatTime(minute) + ":" + formatTime(second);
  }
}
