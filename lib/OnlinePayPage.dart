import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:movies/data/Player.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'HttpManager.dart';
import 'ImageIcons.dart';
import 'data/OnlinePay.dart';
import 'global.dart';
import 'dart:io';

import 'network/NWApi.dart';
import 'network/NWMethod.dart';
typedef clickCallback = void Function(int type);
class OnlinePayPage extends Dialog {
  static const int ALIPAY = 100;
  static const int WECHAT = 101;
  final clickCallback callback;
  List<OnlinePay> list;

  OnlinePayPage(this.list,{Key? key, required this.callback}) : super(key: key);

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
  _buildPays(BuildContext context){
    List<Widget> widgets = [];
    for (int i=0;i< list.length;i++){
      OnlinePay pay = list[i];
      widgets.add(const Padding(padding: EdgeInsets.only(top: 10)));
      widgets.add(InkWell(
        onTap: () {
          callback(pay.id);
          Navigator.pop(context);
        },
        child: Container(
          decoration:  BoxDecoration(
            borderRadius: const BorderRadius.all(Radius.circular(30)),
            color: pay.title.contains('微信') ? const Color.fromRGBO(105, 201, 40, 1) : const Color.fromRGBO(59, 169, 242, 1),
          ),
          child: Container(
            margin: const EdgeInsets.only(top: 10, bottom: 10),
            child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.network(pay.iconImage,width: 27,),
                  const Padding(padding: EdgeInsets.only(left: 10)),
                   Text(pay.title,style: const TextStyle(fontSize: 15,color: Colors.white)),
                ]
            ),
          ),
        ),
      ));
    }
    return Column(
      children: widgets,
    );
  }
  Widget _dialog(BuildContext context) {
    double sWith = 140;
    if(list.length > 0){
      sWith = sWith + (list.length  * 60);
    }
    return Container(
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(10)),
        color: Colors.white,
      ),
      height: sWith,
      width: ((MediaQuery.of(context).size.width) / 1),
      margin: const EdgeInsets.only(left: 20, right: 20),
      child: Container(
        margin: const EdgeInsets.only(left: 30, right: 30),
        child: Column(
            children: [
              const Padding(padding: EdgeInsets.only(top: 20)),
              const Text('选择支付方式',style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold)),
              _buildPays(context),
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
              const Padding(padding: EdgeInsets.only(top: 30)),
            ]
        ),
      ),
    );
  }
}
