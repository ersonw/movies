import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:images_picker/images_picker.dart';
import 'package:movies/antd_ttf.dart';
import 'package:movies/data/User.dart';
import 'package:movies/functions.dart';
import 'package:movies/image_form.dart';
import 'package:movies/messagesPage.dart';
import 'package:movies/model/UserModel.dart';
import 'package:movies/profile_tab.dart';
import 'package:movies/scan_button.dart';
import 'package:movies/settings_tab.dart';
import 'package:movies/system_ttf.dart';
import 'package:movies/web_view.dart';
import 'package:movies/xiaoxiong_icon.dart';
import 'package:movies/Take_picture_screen.dart';
import 'package:qr_code_tools/qr_code_tools.dart';
import 'AccountManager.dart';
import 'GetQrcode.dart';
import 'global.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

// import 'package:fluttertoast/fluttertoast.dart';
import 'global.dart';
import 'image_icon.dart';

class MyProfile extends StatefulWidget {
  static const title = '我的';
  static const icon = ImageIcon(ImageIcons.user);

  const MyProfile({Key? key}) : super(key: key);

  @override
  _MyProfile createState() => _MyProfile();
}

class _MyProfile extends State<MyProfile> {
  final UserModel _userModel = UserModel();
  User _user = User();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _user = _userModel.user;
    _userModel.addListener(() {
      setState(() {
        _user = _userModel.user;
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
              child: Icon(SystemTtf.saoyisao, size: 42, color: Colors.grey,),
              onPressed: () {
                showCupertinoModalPopup<void>(
                  context: context,
                  builder: (context) {
                    return CupertinoActionSheet(
                      // title: const Text('扫一扫'),
                      // message: Text('请选择'),
                      actions: [
                        CupertinoActionSheetAction(
                          child: const Text(
                            '相机', style: TextStyle(color: Colors.black),),
                          isDestructiveAction: true,
                          onPressed: () async {
                            Navigator.pop(context);
                            Navigator.of(context, rootNavigator: true).push<void>(
                                CupertinoPageRoute(
                                    // builder: (context) => TakePictureScreen(cameras: Global.cameras, ),
                                    builder: (context) => ScanQRPage(),
                                ),
                            );
                          },
                        ),
                        CupertinoActionSheetAction(
                          child: const Text('相册', style: TextStyle(color: Colors.black)),
                          onPressed: () async {
                            Navigator.pop(context);
                            List<Media>? res = await ImagesPicker.pick(
                              count: 1,
                              pickType: PickType.image,
                              language: Language.System,
                              maxTime: 30,
                              // maxSize: 500,
//                               cropOpt: CropOption(
//                                 aspectRatio: CropAspectRatio.custom,
//                                 cropType: CropType.circle
//                               ),
                            );
                            if (res != null) {
                              var image = res[0].thumbPath;
                              String data = await QrCodeToolsPlugin.decodeFrom(image);
                              if(data.contains('http')){
                                Navigator.push(context, CupertinoPageRoute(
                                  // builder: (context) => TakePictureScreen(cameras: Global.cameras, ),
                                  builder: (context) => WebViewExample(url: data),
                                ),
                                );
                              }else{
                                ShowCopyDialog(context, "二维码提取", data);
                              }
                            }
                          },
                        ),
                      ],
                      cancelButton: CupertinoActionSheetAction(
                        child: const Text('取消'),
                        isDefaultAction: true,
                        onPressed: () => Navigator.pop(context),
                      ),
                    );
                  },
                );
              },
            ),
            CupertinoButton(
              padding: EdgeInsets.zero,
              child: Icon(XiaoXiongIcon.xiaoxi, size: 30, color: Colors.grey,),
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
              child: const Icon(SystemTtf.shezhi, size: 42, color: Colors.grey,),
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
  _buildAvatar(){
    if ((_userModel.avatar == null || _userModel.avatar == '') || _userModel.avatar?.contains('http') == false) {
      return AssetImage('assets/image/default_head.gif');
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
                          style:
                          const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black),
                        )),
                    Container(
                      margin: const EdgeInsets.only(left: 10),
                      width: 35,
                      height: 35,
                      child: Image(image: _user.sex == 0 ? ImageIcons.nan : ImageIcons.nv,),
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
                            style: TextStyle(
                                fontSize: 13,
                                color: Colors.grey
                            ),
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
                            style: TextStyle(
                                fontSize: 13,
                                color: Colors.grey
                            ),
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
                            style: TextStyle(
                                fontSize: 13,
                                color: Colors.grey
                            ),
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
                            style: TextStyle(
                                fontSize: 13,
                                color: Colors.grey
                            ),
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
                            style: TextStyle(
                                fontSize: 13,
                                color: Colors.grey
                            ),
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
                margin: EdgeInsets.only(top: 20),
                width: 350,
                height: 95,
                decoration: BoxDecoration(
                    color: Colors.grey,
                    borderRadius: BorderRadius.circular(10.0),
                    image: DecorationImage(
                      image: ImageIcons.zhipianrenjihua,
                    )
                ),
              ),
            ),
            // 三图片
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
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
                    margin: EdgeInsets.only(top: 20),
                    width: 110,
                    height: 55,
                    decoration: BoxDecoration(
                        color: Colors.grey,
                        borderRadius: BorderRadius.circular(10.0),
                        image: DecorationImage(
                          image: ImageIcons.vipBuy,
                        )
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(top: 20),
                  width: 110,
                  height: 55,
                  decoration: BoxDecoration(
                      color: Colors.grey,
                      borderRadius: BorderRadius.circular(10.0),
                      image: DecorationImage(
                        image: ImageIcons.promote,
                      )
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(top: 20),
                  width: 110,
                  height: 55,
                  decoration: BoxDecoration(
                      color: Colors.grey,
                      borderRadius: BorderRadius.circular(10.0),
                      image: DecorationImage(
                        image: ImageIcons.income,
                      )
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
