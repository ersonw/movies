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
import 'package:movies/IndexPage.dart';

import 'global.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final songsTabKey = GlobalKey();
  final CupertinoTabController _tabController = CupertinoTabController();

  Widget _buildHomePage(BuildContext context) {
    return CupertinoTabScaffold(
      controller: _tabController,
      tabBar: CupertinoTabBar(
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home_filled,), label: "首页"),
          BottomNavigationBarItem(icon: Icon(Icons.kitesurfing,), label: '狼友推荐'),
          BottomNavigationBarItem(icon: Icon(Icons.add,color: Colors.transparent,)),
          BottomNavigationBarItem(icon: Icon(Icons.public,), label: "推荐"),
          BottomNavigationBarItem(icon: MyProfile.icon, label: MyProfile.title),
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
            ImageIcons.index6.assetName,
            width: 60,
          ),
          onPressed: () {
            setState(() {
              _tabController.index = 2;
            });
          },
          backgroundColor: Colors.transparent),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      body: _buildHomePage(context),
    );
  }
}
