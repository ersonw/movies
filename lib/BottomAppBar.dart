import 'package:flutter/material.dart';
import 'package:movies/ImageIcons.dart';
import 'package:path/path.dart';

import 'GamePage.dart';
import 'IndexHomePage.dart';
import 'MyProfile.dart';
import 'RecommendedPage.dart';
import 'WolfFriendPage.dart';
import 'global.dart';

///自定义不规则底部导航栏
class BottomAppBarState extends StatefulWidget {
  @override
  _BottomAppBarState createState() => _BottomAppBarState();
}

class _BottomAppBarState extends State<BottomAppBarState> {
  List<Widget> _eachView = [];
  int _index = 0;

  @override
  void initState() {
    super.initState();

    _eachView.add(const IndexHomePage());
    _eachView.add(const WolfFriendPage());
    _eachView.add(const RecommendedPage());
    _eachView.add(const MyProfile());
    _eachView.add(const GamePage());
  }
  _enterView(int index){
  }
  @override
  Widget build(BuildContext context) {
    Global.MainContext = context;
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
