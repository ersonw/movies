import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'RoundUnderlineTabIndicator.dart';
import 'global.dart';
import 'image_icon.dart';

class IndexHomePage extends StatefulWidget {
  const IndexHomePage({Key? key}) : super(key: key);

  @override
  _IndexHomePage createState() => _IndexHomePage();

}
class _IndexHomePage extends State<IndexHomePage>{
  final ScrollController _controller = ScrollController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return DefaultTabController(length: 3, child: CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        trailing: Container(
          margin: const EdgeInsets.only(left: 90,right: 90),
          child: const TabBar(
            labelColor: Colors.red,
            labelStyle: TextStyle(),
            // isScrollable: true,
            labelPadding: EdgeInsets.only(left: 0, right: 0),
            // padding: EdgeInsets.only(left: 0, right: 0),
            // indicatorPadding: EdgeInsets.only(left: 0, right: 0),
            // indicatorWeight: 6,
            // indicatorColor: Colors.red,
            unselectedLabelColor: Colors.black,
            unselectedLabelStyle: TextStyle(),
            indicator: RoundUnderlineTabIndicator(
                borderSide: BorderSide(
                  width: 9,
                  color: Colors.red,
                )
            ),
            tabs: [
              Tab(text: '搜索',),
              Tab(text: '精选',),
              Tab(text: '分类',),
            ],
          ),
        ),
      ),
      child: Container(
        margin: const EdgeInsets.all(10),
        child: TabBarView(children: [
          _buildList(),
          _buildList(),
          _buildList(),
        ]),
      ),
    ));
  }
  _buildList() {
    List<Widget> widgets = [];
    widgets.add(Container(
      margin: const EdgeInsets.only(top: 5, bottom: 20),
      child: InkWell(
        onTap: () {
          // Global.playVideo(0);
        },
        child: Column(
          children: [
            Container(
              // width: 350,
              height: 200,
              // margin: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.all(Radius.circular(10)),
                image: DecorationImage(
                  image: AssetImage(
                      'assets/image/d95661e1-b1d2-4363-b263-ef60b965612d.png'),
                  fit: BoxFit.fill,
                  alignment: Alignment.center,
                ),
              ),
              child: Global.buildPlayIcon((){
                Global.playVideo(0);
              }),
            ),
            Container(
              margin: const EdgeInsets.only(top: 10),
              child: Text('[91制片厂]《肉感精油spa》痉挛停不下来 性感开发精油按摩 ',style: TextStyle(fontSize: 18,overflow: TextOverflow.ellipsis),),
            ),
            Container(
              margin: const EdgeInsets.only(top: 5),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('524 次播放',style: TextStyle(color: Colors.grey,fontSize: 12),),
                  Row(
                    children: [
                      Image.asset(ImageIcons.remommendIcon.assetName,width: 45,height: 15,),
                      Text('0人',style: TextStyle(color: Colors.grey,fontSize: 13),),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    ));
    widgets.add(Container(
      margin: const EdgeInsets.only(top: 5, bottom: 20),
      child: InkWell(
        onTap: () {},
        child: Column(
          children: [
            Container(
              // width: 350,
              height: 200,
              // margin: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.all(Radius.circular(10)),
                image: DecorationImage(
                  image: AssetImage(
                      'assets/image/d95661e1-b1d2-4363-b263-ef60b965612d.png'),
                  fit: BoxFit.fill,
                  alignment: Alignment.center,
                ),
              ),
              child: Center(
                child: Global.buildPlayIcon((){}),
              ),
            ),
            Container(
              margin: const EdgeInsets.only(top: 10),
              child: Text('[91制片厂]《肉感精油spa》痉挛停不下来 性感开发精油按摩 ',style: TextStyle(fontSize: 18,overflow: TextOverflow.ellipsis),),
            ),
            Container(
              margin: const EdgeInsets.only(top: 5),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('524 次播放',style: TextStyle(color: Colors.grey,fontSize: 12),),
                  Row(
                    children: [
                      Image.asset(ImageIcons.remommendIcon.assetName,width: 45,height: 15,),
                      Text('0人',style: TextStyle(color: Colors.grey,fontSize: 13),),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    ));
    widgets.add(Container(
      margin: const EdgeInsets.only(top: 10, bottom: 20),
      child: InkWell(
        onTap: () {},
        child: Column(
          children: [
            Container(
              // width: 350,
              height: 200,
              // margin: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.all(Radius.circular(10)),
                image: DecorationImage(
                  image: AssetImage(
                      'assets/image/d95661e1-b1d2-4363-b263-ef60b965612d.png'),
                  fit: BoxFit.fill,
                  alignment: Alignment.center,
                ),
              ),
              child: Center(
                child: Global.buildPlayIcon((){}),
              ),
            ),
            Container(
              margin: const EdgeInsets.only(top: 10),
              child: Text('[91制片厂]《肉感精油spa》痉挛停不下来 性感开发精油按摩 ',style: TextStyle(fontSize: 18,overflow: TextOverflow.ellipsis),),
            ),
            Container(
              margin: const EdgeInsets.only(top: 5),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('524 次播放',style: TextStyle(color: Colors.grey,fontSize: 12),),
                  Row(
                    children: [
                      Image.asset(ImageIcons.remommendIcon.assetName,width: 45,height: 15,),
                      Text('0人',style: TextStyle(color: Colors.grey,fontSize: 13),),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    ));
    widgets.add(Container(
      margin: const EdgeInsets.only(top: 10, bottom: 20),
      child: InkWell(
        onTap: () {},
        child: Column(
          children: [
            Container(
              // width: 350,
              height: 200,
              // margin: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.all(Radius.circular(10)),
                image: DecorationImage(
                  image: AssetImage(
                      'assets/image/d95661e1-b1d2-4363-b263-ef60b965612d.png'),
                  fit: BoxFit.fill,
                  alignment: Alignment.center,
                ),
              ),
              child: Center(
                child: Global.buildPlayIcon((){}),
              ),
            ),
            Container(
              margin: const EdgeInsets.only(top: 10),
              child: Text('[91制片厂]《肉感精油spa》痉挛停不下来 性感开发精油按摩 ',style: TextStyle(fontSize: 18,overflow: TextOverflow.ellipsis),),
            ),
            Container(
              margin: const EdgeInsets.only(top: 5),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('524 次播放',style: TextStyle(color: Colors.grey,fontSize: 12),),
                  Row(
                    children: [
                      Image.asset(ImageIcons.remommendIcon.assetName,width: 45,height: 15,),
                      Text('0人',style: TextStyle(color: Colors.grey,fontSize: 13),),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    ));
    widgets.add(Container(
      margin: const EdgeInsets.only(top: 10, bottom: 20),
      child: InkWell(
        onTap: () {},
        child: Column(
          children: [
            Container(
              // width: 350,
              height: 200,
              // margin: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.all(Radius.circular(10)),
                image: DecorationImage(
                  image: AssetImage(
                      'assets/image/d95661e1-b1d2-4363-b263-ef60b965612d.png'),
                  fit: BoxFit.fill,
                  alignment: Alignment.center,
                ),
              ),
              child: Center(
                child: Global.buildPlayIcon((){}),
              ),
            ),
            Container(
              margin: const EdgeInsets.only(top: 10),
              child: Text('[91制片厂]《肉感精油spa》痉挛停不下来 性感开发精油按摩 ',style: TextStyle(fontSize: 18,overflow: TextOverflow.ellipsis),),
            ),
            Container(
              margin: const EdgeInsets.only(top: 5),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('524 次播放',style: TextStyle(color: Colors.grey,fontSize: 12),),
                  Row(
                    children: [
                      Image.asset(ImageIcons.remommendIcon.assetName,width: 45,height: 15,),
                      Text('0人',style: TextStyle(color: Colors.grey,fontSize: 13),),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    ));
    widgets.add(Container(
      margin: const EdgeInsets.only(top: 10, bottom: 20),
      child: InkWell(
        onTap: () {},
        child: Column(
          children: [
            Container(
              // width: 350,
              height: 200,
              // margin: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.all(Radius.circular(10)),
                image: DecorationImage(
                  image: AssetImage(
                      'assets/image/d95661e1-b1d2-4363-b263-ef60b965612d.png'),
                  fit: BoxFit.fill,
                  alignment: Alignment.center,
                ),
              ),
              child: Center(
                child: Global.buildPlayIcon((){}),
              ),
            ),
            Container(
              margin: const EdgeInsets.only(top: 10),
              child: Text('[91制片厂]《肉感精油spa》痉挛停不下来 性感开发精油按摩 ',style: TextStyle(fontSize: 18,overflow: TextOverflow.ellipsis),),
            ),
            Container(
              margin: const EdgeInsets.only(top: 5),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('524 次播放',style: TextStyle(color: Colors.grey,fontSize: 12),),
                  Row(
                    children: [
                      Image.asset(ImageIcons.remommendIcon.assetName,width: 45,height: 15,),
                      Text('0人',style: TextStyle(color: Colors.grey,fontSize: 13),),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    ));
    widgets.add(Container(
      margin: const EdgeInsets.only(top: 10, bottom: 20),
      child: InkWell(
        onTap: () {},
        child: Column(
          children: [
            Container(
              // width: 350,
              height: 200,
              // margin: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.all(Radius.circular(10)),
                image: DecorationImage(
                  image: AssetImage(
                      'assets/image/d95661e1-b1d2-4363-b263-ef60b965612d.png'),
                  fit: BoxFit.fill,
                  alignment: Alignment.center,
                ),
              ),
              child: Center(
                child: Global.buildPlayIcon((){}),
              ),
            ),
            Container(
              margin: const EdgeInsets.only(top: 10),
              child: Text('[91制片厂]《肉感精油spa》痉挛停不下来 性感开发精油按摩 ',style: TextStyle(fontSize: 18,overflow: TextOverflow.ellipsis),),
            ),
            Container(
              margin: const EdgeInsets.only(top: 5),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('524 次播放',style: TextStyle(color: Colors.grey,fontSize: 12),),
                  Row(
                    children: [
                      Image.asset(ImageIcons.remommendIcon.assetName,width: 45,height: 15,),
                      Text('0人',style: TextStyle(color: Colors.grey,fontSize: 13),),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    ));
    widgets.add(Container(
      margin: const EdgeInsets.only(top: 10, bottom: 20),
      child: InkWell(
        onTap: () {},
        child: Column(
          children: [
            Container(
              // width: 350,
              height: 200,
              // margin: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.all(Radius.circular(10)),
                image: DecorationImage(
                  image: AssetImage(
                      'assets/image/d95661e1-b1d2-4363-b263-ef60b965612d.png'),
                  fit: BoxFit.fill,
                  alignment: Alignment.center,
                ),
              ),
              child: Center(
                child: Global.buildPlayIcon((){}),
              ),
            ),
            Container(
              margin: const EdgeInsets.only(top: 10),
              child: Text('[91制片厂]《肉感精油spa》痉挛停不下来 性感开发精油按摩 ',style: TextStyle(fontSize: 18,overflow: TextOverflow.ellipsis),),
            ),
            Container(
              margin: const EdgeInsets.only(top: 5),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('524 次播放',style: TextStyle(color: Colors.grey,fontSize: 12),),
                  Row(
                    children: [
                      Image.asset(ImageIcons.remommendIcon.assetName,width: 45,height: 15,),
                      Text('0人',style: TextStyle(color: Colors.grey,fontSize: 13),),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    ));
    return ListView(
      controller: _controller,
      children: widgets,
    );
  }
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }
}