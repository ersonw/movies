import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:images_picker/images_picker.dart';
import 'package:movies/BuyDiamondPage.dart';
import 'package:movies/UserSharePage.dart';
import 'package:movies/VIPBuyPage.dart';
import 'package:movies/data/User.dart';
import 'package:movies/functions.dart';
import 'package:movies/messagesPage.dart';
import 'package:movies/profile_tab.dart';
import 'package:movies/settings_tab.dart';
import 'package:movies/system_ttf.dart';
import 'package:movies/web_view.dart';
import 'package:movies/xiaoxiong_icon.dart';
import 'package:qr_code_tools/qr_code_tools.dart';
import 'AccountManager.dart';
import 'BuyGoldPage.dart';
import 'GetQrcode.dart';
import 'global.dart';
import 'image_icon.dart';
import 'dart:ui';

class MyProfile extends StatefulWidget {
  static const title = '我的';
  static const icon = ImageIcon(ImageIcons.user);

  const MyProfile({Key? key}) : super(key: key);

  @override
  _MyProfile createState() => _MyProfile();
}

class _MyProfile extends State<MyProfile> {
  User _user = User();
  final _width = window.physicalSize.width;
  final _height = window.physicalSize.height;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _user = userModel.user;
    userModel.addListener(() {
      setState(() {
        _user = userModel.user;
      });
    });
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
              child: const Icon(
                SystemTtf.saoyisao,
                size: 42,
                color: Colors.grey,
              ),
              onPressed: () {
                List<BottomMenu> lists = [];
                BottomMenu bottonMenu = BottomMenu();
                bottonMenu.title = '相机';
                bottonMenu.fn = () {
                  Navigator.of(context, rootNavigator: true).push<void>(
                    CupertinoPageRoute(
                      // builder: (context) => TakePictureScreen(cameras: Global.cameras, ),
                      builder: (context) => const ScanQRPage(),
                    ),
                  );
                };
                lists.add(bottonMenu);
                bottonMenu = BottomMenu();
                bottonMenu.title = '相册';
                bottonMenu.fn = () async {
                  List<Media>? res = await ImagesPicker.pick(
                    count: 1,
                    pickType: PickType.image,
                    language: Language.System,
                  );
                  if (res != null) {
                    var image = res[0].thumbPath;
                    String data = await QrCodeToolsPlugin.decodeFrom(image)
                        .catchError(() => {});
                    if (data.isEmpty) return;
                    if (data.contains('http')) {
                      Navigator.push(
                        context,
                        CupertinoPageRoute(
                          // builder: (context) => TakePictureScreen(cameras: Global.cameras, ),
                          builder: (context) => WebViewExample(url: data),
                        ),
                      );
                    } else {
                      ShowCopyDialog(context, "二维码提取", data);
                    }
                  }
                };
                lists.add(bottonMenu);
                ShowBottomMenu(context, lists);
              },
            ),
            CupertinoButton(
              padding: EdgeInsets.zero,
              child: Icon(
                XiaoXiongIcon.xiaoxi,
                size: 30,
                color: Colors.grey,
              ),
              onPressed: () {
                // This pushes the settings page as a full page modal dialog on top
                // of the tab bar and everything.
                Navigator.of(context, rootNavigator: true).push<void>(
                  CupertinoPageRoute(
                    title: MessagesPage.title,
                    // fullscreenDialog: true,
                    builder: (context) => const MessagesPage(),
                  ),
                );
              },
            ),
            CupertinoButton(
              padding: EdgeInsets.zero,
              child: const Icon(
                SystemTtf.shezhi,
                size: 42,
                color: Colors.grey,
              ),
              onPressed: () {
                // This pushes the settings page as a full page modal dialog on top
                // of the tab bar and everything.
                Navigator.of(context, rootNavigator: true).push<void>(
                  CupertinoPageRoute(
                    title: SettingsTab.title,
                    // fullscreenDialog: true,
                    builder: (context) => const SettingsTab(),
                  ),
                );
              },
            ),
          ],
        ),
      ),
      child: _buildBody(context),
    );
  }

  _buildAvatar() {
    if ((_user.avatar == null || _user.avatar == '') ||
        _user.avatar?.contains('http') == false) {
      return const AssetImage('assets/image/default_head.gif');
    }
    return NetworkImage(_user.avatar!);
  }

  Widget _buildBody(BuildContext context) {
    return  Container(
      margin: const EdgeInsets.all(15),
      child: Column(
        // mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // 头像用户名
          TextButton(
            onPressed: () {
              Navigator.of(context, rootNavigator: true).push<void>(
                CupertinoPageRoute(
                  title: '账号管理',
                  // fullscreenDialog: true,
                  builder: (context) => const AccountManager(),
                ),
              );
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Container(
                  width: 80,
                  height: 80,
                  // margin: EdgeInsets.only(left: vw()),
                  decoration: BoxDecoration(
                      color: Colors.grey,
                      borderRadius: BorderRadius.circular(50.0),
                      image: DecorationImage(
                        // image: AssetImage('assets/image/default_head.gif'),
                        image: _buildAvatar(),
                      )),
                ),
                Container(
                    margin: const EdgeInsets.only(left: 10, top: 10),
                    child: Text(
                      _user.nickname,
                      style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.black),
                    )),
                Container(
                  margin: const EdgeInsets.only(left: 10),
                  width: 35,
                  height: 35,
                  child: Image(
                    image: _user.sex == 0 ? ImageIcons.nan : ImageIcons.nv,
                  ),
                )
              ],
            ),
          ),
          // 金币数
         SizedBox(
          width: ((MediaQuery.of(context).size.width) / 1.1),
           child:  Row(
             mainAxisAlignment: MainAxisAlignment.spaceBetween,
             children: [
               const Padding(padding: EdgeInsets.only(top: 10,bottom: 10,left: 5,right: 5)),
               InkWell(
                 onTap: () => _enterGold(),
                 child: Column(
                   children: [
                     Text(Global.getNumbersToChinese(userModel.user.gold),
                       style: const TextStyle(
                           fontSize: 20, fontWeight: FontWeight.bold),
                     ),
                     const Text(
                       '金币',
                       style: TextStyle(fontSize: 13, color: Colors.grey),
                     ),
                   ],
                 ),
               ),
               InkWell(
                 onTap: () => _enterDiamond(),
                 child: Column(
                   children: [
                     Text(Global.getNumbersToChinese(userModel.user.diamond),
                       style: const TextStyle(
                           fontSize: 20, fontWeight: FontWeight.bold),
                     ),
                     const Text(
                       '钻石',
                       style: TextStyle(fontSize: 13, color: Colors.grey),
                     ),
                   ],
                 ),
               ),
               InkWell(
                 child: Column(
                   children: [
                     Container(
                         // margin: EdgeInsets.only(left: 10, top: 10),
                         child: Text(
                           '0',
                           style: TextStyle(
                               fontSize: 25, fontWeight: FontWeight.bold),
                         )),
                     Container(
                         // margin: EdgeInsets.only(left: 10, top: 10),
                         child: Text(
                           '推荐数',
                           style: TextStyle(fontSize: 13, color: Colors.grey),
                         )),
                   ],
                 ),
               ),
               InkWell(
                 child: Column(
                   children: [
                     Container(
                         // margin: EdgeInsets.only(left: 10, top: 10),
                         child: Text(
                           '0',
                           style: TextStyle(
                               fontSize: 25, fontWeight: FontWeight.bold),
                         )),
                     Container(
                         // margin: EdgeInsets.only(left: 10, top: 10),
                         child: Text(
                           '我的关注',
                           style: TextStyle(fontSize: 13, color: Colors.grey),
                         )),
                   ],
                 ),
               ),
               InkWell(
                 child: Column(
                   children: [
                     Container(
                         // margin: EdgeInsets.only(left: 10, top: 10),
                         child: Text(
                           '0',
                           style: TextStyle(
                               fontSize: 25, fontWeight: FontWeight.bold),
                         )),
                     Container(
                         // margin: EdgeInsets.only(left: 10, top: 10),
                         child: Text(
                           '我的粉丝',
                           style: TextStyle(fontSize: 13, color: Colors.grey),
                         )),
                   ],
                 ),
               ),
             ],
           ),
         ),
          InkWell(
            onTap: (() {
              // Fluttertoast.showToast(msg: '点击我了');
              Navigator.of(context, rootNavigator: true).push<void>(
                CupertinoPageRoute(
                  title: SettingsTab.title,
                  fullscreenDialog: true,
                  builder: (context) => const SettingsTab(),
                ),
              );
            }),
            child: Container(
              margin: const EdgeInsets.all(10),
              // width: (MediaQuery.of(context).size.width),
              height: 95,
              decoration: BoxDecoration(
                  color: Colors.grey,
                  borderRadius: BorderRadius.circular(5.0),
                  image: const DecorationImage(
                    fit: BoxFit.fill,
                    image: ImageIcons.zhipianrenjihua,
                  )),
            ),
          ),
          // 三图片
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              InkWell(
                onTap: (() {
                  // Fluttertoast.showToast(msg: '点击我了');
                  Navigator.of(context, rootNavigator: true).push<void>(
                    CupertinoPageRoute(
                      title: "VIP购买",
                      // fullscreenDialog: true,
                      builder: (context) => const VIPBuyPage(),
                    ),
                  );
                }),
                child: Container(
                  margin: const EdgeInsets.only(top: 10),
                  width: ((MediaQuery.of(context).size.width) / 3.5),
                  height: 70,
                  decoration: BoxDecoration(
                      color: Colors.transparent,
                      borderRadius: BorderRadius.circular(10.0),
                      image: const DecorationImage(
                        fit: BoxFit.fill,
                        image: ImageIcons.vipBuy,
                      )),
                ),
              ),
              InkWell(
                onTap: () {
                  Navigator.of(context, rootNavigator: true).push<void>(
                    CupertinoPageRoute(
                      title: "推广分享",
                      // fullscreenDialog: true,
                      builder: (context) => const UserSharePage(),
                    ),
                  );
                },
                child: Container(
                  margin: const EdgeInsets.only(top: 10),
                  width: ((MediaQuery.of(context).size.width) / 3.5),
                  height: 70,
                  decoration: BoxDecoration(
                      color: Colors.transparent,
                      borderRadius: BorderRadius.circular(10.0),
                      image: const DecorationImage(
                        fit: BoxFit.fill,
                        image: ImageIcons.promote,
                      )),
                ),
              ),
              InkWell(
                child: Container(
                  margin: const EdgeInsets.only(top: 10),
                  width: ((MediaQuery.of(context).size.width) / 3.5),
                  height: 70,
                  decoration: BoxDecoration(
                      color: Colors.grey,
                      borderRadius: BorderRadius.circular(10.0),
                      image: const DecorationImage(
                        fit: BoxFit.fill,
                        image: ImageIcons.income,
                      )),
                ),
              ),
            ],
          ),
          Container(
            width: (MediaQuery.of(context).size.width),
            // height: 200,
            margin: const EdgeInsets.only(top: 20),
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.all(Radius.circular(10)),
              border: Border.all(width: 1.0, color: Colors.black12),
              // color: Colors.white30,
              // image: DecorationImage(
              //   image: AssetImage(ImageIcons.button_y.assetName),
              //   fit: BoxFit.fill,
              // ),
            ),
            child: Container(
              margin: const EdgeInsets.all(10),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      TextButton(
                        onPressed: () => _enterDiamond(),
                        child: Column(
                          children: [
                            Image.asset(
                              ImageIcons.goumaizuanshi.assetName,
                              width: 45,
                              height: 45,
                            ),
                            const Text(
                              '购买钻石',
                              style: TextStyle(
                                  color: Colors.black, fontSize: 14),
                            ),
                          ],
                        ),
                      ),
                      TextButton(
                        onPressed: () => _enterGold(),
                        child: Column(
                          children: [
                            Image.asset(
                              ImageIcons.goumaijinbi.assetName,
                              width: 45,
                              height: 45,
                            ),
                            const Text(
                              '购买金币',
                              style: TextStyle(color: Colors.black),
                            ),
                          ],
                        ),
                      ),
                      TextButton(
                        onPressed: () {},
                        child: Column(
                          children: [
                            Image.asset(
                              ImageIcons.wodeshoucang.assetName,
                              width: 45,
                              height: 45,
                            ),
                            const Text(
                              '我的收藏',
                              style: TextStyle(color: Colors.black),
                            ),
                          ],
                        ),
                      ),
                      TextButton(
                        onPressed: () {},
                        child: Column(
                          children: [
                            Image.asset(
                              ImageIcons.goumaizuanshi.assetName,
                              width: 45,
                              height: 45,
                            ),
                            const Text(
                              '我的下载',
                              style: TextStyle(color: Colors.black),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      TextButton(
                        onPressed: () {},
                        child: Column(
                          children: [
                            Image.asset(
                              ImageIcons.kaichejinqun.assetName,
                              width: 45,
                              height: 45,
                            ),
                            const Text(
                              '开车进群',
                              style: TextStyle(color: Colors.black),
                            ),
                          ],
                        ),
                      ),
                      TextButton(
                        onPressed: () {},
                        child: Column(
                          children: [
                            Image.asset(
                              ImageIcons.bangzhufankui.assetName,
                              width: 45,
                              height: 45,
                            ),
                            const Text(
                              '帮助反馈',
                              style: TextStyle(color: Colors.black),
                            ),
                          ],
                        ),
                      ),
                      TextButton(
                        onPressed: () {},
                        child: Column(
                          children: [
                            Image.asset(
                              ImageIcons.guankanjilu.assetName,
                              width: 45,
                              height: 45,
                            ),
                            const Text(
                              '观看记录',
                              style: TextStyle(color: Colors.black),
                            ),
                          ],
                        ),
                      ),
                      TextButton(
                        onPressed: () {},
                        child: Column(
                          children: [
                            Image.asset(
                              ImageIcons.yingyongzhongxin.assetName,
                              width: 45,
                              height: 45,
                            ),
                            const Text(
                              '应用中心',
                              style: TextStyle(color: Colors.black),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: Container(),
          ),
          // const LogOutButton(),
        ],
      ),
    );
  }

  void _enterDiamond() {
    Navigator.of(context, rootNavigator: true)
        .push<void>(
          CupertinoPageRoute(
            title: '钻石钱包',
            // fullscreenDialog: true,
            builder: (context) => const BuyDiamondPage(),
          ),
        )
        .then((value) => setState(() {
              Global.getUserInfo();
            }));
  }
  void _enterGold() {
    Navigator.of(context, rootNavigator: true)
        .push<void>(
      CupertinoPageRoute(
        title: '金币钱包',
        // fullscreenDialog: true,
        builder: (context) => const BuyGoldPage(),
      ),
    )
        .then((value) => setState(() {
      Global.getUserInfo();
    }));
  }
}


