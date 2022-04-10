import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
// import 'package:images_picker/images_picker.dart';
import 'package:movies/BuyDiamondPage.dart';
import 'package:movies/CollectsPage.dart';
import 'package:movies/KeFuMessagePage.dart';
import 'package:movies/MyRecommendedPage.dart';
import 'package:movies/OrderRecordsPage.dart';
import 'package:movies/UserSharePage.dart';
import 'package:movies/VIPBuyPage.dart';
import 'package:movies/VideoRecordsPage.dart';
import 'package:movies/data/User.dart';
import 'package:movies/functions.dart';
import 'package:movies/messagesPage.dart';
import 'package:movies/profile_tab.dart';
import 'package:movies/settings_tab.dart';
import 'package:movies/system_ttf.dart';
import 'package:movies/web_view.dart';
import 'package:movies/xiaoxiong_icon.dart';
import 'package:path/path.dart';
import 'package:qr_code_tools/qr_code_tools.dart';
import 'package:url_launcher/url_launcher.dart';
import 'AccountManager.dart';
import 'dart:io';
import 'BuyGoldPage.dart';
import 'FansPage.dart';
import 'FollowsPage.dart';
import 'GetQrcode.dart';
import 'ImageIcons.dart';
import 'InviteCodeInputPage.dart';
import 'SlideRightRoute.dart';
import 'global.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:ui';

class MyProfile extends StatefulWidget {

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
      // print(userModel.user);
      setState(() {
        _user = userModel.user;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    // return Scaffold(
    //   floatingActionButton: FloatingActionButton(
    //       child: Image.asset(
    //         ImageIcons.game.assetName,
    //         width: 60,
    //       ),
    //       onPressed: () {
    //         setState(() {
    //           _tabController.index = 2;
    //         });
    //       },
    //       backgroundColor: Colors.transparent),
    //   floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    //   body: _buildHomePage(context),
    // );
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
                      builder: (context) =>  ScanQRPage(
                        fn: (data){
                          if(data != null) {
                            if(data.startsWith(configModel.config.domain)){
                              Global.handlerScan(data);
                              return;
                            }
                            if (data.contains('http')) {
                              Global.openWebview(data);
                            } else {
                              ShowCopyDialog(context, "二维码提取", data);
                            }
                          }
                        },
                      ),
                    ),
                  );
                };
                lists.add(bottonMenu);
                bottonMenu = BottomMenu();
                bottonMenu.title = '相册';
                bottonMenu.fn = () async {
                  // await Global.requestPhotosPermission();
                  // List<Media>? res = await ImagesPicker.pick(
                  //   count: 1,
                  //   pickType: PickType.image,
                  //   language: Language.System,
                  // );
                  // if (res != null) {
                  String res = await getImage(false);
                  if (res.isNotEmpty) {
                    var image = res;
                    String data = await QrCodeToolsPlugin.decodeFrom(image)
                        .catchError((Object o, StackTrace s)  {
                          print(o.toString());
                    });
                    if (data == null || data.isEmpty) return;
                    if(data.startsWith(configModel.config.domain)){
                      Global.handlerScan(data);
                      return;
                    }
                    if (data.contains('http')) {
                      Global.openWebview(data);
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
              child: const Icon(
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
      return const AssetImage(ImageIcons.default_head);
    }
    return NetworkImage(_user.avatar!);
  }
  Future<String> getImage(isTakePhoto) async {
    // Navigator.pop(context); // 选完图片后 关闭底部弹框
    File? image = await ImagePicker.pickImage(
        source: isTakePhoto ? ImageSource.camera : ImageSource.gallery);
    if(image == null){
      return '';
    }
    return image.path;
  }
  Widget _buildBody(BuildContext context) {
    return  Column(
      children: [
        Expanded(
          child: Container(
            margin: const EdgeInsets.all(5),
            child:  SingleChildScrollView(
              child: Flex(
                // mainAxisAlignment: MainAxisAlignment.center,
                direction: Axis.vertical,
                children: [
                  // 头像用户名
                  InkWell(
                    onTap: (){
                      Navigator.push(Global.MainContext, SlideRightRoute(page: const AccountManager())).then((value) => setState(() {Global.getUserInfo();}));
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Container(
                          width: 80,
                          height: 80,
                          margin: EdgeInsets.only(left: 20),
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
                          child: Column(
                            children: [
                              Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Text(
                                      _user.nickname,
                                      style: const TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black),
                                    ),
                                  ]
                              ),
                            ],
                          ),
                        ),
                        Container(
                          margin: const EdgeInsets.only(left: 10),
                          width: 25,
                          height: 25,
                          child: Image.asset(_user.sex == 0 ? ImageIcons.nan : ImageIcons.nv,
                          ),
                        )
                      ],
                    ),
                  ),
                  const Padding(padding: EdgeInsets.only(top: 10)),
                  // 金币数
                  SizedBox(
                    width: ((MediaQuery.of(context).size.width) / 1),
                    child:  Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Padding(padding: EdgeInsets.only(top: 10,left: 5)),
                        InkWell(
                          onTap: () => _enterGold(context),
                          child: Column(
                            children: [
                              Text(Global.getNumbersToChinese(userModel.user.gold),
                                style: const TextStyle(
                                  fontSize: 18, ),
                              ),
                              const Text(
                                '金币',
                                style: TextStyle(fontSize: 12, color: Colors.grey),
                              ),
                            ],
                          ),
                        ),
                        InkWell(
                          onTap: () => _enterDiamond(context),
                          child: Column(
                            children: [
                              Text(Global.getNumbersToChinese(userModel.user.diamond),
                                style: const TextStyle(
                                  fontSize: 18, ),
                              ),
                              const Text(
                                '钻石',
                                style: TextStyle(fontSize: 12, color: Colors.grey),
                              ),
                            ],
                          ),
                        ),
                        InkWell(
                          onTap: (){
                            // Navigator.of(context, rootNavigator: true).push<void>(
                            //   CupertinoPageRoute(
                            //     title: "推荐记录",
                            //     // fullscreenDialog: true,
                            //     builder: (context) => const MyRecommendedPage(),
                            //   ),
                            // );
                            Navigator.push(Global.MainContext, SlideRightRoute(page: const MyRecommendedPage())).then((value) => setState(() {Global.getUserInfo();}));

                          },
                          child: Column(
                            children: [
                              Text(
                                Global.getNumbersToChinese(userModel.user.remommends),
                                style: const TextStyle(
                                  fontSize: 18,),
                              ),
                              const Text(
                                '推荐',
                                style: TextStyle(fontSize: 12, color: Colors.grey),
                              ),
                            ],
                          ),
                        ),
                        InkWell(
                          onTap: (){
                            // Navigator.of(context, rootNavigator: true).push<void>(
                            //   CupertinoPageRoute(
                            //     title: "关注列表",
                            //     // fullscreenDialog: true,
                            //     builder: (context) => const FollowsPage(),
                            //   ),
                            // );
                            Navigator.push(Global.MainContext, SlideRightRoute(page: const FollowsPage())).then((value) => setState(() {Global.getUserInfo();}));

                          },
                          child: Column(
                            children: [
                              Text(
                                Global.getNumbersToChinese(userModel.user.follows),
                                style: const TextStyle(
                                  fontSize: 18, ),
                              ),
                              const Text(
                                '关注',
                                style: TextStyle(fontSize: 12, color: Colors.grey),
                              ),
                            ],
                          ),
                        ),
                        InkWell(
                          onTap: (){
                            // Navigator.of(context, rootNavigator: true).push<void>(
                            //   CupertinoPageRoute(
                            //     title: "粉丝列表 ",
                            //     // fullscreenDialog: true,
                            //     builder: (context) => const FansPage(),
                            //   ),
                            // );
                            Navigator.push(Global.MainContext, SlideRightRoute(page: const FansPage())).then((value) => setState(() {Global.getUserInfo();}));

                          },
                          child: Column(
                            children: [
                              Text(
                                Global.getNumbersToChinese(userModel.user.fans),
                                style: const TextStyle(
                                  fontSize: 18, ),
                              ),
                              const Text(
                                '粉丝',
                                style: TextStyle(fontSize: 12, color: Colors.grey),
                              ),
                            ],
                          ),
                        ),
                        const Padding(padding: EdgeInsets.only(right: 5)),
                      ],
                    ),
                  ),
                  InkWell(
                    onTap: (() {
                      Navigator.push(Global.MainContext, SlideRightRoute(page: const VIPBuyPage())).then((value) => setState(() {Global.getUserInfo();}));
                    }),
                    child: Stack(
                        alignment: Alignment.bottomLeft,
                        children: [
                          Container(
                            margin: const EdgeInsets.only(top: 10,left:5,right:5),
                            // width: ((MediaQuery.of(context).size.width) / 3.2),
                            height: 60,
                            decoration: BoxDecoration(
                              color: Colors.transparent,
                              borderRadius: BorderRadius.circular(10.0),
                              image: const DecorationImage(
                                fit: BoxFit.fill,
                                image: AssetImage(ImageIcons.vipBuy),
                              ),
                            ),
                          ),
                          Container(
                            height: 25,
                            margin: const EdgeInsets.only(left: 70),
                            child: Text(
                                userModel.user.expired > DateTime.now().millisecondsSinceEpoch ? '您的会员将在${Global.getDateToString(_user.expired)}到期' : '尚未开通会员',
                                style: const TextStyle(color: Colors.white,fontSize: 12)),
                          ),
                        ]
                    ),
                  ),
                  // 三图片
                  // const Padding(padding: EdgeInsets.only(top:20)),
                  Container(
                    margin: const EdgeInsets.only(top: 10,left:5,right:5),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        InkWell(
                          onTap: () {
                            if(userModel.user.invite == null){
                              ShowAlertDialog(context, '友情提示','为了您的账号安全，未绑定手机号无法进行推广哟');
                              return;
                            }
                            Navigator.push(Global.MainContext, SlideRightRoute(page: const UserSharePage())).then((value) => setState(() {Global.getUserInfo();}));
                          },
                          child: Container(
                            // margin: const EdgeInsets.only(top: 10),
                            width: ((MediaQuery.of(context).size.width) / 2.2),
                            height: 54,
                            decoration: BoxDecoration(
                                color: Colors.transparent,
                                borderRadius: BorderRadius.circular(10.0),
                                image: const DecorationImage(
                                  fit: BoxFit.fill,
                                  image: AssetImage(ImageIcons.promote),
                                )),
                          ),
                        ),
                        InkWell(
                          onTap: (){
                            Global.showWebColoredToast('暂未开放，敬请期待!');
                          },
                          child: Container(
                            // margin: const EdgeInsets.only(top: 10),
                            width: ((MediaQuery.of(context).size.width) / 2.2),
                            height: 54,
                            decoration: BoxDecoration(
                                color: Colors.grey,
                                borderRadius: BorderRadius.circular(10.0),
                                image: const DecorationImage(
                                  fit: BoxFit.fill,
                                  image: AssetImage(ImageIcons.income),
                                )),
                          ),
                        ),
                      ],
                    ),
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
                                onPressed: () => _enterDiamond(context),
                                child: Column(
                                  children: [
                                    Image.asset(
                                      ImageIcons.goumaizuanshi,
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
                                onPressed: () => _enterGold(context),
                                child: Column(
                                  children: [
                                    Image.asset(
                                      ImageIcons.goumaijinbi,
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
                                onPressed: () {
                                  // Navigator.of(context, rootNavigator: true).push<void>(
                                  //   CupertinoPageRoute(
                                  //     // title: "推广分享",
                                  //     // fullscreenDialog: true,
                                  //     builder: (context) => const CollectsPage(),
                                  //   ),
                                  // );
                                  Navigator.push(Global.MainContext, SlideRightRoute(page: const CollectsPage())).then((value) => setState(() {Global.getUserInfo();}));
                                },
                                child: Column(
                                  children: [
                                    Image.asset(
                                      ImageIcons.wodeshoucang,
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
                                onPressed: () => Global.showDownloadPage(),
                                child: Column(
                                  children: [
                                    Image.asset(
                                      ImageIcons.wodexiazai,
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
                                onPressed: () async{
                                  String url = configModel.config.groupLink;
                                  if(await canLaunch(url)) launch(url);
                                },
                                child: Column(
                                  children: [
                                    Image.asset(
                                      ImageIcons.kaichejinqun,
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
                                onPressed: () {
                                  // Navigator.of(context, rootNavigator: true).push<void>(
                                  //   CupertinoPageRoute(
                                  //     title: '我的钱包',
                                  //     // fullscreenDialog: true,
                                  //     builder: (context) => const BalancePage(),
                                  //   ),
                                  // );
                                  Navigator.push(Global.MainContext, SlideRightRoute(page: const InviteCodeInputPage())).then((value) => setState(() {Global.getUserInfo();}));
                                },
                                child: Column(
                                  children: [
                                    Image.asset(
                                      ImageIcons.yingyongzhongxin,
                                      width: 45,
                                      height: 45,
                                    ),
                                    const Text(
                                      '兑换码',
                                      style: TextStyle(color: Colors.black),
                                    ),
                                  ],
                                ),
                              ),
                              TextButton(
                                onPressed: () {
                                  // Navigator.of(context, rootNavigator: true).push<void>(
                                  //   CupertinoPageRoute(
                                  //     title: '观看记录',
                                  //     // fullscreenDialog: true,
                                  //     builder: (context) => const VideoRecordsPage(),
                                  //   ),
                                  // );
                                  Navigator.push(Global.MainContext, SlideRightRoute(page: const VideoRecordsPage())).then((value) => setState(() {Global.getUserInfo();}));

                                },
                                child: Column(
                                  children: [
                                    Image.asset(
                                      ImageIcons.guankanjilu,
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
                                onPressed: () {
                                  // Navigator.of(context, rootNavigator: true).push<void>(
                                  //   CupertinoPageRoute(
                                  //     title: '反馈中心',
                                  //     // fullscreenDialog: true,
                                  //     builder: (context) => const KeFuMessagePage(),
                                  //   ),
                                  // );
                                  Global.toChat();
                                },
                                child: Column(
                                  children: [
                                    Image.asset(
                                      ImageIcons.bangzhufankui,
                                      width: 45,
                                      height: 45,
                                    ),
                                    const Text(
                                      '在线客服',
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
                  // const LogOutButton(),
                ],
              ),),
          ),
        ),
        // Row(
        //   mainAxisAlignment: MainAxisAlignment.end,
        //   children: [
        //     Container(
        //       margin: const EdgeInsets.only(right: 20,bottom: 20),
        //       child: InkWell(
        //         onTap: () {
        //           Global.toChat();
        //         },
        //         child: Container(
        //           width: 60,
        //           height: 60,
        //           decoration: const BoxDecoration(
        //             // color: Colors.blueAccent,
        //             image: DecorationImage(
        //               image: AssetImage(ImageIcons.kefu),
        //             ),
        //             borderRadius: BorderRadius.all(Radius.circular(50)),
        //           ),
        //           // child: Container(
        //           //   alignment: Alignment.center,
        //           //   child: const Text('客服', textAlign: TextAlign.center)
        //           // ),
        //         ),
        //       ),
        //     ),
        //   ]
        // ),
      ],
    );
  }

  void _enterDiamond(BuildContext context) {
    Navigator.push(Global.MainContext, SlideRightRoute(page: const BuyDiamondPage())).then((value) => setState(() {Global.getUserInfo();}));
  }
  void _enterGold(BuildContext context) {
    Navigator.push(Global.MainContext, SlideRightRoute(page: const BuyGoldPage())).then((value) => setState(() {Global.getUserInfo();}));
  }
}


