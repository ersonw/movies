import 'dart:async';
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:movies/ImageIcons.dart';
import 'package:movies/SystemNotificationDialog.dart';
import 'package:movies/data/SystemMessage.dart';
import 'package:path/path.dart';

import 'GamePage.dart';
import 'HttpManager.dart';
import 'IndexHomePage.dart';
import 'LockScreenCustom.dart';
import 'MyProfile.dart';
import 'PopUpsDialog.dart';
import 'RecommendedPage.dart';
import 'WolfFriendPage.dart';
import 'global.dart';
import 'network/NWApi.dart';
import 'network/NWMethod.dart';

///自定义不规则底部导航栏
class BottomAppBarState extends StatefulWidget {
  @override
  _BottomAppBarState createState() => _BottomAppBarState();
}

class _BottomAppBarState extends State<BottomAppBarState> {
  List<Widget> _eachView = [];
  int _index = 0;
  SystemMessage systemMessage = SystemMessage();

  @override
  void initState() {
    super.initState();
    if(messagesChangeNotifier.messages.systemMessage.isNotEmpty) systemMessage = messagesChangeNotifier.messages.systemMessage.last;
    _eachView.add(const IndexHomePage());
    _eachView.add(const WolfFriendPage());
    _eachView.add(const RecommendedPage());
    _eachView.add(const MyProfile());
    _eachView.add(const GamePage());
  }
  Future<void> _popUps(BuildContext context)async {
    Map<String, dynamic> parm = { };
    String? result = (await DioManager().requestAsync(
        NWMethod.GET, NWApi.getPopUpsDialog, {"data": jsonEncode(parm)}));
    if (result != null) {
      // print(result);
      Map<String, dynamic> map = jsonDecode(result);
      if(map != null){
        if(map['image'] != null && map['url'] != null){
          Navigator.push(context, DialogRouter(PopUpsDialog(map['image'], url: map['url'])));
        }else if(map['image'] != null){
          Navigator.push(context, DialogRouter(PopUpsDialog(map['image'])));
        }
      }
    }
  }
  _init(BuildContext context){
    Global.MainContext = context;
    if(Global.initMain) return;
    Global.checkVersion();
    // Global.handlerChannel();
    Timer(const Duration(milliseconds: 100), () {
      if (Global.profile.config.bootLock &&
          Global.profile.config.bootLockPasswd != null &&
          Global.profile.config.bootLockPasswd != '') {
        Navigator.of(context, rootNavigator: true).push<void>(
          CupertinoPageRoute(
            // fullscreenDialog: true,
            builder: (context) => LockScreenCustom(LockScreenCustom.lock),
          ),
        );
      }
    });
    Timer(const Duration(milliseconds: 50), () {
      _popUps(context).then((v) {
        if(messagesChangeNotifier.messages.systemMessage.isNotEmpty){
          Navigator.push(context, DialogRouter(SystemNotificationDialog(systemMessage)));
          // showDialog(context: context, builder: (BuildContext _context) => SystemNotificationDialog(systemMessage));
        }
      });
    });
    Global.initMain = true;
  }
  @override
  Widget build(BuildContext context) {
    _init(context);

    // Global.showLockScreen();
    return Scaffold(
      body: _eachView[_index],
      floatingActionButton: FloatingActionButton(
        ///响应事件,push 生成新的页面，即点击中间的按钮跳转的页面
        onPressed: () {
          setState(() {
            _index = 4;
          });
        },

        ///长按
        // tooltip: "狗哥最帅",
        child: Image.asset(ImageIcons.game),
      ),
      bottomNavigationBar: BottomAppBar(
        color: Colors.white,
        shape: const CircularNotchedRectangle(),
        child: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            InkWell(
              child: SizedBox(
                height: 60,
                child: Column(
                  children: [
                    Image.asset(_index == 0 ? ImageIcons.home_active : ImageIcons.home,width: _index == 0 ? 30 : 25,),
                    const Text("首页",style: TextStyle()),
                  ],
                ),
              ),
              onTap: (){
                setState(() {
                  _index = 0;
                });
              }
            ),
            InkWell(
              child: SizedBox(
                height: 60,
                child: Column(
                  children: [
                    Image.asset(_index == 1 ? ImageIcons.past_active : ImageIcons.past,width: _index == 1 ? 30 : 25,),
                    const Text("狼友推荐",style: TextStyle()),
                  ],
                ),
              ),
              onTap: (){
                setState(() {
                  _index = 1;
                });
              }
            ),
            const Padding(padding: EdgeInsets.only(left: 10)),
            InkWell(
              child: SizedBox(
                height: 60,
                child: Column(
                  children: [
                    Image.asset(_index == 2 ? ImageIcons.everyDay_active : ImageIcons.everyDay,width: _index == 2 ? 30 : 25,),
                    const Text("推荐",style: TextStyle()),
                  ],
                ),
              ),
              onTap: (){
                setState(() {
                  _index = 2;
                });
              }
            ),
            InkWell(
              child: SizedBox(
                height: 60,
                child: Column(
                  children: [
                    Image.asset(_index == 3 ? ImageIcons.user_active : ImageIcons.user,width: _index == 3 ? 30 : 25,),
                    const Text("我的",style: TextStyle()),
                  ],
                ),
              ),
              onTap: (){
                setState(() {
                  _index = 3;
                });
              }
            ),
          ],
        ),
      ),

      ///将FloatActionButton 与 BottomAppBar 融合到一起
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }
}
