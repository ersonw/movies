import 'package:flutter/material.dart';
import 'dart:async';
import 'package:meiqiachat/meiqiachat.dart';

void main() {
  return runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
    initMeiqia();
  }

  Future<void> initMeiqia() async {
    try {
      await Meiqiachat.initMeiqiaSdkWith('55584b4e99ced1153307db4d80b19c97');
    } catch (e) {}
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  void _toChat() async {
    await Meiqiachat.toChat();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Plugin example app'),
        ),
        body: Center(
          child: FlatButton(
            child: Text('toChat'),
            onPressed: () => _toChat(),
          ),
        ),
      ),
    );
  }
}
