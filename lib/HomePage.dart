import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:movies/FeaturedPage.dart';
import 'package:movies/IndexHomePage.dart';
import 'package:movies/LockScreenCustom.dart';
import 'package:movies/RecommendedPage.dart';
import 'package:movies/image_icon.dart';
import 'package:movies/MyProfile.dart';
import 'package:movies/WolfFriendPage.dart';

import 'global.dart';
class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}
class _HomePageState extends State<HomePage> {
  final songsTabKey = GlobalKey();
  final CupertinoTabController _tabController = CupertinoTabController();
  static int indexTab = 0;

  Widget _buildHomePage(BuildContext context) {
    return CupertinoTabScaffold(
      controller: _tabController,
      tabBar: CupertinoTabBar(
        items:  [
          BottomNavigationBarItem(icon: Image.asset(indexTab == 0 ? ImageIcons.remommend_active.assetName : ImageIcons.remommend.assetName), label: "首页"),
          BottomNavigationBarItem(icon: Image.asset(indexTab == 1 ? ImageIcons.past_active.assetName : ImageIcons.past.assetName), label: '狼友推荐'),
          const BottomNavigationBarItem(icon: Icon(Icons.add,color: Colors.transparent,)),
          BottomNavigationBarItem(icon: Image.asset(indexTab == 3 ?  ImageIcons.everyDay_active.assetName : ImageIcons.everyDay.assetName), label: "推荐"),
          BottomNavigationBarItem(icon: Image.asset(indexTab == 4 ? ImageIcons.user_active.assetName : ImageIcons.user.assetName), label: MyProfile.title),
        ],
      ),
      tabBuilder: (context, index) {
        switch (index) {
          case 0:
            return CupertinoTabView(
              // defaultTitle: MyProfile.title,
              builder: (context) => const IndexHomePage(),
            );
          case 1:
            return CupertinoTabView(
              // defaultTitle: IndexPage.title,
              builder: (context) => const WolfFriendPage(),
            );
          case 2:
            return CupertinoTabView(
              // defaultTitle: IndexPage.title,
              builder: (context) => const FeaturedPage(),
            );
          case 3:
            return CupertinoTabView(
              // defaultTitle: IndexPage.title,
              builder: (context) => const RecommendedPage(),
            );
          case 4:
            return CupertinoTabView(
              // defaultTitle: MyProfile.title,
              builder: (context) => const MyProfile(),
            );
          default:
            return Container();
        }
      },
    );
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    Global.MainContext = context;
    Global.checkVersion();
    // Global.showLockScreen();
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
    return Scaffold(
      floatingActionButton: FloatingActionButton(
          child: Image.asset(
            ImageIcons.game.assetName,
            width: 60,
          ),
          onPressed: () {
            setState(() {
              _tabController.index = 2;
            });
          },
          backgroundColor: Colors.transparent),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      body: Stack(
        alignment: Alignment.bottomRight,
        children: [
          _buildHomePage(context),
          Container(
            // width: 60,
            // height: 60,
            margin: const EdgeInsets.only(bottom: 90,right: 20),
            child: InkWell(
              onTap: () {
                Global.toChat();
              },
              child: Container(
                width: 60,
                height: 60,
                decoration: const BoxDecoration(
                  // color: Colors.blueAccent,
                  image: DecorationImage(
                    image: ImageIcons.kefu,
                  ),
                  borderRadius: BorderRadius.all(Radius.circular(50)),
                ),
                // child: Container(
                //   alignment: Alignment.center,
                //   child: const Text('客服', textAlign: TextAlign.center)
                // ),
              ),
            ),
          ),

        ],
      ),
    );
  }
}
