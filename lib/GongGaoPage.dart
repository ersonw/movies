import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'ImageIcons.dart';

class GongGaoPage extends StatefulWidget {
  const GongGaoPage({Key? key}) : super(key: key);

  @override
  _GongGaoPage createState() => _GongGaoPage();
  
}
class _GongGaoPage extends State<GongGaoPage>{
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(child: Image.asset(ImageIcons.tingji,width: ((MediaQuery.of(context).size.width) / 2),),),
          const Padding(padding: EdgeInsets.only(top: 50)),
          Text('23PORN 提示您“维护中”',style: TextStyle(color: Colors.black54,fontSize:25,)),
          const Padding(padding: EdgeInsets.only(top: 20)),
          Text('更多详情请访问官网：23av.me 查看',style: TextStyle(color: Colors.black54,fontSize:15,)),
        ],
      ),
    );
  }
}