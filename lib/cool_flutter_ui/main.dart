import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import './config/router_manager.dart';
import './pages/home_page.dart';
import './pages/page1/page_1.dart';
import 'package:oktoast/oktoast.dart';

void cool_flutter_uiRun() {
  runApp(MyApp());
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(statusBarColor: Colors.transparent,));

}

class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return OKToast(
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'nice alarm clock',
        theme: ThemeData(
            primaryColor: Colors.white,
            brightness: Brightness.dark
        ),
        home: HomePage(),
        // home: Page1(),
      ),
    );
  }


}
