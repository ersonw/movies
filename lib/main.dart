// Copyright 2020 The Flutter team. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:movies/SplashPage.dart';
import 'package:movies/global.dart';
import 'package:movies/routes.dart';

import 'GongGaoPage.dart';
// void main() => Global.init().then((e) => runApp(const MyAdaptingApp()));
void main()  {
  Global.init();
}
class MyAdaptingApp extends StatelessWidget {
  const MyAdaptingApp({Key? key}) : super(key: key);

  @override
  Widget build(context) {
    // Either Material or Cupertino widgets work in either Material or Cupertino
    // Apps.
    // return MultiProvider(
    //   providers: [],
    //   child: ,
    // );
    return MaterialApp(
      routes: Routes,
      // title: 'movies App',
      // debugShowCheckedModeBanner: false,
      // theme: ThemeData(
      //   // Use the green theme for Material widgets.
      //   primarySwatch: Colors.blue,
      // ),
      // darkTheme: ThemeData.dark(),
      builder: (context, child) {
        return CupertinoTheme(
          // Instead of letting Cupertino widgets auto-adapt to the Material
          // theme (which is green), this app will use a different theme
          // for Cupertino (which is blue by default).
          data: const CupertinoThemeData(
              primaryColor: Colors.red,
              barBackgroundColor: Colors.white, //上层颜色
              scaffoldBackgroundColor: Colors.white //Body 颜色
              ),
          child: Material(child: child),
        );
      },
      home: SplashPage( validTime: 9),
    );
  }
}
class GongGaoApp extends StatelessWidget {
  const GongGaoApp({Key? key}) : super(key: key);

  @override
  Widget build(context) {
    // Either Material or Cupertino widgets work in either Material or Cupertino
    // Apps.
    // return MultiProvider(
    //   providers: [],
    //   child: ,
    // );
    return MaterialApp(
      home: GongGaoPage(),
    );
  }
}