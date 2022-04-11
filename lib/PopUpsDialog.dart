import 'package:flutter/material.dart';
import 'package:movies/data/SystemMessage.dart';
import 'package:movies/global.dart';
import 'package:url_launcher/url_launcher.dart';

import 'ImageIcons.dart';

class PopUpsDialog extends Dialog {
  String image;
  String url;
  PopUpsDialog(this.image,{Key? key, this.url = ''}) : super(key: key);
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
  Widget _dialog(context){
    // systemMessage.str += systemMessage.str;
    // print(systemMessage.str);
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        InkWell(
          onTap: () async{
            Navigator.pop(context);
            if(url.isNotEmpty){
              if(url.startsWith('http')){
                if(await canLaunch(url)) launch(url);
              }else if(int.tryParse(url) != null){
                Global.playVideo(int.parse(url));
              }
            }
          },
          child: Container(
            margin: const EdgeInsets.all(20),
            height: (MediaQuery.of(context).size.height) / 2,
            width: (MediaQuery.of(context).size.width) / 1,
            decoration: BoxDecoration(
              // color: Colors.black,
              image: DecorationImage(
                image: NetworkImage(image),
                fit: BoxFit.fill,
              ),
            ),
          ),
        ),
        InkWell(
          onTap: () {
            Navigator.pop(context);
          },
          child: Container(
            child: Container(
              margin: const EdgeInsets.only(top:10,bottom: 10, left:30,right: 30),
              child:  Image.asset(ImageIcons.close,width: 60,),
            ),
          ),
        ),
      ],
    );
  }
}