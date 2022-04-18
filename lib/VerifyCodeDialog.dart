import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:movies/data/SystemMessage.dart';
import 'package:movies/global.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:verification_code_custom/verification_code_custom.dart';
import 'ImageIcons.dart';
class VerifyCodeDialog extends StatefulWidget{
  String phone;
  bool covered;
  clickCallback? callback;
  VerifyCodeDialog(this.phone,{Key? key,this.callback, this.covered = false}) : super(key: key);
  @override
  _VerifyCodeDialog createState() =>_VerifyCodeDialog();
}
class _VerifyCodeDialog extends State<VerifyCodeDialog> {
  int validTime = 120;
  Timer _timer = Timer(const Duration(milliseconds: 10),() => {});
  bool disable = true;
  String countDownText = '';
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _countDown();
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
                  Navigator.pop(context);
                },
              ),
              _dialog(context),
            ],
          )),
    );
  }
  void _countDown(){
    _timer = Timer.periodic(
        const Duration(seconds: 1),
            (Timer timer) async {
          setState(() {
            if (validTime < 1) {
              countDownText = '';
              validTime = 120;
              disable = false;
              _timer.cancel();
            } else {
              --validTime;
              countDownText = '${validTime}S';
            }
          });
        });
  }
  Widget _dialog(context){
    if(widget.covered){
      widget.phone = '${widget.phone.substring(0,6)}****${widget.phone.substring(10)}';
    }
    return Center(
      child: Container(
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
              alignment: Alignment.center,
              width: ((MediaQuery.of(context).size.width) / 1),
              margin: const EdgeInsets.only(top:20,),
              child: Column(
                children: [
                  const Text('短信验证码已发送至手机:',style: TextStyle(fontSize: 22,color: Colors.black),),
                  Text(widget.phone,style: const TextStyle(fontSize: 25,color: Colors.blue),),
                ]
              ),
            ),
            Container(
              margin: const EdgeInsets.only(left:30,right: 30),
              child: VerificationCodeCustom(
                itemCount: 6,
                textChanged: (list) {
                  String result = '';
                  for(String str in list){
                    result += str;
                  }
                  if(result.length == 6 && int.tryParse(result) != null){
                    print(result);
                  }
                },),
            ),
            const Padding(padding: EdgeInsets.only(top:20)),
            Center(
                child: Container(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      InkWell(
                        onTap: (){

                        },
                        child: Text('重新发送',style: TextStyle(color: disable ? Colors.grey : Colors.red)),
                      ),
                      const Padding(padding: EdgeInsets.only(left:10)),
                      Text(countDownText),
                    ],
                  ),
                ),
            ),
          ],
        ),
      ),
    );
  }
}