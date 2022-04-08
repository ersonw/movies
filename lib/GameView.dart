import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class GameView extends StatefulWidget {
  final String url;
  GameView ({Key? key, required this.url}) : super(key: key);

  @override
  _GameView createState() => _GameView();
}

class _GameView extends State<GameView> {
  @override
  void initState() {
    super.initState();
    // Enable virtual display.
    if (Platform.isAndroid) WebView.platform = AndroidWebView();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // floatingActionButton: ,
      // floatingActionButtonAnimator: FloatingActionButtonAnimation,
      floatingActionButtonLocation: FloatingActionButtonLocation.miniEndFloat,
      body: Container(
          margin: const EdgeInsets.only(bottom: 20),
          child: WebView(
            javascriptMode: JavascriptMode.unrestricted,
            initialUrl: widget.url,
          )
      ),
    );
  }
}