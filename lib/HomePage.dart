import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:movies/index_page.dart';
import 'package:movies/my_prfile.dart';
import 'package:movies/news_tab.dart';

import 'global.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final songsTabKey = GlobalKey();

  Widget _buildHomePage(BuildContext context) {
    return CupertinoTabScaffold(
      tabBar: CupertinoTabBar(
        items: const [
          BottomNavigationBarItem(
              icon: MyProfile.icon,
              label: MyProfile.title
          ),
          BottomNavigationBarItem(
            label: NewsTab.title,
            icon: NewsTab.iosIcon,
          ),
        ],
      ),
      tabBuilder: (context, index) {
        switch (index) {
          case 1:
            return CupertinoTabView(
              // defaultTitle: IndexPage.title,
              builder: (context) => IndexPage(key: songsTabKey),
            );
          case 0:
            return CupertinoTabView(
              // defaultTitle: MyProfile.title,
              builder: (context) => const MyProfile(),
            );
          default:
            assert(false, 'Unexpected tab');
            return const SizedBox.shrink();
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    Global.MainContext = context;
    Global.checkVersion();
    return Scaffold(
      floatingActionButton:  FloatingActionButton(
          child: Icon(Icons.search,color: Colors.white,size: 40,),
          onPressed: (){
            print('FloatingActionButton');
          },
          backgroundColor: Colors.yellow
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      body: _buildHomePage(context),
    );
  }
}