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
  String domian = configModel.config.shareDomain;
  GlobalKey repaintKey = GlobalKey();
  SpreadVideoDialog({Key? key,required this.player})
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
    if(domian != null && !domian.endsWith('/')){
      domian='$domian/';
    }
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
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        RepaintBoundary(
            key: repaintKey,
            child: Container(
                margin: const EdgeInsets.all(30),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.all(Radius.circular(10)),
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
                          child: Text(player.title,
                            style: const TextStyle(color: Colors.black,fontSize: 17,fontWeight: FontWeight.normal,overflow: TextOverflow.ellipsis),),
                        )
                      ],
                    ),
                    Row(
                      // mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                            data: '$domian${player.id}-${userModel.user.invite}',
                            size: 130,
                            version: QrVersions.auto,
                            embeddedImageStyle: QrEmbeddedImageStyle(
                              size: const Size(36, 36),
                            ),
                            // embeddedImage: _buildAvatar(),
                          ),
                        ),
                        Container(
                          margin: const EdgeInsets.only(right: 10),
                          child: Column(
                            children: [
                              Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                children:const [
                                  Text('下载地址：'),
                                ]
                              ),
                              SizedBox(
                                width: (MediaQuery.of(context).size.width) / 2.7,
                                child: Text('$domian${player.id}-${userModel.user.invite}'),
                              ),
                              SizedBox(
                                width: 120,
                                child: TextButton(
                                  style: ButtonStyle(
                                    backgroundColor: MaterialStateProperty.all(Colors.grey),
                                    shape: MaterialStateProperty.all(RoundedRectangleBorder(borderRadius: BorderRadius.circular(16))),
                                  ),
                                  onPressed: () async{
                                    await Clipboard.setData(ClipboardData(text: '$domian${player.id}-${userModel.user.invite}'));
                                    Global.showWebColoredToast('复制成功！');
                                  },
                                  child: const Text('复制链接',style: TextStyle(color: Colors.black),),
                                ),
                              ),
                              SizedBox(
                                width: 120,
                                child: TextButton(
                                  style: ButtonStyle(
                                    backgroundColor: MaterialStateProperty.all(Colors.red),
                                    shape: MaterialStateProperty.all(RoundedRectangleBorder(borderRadius: BorderRadius.circular(16))),
                                  ),
                                  onPressed: () async{
                                    // await capturePng();
                                    // requestPermission();
                                    if(await Global.requestPhotosPermission() || Platform.isIOS){
                                      await Global.capturePng(repaintKey);
                                    }
                                  },
                                  child: const Text('保存图片',style: TextStyle(color: Colors.white),),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),

                  ],
                )),
        ),

      ],
    );
  }
}
