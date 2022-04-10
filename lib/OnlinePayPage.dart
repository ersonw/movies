import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:movies/data/Player.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'ImageIcons.dart';
import 'global.dart';
import 'dart:io';
typedef clickCallback = void Function(int type);
class OnlinePayPage extends Dialog {
  static const int ALIPAY = 100;
  static const int WECHAT = 101;
  final clickCallback callback;

  OnlinePayPage({Key? key, required this.callback}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Material(

          ///背景透明
          color: Colors.transparent,

          ///保证控件居中效果
          child: Stack(
            alignment: Alignment.center,
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
  Widget _dialog(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(10)),
        color: Colors.white,
      ),
      height: 300,
      width: ((MediaQuery.of(context).size.width) / 1),
      margin: const EdgeInsets.only(left: 20, right: 20),
      child: Container(
        margin: const EdgeInsets.only(left: 30, right: 30),
        child: Column(
            children: [
              const Padding(padding: EdgeInsets.only(top: 20)),
              const Text('选择支付方式',style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold)),
              const Padding(padding: EdgeInsets.only(top: 20)),
              InkWell(
                onTap: () {
                  callback(ALIPAY);
                  Navigator.pop(context);
                },
                child: Container(
                  decoration: const BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(30)),
                    color: Color.fromRGBO(59, 169, 242, 1),
                  ),
                  child: Container(
                    margin: const EdgeInsets.only(top: 10, bottom: 10),
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset(ImageIcons.alipay,width: 27,),
                          const Padding(padding: EdgeInsets.only(left: 10)),
                          const Text("支付宝支付",style: TextStyle(fontSize: 15,color: Colors.white)),
                        ]
                    ),
                  ),
                ),
              ),
              const Padding(padding: EdgeInsets.only(top: 10)),
              InkWell(
                onTap: () {
                  callback(WECHAT);
                  Navigator.pop(context);
                },
                child: Container(
                  decoration: const BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(30)),
                    color: Color.fromRGBO(105, 201, 40, 1),
                  ),
                  child: Container(
                    margin: const EdgeInsets.only(top: 10, bottom: 10),
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset(ImageIcons.wechat,width: 27,),
                          const Padding(padding: EdgeInsets.only(left: 10)),
                          const Text("微信支付",style: TextStyle(fontSize: 15,color: Colors.white)),
                        ]
                    ),
                  ),
                ),
              ),
              const Padding(padding: EdgeInsets.only(top: 10)),
              InkWell(
                onTap: (){
                  Navigator.pop(context);
                  Global.toChat(game: true);
                },
                child: Container(
                  decoration: const BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(30)),
                    color: Color.fromRGBO(247, 149, 110, 1),
                  ),
                  child: Container(
                    margin: const EdgeInsets.only(top: 10, bottom: 10),
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset(ImageIcons.agent,width: 27,),
                          const Padding(padding: EdgeInsets.only(left: 10)),
                          const Text("代理支付",style: TextStyle(fontSize: 15,color: Colors.white)),
                        ]
                    ),
                  ),
                ),
              ),
            ]
        ),
      ),
    );
  }
}
