import 'dart:convert';
import 'dart:typed_data';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:movies/UserShareRecordsPage.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'HttpManager.dart';
import 'ImageIcons.dart';
import 'functions.dart';
import 'global.dart';
import 'image_icon.dart';
import 'network/NWApi.dart';
import 'network/NWMethod.dart';

class UserSharePage extends StatefulWidget {
  const UserSharePage({Key? key}) : super(key: key);

  @override
  _UserSharePage createState() => _UserSharePage();
}

class _UserSharePage extends State<UserSharePage> {
  GlobalKey repaintKey = GlobalKey();
  String domian = configModel.config.domain;
  int count = 0;
  String? bgImage;
  String shareText='推广奖励';
  String shareUrl='';

  @override
  void initState() {
    // TODO: implement initState
    _initCount();
    super.initState();
  }
  _buildAvatar() {
    if ((userModel.avatar == null || userModel.avatar == '') ||
        userModel.avatar?.contains('http') == false) {
      return const AssetImage(ImageIcons.default_head);
    }
    return NetworkImage(userModel.avatar!);
  }
  _initCount() async {
    Map<String, dynamic> parm = {};
    String? result = (await DioManager().requestAsync(
        NWMethod.GET, NWApi.getShareCount, {"data": jsonEncode(parm)}));
    if (result != null) {
      // print(result);
      Map<String, dynamic> map = jsonDecode(result);
      if(map['count'] != null){
        setState(() {
          count = map['count'];
        });
      }
      if(map['bgImage'] != null){
        setState(() {
          bgImage = map['bgImage'];
        });
      }
      if(map['shareText'] != null){
        setState(() {
          shareText = map['shareText'];
        });
      }
      if(map['shareUrl'] != null){
        setState(() {
          shareText = map['shareUrl'];
        });
      }
    }
  }
  _buildBgImage(){
    if(bgImage == null || bgImage == ''){
      return const AssetImage(ImageIcons.shareBgImage);
    }
    return NetworkImage(bgImage!);
  }
  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        trailing: Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              CupertinoButton(
                padding: EdgeInsets.zero,
                onPressed: () {
                  Navigator.of(context, rootNavigator: true).push<void>(
                    CupertinoPageRoute(
                      title: '邀请记录',
                      builder: (context) => const UserShareRecordsPage(),
                    ),
                  );
                },
                child: const Text(
                  "邀请记录",
                  style: TextStyle(color: Colors.black, fontSize: 18),
                ),
              ),
            ]),
      ),
      child: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          RepaintBoundary(
              key: repaintKey,
              child: Container(
                width: (MediaQuery.of(context).size.width),
                decoration: BoxDecoration(
                  color: Colors.white,
                  image: DecorationImage(
                    image: _buildBgImage(),
                    fit: BoxFit.fill,
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [

                    Container(
                      // margin: const EdgeInsets.only(left: 15, bottom: 90),
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
                        size: 170,
                        version: QrVersions.auto,
                        embeddedImageStyle: QrEmbeddedImageStyle(
                          size: const Size(30, 30),
                        ),
                        // embeddedImage: _buildAvatar(),
                      ),
                    ),
                    const Padding(padding: EdgeInsets.only(top: 10)),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text('邀请码',style: TextStyle(color: Colors.black,fontSize: 16,fontWeight: FontWeight.bold)),
                        const Padding(padding: EdgeInsets.only(left: 20)),
                        Text(userModel.user.invite!,style: const TextStyle(color: Colors.redAccent,fontWeight: FontWeight.bold,fontSize: 18),),
                        const Padding(padding: EdgeInsets.only(left: 20)),
                        InkWell(
                          onTap: () async{
                            await Clipboard.setData(ClipboardData(text: shareUrl,));
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              border: Border.all(width: 1.0, color: Colors.deepOrange),
                              borderRadius: BorderRadius.circular(30),
                            ),
                            child: Container(
                              margin: const EdgeInsets.only(left: 10,right: 10),
                              child: Text('复制',style: TextStyle(fontSize: 15,color: Colors.deepOrangeAccent,fontWeight: FontWeight.bold),textAlign: TextAlign.center),
                            ),
                          ),
                        ),
                      ],
                    ),
                    Container(
                      width: 300,
                      // color: Colors.white,
                      decoration: const BoxDecoration(
                        // border: Border(bottom: BorderSide(color: Colors.black, width: 1)),
                      ),
                      child: Container(
                        margin: const EdgeInsets.all(5),
                        child: Text(shareText.length > 36 ? '${shareText.substring(0,36)}...' : shareText,style: const TextStyle(color: Colors.black,fontSize: 15),),
                      ),
                    ),
                    const Padding(padding: EdgeInsets.only(top: 10)),
                  ],
                ),
              ),
          ),

          Container(
            height: 250,
            // color: Colors.black54,
            margin:  EdgeInsets.only(left: 40, right: 40,bottom: ((MediaQuery.of(context).size.height) / 2.8)),
            child: Column(
              children: [
                InkWell(
                  onTap: (){
                    _initCount();
                  },
                  child: Container(
                    // decoration: BoxDecoration(
                    //   borderRadius: const BorderRadius.all(Radius.circular(10)),
                    //   // border: Border.all(width: 2.0, color: Colors.black),
                    //   // color: Colors.yellow,
                    //   image: DecorationImage(
                    //     image: AssetImage(ImageIcons.button_y.assetName),
                    //     fit: BoxFit.fill,
                    //   ),
                    // ),
                    width: 200,
                    height: 45,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          '已邀请$count人',
                          style: const TextStyle(
                              color: Colors.black,
                              fontSize: 18,
                              fontWeight: FontWeight.bold),
                        )
                      ],
                    ),
                  ),
                ),
                // const Padding(padding: EdgeInsets.only(top: 5)),

              ],
            ),
          ),
          Container(
            height: 100,
            margin: const EdgeInsets.only(right: 18,left: 18),
            // color: Colors.black54,
            child: Column(
              children: [
                InkWell(
                  onTap: () async{
                    if(await Global.requestPhotosPermission() || Platform.isIOS){
                      await Global.capturePng(repaintKey);
                    }
                  },
                  child: Container(
                    height: 60,
                    decoration: const BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage(ImageIcons.share_btn),
                        fit: BoxFit.fill,
                      ),
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



  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }
}
