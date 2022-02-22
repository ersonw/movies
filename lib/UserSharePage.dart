import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:movies/UserShareRecordsPage.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:permission_handler/permission_handler.dart';
import 'dart:ui' as ui;
import 'global.dart';
import 'image_icon.dart';

class UserSharePage extends StatefulWidget {
  const UserSharePage({Key? key}) : super(key: key);

  @override
  _UserSharePage createState() => _UserSharePage();
}

class _UserSharePage extends State<UserSharePage> {
  GlobalKey repaintKey = GlobalKey();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
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
      child: Container(
        width: (MediaQuery.of(context).size.width),
        decoration: BoxDecoration(
          color: Colors.white,
          image: DecorationImage(
            image: NetworkImage(Global.profile.config.bootImage),
            fit: BoxFit.fill,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Container(
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.all(Radius.circular(10)),
                // border: Border.all(width: 2.0, color: Colors.black),
                // color: Colors.yellow,
                image: DecorationImage(
                  image: AssetImage(ImageIcons.button_y.assetName),
                  fit: BoxFit.fill,
                ),
              ),
              width: 200,
              height: 45,
              margin: const EdgeInsets.only(left: 40, right: 40, bottom: 100),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    '已邀请0人',
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 18,
                        fontWeight: FontWeight.bold),
                  )
                ],
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                RepaintBoundary(
                    key: repaintKey,
                    child: Container(
                      margin: const EdgeInsets.only(left: 10,right: 10, bottom: 40),
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
                        data: 'https://img2.woyaogexing.com/2019/09/06/f9afde08c5a4460cb08389a6c7f74c7a!600x600.jpeg',
                        size: 200,
                        version: QrVersions.auto,
                        embeddedImageStyle: QrEmbeddedImageStyle(
                          size: const Size(50, 50),
                        ),
                        embeddedImage: NetworkImage(
                            'https://img2.woyaogexing.com/2019/09/06/f9afde08c5a4460cb08389a6c7f74c7a!600x600.jpeg'),
                      ),
                    )),
                Column(
                  children: [
                    InkWell(
                      onTap: () async{
                        await capturePng();
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius:
                              const BorderRadius.all(Radius.circular(20)),
                          // border: Border.all(width: 2.0, color: Colors.black),
                          // color: Colors.yellow,
                          image: DecorationImage(
                            image: AssetImage(ImageIcons.button_y.assetName),
                            fit: BoxFit.fill,
                          ),
                        ),
                        width: 200,
                        height: 45,
                        margin: const EdgeInsets.only(right: 10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: const [
                            Text(
                              '保存分享二维码',
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold),
                            )
                          ],
                        ),
                      ),
                    ),
                    InkWell(
                      onTap: () {},
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius:
                              const BorderRadius.all(Radius.circular(20)),
                          // border: Border.all(width: 2.0, color: Colors.black),
                          // color: Colors.yellow,
                          image: DecorationImage(
                            image: AssetImage(ImageIcons.button_y.assetName),
                            fit: BoxFit.fill,
                          ),
                        ),
                        width: 200,
                        height: 45,
                        margin: const EdgeInsets.only(right: 10, top: 20),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: const [
                            Text(
                              '复制分享链接',
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold),
                            )
                          ],
                        ),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ],
        ),
      ),
    );
  }

  Future<String?> capturePng() async {
    try {
      print('开始保存');
      RenderRepaintBoundary boundary = repaintKey.currentContext?.findRenderObject()! as RenderRepaintBoundary;
      ui.Image image = await boundary.toImage();
      ByteData byteData = (await image.toByteData(format: ui.ImageByteFormat.png))!;
      final result = await ImageGallerySaver.saveImage(byteData.buffer.asUint8List());
      print(result); // result是图片地址
      Global.showWebColoredToast('保存成功');
    } catch (e) {
      print(e);
    }
    return null;
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }
}
