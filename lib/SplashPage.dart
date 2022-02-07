import 'package:flutter/material.dart';

class SplashPage extends StatefulWidget {
  SplashPage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<StatefulWidget> createState() {
    return _SplashPageState();
  }
}

class _SplashPageState extends State<SplashPage> {

  @override
  void initState() {
    // TODO: do something to init
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Builder(builder: (context) {
      return Container(
        child: const Image(image: AssetImage('assets/image/splash.png'), fit: BoxFit.fill,),
      );
    });
  }
}