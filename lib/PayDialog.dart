import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:movies/data/SystemMessage.dart';
import 'package:movies/global.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:verification_code_custom/verification_code_custom.dart';
import 'ImageIcons.dart';

class PayDialog extends StatefulWidget {

  const PayDialog( {Key? key})
      : super(key: key);

  @override
  _PayDialog createState() => _PayDialog();
}

class _PayDialog extends State<PayDialog> {

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Material(

          ///背景透明
          color: Colors.transparent,

          ///保证控件居中效果
          child: Stack(
            // alignment: Alignment.center,
            children: <Widget>[
              GestureDetector(
                ///点击事件
                onTap: () {
                  // Navigator.pop(context);
                },
              ),
              _dialog(context),
            ],
          )),
    );
  }

  Widget _dialog(context) {
    return Center(
      child: Container(
        width: ((MediaQuery.of(context).size.width) / 1),
        margin: const EdgeInsets.all(30),
        height: 210,
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(15)),
          color: Colors.white,
        ),
        child: Column(
          // mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              margin: const EdgeInsets.all(20),
              child: Text("提示",style: TextStyle(color: Colors.black,fontSize: 18,fontWeight: FontWeight.bold),),
            ),
            Container(
              margin: const EdgeInsets.all(20),
              child: Text("付款后1-5分钟内到账，请稍后确认，超市未到账请联系客服。",style: TextStyle(color: Colors.black54,fontSize: 18),),
            ),
            InkWell(
              onTap: () {
                Navigator.pop(context);
              },
              child: Container(
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [
                      // Colors.redAccent,
                      Color(0xFFFC8A7D),
                      Color(0xffff0010),
                    ],
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                  ),
                  borderRadius: const BorderRadius.all(Radius.circular(30)),
                  border: Border.all(width: 1.0, color: Colors.black12),
                ),
                child: Container(
                  margin: const EdgeInsets.only(top:5,bottom: 5, left:45,right: 45),
                  child:  const Text(
                    '确认',
                    style: TextStyle(
                        color: Colors.white, fontSize: 15),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
  @override
  void dispose() {
    super.dispose();
  }
}
