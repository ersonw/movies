import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:movies/global.dart';
import 'BottomAppBar.dart';
import 'HttpManager.dart';
import 'ImageIcons.dart';
import 'data/Splash.dart';
import 'network/NWApi.dart';
import 'network/NWMethod.dart';

class SplashPage extends StatefulWidget {
  SplashPage({Key? key, required this.validTime}) : super(key: key);
  int validTime;

  @override
  SplashScreenState createState() => SplashScreenState();
}

class SplashScreenState extends State<SplashPage> {
  late Timer _timer;
  int seconds = 0;
  List<Splash> _list = [];
  int sIndex = 0;
  // ImageProvider bgImage = const AssetImage(ImageIcons.appBootBg);

  @override
  void initState() {
    super.initState();
    // Global.MainContext = context;
    _init();
  }
  _init() async {
    Map<String, dynamic> parm = { };
    String? result = (await DioManager().requestAsync(
        NWMethod.GET, NWApi.getBoots, {"data": jsonEncode(parm)}));
    if (result != null) {
      // print(result);
      Map<String, dynamic> map = jsonDecode(result);
      if(map != null && map['list'] != null){
        setState(() {
          _list =  (map['list'] as List).map((e) => Splash.formJson(e)).toList();
        });
        _countDown();
      }else{
        _next();
      }
    }
  }

  _countDown()async{
    if(_list.isEmpty) {
      _next();
      return;
    }
    seconds = _list[sIndex].du;
    _timer = Timer.periodic(
        const Duration(seconds: 1),
            (Timer timer) => {
          setState(() {
            if (seconds < 1) {
              _timer.cancel();
              _next();
            } else {
              seconds = seconds - 1;
            }
          })
        });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      // color: Colors.transparent,
      decoration: BoxDecoration(
        color: Colors.white,
        image: _list.isEmpty ? null : (sIndex < (_list.length) ?
        DecorationImage(
          // image:NetworkImage(_list[sIndex].image),
          image: NetworkImage( _list[sIndex].image),
          fit: BoxFit.fill,
        ) : null),
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
                  onPressed: () {
                    _timer.cancel();
                    _next();
                    },
                  child: Text('[$seconds] 跳过',style: const TextStyle(color: Colors.black),),
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
    // print(sIndex);
    if(sIndex < (_list.length -1)){
      setState(() {
        sIndex++;
      });
      _countDown();
    }else{
      Navigator.pushReplacement(context,
          MaterialPageRoute(builder: (context) => BottomAppBarState()));
    }
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
