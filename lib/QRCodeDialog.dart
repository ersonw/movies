import 'dart:io';

import 'package:flutter/material.dart';
import 'package:movies/data/SystemMessage.dart';
import 'package:movies/global.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

import 'ImageIcons.dart';

class QRCodeDialog extends Dialog {
  GlobalKey repaintKey = GlobalKey();
  String data;
  QRCodeDialog(this.data,{Key? key}) : super(key: key);
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
  Widget _dialog(context){
    // systemMessage.str += systemMessage.str;
    // print(systemMessage.str);
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        RepaintBoundary(
          key: repaintKey,
          child: Container(
            margin: const EdgeInsets.all(20),
            height: (MediaQuery.of(context).size.height) / 2,
            width: (MediaQuery.of(context).size.width) / 1,
            alignment: Alignment.bottomRight,
            decoration: const BoxDecoration(
              // color: Colors.transparent,
              image: DecorationImage(
                image: AssetImage(ImageIcons.qrcodeBg),
                fit: BoxFit.fill,
              ),
            ),
            child: Container(
              margin: const EdgeInsets.only(right: 35,bottom: 20),
              color: Colors.white,
              child: QrImage(
                data: data,
                size: 110,
                version: QrVersions.auto,
                embeddedImageStyle: QrEmbeddedImageStyle(
                  size: const Size(30, 30),
                ),
                // embeddedImage: _buildAvatar(),
              ),
            ),
          ),
        ),
        InkWell(
          onTap: () async{
            Navigator.pop(context);
            if(await Global.requestPhotosPermission() || Platform.isIOS){
              await Global.capturePng(repaintKey);
            }
          },
          child: Container(
            width: (MediaQuery.of(context).size.width) / 1,
            alignment: Alignment.center,
            height: 60,
            margin: const EdgeInsets.only(top:10,bottom: 10, left:30,right: 30),
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage(ImageIcons.yello_btn),
                fit: BoxFit.fill,
              ),
            ),
            child: const  Text("保存二维码",style: TextStyle(color: Colors.white,fontSize: 20,fontWeight: FontWeight.bold)),
          ),
        ),
      ],
    );
  }
}