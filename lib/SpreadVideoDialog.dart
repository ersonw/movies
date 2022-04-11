import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:movies/data/Player.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'ImageIcons.dart';
import 'global.dart';
import 'dart:io';

class SpreadVideoDialog extends Dialog {
  Player player;
  String shareUrl;
  GlobalKey repaintKey = GlobalKey();
  bool save = true;
  SpreadVideoDialog({Key? key,required this.player,required this.shareUrl})
      : super(key: key);
  _buildAvatar() {
    if ((userModel.avatar == null || userModel.avatar == '') ||
        userModel.avatar?.contains('http') == false) {
      return const AssetImage(ImageIcons.default_head);
    }
    return NetworkImage(userModel.avatar!);
  }

  @override
  Widget build(BuildContext context) {
    shareUrl = '$shareUrl&video=${player.id}';
    return Center(
      child: Material(

          ///背景透明
          color: Colors.transparent,

          ///保证控件居中效果
          child: Stack(
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
    return Center(
      child: Stack(
        // mainAxisAlignment: MainAxisAlignment.center,
        alignment: Alignment.bottomCenter,
        children: [
          RepaintBoundary(
            key: repaintKey,
            child: Container(
                height: 550,
                margin: const EdgeInsets.all(30),
                decoration:  BoxDecoration(
                  color: save ? Colors.deepOrange : Colors.white,
                  borderRadius: const BorderRadius.all(Radius.circular(10)),
                ),
                child: Column(
                  children: [
                    Container(
                      width: 350,
                      height: 200,
                      margin: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        borderRadius: const BorderRadius.all(Radius.circular(10)),
                        image: DecorationImage(
                          image: NetworkImage(player.pic),
                          fit: BoxFit.fill,
                          alignment: Alignment.center,
                        ),
                      ),
                      // child: Global.buildPlayIcon(() {}),
                    ),
                    Row(
                      children: [
                        Container(
                          margin: const EdgeInsets.all(10),
                          width: (MediaQuery.of(context).size.width) / 1.3,
                          child: Text(player.title.length > 35 ? '${player.title.substring(0,35)}...' : player.title,
                            style: const TextStyle(color: Colors.black,fontSize: 17,fontWeight: FontWeight.normal,overflow: TextOverflow.clip),),
                        )
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          margin: const EdgeInsets.only(left: 10,right: 10, bottom: 60),
                          decoration: BoxDecoration(
                            // borderRadius: const BorderRadius.all(Radius.circular(10)),
                            border: Border.all(width: 2.0, color: Colors.black),
                            color: Colors.white,
                            // image: DecorationImage(
                            //   image: AssetImage(ImageIcons.button_y.assetName),
                            //   fit: BoxFit.fill,
                            // ),
                          ),
                          child: QrImage(
                            data: shareUrl,
                            size: 180,
                            version: QrVersions.auto,
                            embeddedImageStyle: QrEmbeddedImageStyle(
                              size: const Size(36, 36),
                            ),
                            // embeddedImage: _buildAvatar(),
                          ),
                        ),
                      ],
                    ),

                  ],
                )),
          ),
          Container(
            height: 100,
            margin: const EdgeInsets.only(right: 18,left: 18),
            // color: Colors.white,
            child: Column(
              children: [
                InkWell(
                  onTap: () async{
                    if(await Global.requestPhotosPermission() || Platform.isIOS){
                      // state((){
                      //   save = true;
                      // });
                      await Global.capturePng(repaintKey);
                    }
                    Navigator.pop(context);
                  },
                  child: Container(
                    // height: 60,
                    width: (MediaQuery.of(context).size.height) / 3,
                    decoration: const BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage(ImageIcons.yello_btn),
                        fit: BoxFit.fill,
                      ),
                    ),
                    child: Container(
                      margin: const EdgeInsets.only(top:10,bottom:10),
                      child: const Text('保存并分享',style: TextStyle(color: Colors.white,fontSize: 20,fontWeight: FontWeight.normal),textAlign: TextAlign.center,),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
