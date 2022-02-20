import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:images_picker/images_picker.dart';
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
              child: Icon(
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
                    String data = await QrCodeToolsPlugin.decodeFrom(image);
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
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
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
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  child: Column(
                    children: [
                      Container(
                          margin: const EdgeInsets.only(left: 10, top: 10),
                          child: Text(
                            '${Global.profile.user.gold}',
                            style: const TextStyle(
                                fontSize: 25, fontWeight: FontWeight.bold),
                          )),
                      Container(
                          margin: const EdgeInsets.only(left: 10, top: 10),
                          child: const Text(
                            '金币',
                            style: TextStyle(fontSize: 13, color: Colors.grey),
                          )),
                    ],
                  ),
                ),
                Container(
                  child: Column(
                    children: [
                      Container(
                          margin: const EdgeInsets.only(left: 10, top: 10),
                          child: Text(
                            '${Global.profile.user.diamond}',
                            style: const TextStyle(
                                fontSize: 25, fontWeight: FontWeight.bold),
                          )),
                      Container(
                          margin: const EdgeInsets.only(left: 10, top: 10),
                          child: const Text(
                            '钻石',
                            style: TextStyle(fontSize: 13, color: Colors.grey),
                          )),
                    ],
                  ),
                ),
                Container(
                  child: Column(
                    children: [
                      Container(
                          margin: EdgeInsets.only(left: 10, top: 10),
                          child: Text(
                            '0',
                            style: TextStyle(
                                fontSize: 25, fontWeight: FontWeight.bold),
                          )),
                      Container(
                          margin: EdgeInsets.only(left: 10, top: 10),
                          child: Text(
                            '推荐数',
                            style: TextStyle(fontSize: 13, color: Colors.grey),
                          )),
                    ],
                  ),
                ),
                Container(
                  child: Column(
                    children: [
                      Container(
                          margin: EdgeInsets.only(left: 10, top: 10),
                          child: Text(
                            '0',
                            style: TextStyle(
                                fontSize: 25, fontWeight: FontWeight.bold),
                          )),
                      Container(
                          margin: EdgeInsets.only(left: 10, top: 10),
                          child: Text(
                            '我的关注',
                            style: TextStyle(fontSize: 13, color: Colors.grey),
                          )),
                    ],
                  ),
                ),
                Container(
                  child: Column(
                    children: [
                      Container(
                          margin: EdgeInsets.only(left: 10, top: 10),
                          child: Text(
                            '0',
                            style: TextStyle(
                                fontSize: 25, fontWeight: FontWeight.bold),
                          )),
                      Container(
                          margin: EdgeInsets.only(left: 10, top: 10),
                          child: Text(
                            '我的粉丝',
                            style: TextStyle(fontSize: 13, color: Colors.grey),
                          )),
                    ],
                  ),
                ),
              ],
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
                margin: const EdgeInsets.only(top: 20),
                width: 350,
                height: 95,
                decoration: BoxDecoration(
                    color: Colors.grey,
                    borderRadius: BorderRadius.circular(10.0),
                    image: const DecorationImage(
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
            // const PreferenceCard(
            //   header: 'MY INTENSITY PREFERENCE',
            //   content: '🔥',
            //   preferenceChoices: [
            //     'Super heavy',
            //     'Dial it to 11',
            //     "Head bangin'",
            //     '1000W',
            //     'My neighbor hates me',
            //   ],
            // ),
            // const PreferenceCard(
            //   header: 'CURRENT MOOD',
            //   content: '🤘🏾🚀',
            //   preferenceChoices: [
            //     'Over the moon',
            //     'Basking in sunlight',
            //     'Hello fellow Martians',
            //     'Into the darkness',
            //   ],
            // ),
            Expanded(
              child: Container(),
            ),
            const LogOutButton(),
          ],
        ),
      ),
    );
  }
}
