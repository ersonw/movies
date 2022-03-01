import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'global.dart';
import 'image_icon.dart';

class IndexPage extends StatefulWidget {
  const IndexPage({Key? key}) : super(key: key);

  @override
  _IndexPage createState() => _IndexPage();
}

class _IndexPage extends State<IndexPage> {
  final ScrollController _controller = ScrollController();
  final List<String> _first = [];
  final List<String> _last = [];
  int _firstIndex = 0;
  int _lastIndex = 0;

  @override
  void initState() {
    _first.add('最新');
    _first.add('最热');
    _last.add('全部');
    _last.add('徐韵姗');
    _last.add('叶一涵');
    _last.add('李靖琪');
    _last.add('徐韵姗');
    _last.add('叶一涵');
    _last.add('李靖琪');
    super.initState();
    _controller.addListener(() {
      if(_controller.position.pixels == _controller.position.maxScrollExtent){
        // _getMore();
      }
    });
  }

  Widget _buildFirst() {
    List<Widget> widgets = [];
    for (int i = 0; i < _first.length; i++) {
      widgets.add(InkWell(
        onTap: () => setState(() {
          _firstIndex = i;
        }),
        child: Container(
          margin: const EdgeInsets.only(right: 10),
          decoration: BoxDecoration(
            color: _firstIndex == i ? Colors.red : Colors.transparent,
            borderRadius: const BorderRadius.all(Radius.circular(20)),
          ),
          child: Container(
            // color: Colors.black,
            margin:
                const EdgeInsets.only(top: 4, bottom: 4, left: 15, right: 15),
            child: Text(
              _first[i],
              style: TextStyle(
                color: _firstIndex == i ? Colors.white : Colors.black,
                fontSize: 18,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ));
    }
    return ListView(
      scrollDirection: Axis.horizontal,
      children: widgets,
    );
  }

  Widget _buildLast() {
    List<Widget> widgets = [];
    for (int i = 0; i < _last.length; i++) {
      widgets.add(InkWell(
        onTap: () => setState(() {
          _lastIndex = i;
        }),
        child: Container(
          margin: const EdgeInsets.only(right: 10),
          decoration: BoxDecoration(
            color: _lastIndex == i ? Colors.red : Colors.transparent,
            borderRadius: const BorderRadius.all(Radius.circular(20)),
          ),
          child: Container(
            margin:
                const EdgeInsets.only(top: 4, bottom: 4, left: 15, right: 15),
            child: Text(
              _last[i],
              style: TextStyle(
                color: _lastIndex == i ? Colors.white : Colors.black,
                fontSize: 18,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ));
    }
    return ListView(
      scrollDirection: Axis.horizontal,
      children: widgets,
    );
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
  Widget build(BuildContext context) {
    // TODO: implement build
    return CupertinoPageScaffold(
      child: Container(
        margin: const EdgeInsets.all(10),
        child: Column(
          children: [
            Flexible(
              flex: 1,
              child: Container(
                margin: const EdgeInsets.only(top: 30),
                child: _buildFirst(),
              ),
            ),
            Flexible(
              flex: 1,
              child: Container(
                margin: const EdgeInsets.only(top: 15, bottom: 15),
                child: _buildLast(),
              ),
            ),
            Expanded(
              flex: 9,
              child: Container(
                // margin: const EdgeInsets.only(top: 15),
                // color: Colors.black,
                child: _buildList(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }
}
