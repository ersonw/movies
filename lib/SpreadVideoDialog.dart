import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'global.dart';

class SpreadVideoDialog extends Dialog {
  String title;
  String image;
  GlobalKey repaintKey = GlobalKey();
  SpreadVideoDialog({Key? key, required this.title, required this.image})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
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
                          image: AssetImage(
                              'assets/image/06b6f2f7-484e-41e1-82e8-4b31d199e813.jpg'),
                          fit: BoxFit.fill,
                          alignment: Alignment.center,
                        ),
                      ),
                      child: Global.buildPlayIcon(() {
                        print(title);
                      }),
                    ),
                    Row(
                      children: [
                        Container(
                          margin: const EdgeInsets.all(10),
                          width: (MediaQuery.of(context).size.width) / 1.3,
                          child: Text(title,
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
                            data: 'https://img2.woyaogexing.com/2019/09/06/f9afde08c5a4460cb08389a6c7f74c7a!600x600.jpeg',
                            size: 130,
                            version: QrVersions.auto,
                            embeddedImageStyle: QrEmbeddedImageStyle(
                              size: const Size(50, 50),
                            ),
                            // embeddedImage: NetworkImage('https://img2.woyaogexing.com/2019/09/06/f9afde08c5a4460cb08389a6c7f74c7a!600x600.jpeg'),
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
                                child: Text('https://img2.woyaogexing.com/2019/09/06'),
                              ),
                              SizedBox(
                                width: 120,
                                child: TextButton(
                                  style: ButtonStyle(
                                    backgroundColor: MaterialStateProperty.all(Colors.grey),
                                    shape: MaterialStateProperty.all(RoundedRectangleBorder(borderRadius: BorderRadius.circular(16))),
                                  ),
                                  onPressed: () async{
                                    await Clipboard.setData(ClipboardData(text: 'test'));
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
                                    if(await Global.requestPhotosPermission()){
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
