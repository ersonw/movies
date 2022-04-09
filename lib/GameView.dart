import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:wakelock/wakelock.dart';
import 'package:webview_flutter/webview_flutter.dart';

import 'DraggableFloatingActionButton.dart';
import 'functions.dart';
import 'global.dart';

class GameView extends StatefulWidget {
  final String url;
  GameView ({Key? key, required this.url}) : super(key: key);

  @override
  _GameView createState() => _GameView();
}

class _GameView extends State<GameView> {
  final GlobalKey _parentKey = GlobalKey();
  double oWith = 0;
  double oHeight = 0;

  @override
  void initState() {
    Wakelock.enable();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
        overlays: [SystemUiOverlay.bottom]);
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight
    ]);
    super.initState();

    // Enable virtual display.
    if (Platform.isAndroid) WebView.platform = AndroidWebView();
  }

  @override
  Widget build(BuildContext context) {
    oWith = 10;
    oHeight = 50;
    return Scaffold(
      // floatingActionButton: FloatingActionButton(
      //   onPressed: () {
      //     Navigator.pop(context);
      //   },
      //   child: Container(
      //     child: Icon(Icons.phonelink_erase_sharp),
      //   ),
      // ),
      // // floatingActionButtonAnimator: FloatingActionButtonAnimation,
      // floatingActionButtonLocation: FloatingActionButtonLocation.miniStartDocked,
      body: Stack(
        key: _parentKey,
        children: [
          Container(
            // margin: const EdgeInsets.only(bottom: 20),
              child: WebView(
                javascriptMode: JavascriptMode.unrestricted,
                initialUrl: widget.url,
              )
          ),
          DraggableFloatingActionButton(
            child: InkWell(
              child: Container(
                width: 30,
                height: 30,
                decoration:  BoxDecoration(
                  borderRadius: const BorderRadius.all(Radius.circular(60)),
                  gradient: const LinearGradient(
                    colors: [
                      // Colors.redAccent,
                      Color(0xFFEF0505),
                      Color(0x1a000000),
                    ],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                  boxShadow: [
                    BoxShadow(
                      blurRadius: 10, //阴影范围
                      spreadRadius: 0.1, //阴影浓度
                      color: Colors.grey.withOpacity(0.2), //阴影颜色
                    ),
                  ],
                ),
                child: const Icon(Icons.exit_to_app_outlined,color: Colors.white,),
              ),
              onTap: () async{
                if(await ShowAlertDialogBool(context,"温馨提醒", "退出游戏还回桌面，未完成的对局将会自动托管，确定继续退出吗?")){
                  Navigator.pop(context);
                }
              },
            ),
            initialOffset:  Offset(oWith, oHeight),
            parentKey: _parentKey,
            onPressed: () {},
          ),
        ],
      ),
    );
  }
  @override
  void dispose() {
    Wakelock.disable();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.leanBack,
        overlays: [SystemUiOverlay.bottom]);
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown
    ]);
    super.dispose();
  }
}