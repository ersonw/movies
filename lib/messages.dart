import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Messages extends StatefulWidget {
  const Messages({Key? key}) : super(key: key);

  @override
  _Messages createState() => _Messages();
}
class _Messages extends State<Messages>{
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: const Text('消息中心'),backgroundColor: Colors.transparent,),
        body: ListView()
    );
  }
}